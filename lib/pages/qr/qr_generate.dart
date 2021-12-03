import 'package:flutter/material.dart';

class QrGenerate extends StatelessWidget {
  const QrGenerate({Key? key, required String phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("CarpeTiem - QR Kod Oluşturma"),
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.blueGrey[200],
    );
  }
}
