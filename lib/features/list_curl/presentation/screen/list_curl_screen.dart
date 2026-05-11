import 'package:dio_shaker_interceptor/features/list_curl/presentation/bloc/list_curl_cubit.dart';
import 'package:dio_shaker_interceptor/features/list_curl/presentation/widget/list_curl_body.dart';
import 'package:dio_shaker_interceptor/utils/curl_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A stateless widget that represents the screen displaying a list of cURL requests.
///
/// The [ListCurlScreen] widget provides a user interface to view and manage
/// a list of cURL requests. It includes an app bar with a title and an optional
/// delete button that appears when there are items in the list. The delete button
/// allows users to clear all cURL logs after confirming their action through a dialog.
class ListCurlScreen extends StatelessWidget {
  const ListCurlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          CurlLogs.instance.markClosed();
        }
      },
      child: BlocProvider(
        create: (context) => ListCurlCubit(),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('List Curl'),
            actions: [
              if (CurlLogs.instance.items.isNotEmpty)
                IconButton(
                  onPressed: () {
                    // Show a confirmation dialog before deleting all items.
                    showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: Text('Confirm Deletion'),
                          content: Text(
                              'Are you sure you want to delete all items?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Clear all cURL logs and close the dialog and screen.
                                CurlLogs.instance.clear();
                                Navigator.of(ctx).pop(); // Close the dialog
                                Navigator.of(context).pop();
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
          body: ListCurlBody(),
        ),
      ),
    );
  }
}
