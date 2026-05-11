import 'package:collection/collection.dart';
import 'package:dio_shaker_interceptor/features/list_curl/data/curl_model.dart';
import 'package:get_it/get_it.dart';

class CurlLogs {
  bool isAlreadyOpen = false;

  /// Numero massimo di richieste in memoria (più vecchie eliminate).
  int maxItems = 200;

  final List<CurlModel> items = [];

  /// Chiude lo stato "inspector già aperto" (es. dopo pop lista).
  void markClosed() {
    isAlreadyOpen = false;
  }

  void replace({required CurlModel replace, required CurlModel save}) {
    final int index = items.indexWhere((CurlModel item) => item.id == replace.id);
    if (index != -1) {
      items[index] = save;
    }
  }

  CurlModel? getById(String id) {
    return items.firstWhereOrNull((CurlModel item) => item.id == id);
  }

  @Deprecated('Usa getById per match stabile con richieste parallele.')
  CurlModel? getCurlModelByUri(Uri uri) {
    return items.firstWhereOrNull(
      (CurlModel item) => item.url == uri && item.status == null,
    );
  }

  void addItem(CurlModel model) {
    items.insert(0, model);
    while (items.length > maxItems) {
      items.removeLast();
    }
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
