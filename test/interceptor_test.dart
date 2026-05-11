import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_shaker_interceptor/features/list_curl/data/curl_model.dart';
import 'package:dio_shaker_interceptor/utils/curl_logger.dart';
import 'package:dio_shaker_interceptor/utils/dsi_constants.dart';
import 'package:dio_shaker_interceptor/utils/interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

class _FakeAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final String? id = options.extra[kDsiRequestIdExtraKey] as String?;
    return ResponseBody.fromString(
      '{"echo":"$id"}',
      200,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>['application/json'],
      },
    );
  }
}

void main() {
  tearDown(() async {
    await GetIt.instance.reset();
  });

  test('richieste parallele stessa URL hanno response distinta', () async {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: 'https://example.com',
      ),
    );
    dio.httpClientAdapter = _FakeAdapter();
    dio.interceptors.add(DioShakerInterceptor());

    await Future.wait(<Future<Response<dynamic>>>[
      dio.get<dynamic>('/same'),
      dio.get<dynamic>('/same'),
    ]);

    final CurlLogs log = CurlLogs.instance;
    expect(log.items.length, 2);
    for (final CurlModel item in log.items) {
      expect(item.response, isA<Map<dynamic, dynamic>>());
      final Map<dynamic, dynamic> m = item.response as Map<dynamic, dynamic>;
      expect(m['echo'], item.id);
    }
  });
}
