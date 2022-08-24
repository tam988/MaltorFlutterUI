import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:ui_ids/models/app.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class UpdateView extends StatefulWidget {
  const UpdateView({Key? key}) : super(key: key);

  static const routeName = '/update_view';

  @override
  _UpdateViewState createState() => _UpdateViewState();
}

class _UpdateViewState extends State<UpdateView> {
  late final User? currentUser;
  final _formKey = GlobalKey<FormState>();
  late App? _appInput = App(id: "", name: "", sec: "", apkURL: "", accuracy: "");
  bool _checkBoxBenign = false;
  bool _checkBoxAdverse = false;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  void _saveForm() {
    final _isValid = _formKey.currentState!.validate();
    if (!_isValid) {
      return;
    }
    _formKey.currentState!.save();
    _updateMyRecord();
    print("appInput = " + _appInput!.toString());
  }

  Future<void> _updateMyRecord() async {
    try {
      final Uri url = Uri.parse(
          "https://sel-anti-malware-f4b91-default-rtdb.europe-west1.firebasedatabase.app/apps.json");
      final http.Response response = await http
          .post(
        url,
        body: json.encode(
          {
            "id": _appInput!.id,
            "name": _appInput!.name,
            "security": _appInput!.security
          },
        ),
      )
          .then((response) {
        print(json.decode(response.body));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('App data updated'),
          ),
        );
        return response;
      }).catchError((error) {
        print(json.decode(error));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ops! error happened.'),
          ),
        );
      });
      print("response " + response.statusCode.toString());
    } catch (e) {
      log('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    //final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, bottom: 10, left: 2),
                      child: Text(
                        'Update an app security info:',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'App name',
                          border: OutlineInputBorder(),
                          hintText: 'instagram',
                        ),
                        style: Theme.of(context).textTheme.headline1,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter an app name";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _appInput = App(
                              id: _appInput!.id,
                              name: value!.trim().toLowerCase(),
                              sec: _appInput!.security,
                              apkURL: "", accuracy: "");
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'App ID',
                          border: OutlineInputBorder(),
                          hintText: 'com.instagram.android',
                        ),
                        style: Theme.of(context).textTheme.headline1,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter an app ID";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _appInput = App(
                              id: value!.trim(),
                              name: _appInput!.name,
                              sec: _appInput!.security,
                              apkURL: "",
                              accuracy: "");
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, bottom: 8, left: 2),
                      child: Text(
                        'App security',
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    FormField(
                      initialValue: false,
                      validator: (value) {
                        if (value == false) {
                          return 'Please choose a security state.';
                        }
                        return null;
                      },
                      builder: (FormFieldState formFieldState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _checkBoxBenign,
                                  onChanged: (value) {
                                    _checkBoxBenign = value!;
                                    _checkBoxAdverse = false;
                                    formFieldState.didChange(value);
                                    if (value == true) {
                                      setState(() {
                                        _appInput = App(
                                            id: _appInput!.id,
                                            name: _appInput!.name,
                                            sec: "benign",
                                            apkURL: "",
                                            accuracy: "");
                                      });
                                    }
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    'Benign',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: _checkBoxAdverse,
                                  onChanged: (value) {
                                    _checkBoxAdverse = value!;
                                    _checkBoxBenign = false;
                                    formFieldState.didChange(value);
                                    if (value == true) {
                                      setState(() {
                                        _appInput = App(
                                            id: _appInput!.id,
                                            name: _appInput!.name,
                                            sec: "adverse",
                                            apkURL: "",
                                            accuracy: "");
                                      });
                                    }
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    'Adverse',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                              ],
                            ),
                            if (!formFieldState.isValid)
                              Text(
                                formFieldState.errorText ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: Theme.of(context).errorColor),
                              ),
                          ],
                        );
                      },
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 20),
                        ),
                        child: Text(
                          'Update App',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        onPressed: _saveForm,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
