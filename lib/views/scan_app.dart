import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ui_ids/localization/language_constants.dart';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:ui_ids/models/app.dart';

class AppScanView extends StatefulWidget {
  const AppScanView({Key? key}) : super(key: key);

  static const routeName = '/scan_app';

  @override
  _AppScanView createState() => _AppScanView();
}

class _AppScanView extends State<AppScanView> {
  late final User? currentUser;
  final _formKey = GlobalKey<FormState>();
  String _image = "assets/images/defense.png";
  String _text = "";
  late App? _app = App(id: "", name: "", sec: "", apkURL: "", accuracy: "");
  var _appNameInput = "";
  bool appExist = false;
  double showAccuracy = 0;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _image = "assets/images/scan.png";
    _text = "";
    appExist = false;
  }

  void _saveForm() {
    final _isValid = _formKey.currentState!.validate();
    if (!_isValid) {
      return;
    }
    _formKey.currentState!.save();
    _searchAppOnServer(_appNameInput);
    print("_appNameInput = " + _appNameInput);
  }

  // search for the app using the api on the server
  Future<void> _searchAppOnServer(String _appName) async {
    _app = App(id: "", name: "", sec: "", apkURL: "", accuracy: "");
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.19.160:80/apk_scraper.php'));
    request.fields.addAll({'appName': _appName});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var appString = await response.stream.bytesToString();
      var appJson = json.decode(appString);
      print(appString);
      print(appJson);

      if (appJson["status"] == "002" || appJson["status"] == "000") {
        // apk already exist
        setState(() {
          _app = App(
              id: appJson["app"]["appID"],
              name: appJson["app"]["appName"],
              sec: appJson["app"]["security"],
              apkURL: appJson["app"]["apk"],
              accuracy: appJson["app"]["accuracy"]);
          appExist = true;
          //_text = _app!.name + " security is " + _app!.security + "\napp id: " + _app!.id + "\napk link: " + appJson["app"]["apk"];
          _text = _app!.name;
          showAccuracy = double.parse(_app!.accuracy);
          _image = "assets/images/scan_success.png";
        });
      }
    } else {
      appExist = false;
      var appString = await response.stream.bytesToString();
      var appJson = json.decode(appString);
      print(response.reasonPhrase);
      print(
          "status: " + appJson["status"] + " , message: " + appJson["message"]);
      setState(() {
        _text = "Sorry! could not scan this app";
        _image = "assets/images/scan_failed.png";
        print("status: " +
            appJson["status"] +
            " , message: " +
            appJson["message"]);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sorry, we could not scan this app!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 20, right: 20, bottom: 10),
                child: Text(
                  (getTranslated(context, 'scan_field'))!,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: (getTranslated(context, 'app_name'))!,
                    border: OutlineInputBorder(),
                    hintText: (getTranslated(context, 'app_name_hint'))!,
                  ),
                  style: Theme.of(context).textTheme.headline1,
                  //controller: controller,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    // TODO: validate user input
                    //var Pattern = r"(([a-zA-Z]\.)||(\d))";
                    //var Pattern = r"((\w+)\.(\w+)\.(\w+)$)";
                    // var result = new RegExp(Pattern, caseSensitive: false).firstMatch(value);
                    if (value!.isEmpty) {
                      return (getTranslated(context, 'app_name_empty'))!;
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    _saveForm();
                  },
                  onSaved: (value) {
                    _appNameInput = value!.trim().toLowerCase();
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  child: Text(
                    (getTranslated(context, 'scan_action'))!,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  onPressed: _saveForm,
                ),
              ),
              // if (snapshot.connectionState == ConnectionState.active)
              //   {
              SizedBox(
                height: 20,
              ),
              Center(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: new BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          shape: BoxShape.circle,
                        ),
                        height: 200,
                        width: 200,
                        child: Image.asset(
                          _image,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (_text.isNotEmpty)
                appExist
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  _text,
                                  style: Theme.of(context).textTheme.headline1,
                                  textAlign: TextAlign.center,
                                ),
                                Divider(),
                                // Container(
                                //   padding:
                                //       const EdgeInsets.symmetric(vertical: 5.0),
                                //   width: double.infinity,
                                //   child: Row(
                                //     children: [
                                //       Text(
                                //         (getTranslated(context, 'app_id'))!,
                                //         style: TextStyle(
                                //           fontSize: 18.0,
                                //           fontFamily: 'RobotoCondensed',
                                //           fontWeight: FontWeight.bold,
                                //         ),
                                //       ),
                                //       Text(
                                //         _app!.id,
                                //         style:
                                //             Theme.of(context).textTheme.bodyText2,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Text(
                                        (getTranslated(
                                            context, 'app_security'))!,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: 'RobotoCondensed',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _app!.sec,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (getTranslated(
                                            context, 'app_accuracy'))!,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: 'RobotoCondensed',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Flexible(
                                        //Text(
                                        //   _app!.accuracy,
                                        //   style: Theme.of(context)
                                        //       .textTheme
                                        //       .bodyText1,
                                        //   overflow: TextOverflow.ellipsis,
                                        //   maxLines: 5,
                                        // ),
                                        child: GFProgressBar(
                                          percentage: showAccuracy / 100,
                                          lineHeight: 30,
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          alignment:
                                              MainAxisAlignment.spaceBetween,
                                          child: Text(
                                            _app!.accuracy + '%',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                          leading: Icon(
                                              Icons
                                                  .sentiment_dissatisfied_sharp,
                                              color: Colors.red),
                                          trailing: Icon(
                                              Icons.sentiment_satisfied_sharp,
                                              color: Colors.green),
                                          backgroundColor: Colors.black12,
                                          progressBarColor: Colors.green,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                // Container(
                                //   padding:
                                //       const EdgeInsets.symmetric(vertical: 5.0),
                                //   width: double.infinity,
                                //   child: Row(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //       Text(
                                //         (getTranslated(
                                //             context, 'app_apk_link'))!,
                                //         style: TextStyle(
                                //           fontSize: 18.0,
                                //           fontFamily: 'RobotoCondensed',
                                //           fontWeight: FontWeight.bold,
                                //         ),
                                //       ),
                                //       Flexible(
                                //         child: Text(
                                //           _app!.apkURL,
                                //           style: Theme.of(context)
                                //               .textTheme
                                //               .bodyText1,
                                //           overflow: TextOverflow.ellipsis,
                                //           maxLines: 5,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          color: Colors.orangeAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Text(
                              _text,
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
              else
                SizedBox(
                  height: 30,
                ),
              //}
            ],
          ),
        ),
      );
    });
  }
}