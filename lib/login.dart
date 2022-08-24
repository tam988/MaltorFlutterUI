import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;

  Future<void> _loginAnon() async {
    setState(() {
      loading = !loading;
    });

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      log(userCredential.user!.uid);

      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } catch (e) {
      //TODO handle errors better
      log('$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something is wrong'),
        ),
      );
      setState(() {
        loading = !loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: Text('SEL IDS'),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.bottomCenter,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/ids_poster.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            height: 250,
            padding: const EdgeInsets.all(26),
            child: Card(
              elevation: 3,
              color: Theme.of(context).canvasColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:30, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.person),
                      Text("Login"),
                    ],
                  ),
                  onPressed: _loginAnon,
                ),
                    SizedBox(
                      height: 20,
                    ),
              SizedBox(
                height: 40,
                child: loading ? CircularProgressIndicator.adaptive() : null,
              ),
              SizedBox(
                height: 20,
              ),
              ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
