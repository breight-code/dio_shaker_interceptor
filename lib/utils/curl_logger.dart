import 'package:collection/collection.dart';
import 'package:dio_shaker_interceptor/features/list_curl/data/curl_model.dart';
import 'package:get_it/get_it.dart';

class CurlLogs {
  bool isAlreadyOpen = false;
  final List<CurlModel> items = [];

  void replace({required CurlModel replace, required CurlModel save}) {
    final index = items.indexWhere(
      (item) => item.url == replace.url && item.status == null,
    );
    if (index != -1) {
      items[index] = save;
    }
  }

  CurlModel? getCurlModelByUri(Uri uri) {
    return items.firstWhereOrNull(
      (item) => item.url == uri && item.status == null,
    );
  }

  void addItem(CurlModel model) {
    items.insert(0, model);
  }

  static CurlLogs get instance {
    if (!GetIt.instance.isRegistered<CurlLogs>()) {
      GetIt.instance.registerSingleton<CurlLogs>(CurlLogs());
    }
    return GetIt.instance<CurlLogs>();
  }

  void clear() {
    items.clear();
  }
}
