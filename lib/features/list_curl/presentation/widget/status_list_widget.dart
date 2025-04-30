import 'package:dio_shaker_interceptor/features/list_curl/presentation/bloc/list_curl_cubit.dart';
import 'package:dio_shaker_interceptor/features/list_curl/presentation/bloc/list_curl_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusListWidget extends StatelessWidget {
  const StatusListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListCurlCubit, ListCurlState>(builder: (context, state) {
      return SizedBox(
        height: 50.0, // Set a fixed height for the horizontal ListView
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: context.listCurlCubit.statusList.length,
          itemBuilder: (BuildContext context, int index) {
            final item = context.listCurlCubit.statusList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FilterChip(
                label: Text(item.toString()),
                selected: (state.statusListSelected?.contains(item) ?? false),
                onSelected: (_) {
                  context.listCurlCubit.updateStatus(item);
                },
              ),
            );
          },
        ),
      );
    });
  }
}
