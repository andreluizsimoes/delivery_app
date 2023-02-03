import 'package:delivery_app/app/core/global/global_context.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
    final sp = await SharedPreferences.getInstance();
    final accesstoken = sp.getString('accessToken');

    options.headers['Authorization'] = 'Bearer $accesstoken';

    handler.next(options);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);
    if (err.response?.statusCode == 401) {
      //Redirecionar usuário para Home!
      GlobalContext.i.loginExpire();
    } else {
      handler.next(err);
    }
  }
}
