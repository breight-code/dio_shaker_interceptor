import 'dart:convert';

import 'package:dio_shaker_interceptor/features/curl_detail/presentation/widget/action_button.dart';
import 'package:dio_shaker_interceptor/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dio_shaker_interceptor/features/list_curl/data/curl_model.dart';

/// A stateless widget that displays detailed information about a cURL request.
///
/// The [CurlDetailScreen] widget shows various details of a cURL request,
/// including the URL, HTTP method, headers, body, query parameters, status,
/// response, and duration. It provides a detailed view of a single cURL request
/// encapsulated in a [CurlModel].
class CurlDetailScreen extends StatelessWidget {
  /// The [CurlModel] containing the details of the cURL request to be displayed.
  final CurlModel curlModel;

  /// Creates a [CurlDetailScreen] widget.
  ///
  /// The [curlModel] parameter must not be null.
  CurlDetailScreen({super.key, required this.curlModel});

  /// The text style used for titles in the detail view.
  final TextStyle titleSyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Curl Detail'),
        actions: [
          ActionButton(curlModel: curlModel),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SelectionArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Text('URL:', style: titleSyle),
                Text(curlModel.url.toString()),
                SizedBox(height: 16.0),
                Text('Method:', style: titleSyle),
                Text(curlModel.method),
                SizedBox(height: 16.0),
                Text('Headers:', style: titleSyle),
                Text(JsonEncoder.withIndent('  ').convert(curlModel.headers)),
                SizedBox(height: 16.0),
                if (curlModel.body != null) ...[
                  Text('Body:', style: titleSyle),
                  Text(curlModel.body.toString()),
                  SizedBox(height: 16.0),
                ],
                if (curlModel.queryParameters.isNotEmpty) ...[
                  Text(
                    'Query Parameters:',
                    style: titleSyle,
                  ),
                  Text(curlModel.queryParameters.toString()),
                  SizedBox(height: 16.0),
                ],
                if (curlModel.status != null) ...[
                  Text('Status:', style: titleSyle),
                  Text(
                    curlModel.status?.toString() ?? 'N/A',
                    style: TextStyle(color: curlModel.color),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Response:',
                    style: titleSyle,
                  ),
                  Text(
                      JsonEncoder.withIndent('  ').convert(curlModel.response)),
                  if (curlModel.updateDate != null) ...[
                    SizedBox(height: 16.0),
                    Text(
                      'Duration:',
                      style: titleSyle,
                    ),
                    Text(
                      Utils().calculateTimeBetweenTwoDate(
                        curlModel.creationDate,
                        curlModel.updateDate!,
                      ),
                    ),
                  ]
                ],
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
