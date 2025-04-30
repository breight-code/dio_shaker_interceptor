import 'package:dio_shaker_interceptor/features/list_curl/data/curl_model.dart';
import 'package:equatable/equatable.dart';

class ListCurlState extends Equatable {
  /// The list of cURL requests.
  final List<CurlModel> curlList;

  /// The current status of the cURL requests.
  final List<int>? statusListSelected;

  /// Creates a [ListCurlState] with the given [curlList] and [statusListSelected].
  ///
  /// The [curlList] parameter must not be null.
  const ListCurlState({
    this.curlList = const [],
    this.statusListSelected,
  });

  @override
  List<Object?> get props => [curlList, statusListSelected];

  /// Creates a copy of the current state with the given [curlList] and [statusList].
  ListCurlState copyWith({
    List<CurlModel>? curlList,
    List<int>? statusListSelected,
  }) {
    return ListCurlState(
      curlList: curlList ?? this.curlList,
      statusListSelected: statusListSelected ?? this.statusListSelected,
    );
  }
}
