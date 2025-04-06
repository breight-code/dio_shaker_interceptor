import 'package:flutter/material.dart';

/// A model representing a cURL request and its associated data.
class CurlModel {
  /// The URL of the request.
  final Uri url;

  /// The headers of the request.
  final Map<String, dynamic> headers;

  /// The body of the request, if any.
  final dynamic body;

  /// Additional parameters for the request, if any.
  final Map<String, dynamic>? params;

  /// The HTTP status code of the response, if available.
  final int? status;

  /// The response data from the request, if available.
  final dynamic response;

  /// The HTTP method used for the request (e.g., GET, POST).
  final String method;

  /// Extra data associated with the request.
  final Map<String, dynamic> extra;

  /// The query parameters of the request.
  final Map<String, dynamic> queryParameters;

  /// The date and time when the request was created.
  final DateTime creationDate;

  /// The date and time when the request was last updated, if available.
  final DateTime? updateDate;

  /// Constructs a [CurlModel] with the given parameters.
  CurlModel({
    required this.url,
    required this.headers,
    this.body,
    this.status,
    this.response,
    required this.method,
    this.params,
    required this.extra,
    required this.queryParameters,
    required this.creationDate,
    this.updateDate,
  });

  /// Creates a copy of this [CurlModel] with optional new values for [status] and [response].
  CurlModel copyWith({int? status, dynamic response}) {
    return CurlModel(
      url: url,
      headers: headers,
      body: body,
      params: params,
      status: status ?? this.status,
      response: response ?? this.response,
      method: method,
      extra: extra,
      queryParameters: queryParameters,
      creationDate: creationDate,
      updateDate: DateTime.now(),
    );
  }

  /// Returns the path of the URL as the name of the request.
  String get name => url.path;

  /// Returns a color representing the status of the request.
  /// - Green for successful responses (status code 200-299).
  /// - Red for unsuccessful responses.
  /// - Black if the status is not available.
  Color get color {
    if (status == null) return Colors.black;
    if (status! >= 200 && status! < 300) return Colors.green;
    return Colors.red;
  }
}
