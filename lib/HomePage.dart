import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fire/Model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Basket> _item = [];
  @override
  void initState() {
    fetchdata();
    FirebaseFirestore.instance
        .collection('basket')
        .snapshots()
        .listen((record) {
      mapRecords(record);
    });
    super.initState();
  }

  fetchdata() async {
    var record = await FirebaseFirestore.instance.collection('basket').get();
    mapRecords(record);
  }

  void mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var _list = records.docs
        .map((item) =>
            Basket(id: item.id, name: item['name'], quantity: item['quantity']))
        .toList();

    setState(() {
      _item = _list;
    });
  }

  deleteData(String id) {
    FirebaseFirestore.instance.collection('basket').doc(id).delete();
  }

  modifyData(String id) {
    FirebaseFirestore.instance
        .collection('basket')
        .doc(id)
        .update({'name': 'Some new data'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cloud FireStore"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _item.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onDoubleTap: () {
                deleteData(_item[index].id);
              },
              onTap: () {
                modifyData(_item[index].id);
              },
              child: ListTile(
                title: Text(_item[index].name),
                subtitle: Text(_item[index].quantity),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return Dialoge();
              });
        },
      ),
    );
  }

  AddDialogue() {
    showDialog(
        context: context,
        builder: ((context) {
          return Column(
            children: [
              TextField(),
              TextField(),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Card(
                    child: Text("Add"),
                  ))
            ],
          );
        }));
  }
}

class Dialoge extends StatelessWidget {
  String _name = "";
  String _quant = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 10,
      child: Material(
        child: Column(
          children: [
            TextField(
              // controller: _name,
              onChanged: (value) {
                _name = value;
              },
            ),
            TextField(
              // controller: _quant,

              onChanged: ((value) {
                _quant = value;
              }),
            ),
            ElevatedButton(
                onPressed: () {
                  addData(_name.toString(), _quant.toString());
                  Navigator.pop(context);
                },
                child: Card(
                  child: Text("Add"),
                ))
          ],
        ),
      ),
    );
  }

  addData(String name, String quantity) {
    FirebaseFirestore.instance
        .collection('basket')
        .add(Basket(id: '', name: name, quantity: quantity).toJson());
  }
}
