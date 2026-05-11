import 'package:dio_shaker_interceptor/features/list_curl/data/curl_model.dart';
import 'package:dio_shaker_interceptor/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Utils.getCurl', () {
    test('redige Authorization header', () {
      final CurlModel m = CurlModel(
        url: Uri.parse('https://example.com/a'),
        headers: <String, dynamic>{
          'Authorization': 'Bearer secret',
          'Content-Type': 'application/json',
        },
        method: 'GET',
        extra: <String, dynamic>{},
        queryParameters: <String, dynamic>{},
        creationDate: DateTime.now(),
      );
      final String curl = Utils().getCurl(m, redactHeaders: true);
      expect(curl, isNot(contains('secret')));
      expect(curl, contains('***'));
      expect(curl, contains('application/json'));
    });

    test('escape apostrofo nel body JSON', () {
      final CurlModel m = CurlModel(
        url: Uri.parse('https://example.com/'),
        headers: <String, dynamic>{'Content-Type': 'application/json'},
        method: 'POST',
        body: <String, String>{'q': "it's"},
        extra: <String, dynamic>{},
        queryParameters: <String, dynamic>{},
        creationDate: DateTime.now(),
      );
      final String curl = Utils().getCurl(m);
      expect(curl, contains(r"'\''"));
    });

    test('estimateSize su String', () {
      expect(Utils.estimateSize('abc'), 3);
      expect(Utils.estimateSize(null), null);
    });
  });
}
