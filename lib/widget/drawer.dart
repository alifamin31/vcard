import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vcard/authentication/login.dart';
import 'package:vcard/home.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key, this.data}) : super(key: key);
  final data;

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {

  final storage = const FlutterSecureStorage();

  var dataPass;

  @override
  void initState() {
    dataPass = jsonDecode(widget.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(color: Colors.purple.shade600),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '   Sign in as :',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20,color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Align(
                  child: Text(
                    '${dataPass['username']}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20,color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      )
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  await storage.delete(key: 'email');
                  await storage.delete(key: 'password');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    )
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
