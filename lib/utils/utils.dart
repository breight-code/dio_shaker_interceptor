import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_shaker_interceptor/features/list_curl/data/curl_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utility class providing various helper methods.
class Utils {
  /// Generates a cURL command string from a [CurlModel] request.
  ///
  /// This method constructs a cURL command using the HTTP method, headers,
  /// body, and URL from the provided [CurlModel] request.
  ///
  /// Returns a [String] representing the cURL command.
  String getCurl(CurlModel request) {
    final stringBuilder = StringBuffer()..write('curl -X ${request.method}');

    request.headers.forEach((key, value) {
      if (key.toLowerCase() != 'content-length') {
        stringBuilder.write(' -H "$key: $value"');
      }
    });

    if (request.body != null && request.body.isNotEmpty) {
      stringBuilder.write(' -d \'${getCurlInputBody(request.body)}\'');
    }

    stringBuilder.write(' "${request.url}"');

    return stringBuilder.toString();
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
        final formData =
            data.fields.map((e) => '${e.key}=${e.value}').join('&');
        return formData;
      } else {
        final res = json.encode(data);

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
  void copyCurl(CurlModel request, BuildContext context) {
    final curl = getCurl(request);
    final data = ClipboardData(text: curl);
    Clipboard.setData(data);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Curl copied to clipboard')),
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
    String defaultStringResult = '0s';
    Duration difference = dateTimeSecond.difference(dateTimeFirst);
    int differenceInSecond = difference.inSeconds;
    int days = (differenceInSecond / secondInDay).truncate();
    differenceInSecond -= (days * secondInDay);
    int hours = (differenceInSecond / secondInHour).truncate();
    differenceInSecond -= (hours * secondInHour);
    int minutes = (differenceInSecond / secondInMinute).truncate();
    differenceInSecond -= (minutes * secondInMinute);
    int seconds = differenceInSecond;
    int milliseconds = difference.inMilliseconds.remainder(1000);
    String daysString = days > 0 ? '${days}d ' : '';
    String hoursString = hours > 0 || daysString.isNotEmpty ? '${hours}h ' : '';
    String minutesString =
        minutes > 0 || hoursString.isNotEmpty ? '${minutes}m ' : '';
    String secondsString =
        seconds > 0 || minutesString.isNotEmpty ? '${seconds}s ' : '';
    String millisecondsString =
        milliseconds > 0 || secondsString.isNotEmpty ? '${milliseconds}ms' : '';
    String result = daysString +
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
