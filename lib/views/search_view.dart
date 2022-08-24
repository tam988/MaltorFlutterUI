import 'dart:io';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui_ids/localization/language_constants.dart';
import 'dart:convert';
import 'package:ui_ids/models/app.dart';
import 'package:ui_ids/controllers/apps_controller.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:ui_ids/views/widgets/app_card.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  static const routeName = '/search_view';

  @override
  _SearchView createState() => _SearchView();
}

class _SearchView extends State<SearchView> {
  late final User? currentUser;
  final _formKey = GlobalKey<FormState>();
  String _image = "assets/images/searchDB.png";
  String _text = "";
  late List<App?> _appList = [];
  var _appNameInput = "";
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String?, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Map<String?, dynamic>? deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String?, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData!;
    });
  }

  Map<String?, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String?, dynamic>{
      // 'Version Security Patch': build.version.securityPatch,
      // 'version.sdkInt': build.version.sdkInt,
      getTranslated(context, 'latest_version'): build.version.release,
      // 'version.previewSdkInt': build.version.previewSdkInt,
      // 'version.incremental': build.version.incremental,
      // 'version.codename': build.version.codename,
      // 'version.baseOS': build.version.baseOS,
      // 'board': build.board,
      // 'bootloader': build.bootloader,
      getTranslated(context, 'phone_brand'): build.brand,
      getTranslated(context, 'device_name'): build.device,
      // 'display': build.display,
      // 'fingerprint': build.fingerprint,
      // 'hardware': build.hardware,
      // 'host': build.host,
      // 'id': build.id,
      // 'manufacturer': build.manufacturer,
      getTranslated(context, 'device_model'): build.model,
      getTranslated(context, 'product'): build.product,
      // 'supported32BitAbis': build.supported32BitAbis,
      // 'supported64BitAbis': build.supported64BitAbis,
      // 'supportedAbis': build.supportedAbis,
      // 'tags': build.tags,
      // 'type': build.type,
      // 'isPhysicalDevice': build.isPhysicalDevice,
      // 'androidId': build.androidId,
      // 'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  void _saveForm() {
    final _isValid = _formKey.currentState!.validate();
    if (!_isValid) {
      return;
    }
    _formKey.currentState!.save();
    searchApp(_appNameInput);
    print("_appNameInput = " + _appNameInput);
  }

  void searchApp(String _appName) async {
    try {
      _appList.clear();
      App _app = App(id: "", name: "", sec: "", apkURL: "", accuracy: "");
      String searchAppResponse = (await AppsController().search(_appName));
      var appJson = json.decode(searchAppResponse.toString());
      print(
          "status: " + appJson["status"] + " , message: " + appJson["message"]);
      if (appJson["status"] == "000") {
        setState(() {
          _image = "assets/images/scan_success.png";
          for (var app in appJson["0"]['apps']) {
            _app = App(
                id: app["appID"],
                name: app["appName"],
                sec: app["security"],
                apkURL: app["apk"],
                accuracy: app["accuracy"]);
            _appList.add(_app);
          }
        });
        print("appList ==> " + _appList.toString());
      } else {
        print("status: " +
            appJson["status"] +
            " , message: " +
            appJson["message"]);
        setState(() {
          _image = "assets/images/scan_failed.png";
          _text = "no apps found";
        });
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Ops, something went wrong!"),
      ));
    }
  }

  String imageURL(String sec) {
    switch (sec) {
      case "unknown":
        return 'assets/images/scan.png';
        break;
      case "benign":
        return 'assets/images/benign.png';
        break;
      case "adverse":
        return 'assets/images/adverse.png';
        break;
      default:
        return 'assets/images/not-found.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Card(
        elevation: 50,
        shadowColor: Colors.grey,
        color: Theme.of(context).canvasColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: _deviceData.keys.map((String? property) {
              return Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      property!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    child: Text(
                      '${_deviceData[property]}',
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
// @override
// Widget build(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.all(20),
//     child: Form(
//       key: _formKey,
//       child: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0, bottom: 8),
//               child: Text(
//                 'Enter the name of the application:',
//                 style: Theme.of(context).textTheme.headline1,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0, bottom: 8),
//               child: TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'App name',
//                   border: OutlineInputBorder(),
//                   hintText: 'instagram',
//                 ),
//                 style: Theme.of(context).textTheme.headline1,
//                 //controller: controller,
//                 keyboardType: TextInputType.text,
//                 validator: (value) {
//                   // TODO: validate user input
//                   //var Pattern = r"(([a-zA-Z]\.)||(\d))";
//                   //var Pattern = r"((\w+)\.(\w+)\.(\w+)$)";
//                   // var result = new RegExp(Pattern, caseSensitive: false).firstMatch(value);
//                   if (value!.isEmpty) {
//                     return "Please enter an app name";
//                   }
//                   return null;
//                 },
//                 textInputAction: TextInputAction.done,
//                 onFieldSubmitted: (_) {
//                   _saveForm();
//                 },
//                 onSaved: (value) {
//                   _appNameInput = value!.trim().toLowerCase();
//                 },
//               ),
//             ),
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   textStyle: TextStyle(fontSize: 20),
//                 ),
//                 child: Text(
//                   'Check App',
//                   style: Theme.of(context).textTheme.bodyText2,
//                 ),
//                 onPressed: _saveForm,
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             _appList.length == 0
//                 ? Center(
//                     child: Column(
//                       children: [
//                         Stack(
//                           children: <Widget>[
//                             Container(
//                               decoration: new BoxDecoration(
//                                 color: Theme.of(context).canvasColor,
//                                 shape: BoxShape.circle,
//                               ),
//                               height: 200,
//                               width: 200,
//                               child: Image.asset(
//                                 _image,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                           ],
//                         ),
//                         _text == "no apps found"
//                             ? Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 10),
//                                 child: Card(
//                                   color: Colors.orangeAccent,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(30),
//                                     child: Text(
//                                       _text,
//                                       style:
//                                           Theme.of(context).textTheme.headline1,
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             : SizedBox(
//                                 height: 30,
//                               ),
//                       ],
//                     ),
//                   )
//                 : Container(
//                     child: ListView.builder(
//                       itemCount: _appList.length,
//                       scrollDirection: Axis.vertical,
//                       shrinkWrap: true,
//                       physics: ClampingScrollPhysics(),
//                       itemBuilder: (BuildContext context, int index) {
//                         return AppCard(
//                             appID: _appList[index]!.appID,
//                             appName: _appList[index]!.appName,
//                             security: _appList[index]!.security,
//                             imageUrl: imageURL(_appList[index]!.security));
//                       },
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
// }