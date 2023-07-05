import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CookieManager extends Interceptor {
  // singleton
  static final CookieManager _instance = CookieManager._internal();
  static CookieManager get instance => _instance;
  CookieManager._internal();

  String? _cookie;

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // print('OnResponse');
    if (response.statusCode == 200) {
      if (response.headers.map['Set-Cookie'] != null) {
        _saveCookie(response.headers.map['Set-Cookie']![0]);
      } else if (response.statusCode == 401) {
        _clearCookie();
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    print('Current Cookie:$_cookie');
    options.headers['Cookie'] = _cookie;
    super.onRequest(options, handler);
  }

  Future<void> initCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cookie = prefs.getString('cookie');
    print('Init Cookie:$_cookie');
  }

  void _saveCookie(String newCookie) async {
    if (_cookie != newCookie) {
      _cookie = newCookie;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('cookie', _cookie!);
    }
  }

  void _clearCookie() async {
    _cookie = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cookie');
  }
}
