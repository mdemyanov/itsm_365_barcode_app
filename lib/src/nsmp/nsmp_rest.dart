import 'dart:async';
import 'dart:convert';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';

class NsmpRest {
  static final _headers = {'Content-Type': 'application/json'};
  static String _find = '../services/rest/find';
  static String _get = '../services/rest/get';
  static String _edit = '../services/rest/edit';
  static String _create = '../services/rest/create-m2m';
  static BrowserClient _http = new BrowserClient();

  static Future<Map> findFirst(String url) async {
    try {
      List data = await find(url);
      return data.length > 0 ? data.first : {};
    } catch (e) {
      print(e.toString());
      return {};
    }
  }
  static Future<Map> getObjectByUrl(String url) async {
    try {
      final response = await _http.get(url);
      return _extractData(response);
    } catch (e) {
      return {};
    }
  }
  static Future<Map> get(String url) async {
    try {
      final response = await _http.get('$_get/$url');
      return _extractData(response);
    } catch (e) {
      return {};
    }
  }

  static Future<List> find(String url) async {
    try {
      final response = await _http.get('$_find$url');
      return _extractData(response);
    } catch (e) {
      return [];
    }
  }

  static Future<Map> create(String url, Map data) async {
    try {
      final response = await _http.post(
          '$_create$url',
          headers: _headers,
          body: JSON.encode(data)
      );
      return _extractData(response);
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  static Future<String> edit(String url, Map data) async {
    String body = JSON.encode(data);
    try {
      final response = await _http.post(
          '$_edit$url',
          headers: _headers,
          body: body
      );
      return response.body;
    } catch (e) {
      print(e.toString());
      return 'Rest error';
    }
  }

  static _extractData(Response resp) => JSON.decode(resp.body);
}