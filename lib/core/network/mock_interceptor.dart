import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class MockInterceptor extends Interceptor {
  MockInterceptor(this.assetBundle);

  final AssetBundle assetBundle;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path.contains('/inspections')) {
      await Future<void>.delayed(const Duration(milliseconds: 800));

      try {
        final String source = await assetBundle.loadString('assets/mocks/inspections.json');
        final Map<String, dynamic> decoded = jsonDecode(source) as Map<String, dynamic>;

        handler.resolve(
          Response<dynamic>(requestOptions: options, data: decoded, statusCode: decoded['statusCode'] as int? ?? 200),
        );
      } catch (e) {
        handler.reject(DioException(requestOptions: options, error: 'Falha ao carregar dados simulados: $e'));
      }
      return;
    }

    handler.next(options);
  }
}
