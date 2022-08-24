import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard(
      {Key? key,
      required this.appID,
      required this.appName,
      required this.security,
      required this.imageUrl})
      : super(key: key);

  final String appID;
  final String appName;
  final String security;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () {},
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  this.appName,
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                Divider(),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        "App ID: ",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'RobotoCondensed',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        this.appID,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        "Security: ",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'RobotoCondensed',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        this.security,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
