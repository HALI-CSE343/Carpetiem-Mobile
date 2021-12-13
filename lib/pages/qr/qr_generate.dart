import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGenerate extends StatefulWidget {
  final String customerID;

  const QrGenerate({Key? key, required this.customerID}) : super(key: key);

  @override
  State<QrGenerate> createState() => _QrGenerateState();
}

class _QrGenerateState extends State<QrGenerate> {
  TextEditingController areaController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String carpetType = "ince";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("CarpeTiem - QR Kod Oluşturma"),
        backgroundColor: Colors.grey[900],
      ),
      body: Column(
        children: [
          // Information text
          _getUser(context),
          // Space
          // Carpet
          _printCarpetInfo(),

          const Spacer(),
          Row(
            children: [
              Expanded(child: _generateAnotherQRButton(context)),
              Expanded(child: _generateButton()),
            ],
            mainAxisSize: MainAxisSize.max,
          )
        ],
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
      ),
      backgroundColor: Colors.blueGrey[200],
    );
  }

  Widget _getUser(BuildContext context) {
    // Getting customer collection
    CollectionReference customers = FirebaseFirestore.instance.collection('customers');

    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(widget.customerID).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong.");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Customer does not exist");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return _printCustomerInfo(data['address'], data['city'], data['district'], data['neighborhood'], data['name'], data['phone']);
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _printCustomerInfo(address, city, district, neighborhood, name, phone) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Spacing between Appbar and Müşteri Bilgileri
        const Align(
          child: SizedBox.square(
            dimension: 20,
          ),
          alignment: Alignment.center,
        ),

        // Text: Müşteri Bilgileri
        const Center(
          child: Text(
            "Müşteri Bilgileri",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        // Spacing between Müşteri Bilgileri and texts
        const Align(
          child: SizedBox.square(
            dimension: 20,
          ),
          alignment: Alignment.center,
        ),

        Row(
          children: [
            Column(
              children: [
                RichText(
                    text: const TextSpan(
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                        children: <TextSpan>[
                      TextSpan(text: "  İsim\n"),
                      TextSpan(text: "  Telefon\n"),
                      TextSpan(text: "  Şehir\n"),
                      TextSpan(text: "  İlçe\n"),
                      TextSpan(text: "  Semt\n"),
                      TextSpan(text: "  Adres\n"),
                    ]))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            const Align(
              child: SizedBox.square(
                dimension: 10,
              ),
              alignment: Alignment.center,
            ),
            Column(
              children: [
                RichText(
                    text: TextSpan(
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          height: 1.5,
                        ),
                        children: <TextSpan>[
                      TextSpan(text: ": $name   \n"),
                      TextSpan(text: ": $phone  \n"),
                      TextSpan(text: ": ${city[0].toUpperCase()}${city.substring(1)}   \n"),
                      TextSpan(text: ": ${district[0].toUpperCase()}${district.substring(1)}\n"),
                      TextSpan(text: ": ${neighborhood[0].toUpperCase()}${neighborhood.substring(1)}\n"),
                      TextSpan(text: ": $address\n"),
                    ]))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            )
          ],
        ),
      ],
    );
  }

  Widget _printCarpetInfo() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Text: Yeni Halı Bilgileri
        const Center(
          child: Text(
            "Yeni Halı Bilgileri",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        // Spacing between Yeni Halı Bilgileri and texts
        const Align(
          child: SizedBox.square(
            dimension: 20,
          ),
          alignment: Alignment.center,
        ),

        Padding(
          padding: const EdgeInsets.all(15),
          child: TextField(
            decoration: const InputDecoration(
              hintText: "Örnek: 2m²",
              alignLabelWithHint: true,
              labelText: "Halının alanı",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            keyboardType: TextInputType.phone,
            cursorWidth: 2,
            cursorHeight: 20,
            cursorColor: Colors.black,
            controller: areaController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextField(
            decoration: const InputDecoration(
              hintText: "Örnek: 80 TL",
              alignLabelWithHint: true,
              labelText: "Halının fiyatı",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            keyboardType: TextInputType.phone,
            cursorWidth: 2,
            cursorHeight: 20,
            cursorColor: Colors.black,
            controller: priceController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: _carpetTypeButton(),
        ),
      ],
    );
  }

  Widget _generateAnotherQRButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        // Customization
        child: const Text("Başka QR Kod Oluştur"),
        // Functional Partf
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => QrGenerate(customerID: widget.customerID)));
        },
      ),
    );
  }

  Widget _generateButton() {
    String area = areaController.text;
    String cost = priceController.text;
    String customerID = widget.customerID;
    String status = "Alındı";
    String type = carpetType;
    String newCarpetID = "";

    return Padding(
      child: ElevatedButton(
        // Customization
        child: const Text("Oluştur"),
        // Functional Partf
        onPressed: () {
          _getNewCarpetID(area, cost, customerID, status, type).then((value) => {
                newCarpetID = value,
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 200,
                              height: 300,
                              child: QrImage(
                                data: newCarpetID,
                              ),
                            ),
                            Text("Carpet ID: $newCarpetID"),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.download_rounded),
                              iconSize: 50,
                            )
                          ],
                        ),
                      );
                    })
              });
        },
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }

  Future<String> _getNewCarpetID(area, cost, customerID, status, type) async {
    CollectionReference carpets = FirebaseFirestore.instance.collection("carpets");

    DocumentReference docRef = await carpets.add({
      'area': area,
      'cost': cost,
      'customer_id': customerID,
      'status': status,
      'type': type,
    });
    return docRef.id;
  }

  Widget _carpetTypeButton() {
    return Row(
      children: [
        const Text(
          "Halının tipi : ",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: DropdownButton<String>(
            value: carpetType,
            alignment: Alignment.center,
            iconSize: 24,
            elevation: 0,
            style: const TextStyle(color: Colors.black, fontSize: 20),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) {
              setState(() {
                carpetType = newValue!;
              });
            },
            items: <String>['ince', 'orta', 'kalın'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
