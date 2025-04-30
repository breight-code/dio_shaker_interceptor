import 'package:dio_shaker_interceptor/features/curl_detail/presentation/screen/curl_detail_screen.dart';
import 'package:dio_shaker_interceptor/features/list_curl/data/curl_model.dart';
import 'package:dio_shaker_interceptor/utils/utils.dart';
import 'package:flutter/material.dart';

class CurlCard extends StatelessWidget {
  final CurlModel item;
  const CurlCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${item.status ?? 'ongoing'}',
                                style: TextStyle(
                                  color: item.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
