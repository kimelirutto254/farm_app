import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  // final String _url = "http://10.0.2.2:8000/api/";
  final String _url = "http://127.0.0.1:8000/api/";

  // Get the SharedPreferences instance

  // getImage(image) {
  //   return _imgUrl + image;
  // }

  postData(Map<String, dynamic> data, String apiUrl,
      {int? id, List<File>? files}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var fullUrl = _url + apiUrl + (id != null ? '/$id' : '');

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(fullUrl));

    // Add headers
    request.headers.addAll(_setHeaders(token));

    // Add fields
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add files to body
    if (files != null) {
      for (var i = 0; i < files.length; i++) {
        var stream = http.ByteStream(files[i].openRead());
        var length = await files[i].length();
        var multipartFile = http.MultipartFile('image[]', stream, length,
            filename: files[i].path.split('/').last);
        request.files.add(multipartFile);
      }
    }

    // Send request
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    // Decode response
    var responseBody = json.decode(responseString);

    return responseBody;
  }

  _setHeaders(token) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }

  getData(String apiUrl, {int? id}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      http.Response response = await http.get(
          Uri.parse(_url + apiUrl + (id != null ? '/$id' : '')),
          headers: _setHeaders(token));

      if (response.statusCode == 200) {
        return response;
      } else {
        return 'failed';
      }
    } catch (e) {
      print(e);
      return 'failed';
    }
  }
}
//Future<void> _getData() async {
