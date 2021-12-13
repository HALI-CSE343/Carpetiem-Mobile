import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code/pages/qr/qr_generate.dart';
import 'package:qr_code/pages/qr/qr_scan.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
          children: [
            const SizedBox(height: 10),
            /* Logo */
            Image.asset(
              'assets/images/logo.png',
              scale: 3,
            ),
            const SizedBox(height: 50),

            /* First Button */
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _scanQRCode(),
            ),

            /* Second Button */
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _generateQRCode(),
            ),

            /* Customer's phone number */
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: _getPhoneNumber(),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFC1BFE5),
    );
  }

  ElevatedButton _generateQRCode() {
    return ElevatedButton(
      onPressed: () {
        String phone = phoneController.text;
        if (phone.length != 14) {
          Fluttertoast.showToast(msg: "Lütfen doğru telefon numarası giriniz");
        } else {
          _findUser(phone);
        }
      },
      child: const Text(
        "QR Kod Oluştur",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(100, 56)),
        backgroundColor: MaterialStateProperty.all(const Color(0xFFFFBB38)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              color: Colors.black,
              width: 4,
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _scanQRCode() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const QrScan()));
      },
      child: const Text(
        "QR Kod Tara",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(100, 56)),
        backgroundColor: MaterialStateProperty.all(const Color(0xFFFFBB38)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              color: Colors.black,
              width: 4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPhoneNumber() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: "Müşteri Telefon Numarası",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 3,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 3,
            ),
          ),
        ),
        inputFormatters: [MaskTextInputFormatter(mask: "(###) ### ####")],
      ),
    );
  }

  Future _findUser(String phone) async {
    // Customer as QuerySnapshot
    QuerySnapshot customer = await FirebaseFirestore.instance.collection('customers').where('phone', isEqualTo: phone).get();
    // Warn the user if customer doesn't exist
    if (customer.docs.isEmpty) {
      Fluttertoast.showToast(msg: "Bu numarayla kayıtlı müşteri bulunmamakta.");
      return;
    }
    // Getting document snapshot of the query
    QueryDocumentSnapshot doc = customer.docs[0];
    // Document reference of that snapshot
    DocumentReference docRef = doc.reference;

    Fluttertoast.showToast(
      msg: "Phone: $phone, UserID: ${docRef.id}",
      toastLength: Toast.LENGTH_LONG,
    );

    Navigator.push(context, MaterialPageRoute(builder: (context) => QrGenerate(customerID: docRef.id)));
  }
}
