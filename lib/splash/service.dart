import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vcard/authentication/login.dart';
import 'package:vcard/home.dart';

class SplashService {

  final storage = FlutterSecureStorage();

  var _email;
  var _password;
  var _data;

  void loginDecision(BuildContext context) async {
    _email = await storage.read(key: 'email');
    _password = await storage.read(key: 'password');
    _data = await storage.read(key: 'data');

    final connectivityResult = await (Connectivity().checkConnectivity());
    
    if(connectivityResult == ConnectivityResult.none) {
      if(_email != null && _password != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(data: _data,)));
      } else {
        Timer(const Duration(seconds: 3), () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));
        });
      }
    } else {
      if(_email != null && _password != null) {
        final response = await http.post(
          Uri.parse('http://10.60.31.122:8000/api/vcard/login'),
          body: {
            'email' : _email,
            'password' : _password
          }
        );
        if(response.statusCode == 200) {
          final login = jsonDecode(response.body);
          print('login $login');
          if(login == 'Username Do Not Exist') {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));
          } else if(login == 'Wrong Password. Please Try Again') {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));
          } else {
            String data = jsonEncode(login);
            await storage.write(key: 'data', value: data);
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage(data: data,)));
          }
        }
      } else {
        Timer(const Duration(seconds: 3), () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));
        });
      }
    }
  }
}