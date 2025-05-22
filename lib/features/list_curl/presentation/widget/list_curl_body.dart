import 'package:dio_shaker_interceptor/features/curl_detail/presentation/screen/curl_detail_screen.dart';
import 'package:dio_shaker_interceptor/features/list_curl/presentation/bloc/list_curl_cubit.dart';
import 'package:dio_shaker_interceptor/features/list_curl/presentation/bloc/list_curl_state.dart';
import 'package:dio_shaker_interceptor/features/list_curl/presentation/widget/curl_card.dart';
import 'package:dio_shaker_interceptor/features/list_curl/presentation/widget/status_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return
      GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: context.listCurlCubit.searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              StatusListWidget(),
              Expanded(
                child: BlocBuilder<ListCurlCubit, ListCurlState>(
                  bloc: context.listCurlCubit,
                  builder: (context, state) {
                    if (state.curlList.isNotEmpty) {
                      return ListView.builder(
                        itemCount: state.curlList.length,
                        itemBuilder: (context, index) {
                          return CurlCard(item: state.curlList[index]);
                        },
                      );
                    } else {
                      return Center(child: Text('No items found'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }
}
