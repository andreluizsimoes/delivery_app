import 'dart:developer';

import 'package:delivery_app/app/core/global/global_context.dart';
import 'package:delivery_app/app/core/rest_client/custom_dio.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../exceptions/expired_token_exception.dart';

class AuthInterceptor extends Interceptor {
  final CustomDio dio;

  AuthInterceptor(this.dio);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // super.onRequest(options, handler);
    final sp = await SharedPreferences.getInstance();
    final accessToken = sp.getString('accessToken');

    options.headers['Authorization'] = 'Bearer $accessToken';

    return handler.next(options);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    // super.onError(err, handler);
    if (err.response?.statusCode == 401) {
      try {
        if (err.requestOptions.path != '/auth/refresh') {
          await _refreshToken(err);
          await _retryRequest(err, handler);
        } else {
          GlobalContext.i.loginExpire();
        }
      } catch (e) {
        GlobalContext.i.loginExpire();
      }
    } else {
      return handler.next(err);
    }
  }

  Future<void> _refreshToken(DioError err) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final refreshToken = sp.getString('refreshToken');

      if (refreshToken == null) {
        return;
      }

      final refreshResult = await dio.auth().put('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });

      sp.setString('accessToken', refreshResult.data['access_token']);
      sp.setString('refreshToken', refreshResult.data['refresh_token']);
    } on DioError catch (e, s) {
      log('Erro ao realizar o RefreshToken', error: e, stackTrace: s);
      throw ExpiredTokenException();
    }
  }

  Future<void> _retryRequest(
      DioError err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;

    final result = await dio.request(
      requestOptions.path,
      options: Options(
          headers: requestOptions.headers, method: requestOptions.method),
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );

    handler.resolve(Response(
      requestOptions: requestOptions,
      data: result.data,
      statusCode: result.statusCode,
      statusMessage: result.statusMessage,
    ));
  }
}
