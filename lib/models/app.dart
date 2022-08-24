import 'package:flutter/material.dart';

class App{
  final String id;
  final String name;
  final String sec;
  final String apkURL;
  final String accuracy;

  App({required this.id, required this.name, required this.sec, required this.apkURL, required this.accuracy});

  get appID => this.id;
  get appName => this.name;
  get security => this.sec;
  get getAPKURL => this.apkURL;
  get getAccuracy => this.accuracy;

  @override
  String toString(){
    return "id: " + this.id + ", name: " + this.name + ", security: " + this.security + ", apk: " + this.apkURL;
  }

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      id: json['id'],
      name: json['name'],
      sec: json['security'],
      apkURL: json['apk'],
      accuracy: json['accuracy'],
    );
  }
}