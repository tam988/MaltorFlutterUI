import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';

class AppsController with ChangeNotifier {
  // search for the app using the api on the server
  Future<void> scan(String _appName) async {
    try {
      var request = http.Request('GET',
          Uri.parse('http://10.0.19.90/search_app.php?s=$_appName'));

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var appString = await response.stream.bytesToString();
        var appJson = json.decode(appString);
        debugPrint(appString);
        //print(appJson);
        return appJson;
      } else {
        var appString = await response.stream.bytesToString();
        var appJson = json.decode(appString);
        print(response.reasonPhrase);
        print("status: " +
            appJson["status"] +
            " , message: " +
            appJson["message"]);
        return appJson;
      }
    } catch (e) {
      log('$e');
    }
  }

  // search for the app using the api on the server
  Future<String> search(String _appName) async {
    var request = http.Request('GET', Uri.parse('http://10.0.19.90/search_app.php?s=$_appName'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var appString = await response.stream.bytesToString();
      var appJson = json.decode(appString);
      print(appString);
      print(appJson);
      return appString;
    } else {
      var appString = await response.stream.bytesToString();
      print(response.reasonPhrase);

      return appString;
    }
  }
}
