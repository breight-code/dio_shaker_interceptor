import 'dart:math';

import 'package:flutter/material.dart';

/// Genera un id univoco per una richiesta in-sessione (no dep esterne).
String generateDsiRequestId() {
  final Random r = Random();
  return '${DateTime.now().microsecondsSinceEpoch}_${r.nextInt(0x7fffffff)}';
}

/// A model representing a cURL request and its associated data.
class CurlModel {
  /// Identificatore univoco della richiesta (match stabile con la risposta).
  final String id;

  /// The URL of the request.
  final Uri url;

  /// The headers of the request.
  final Map<String, dynamic> headers;

  /// The body of the request, if any.
  final dynamic body;

  /// Dimensione stimata del body richiesta (es. jsonEncode), se nota.
  final int? requestSize;

  /// Dimensione stimata della risposta, quando disponibile.
  final int? responseSize;

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
    String? id,
    required this.url,
    required this.headers,
    this.body,
    this.requestSize,
    this.responseSize,
    this.status,
    this.response,
    required this.method,
    this.params,
    required this.extra,
    required this.queryParameters,
    required this.creationDate,
    this.updateDate,
  }) : id = id ?? generateDsiRequestId();

  /// Creates a copy of this [CurlModel] with optional new values.
  CurlModel copyWith({
    String? id,
    int? status,
    dynamic response,
    int? requestSize,
    int? responseSize,
  }) {
    return CurlModel(
      id: id ?? this.id,
      url: url,
      headers: headers,
      body: body,
      requestSize: requestSize ?? this.requestSize,
      responseSize: responseSize ?? this.responseSize,
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
