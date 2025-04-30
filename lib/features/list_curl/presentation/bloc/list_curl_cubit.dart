import 'package:dio_shaker_interceptor/features/list_curl/presentation/bloc/list_curl_state.dart';
import 'package:dio_shaker_interceptor/utils/curl_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit responsible for managing the list of cURL requests.
class ListCurlCubit extends Cubit<ListCurlState> {
  final TextEditingController searchController = TextEditingController();

  /// Constructor that initializes the cubit with an initial state.
  ListCurlCubit() : super(const ListCurlState()) {
    emit(state.copyWith(curlList: CurlLogs.instance.items));

    /// Updates the list of cURL models in the state.
    ///
    /// [newCurlList] is the new list of cURL models to be set in the state.
    searchController.addListener(() {
      emitListFilter();
    });
  }

  void emitListFilter() {
    final query = searchController.text.toLowerCase();
    final filteredList = CurlLogs.instance.items.where((curl) {
      final urlContainsQuery =
          curl.url.toString().toLowerCase().contains(query);
      final statusListSelected = state.statusListSelected ?? [];
      final statusMatches = statusListSelected.isEmpty ||
          statusListSelected.contains(curl.status);
      return urlContainsQuery && statusMatches;
    }).toList();
    emit(state.copyWith(curlList: filteredList));
  }

  /// Updates the status in the state.
  ///
  /// [newStatus] is the new status to be set in the state.
  void updateStatus(int newStatus) {
    final currentStatusList = state.statusListSelected ?? [];
    if (!currentStatusList.contains(newStatus)) {
      emit(state
          .copyWith(statusListSelected: [...currentStatusList, newStatus]));
    } else {
      final updatedStatusList = List<int>.from(currentStatusList)
        ..remove(newStatus);
      emit(state.copyWith(statusListSelected: updatedStatusList));
    }
    emitListFilter();
  }

  List<int> get statusList {
    return CurlLogs.instance.items
        .map((e) => e.status)
        .whereType<int>()
        .toSet()
        .toList();
  }
}

extension BuildContextExt on BuildContext {
  ListCurlCubit get listCurlCubit => read<ListCurlCubit>();
}
