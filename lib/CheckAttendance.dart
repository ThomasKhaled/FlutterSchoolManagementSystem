import 'dart:async';

import 'sign_in.dart';
import 'package:flutter/material.dart';
import 'Students.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class checkAttendance extends StatefulWidget {
  final Student recordName;
  const checkAttendance(this.recordName);
  checkAttendanceState createState() => checkAttendanceState();
}

class checkAttendanceState extends State<checkAttendance> {
  Student x;
  final firestoreInstance = FirebaseFirestore.instance;
  List list = [];

  double opacityLevel = 0.0;
  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  Future<List> getData() async {
    await firestoreInstance
        .collection("users")
        .get()
        .then((querySnapshot) {
      firestoreInstance
          .collection("users")
          .doc('admin')
          .collection("Members")
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if (element.data()["FullName"].toString() ==
              widget.recordName.FullName) {
              list.add(List.from(element.data()["AttendanceFasl"]));
          }
        });
        Future.delayed(Duration(seconds: 2));
      });
    });
    return list;
  }

  @override
  void initState() {

    Future.delayed(Duration(seconds: 2)).whenComplete(() {
      _changeOpacity();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[],
        ),
        body: FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData && list.isNotEmpty) {
              return ListView.builder(
                  itemCount: list[0].length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        onTap: () {},
                        title: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            color: Colors.lightBlue,
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                      (list[0][index]["minuteAtten"].toString().length != 1)?"اليوم : ${list[0][index]["dayAtten"]}/${list[0][index]["monthAtten"]}  -  الساعة : ${list[0][index]["hourAtten"]}:${list[0][index]["minuteAtten"]}"
                                      :"اليوم : ${list[0][index]["dayAtten"]}/${list[0][index]["monthAtten"]}  -  الساعة : ${list[0][index]["hourAtten"]}:0${list[0][index]["minuteAtten"]}",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                          ),
                        ));
                  });
            } else if (snapshot.hasData && list.isEmpty) {
              return AnimatedOpacity(
                  opacity: opacityLevel,
                  duration: Duration(
                    milliseconds: 1000,
                  ),
                  child: Center(
                      child: Text('No Data', style: TextStyle(fontSize: 24))));
            }

            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 30,
            ));
          },
        ));
  }
}

class atten {
  int hourAttendance;
  int minuteAttendance;
  int dayAttendance;
  int monthAttendance;

  atten(this.hourAttendance, this.minuteAttendance, this.dayAttendance,
      this.monthAttendance);
}
