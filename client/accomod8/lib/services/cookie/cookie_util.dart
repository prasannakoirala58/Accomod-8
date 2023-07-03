import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';

class CookieUtil {
  // static Future<void> storeCookies(String cookie) async {
  //   final jar = PersistCookieJar();
  //   final uri = Uri.parse(loginUrl);

  //   final parsedCookie = Cookie.fromSetCookieValue(cookie);

  //   print('Cookie:${jar.saveFromResponse(uri, [parsedCookie])}');
  //   // for (var cookie in cookies) {
  //   // final parsedCookie = Cookie.fromSetCookieValue(cookie);
  //   await jar.saveFromResponse(uri, [parsedCookie]);

  //   // await jar.save();

  //   // }
  // }

  Future<void> retrieveDataFromCookie({
    required String url,
  }) async {
    // print('ok cha hai');

    final response = await http.get(Uri.parse(url));
    // final body = response.body;
    // print('Res Body:$body');
    final head = response.headers;
    print('Res Head:$head');
    final cookies = response.headers['Set-Cookie'];
    print('Cookies: $cookies');
    if (cookies != null) {
      final individualCookies = cookies.split(',');
      // Parse and process the cookies as needed
      for (var cookie in individualCookies) {
        // Process the cookie value
        print('Cookie: $cookie');
        // Do something with the cookie value
      }
    }
    // return cookies;
  }

  // static Future<void> storeCookies(List<Cookie> cookies) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final cookieStrings = cookies.map((cookie) => cookie.toString()).toList();
  //   prefs.setStringList('cookies', cookieStrings);
  //   print('prefs: $prefs');
  //   print('cookieString: $cookieStrings');
  // }

  // static Future<List<Cookie>> retrieveCookies() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final cookieStrings = prefs.getStringList('cookies') ?? [];
  //   return cookieStrings
  //       .map((cookieStr) => Cookie.fromSetCookieValue(cookieStr))
  //       .toList();
  // }
}
