import 'dart:convert';
import 'dart:io';

import 'package:dio_shaker_interceptor/features/list_curl/data/curl_model.dart';
import 'package:dio_shaker_interceptor/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// The `ActionButton` widget is a stateless widget that provides a popup menu
/// with various actions related to a cURL request. The actions include copying
/// the cURL command, sharing the cURL command, sharing detailed request and
/// response data, and saving the detailed data to a file and sharing the file.
///
/// The widget takes a `CurlModel` object as a parameter, which contains all the
/// necessary information about the cURL request and response.
///
/// The `PopupMenuButton` widget is used to display the popup menu with the
/// available actions. When an action is selected, the corresponding functionality
/// is executed using the `Utils` class and the `Share` package.
///
/// The available actions are:
/// - Copy cURL: Copies the cURL command to the clipboard.
/// - Share cURL: Shares the cURL command using the system's share functionality.
/// - Share data: Shares detailed request and response data using the system's share functionality.
/// - Save and share data: Saves the detailed data to a file and shares the file using the system's share functionality.
///
/// The `onSelected` callback handles the selected action and performs the
/// corresponding task. The `getApplicationDocumentsDirectory` function from
/// the `path_provider` package is used to get the directory for saving the file.
///
/// The `Utils` class provides utility functions for generating the cURL command,
/// copying the cURL command to the clipboard, and calculating the duration
/// between two dates.

class ActionButton extends StatelessWidget {
  final CurlModel curlModel;

  const ActionButton({super.key, required this.curlModel});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (value) async {
        final curl = Utils().getCurl(curlModel);
        final data = '''
Request data:\n
URL: ${curlModel.url}
Method: ${curlModel.method}
Headers: ${JsonEncoder.withIndent('  ').convert(curlModel.headers)}
Body: ${curlModel.body}
Query Parameters: ${JsonEncoder.withIndent('  ').convert(curlModel.queryParameters)}
Send at: ${curlModel.creationDate}
\nResponse data:\n
Status: ${curlModel.status}
Response: ${JsonEncoder.withIndent('  ').convert(curlModel.response)}
Response at: ${curlModel.updateDate}
${curlModel.updateDate != null ? 'Duration: ${Utils().calculateTimeBetweenTwoDate(curlModel.creationDate, curlModel.updateDate!)}' : ''}
\nCurl: $curl
                  ''';
        switch (value) {
          case 0:
            Utils().copyCurl(curlModel, context);
            break;
          case 1:
            await Share.share(curl);
            break;
          case 2:
            await Share.share(data);
            break;
          case 3:
            final directory = await getApplicationDocumentsDirectory();
            final path =
                '${directory.path}/curl_details_${DateTime.now().millisecondsSinceEpoch}.txt';
            final file = File(path);
            await file.writeAsString(data);
            final XFile xFile = XFile(path);
            await Share.shareXFiles([xFile]);
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return {
          0: 'Copy curl',
          1: 'Share curl',
          2: 'Share data',
          3: 'Download data'
        }
            .map((int key, String value) {
              return MapEntry(
                key,
                PopupMenuItem<int>(
                  value: key,
                  child: Text(value),
                ),
              );
            })
            .values
            .toList();
      },
      icon: Icon(Icons.more_vert),
    );
  }
}
