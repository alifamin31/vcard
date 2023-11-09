import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:vcard/home.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  var rememberme;
  var rememberemail;
  var rememberpassword;

  bool _isObscure3 = true;
  bool visible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    autoFillButton();
    super.initState();
  }

  Future<bool> _onWillPop() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              SystemNavigator.pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    return false;
  }

  void autoFillButton() async {
    rememberemail = await storage.read(key: 'rememberemail');
    rememberpassword = await storage.read(key: 'rememberpassword');
    rememberme = await storage.read(key: 'rememberme');
    setState(() {
      if(rememberme == 'true') {
        _rememberMe = true;
        print('object');
        _controllerEmail = TextEditingController(text: rememberemail);
        _controllerPassword = TextEditingController(text: rememberpassword);
      } else {
        print('objective');
        _controllerEmail = TextEditingController();
        _controllerPassword = TextEditingController();
      }
    });
  }

  Future<void> _signin() async {
    final response = await http.post(
      Uri.parse('http://10.60.31.122:8000/api/vcard/login'),
      body : {
        'email' : _controllerEmail.text,
        'password' : _controllerPassword.text
      }
    );
    if(response.statusCode == 200) {
      final login = jsonDecode(response.body);
      print('login $login');
      String data = jsonEncode(login);
      if(login == 'Username Do Not Exist') {
        showDialog(
          context: context,
          builder: (context){
            return const AlertDialog(
              content: Text('Email Not Found'),
            );
          }
        );
      } else if(login == 'Wrong Password. Please Try Again') {
        showDialog(
          context: context,
          builder: (context){
            return const AlertDialog(
              content: Text('Wrong Password. Please Try Again'),
            );
          }
        );
      } else {
        await storage.write(key: "email", value: _controllerEmail.text);
        await storage.write(key: "password", value: _controllerPassword.text);
        await storage.write(key: 'data', value: data);
        if(_rememberMe == true) {
          await storage.write(key: 'rememberme', value: _rememberMe.toString());
          await storage.write(key: 'rememberemail', value: _controllerEmail.text);
          await storage.write(key: 'rememberpassword', value: _controllerPassword.text);
        } else {
          await storage.write(key: 'rememberme', value: _rememberMe.toString());
        }
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage(data: data,)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection
        ],
        child: Scaffold(
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 40.0, left: 30.0, right: 30.0, bottom: 100.0
                  ),
                ),
                Expanded(
                  child: Container(
                    child:  Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: [
                                const Text(
                                  'e Business Card',textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    letterSpacing: 1,
                                    color: Colors.black87,
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.purple.shade600,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                                  ),
                                  color: const Color(0XFFE8EAF6),
                                  margin: const EdgeInsets.all(45),
                                  elevation: 9,
                                  child: Center(
                                    child: Container(
                                      margin: const EdgeInsets.all(20),
                                      child: Form(
                                        key: _formkey,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            TextFormField(
                                              controller: _controllerEmail,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: 'Email',
                                                enabled: true,
                                                contentPadding: const EdgeInsets.only(
                                                    left: 14.0, bottom: 8.0, top: 8.0),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(color: Colors.white),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(color: Colors.white),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.length == 0) {
                                                  return "Email cannot be empty";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              onSaved: (value) {
                                                _controllerEmail.text = value!;
                                              },
                                              keyboardType: TextInputType.emailAddress,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            TextFormField(
                                              controller: _controllerPassword,
                                              obscureText: _isObscure3,
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                    icon: Icon(_isObscure3
                                                        ? Icons.visibility
                                                        : Icons.visibility_off),
                                                    onPressed: () {
                                                      setState(() {
                                                        _isObscure3 = !_isObscure3;
                                                      });
                                                    }),
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: 'Password',
                                                enabled: true,
                                                contentPadding: const EdgeInsets.only(
                                                    left: 14.0, bottom: 8.0, top: 15.0),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(color: Colors.white),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide:
                                                  const BorderSide(color: Colors.white),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              validator: (value) {
                                                RegExp regex = RegExp(r'^.{6,}$');
                                                if (value!.isEmpty) {
                                                  return "Password cannot be empty";
                                                }
                                                if (!regex.hasMatch(value)) {
                                                  return ("please enter valid password min. 6 character");
                                                } else {
                                                  return null;
                                                }
                                              },
                                              onSaved: (value) {
                                                _controllerPassword.text = value!;
                                              },
                                              keyboardType: TextInputType.emailAddress,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                    value: _rememberMe,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _rememberMe = value!;
                                                      });
                                                    }
                                                ),
                                                const Text('Remember Me'),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            MaterialButton(
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20.0))),
                                              elevation: 5.0,
                                              splashColor: const Color(0xFF1A237E),
                                              height: 40,
                                              onPressed: () {
                                                _signin();
                                              },
                                              color: Colors.indigo[900],
                                              child: const Text(
                                                'Login  ',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  letterSpacing: 1,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
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
