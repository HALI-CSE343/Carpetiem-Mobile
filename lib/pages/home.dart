import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_code/pages/qr/qr_generate.dart';
import 'package:qr_code/pages/qr/qr_scan.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* App Bar */
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: const Text("CarpeTiem"),
      ),

      /* Body - Buttons */
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /* First Button */
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const QrScan()));
              },
              child: const Text("Scan QR Code"),
            ),
            Container(
              height: 5,
              color: Colors.black,
            ),

            /* Second Button */
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const QrGenerate()));
              },
              child: const Text("Generate QR Code"),
            )
          ],
        ),
      ),
    );
  }
}
