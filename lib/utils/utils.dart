import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_shaker_interceptor/features/list_curl/data/curl_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utility class providing various helper methods.
class Utils {
  /// Pattern per nomi header da redigere in output curl/share (case-insensitive sul nome).
  static List<RegExp> redactedHeaderPatterns = <RegExp>[
    RegExp(r'^authorization$', caseSensitive: false),
    RegExp(r'^cookie$', caseSensitive: false),
    RegExp(r'^set-cookie$', caseSensitive: false),
    RegExp(r'^x-api-key$', caseSensitive: false),
  ];

  /// Escape valore per uso dentro doppie virgolette in shell (-H "...").
  static String escapeHeaderValueForDoubleQuotes(String value) {
    return value.replaceAll(r'\', r'\\').replaceAll('"', r'\"');
  }

  /// Escape stringa per embedding in singole quote POSIX: `'...'`.
  static String escapeForSingleQuotedShell(String value) {
    return value.replaceAll("'", r"'\''");
  }

  static bool _shouldRedactHeaderName(String name) {
    return redactedHeaderPatterns
        .any((RegExp r) => r.hasMatch(name.trim()));
  }

  static String _formatHeaderValue(String name, dynamic value, bool redact) {
    final String s = '$value';
    if (redact && _shouldRedactHeaderName(name)) {
      return '***';
    }
    return s;
  }

  /// Stima dimensione payload (bytes UTF-8 approssimativi per stringhe).
  static int? estimateSize(dynamic data) {
    if (data == null) {
      return null;
    }
    try {
      if (data is FormData) {
        int n = 0;
        for (final MapEntry<String, String> e in data.fields) {
          n += e.key.length + e.value.length;
        }
        return n;
      }
      if (data is String) {
        return data.length;
      }
      return jsonEncode(data).length;
    } catch (_) {
      return null;
    }
  }

  /// Applica redazione ai valori header (mappa nuova).
  static Map<String, dynamic> redactedHeadersMap(
    Map<String, dynamic> headers, {
    bool redact = true,
  }) {
    if (!redact) {
      return Map<String, dynamic>.from(headers);
    }
    return headers.map((String k, dynamic v) {
      return MapEntry<String, dynamic>(
        k,
        _shouldRedactHeaderName(k) ? '***' : v,
      );
    });
  }

  /// Generates a cURL command string from a [CurlModel] request.
  ///
  /// This method constructs a cURL command using the HTTP method, headers,
  /// body, and URL from the provided [CurlModel] request.
  ///
  /// Returns a [String] representing the cURL command.
  String getCurl(CurlModel request, {bool redactHeaders = true}) {
    final StringBuffer stringBuilder = StringBuffer()..write('curl -X ${request.method}');

    request.headers.forEach((String key, dynamic value) {
      if (key.toLowerCase() != 'content-length') {
        final String display = _formatHeaderValue(key, value, redactHeaders);
        final String escaped = escapeHeaderValueForDoubleQuotes(display);
        stringBuilder.write(' -H "$key: $escaped"');
      }
    });

    final String? bodyString = _curlBodyString(request.body);
    if (bodyString != null && bodyString.isNotEmpty) {
      final String esc = escapeForSingleQuotedShell(bodyString);
      stringBuilder.write(" -d '$esc'");
    }

    stringBuilder.write(' "${request.url}"');

    return stringBuilder.toString();
  }

  /// True se il body va incluso nel curl.
  static bool bodyIsNonEmpty(dynamic body) {
    if (body == null) {
      return false;
    }
    if (body is String) {
      return body.isNotEmpty;
    }
    if (body is Map) {
      return body.isNotEmpty;
    }
    if (body is List) {
      return body.isNotEmpty;
    }
    if (body is FormData) {
      return body.fields.isNotEmpty || body.files.isNotEmpty;
    }
    return true;
  }

  String? _curlBodyString(dynamic body) {
    if (!bodyIsNonEmpty(body)) {
      return null;
    }
    return getCurlInputBody(body);
  }

  /// Encodes the input body data for a cURL command.
  ///
  /// If the data is of type [FormData], it converts the fields to a URL-encoded
  /// string. Otherwise, it encodes the data as JSON.
  ///
  /// Returns a [String] representing the encoded body data.
  String getCurlInputBody(dynamic data) {
    try {
      if (data is FormData) {
        final String formData =
            data.fields.map((MapEntry<String, String> e) => '${e.key}=${e.value}').join('&');
        return formData;
      } else {
        final String res = json.encode(data);

        return res;
      }
    } catch (e) {
      return '';
    }
  }

  /// Copies the generated cURL command to the clipboard and shows a snackbar.
  ///
  /// This method generates a cURL command from the provided [CurlModel] request,
  /// copies it to the clipboard, and displays a snackbar notification in the
  /// given [BuildContext].
  void copyCurl(CurlModel request, BuildContext context, {bool redactHeaders = true}) {
    final String curl = getCurl(request, redactHeaders: redactHeaders);
    final ClipboardData data = ClipboardData(text: curl);
    Clipboard.setData(data);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Curl copied to clipboard')),
    );
  }

  /// Calculates the time difference between two dates and formats it as a string.
  ///
  /// This method calculates the difference between [dateTimeFirst] and
  /// [dateTimeSecond], and formats the result as a string in the format
  /// "Xd Xh Xm Xs Xms", where X represents the number of days, hours, minutes,
  /// seconds, and milliseconds, respectively.
  ///
  /// Returns a [String] representing the formatted time difference.
  String calculateTimeBetweenTwoDate(
    DateTime dateTimeFirst,
    DateTime dateTimeSecond,
  ) {
    const int secondInDay = 86400;
    const int secondInHour = 3600;
    const int secondInMinute = 60;
    final String defaultStringResult = '0s';
    final Duration difference = dateTimeSecond.difference(dateTimeFirst);
    int differenceInSecond = difference.inSeconds;
    int days = (differenceInSecond / secondInDay).truncate();
    differenceInSecond -= days * secondInDay;
    int hours = (differenceInSecond / secondInHour).truncate();
    differenceInSecond -= hours * secondInHour;
    int minutes = (differenceInSecond / secondInMinute).truncate();
    differenceInSecond -= minutes * secondInMinute;
    int seconds = differenceInSecond;
    final int milliseconds = difference.inMilliseconds.remainder(1000);
    final String daysString = days > 0 ? '${days}d ' : '';
    final String hoursString = hours > 0 || daysString.isNotEmpty ? '${hours}h ' : '';
    final String minutesString =
        minutes > 0 || hoursString.isNotEmpty ? '${minutes}m ' : '';
    final String secondsString =
        seconds > 0 || minutesString.isNotEmpty ? '${seconds}s ' : '';
    final String millisecondsString =
        milliseconds > 0 || secondsString.isNotEmpty ? '${milliseconds}ms' : '';
    final String result = daysString +
        hoursString +
        minutesString +
        secondsString +
        millisecondsString;
    if (result.isEmpty) {
      return defaultStringResult;
    }
    return result;
  }
}
