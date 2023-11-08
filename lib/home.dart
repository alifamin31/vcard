import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vcard/widget/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.data}) : super(key: key);
  final data;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var dataPass;

  @override
  void initState() {
    dataPass = jsonDecode(widget.data);
    super.initState();
  }
  
  String generateVCard() {
    return 'BEGIN:VCARD\n'
      'VERSION:3.0\n'
      'N:${dataPass['fullname']}\n'
      'ORG:${dataPass['username']}\n'
      'TEL:${dataPass['phone_number']}\n'
      'END:VCARD';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('vCard'),
          backgroundColor: Colors.purple.shade600,
        ),
        drawer: DrawerPage(data: widget.data),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Text(
                '${dataPass['fullname']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                '${dataPass['employment']}'
              ),
              const SizedBox(
                height: 40,
              ),
              RepaintBoundary(
                child: QrImage(
                  embeddedImage: const AssetImage('images/vcard.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const ui.Size(50, 50),
                  ),
                  data: generateVCard(),
                  version: QrVersions.auto,
                  size: 200.0,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
              ),
              const Text('vCard')
            ],
          ),
        ),
      ),
    );
  }
}
