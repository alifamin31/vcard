import 'package:flutter/material.dart';
import 'package:vcard/splash/service.dart';

class SplashIndex extends StatefulWidget {
  const SplashIndex({Key? key}) : super(key: key);

  @override
  State<SplashIndex> createState() => _SplashIndexState();
}

class _SplashIndexState extends State<SplashIndex> {

  SplashService splashService = SplashService();

  @override
  void initState() {
    splashService.loginDecision(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('SPLASHHHH'),
    );
  }
}
