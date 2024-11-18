part of "my_dio.dart";

class CustomInterceptors extends Interceptor {

  // static final _header = {"content-type": "application/json; charset=utf-8"};
  // String token;

  // CustomInterceptors(this.token);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    // options.headers.addAll(_header);
    // options.headers.addAll({'x-token': token});

    if (kDebugMode) {
      print('REQUEST[${options.method}] => PATH: ${options.path}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    }
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.data}');
    }
    super.onError(err, handler);
    return Future(() => err);
  }
}
