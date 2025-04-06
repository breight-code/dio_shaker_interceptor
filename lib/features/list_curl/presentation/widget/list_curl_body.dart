import 'package:dio_shaker_interceptor/features/curl_detail/presentation/screen/curl_detail_screen.dart';
import 'package:dio_shaker_interceptor/utils/curl_logger.dart';
import 'package:dio_shaker_interceptor/utils/utils.dart';
import 'package:flutter/material.dart';

/// A stateless widget that displays a list of cURL requests.
/// 
/// The [ListCurlBody] widget uses a [ListView.builder] to display each cURL request
/// as a [Card] widget. Each card shows the status and URL of the request. Users can
/// tap on a card to navigate to the [CurlDetailScreen] for more details, or long-press
/// to copy the cURL command to the clipboard.
class ListCurlBody extends StatelessWidget {
  const ListCurlBody({super.key});

  @override
  Widget build(BuildContext context) {
    if (CurlLogs.instance.items.isNotEmpty) {
      return ListView.builder(
        itemCount: CurlLogs.instance.items.length,
        itemBuilder: (context, index) {
          final item = CurlLogs.instance.items[index];
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onLongPress: () {
                Utils().copyCurl(item, context);
              },
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CurlDetailScreen(curlModel: item),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Status: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${item.status ?? 'ongoing'}',
                                      style: TextStyle(color: item.color),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${item.method} ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: item.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (item.updateDate != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Text(
                                    'Duration: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    Utils().calculateTimeBetweenTwoDate(
                                      item.creationDate,
                                      item.updateDate!,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Center(child: Text('No items found'));
    }
  }
}
