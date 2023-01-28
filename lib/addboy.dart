import 'package:barangcok/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class addboy extends StatefulWidget {
  addboy({Key? key}) : super(key: key);

  @override
  State<addboy> createState() => _addboyState();
}

class _addboyState extends State<addboy> {
  final formkey = GlobalKey<FormState>();
  TextEditingController kode = TextEditingController();
  TextEditingController nama_barang = TextEditingController();
  TextEditingController jumlah = TextEditingController();
  Future _simpan() async {
    final respone = await http
        .post(Uri.parse('http://192.168.1.4/crud_boy/add.php'), body: {
      "kode": kode.text,
      "nama_barang": nama_barang.text,
      "jumlah": jumlah.text,
    });
    if (respone.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
      ),
      body: Form(
          key: formkey,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: kode,
                  decoration: InputDecoration(
                    hintText: "Kode",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Kode jangan kosong";
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: nama_barang,
                  decoration: InputDecoration(
                    hintText: "Nama Barang",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Nama barang jangan kosong";
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: jumlah,
                  decoration: InputDecoration(
                    hintText: "Jumlah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Jumlah jangan kosong";
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        _simpan().then((value) {
                          if (value) {
                            final snackBar = SnackBar(
                              content: const Text('Data disimpan'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            final snackBar = SnackBar(
                              content: const Text('Data gagal simpan'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: ((context) => home())),
                            (route) => false);
                      }
                    },
                    child: Text("Submit"))
              ],
            ),
          )),
    );
  }
}
