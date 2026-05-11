import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_shaker_interceptor/features/list_curl/data/curl_model.dart';
import 'package:dio_shaker_interceptor/utils/curl_logger.dart';
import 'package:dio_shaker_interceptor/utils/dsi_constants.dart';
import 'package:dio_shaker_interceptor/utils/utils.dart';
import 'package:flutter/material.dart';

class DioShakerInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String id = generateDsiRequestId();
    options.extra[kDsiRequestIdExtraKey] = id;

    final CurlModel curlModel = CurlModel(
      id: id,
      url: options.uri,
      headers: Map<String, dynamic>.from(options.headers),
      body: options.data,
      requestSize: Utils.estimateSize(options.data),
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
    final String? id = response.requestOptions.extra[kDsiRequestIdExtraKey] as String?;
    if (id == null) {
      super.onResponse(response, handler);
      return;
    }
    final CurlModel? curlModel = CurlLogs.instance.getById(id);
    if (curlModel != null) {
      try {
        final CurlModel updatedCurlModel = curlModel.copyWith(
          status: response.statusCode,
          response: response.data,
          responseSize: Utils.estimateSize(response.data),
        );
        CurlLogs.instance.replace(replace: curlModel, save: updatedCurlModel);
      } catch (e) {
        debugPrint('DioshakerInterceptor error: $e');
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final String? id = err.requestOptions.extra[kDsiRequestIdExtraKey] as String?;
    if (id != null && err.response != null) {
      final CurlModel? curlModel = CurlLogs.instance.getById(id);
      if (curlModel != null) {
        try {
          final CurlModel updatedCurlModel = curlModel.copyWith(
            status: err.response?.statusCode,
            response: err.response?.data,
            responseSize: Utils.estimateSize(err.response?.data),
          );
          CurlLogs.instance.replace(replace: curlModel, save: updatedCurlModel);
        } catch (e) {
          debugPrint('DioshakerInterceptor error: $e');
        }
      }
    }
    super.onError(err, handler);
  }
}

class CurlInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final CurlModel curlModel = CurlModel(
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
