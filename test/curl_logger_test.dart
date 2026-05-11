import 'package:dio_shaker_interceptor/features/list_curl/data/curl_model.dart';
import 'package:dio_shaker_interceptor/utils/curl_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

CurlModel _minimal({required String id}) {
  return CurlModel(
    id: id,
    url: Uri.parse('https://example.com/x'),
    headers: <String, dynamic>{},
    method: 'GET',
    extra: <String, dynamic>{},
    queryParameters: <String, dynamic>{},
    creationDate: DateTime.now(),
  );
}

void main() {
  tearDown(() async {
    await GetIt.instance.reset();
  });

  test('addItem rispetta maxItems', () {
    final CurlLogs log = CurlLogs.instance;
    log.maxItems = 3;
    log.addItem(_minimal(id: '1'));
    log.addItem(_minimal(id: '2'));
    log.addItem(_minimal(id: '3'));
    log.addItem(_minimal(id: '4'));
    expect(log.items.length, 3);
    expect(log.items.first.id, '4');
    expect(log.items.last.id, '2');
  });

  test('getById e replace', () {
    final CurlLogs log = CurlLogs.instance;
    final CurlModel a = _minimal(id: 'a');
    log.addItem(a);
    expect(log.getById('a')?.id, 'a');
    final CurlModel updated = a.copyWith(status: 200, response: <String, dynamic>{});
    log.replace(replace: a, save: updated);
    expect(log.getById('a')?.status, 200);
  });

  test('markClosed resetta isAlreadyOpen', () {
    final CurlLogs log = CurlLogs.instance;
    log.isAlreadyOpen = true;
    log.markClosed();
    expect(log.isAlreadyOpen, isFalse);
  });
}
