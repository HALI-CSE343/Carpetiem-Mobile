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
      resizeToAvoidBottomInset: false,

      /* Body - Buttons */
      body: Center(
        child: Column(
          children: [
            AppBar(
              title: const Text(
                  "CarpeTiem",
                  style: TextStyle(fontSize: 30, color: Colors.black)
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.black),
                  onPressed:  () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 130),
            /* Logo */
            Image.asset(
              'assets/images/search.png',
              scale: 4,
            ),
            const SizedBox(height: 50),

            /* Customer's phone number */
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: _getPhoneNumber(),
            ),
            /* First Button */
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _scanQRCode(),
            ),

            /* Second Button */
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: _generateQRCode(),
            ),



          ],
        ),
      ),
      backgroundColor: Colors.white,
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
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(320, 48)),
            backgroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                )
            )
        )
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
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(320, 48)),
            backgroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                )
            )
        )
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
          contentPadding: const EdgeInsets.all(8.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          hintText: "Customer's phone number",
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
