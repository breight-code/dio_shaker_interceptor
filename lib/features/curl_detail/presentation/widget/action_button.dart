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
class ActionButton extends StatelessWidget {
  final CurlModel curlModel;

  const ActionButton({super.key, required this.curlModel});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (int value) async {
        final Utils utils = Utils();
        switch (value) {
          case 0:
            utils.copyCurl(curlModel, context, redactHeaders: true);
            break;
          case 1:
            await SharePlus.instance.share(
              ShareParams(text: utils.getCurl(curlModel, redactHeaders: true)),
            );
            break;
          case 2:
            final String data = _buildShareData(utils, redactHeaders: true);
            await SharePlus.instance.share(ShareParams(text: data));
            break;
          case 3:
            final String data = _buildShareData(utils, redactHeaders: true);
            final Directory directory = await getApplicationDocumentsDirectory();
            final String path =
                '${directory.path}/curl_details_${DateTime.now().millisecondsSinceEpoch}.txt';
            final File file = File(path);
            await file.writeAsString(data);
            final XFile xFile = XFile(path);
            await SharePlus.instance.share(ShareParams(files: <XFile>[xFile]));
            break;
          case 4:
            await showDialog<void>(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: const Text('Copia curl senza redaction'),
                  content: const Text(
                    'Gli header sensibili (Authorization, Cookie, …) saranno inclusi in chiaro. Continuare?',
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Annulla'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        utils.copyCurl(curlModel, context, redactHeaders: false);
                      },
                      child: const Text('Copia'),
                    ),
                  ],
                );
              },
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        const Map<int, String> items = <int, String>{
          0: 'Copy curl',
          1: 'Share curl',
          2: 'Share data',
          3: 'Download data',
          4: 'Copy curl (raw, no redact)',
        };
        return items
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
      icon: const Icon(Icons.more_vert),
    );
  }

  String _encodeJsonSafe(dynamic value) {
    try {
      if (value == null) {
        return 'null';
      }
      return JsonEncoder.withIndent('  ').convert(value);
    } catch (_) {
      return value.toString();
    }
  }

  String _buildShareData(Utils utils, {required bool redactHeaders}) {
    final Map<String, dynamic> headersForExport =
        Utils.redactedHeadersMap(curlModel.headers, redact: redactHeaders);
    return '''
Request data:\n
URL: ${curlModel.url}
Method: ${curlModel.method}
Headers: ${JsonEncoder.withIndent('  ').convert(headersForExport)}
Body: ${_encodeJsonSafe(curlModel.body)}
Query Parameters: ${_encodeJsonSafe(curlModel.queryParameters)}
Send at: ${curlModel.creationDate}
\nResponse data:\n
Status: ${curlModel.status}
Response: ${_encodeJsonSafe(curlModel.response)}
Response at: ${curlModel.updateDate}
${curlModel.updateDate != null ? 'Duration: ${utils.calculateTimeBetweenTwoDate(curlModel.creationDate, curlModel.updateDate!)}' : ''}
\nCurl: ${utils.getCurl(curlModel, redactHeaders: redactHeaders)}
                  ''';
  }
}
