import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_shaker_interceptor/features/list_curl/data/curl_model.dart';
import 'package:dio_shaker_interceptor/utils/curl_logger.dart';
import 'package:dio_shaker_interceptor/utils/utils.dart';
import 'package:flutter/material.dart';

class DioShakerInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final curlModel = CurlModel(
      url: options.uri,
      headers: options.headers,
      body: options.data,
      extra: options.extra,
      method: options.method,
      queryParameters: options.queryParameters,
      creationDate: DateTime.now(),
    );
    CurlLogs.instance.addItem(curlModel);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final curlModel = CurlLogs.instance.getCurlModelByUri(
      response.requestOptions.uri,
    );
    if (curlModel != null) {
      try {
        final updatedCurlModel = curlModel.copyWith(
          status: response.statusCode,
          response: response.data,
        );
        CurlLogs.instance.replace(
          replace: curlModel,
          save: updatedCurlModel,
        );
      } catch (e) {
        debugPrint("DioshakerInterceptor error: $e");
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      final curlModel = CurlLogs.instance.getCurlModelByUri(
        err.requestOptions.uri,
      );
      if (curlModel != null) {
        try {
          final updatedCurlModel = curlModel.copyWith(
            status: err.response?.statusCode,
            response: err.response?.data,
          );
          CurlLogs.instance.replace(
            replace: curlModel,
            save: updatedCurlModel,
          );
        } catch (e) {
          debugPrint("DioshakerInterceptor error: $e");
        }
      }
    }
    super.onError(err, handler);
  }
}

class CurlInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final curlModel = CurlModel(
      url: options.uri,
      headers: options.headers,
      body: options.data,
      extra: options.extra,
      method: options.method,
      queryParameters: options.queryParameters,
      creationDate: DateTime.now(),
    );
    log(
      '╔ API ════════════════════════════════════════════════════════════════════════════════════╗',
    );
    log(curlModel.name);
    log(Utils().getCurl(curlModel));
    log(
      '╚══════════════════════════════════════════════════════════════════════════════════════════╝',
    );
    super.onRequest(options, handler);
  }
}
