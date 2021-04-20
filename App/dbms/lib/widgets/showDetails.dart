import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ShowDetails extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String doctor_name;
  // ignore: non_constant_identifier_names
  String search_term;
  ShowDetails(String e, String searchTerm) {
    doctor_name = e;
    this.search_term = searchTerm;
  }

  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  Map<String, String> details = {'': ''};
  List test = [];

  calling() async {
    await FirebaseFirestore.instance
        .collection('Details')
        .doc(widget.search_term)
        .collection('Name')
        .doc(widget.doctor_name)
        .get()
        .then((value) {
      setState(() {
        details.clear();
      });
      value.data().forEach((key, value) {
        print('Key: $key value: $value');
        details.putIfAbsent(key, () => value);
      });
      details.forEach((k, v) => test.add('{$k,$v}'));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calling();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.keyboard_backspace),
          color: Colors.black,
        ),
        title: Text(
          'Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.blueAccent,
      ),
      body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Doctor Details',
                  style:
                      GoogleFonts.lato(fontSize: 25, color: Colors.grey[700]),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Doctor Name\nDr.${widget.doctor_name}',
                  style: GoogleFonts.lato(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            offset: Offset(5, 5),
                            color: Colors.tealAccent),
                      ]),
                  child: Column(
                    children: [
                      ...details.entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '${e.key}:',
                                style: GoogleFonts.lato(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                e.value,
                                style: GoogleFonts.lato(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList()
                    ],
                  ),
                ),
              ),
              // ...details.keys.map((e) => print(e)).toList();
            ],
          )),
    );
  }
}
