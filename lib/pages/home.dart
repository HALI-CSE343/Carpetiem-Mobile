import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code/pages/qr/qr_generate.dart';
import 'package:qr_code/pages/qr/qr_scan.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController phoneController = TextEditingController();

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
                String phone = phoneController.text;
                _findUser(phone);
              },
              child: const Text("Generate QR Code"),
            ),
            _getPhoneNumber(),
          ],
        ),
      ),
    );
  }

  Widget _getPhoneNumber() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          hintText: "Müşteri Telefon Numarası",
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future _findUser(String phone) async {
    // Customer as QuerySnapshot
    QuerySnapshot customer = await FirebaseFirestore.instance.collection('customers').where('phone', isEqualTo: phone).get();
    // Getting document snapshot of the query
    QueryDocumentSnapshot doc = customer.docs[0];
    // Document reference of that snapshot
    DocumentReference docRef = doc.reference;

    Fluttertoast.showToast(
      msg: "Phone: $phone, UserID: ${docRef.id}",
      toastLength: Toast.LENGTH_LONG,
    );

    Navigator.push(context, MaterialPageRoute(builder: (context) => QrGenerate(phoneNumber: phone)));
  }
}
