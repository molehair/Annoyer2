import 'dart:convert';

import 'package:http/http.dart';

import 'config.dart';
import 'database/local_settings.dart';

class Browser {
  static final Client _client = Client();

  /// Create and return Uri instance
  static Uri createUri(String serverAddress, String unencodedPath,
      {Map<String, dynamic>? queryParameters}) {
    /// Cut out prefix "http://" or "https://" from the server address
    /// If omitted, it is regarded as https.
    return serverAddress.startsWith('http://')
        ? Uri.http(serverAddress.substring(7), unencodedPath, queryParameters)
        : Uri.https(serverAddress.substring(8), unencodedPath, queryParameters);
  }

  static Future<Response> get(
    String unencodedPath, {
    Map<String, dynamic>? queryParameters,
  }) async {
    var url = createUri(serverAddress, unencodedPath,
        queryParameters: queryParameters);

    String? cookie = await LocalSettings.getCookie();
    Response res;
    res = await _client.get(
      url,
      headers: (cookie != null) ? {"Cookie": cookie} : null,
    );

    // check new cookie
    await _updateCookie(res);

    return Future.value(res);
  }

  static Future<Response> post(
    String unencodedPath, {
    Map<String, dynamic>? queryParameters,
    Object? body,
    Encoding? encoding,
  }) async {
    var url = createUri(serverAddress, unencodedPath,
        queryParameters: queryParameters);

    String? cookie = await LocalSettings.getCookie();
    Response res;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (cookie != null) {
      headers["Cookie"] = cookie;
    }
    res = await _client.post(
      url,
      body: jsonEncode(body),
      encoding: encoding,
      headers: headers,
    );

    // check new cookie
    await _updateCookie(res);

    return Future.value(res);
  }

  static Future<void> _updateCookie(Response res) async {
    if (res.headers.containsKey("set-cookie")) {
      String raw = res.headers["set-cookie"]!;

      // parse and store the cookie on memory
      // e.g.
      //    "mysession=MTY0M...eTzC; Path=/; ..."
      //     => "mysession=MTY0M...eTzC"
      String cookie = raw.substring(0, raw.indexOf(";"));

      // store the cookie on disk
      await LocalSettings.setCookie(cookie);
    }
  }
}
