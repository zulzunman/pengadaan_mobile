import 'dart:convert';

import 'package:barangcok/addboy.dart';
import 'package:barangcok/editboy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class home extends StatefulWidget {
  home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _nameState();
}

class _nameState extends State<home> {
  List _listdata = [];
  bool _isloading = true;

  Future _getdata() async {
    try {
      final respone =
          await http.get(Uri.parse("http://192.168.1.4/crud_boy/read.php"));
      if (respone.statusCode == 200) {
        print(respone.body);
        final data = jsonDecode(respone.body);
        setState(() {
          _listdata = data;
          _isloading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _hapus(String id) async {
    try {
      final respone = await http
          .post(Uri.parse("http://192.168.1.4/crud_boy/del.php"), body: {
        "kode": id,
      });
      if (respone.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getdata();
    // print(_listdata);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => editboy(
                                Listdata: {
                                  "id": _listdata[index]['id'],
                                  "kode": _listdata[index]['kode'],
                                  "nama_barang": _listdata[index]
                                      ['nama_barang'],
                                  "jumlah": _listdata[index]['jumlah'],
                                },
                              )),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(_listdata[index]['nama_barang']),
                      subtitle: Text(_listdata[index]['jumlah']),
                      trailing: IconButton(
                          onPressed: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: ((context) {
                                  return AlertDialog(
                                    content: Text("Yakin nih"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            _hapus(_listdata[index]['kode'])
                                                .then((value) {
                                              if (value) {
                                                final snackBar = SnackBar(
                                                  content: const Text(
                                                      'Data dihapus'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else {
                                                final snackBar = SnackBar(
                                                  content: const Text(
                                                      'Data gagal hapus'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            });
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        home())),
                                                (route) => false);
                                          },
                                          child: Text("Hapus")),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Batal"))
                                    ],
                                  );
                                }));
                          },
                          icon: Icon(Icons.delete)),
                    ),
                  ),
                );
              })),
      floatingActionButton: FloatingActionButton(
          child: Text(
            "+",
            style: TextStyle(fontSize: 30),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: ((context) => addboy())));
          }),
    );
  }
}
