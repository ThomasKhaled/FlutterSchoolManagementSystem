import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khedma_app/sign_in.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class GradesReport2 extends StatefulWidget {
  final List listOfMa5domeen;
  final List listOfClasses;
  final String elSana;
  const GradesReport2({this.listOfMa5domeen,this.listOfClasses,this.elSana});

  @override
  _GradesReportState createState() => _GradesReportState(listOfMa5domeen,listOfClasses,elSana);
}

class _GradesReportState extends State<GradesReport2> with SingleTickerProviderStateMixin {
  _GradesReportState(listOfMa5domeen, listOfClasses, elSana);

  List<Ma5doom> ma5domeen = [];
  bool f1 = false,
      f2 = false;
  Future getGrades;
  String elSana = '3';
  bool filterPressed = false;


  @override
  void initState() {
    //getGrades = getListOfMa5domeenAll('3');
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }


  CollectionReference users = FirebaseFirestore.instance.collection('users');

  /* Future<List> getListOfMa5domeenAll(String elSana) async{
    var fullName;
    int idx =0;
    if(elSana == '1'){
      ma5domeen = [];
      int i=0;
        await users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').get().then((value){
          value.docs.forEach((element) {
            (idx <=widget.listOfMa5domeen.length-1)?fullName = widget.listOfMa5domeen[idx]['FullName']:'';
            Ma5doom ma5doom = Ma5doom(nos3am: element.data()['emte7anNos3am'],
                mosab2at:  element.data()['totalMosab2at'],
                qebtyWeAl7an: element.data()['ebtyWeAl7an'],
                a5erEl3am: element.data()['a5erEl3am'],
                mo2tamar: element.data()['mo2tamar'],
                shafawy: element.data()['shafawy'],fullName: fullName
                ,sanaDeraseyya: element.data()['e3dad5odam3amDerasy']);
            if(ma5doom.sanaDeraseyya.toString() == '1'&& (idx <=widget.listOfMa5domeen.length-1)){
              setState(() {
                ma5domeen.add(ma5doom);
              });
            }
            idx++;

          });
        });

      return ma5domeen;
    }
    else if(elSana == '2'){
      ma5domeen = [];
      int i=0;
        await users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').get().then((value){
          value.docs.forEach((element) {
            (idx <=widget.listOfMa5domeen.length-1)?fullName = widget.listOfMa5domeen[idx]['FullName']:'';
            Ma5doom ma5doom = Ma5doom(nos3am: element.data()['emte7anNos3am'],mosab2at:  element.data()['totalMosab2at'],
                qebtyWeAl7an: element.data()['ebtyWeAl7an'], a5erEl3am: element.data()['a5erEl3am'],
                mo2tamar: element.data()['mo2tamar'], shafawy: element.data()['shafawy'],fullName: fullName
                ,sanaDeraseyya: element.data()['e3dad5odam3amDerasy']);
            if(ma5doom.sanaDeraseyya.toString() == '2'&& (idx <=widget.listOfMa5domeen.length-1)){
              setState(() {
                ma5domeen.add(ma5doom);
              });
            }
            idx++;

          });
        });

      return ma5domeen;
    }else{
      ma5domeen = [];
      int i=0;
        await users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').get().then((value){
          value.docs.forEach((element) {
            (idx <=widget.listOfMa5domeen.length-1)?fullName = widget.listOfMa5domeen[idx]['FullName']:'';
            Ma5doom ma5doom = Ma5doom(nos3am: element.data()['emte7anNos3am'],mosab2at:  element.data()['totalMosab2at'],
                qebtyWeAl7an: element.data()['ebtyWeAl7an'], a5erEl3am: element.data()['a5erEl3am'],
                mo2tamar: element.data()['mo2tamar'], shafawy: element.data()['shafawy'],fullName: fullName
                ,sanaDeraseyya: element.data()['e3dad5odam3amDerasy']);
            if((idx <=widget.listOfMa5domeen.length-1)){
              setState(() {
                ma5domeen.add(ma5doom);
              });
            }
            idx++;

          });
        });

      return ma5domeen;
    }
  }*/


  bool nos3am = false,
      a5erel3am = false;

  void handleClick(String value) {
    switch (value) {
      case 'ترتيب حسب إمتحان نصف العام':
        setState(() {
          nos3am = true;
          a5erel3am = false;
        });
        break;

      case 'ترتيب حسب إمتحان اخر العام':
        setState(() {
          nos3am = false;
          a5erel3am = true;
        });
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('تقرير الدرجات', style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {
                'ترتيب حسب إمتحان نصف العام',
                'ترتيب حسب إمتحان اخر العام'
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],

      ),
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              StreamBuilder(
                stream: (nos3am) ? users.doc('Ma5domeen').collection('classes')
                    .doc('admin').collection('class')
                    .where("e3dad5odam3amDerasy", isEqualTo: widget.elSana)
                    .orderBy('emte7anNos3am', descending: true)
                    .snapshots() :
                (a5erel3am) ? users.doc('Ma5domeen').collection('classes').doc(
                    'admin').collection('class')
                    .where("e3dad5odam3amDerasy", isEqualTo: widget.elSana)
                    .orderBy('a5erEl3am', descending: true)
                    .snapshots() :
                users.doc('Ma5domeen').collection('classes').doc('admin')
                    .collection('class')
                    .where("e3dad5odam3amDerasy", isEqualTo: widget.elSana).orderBy('FullName')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  /*if(filterPressed){
                      getGrades = getListOfMa5domeenAll(elSana);
                      filterPressed = false;
                    }*/

                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, int index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];

                        return ListTile(
                          title: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: [
                                DataTable(
                                  border: TableBorder.all(color: Colors.black),
                                  headingRowHeight: 20,
                                  horizontalMargin: 3,
                                  headingRowColor: MaterialStateProperty.all<
                                      Color>(Colors.lightBlue),
                                  columnSpacing: 10,
                                  columns: [
                                    DataColumn(label: Text('الاسم',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18, color: Colors.white))),
                                    DataColumn(label: Text('نصف العام',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18, color: Colors.white))),
                                    DataColumn(label: Text(' مسابقات',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18, color: Colors.white))),
                                    DataColumn(label: Text('قبطي و الحان',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18, color: Colors.white))),
                                    DataColumn(label: Text('اخر العام',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18, color: Colors.white))),
                                    DataColumn(label: Text('مؤتمر',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18, color: Colors.white))),
                                    DataColumn(label: Text('شفوي',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18, color: Colors.white)))
                                  ],
                                  rows: [
                                    DataRow(
                                        cells: [
                                          DataCell(SizedBox(width: 200,
                                            child: Text(
                                              (index + 1).toString() + '-  ' +
                                                  ds['FullName'] + '(سنة ١)',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),),
                                          )),
                                          DataCell(
                                              ["", null, false, 0].contains(
                                                  ds['emte7anNos3am']) ?
                                              Center(child: Text('لا يوجد',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18),)) :
                                              Center(child: Text(
                                                ds['emte7anNos3am'] + '%',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18),))
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['totalMosab2at']) ?
                                            Center(child: Text('لا يوجد',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text('${int.tryParse(
                                                ds['totalMosab2at']
                                                    .toString())}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['ebtyWeAl7an']) ?
                                            Center(child: Text('لا يوجد',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text(
                                              ds['ebtyWeAl7an'] + '%',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['a5erEl3am']) ?
                                            Center(child: Text('لا يوجد',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text(
                                              ds['a5erEl3am'] + '%',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['mo2tamar']) ?
                                            Center(child: Text('لا يوجد',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text(ds['mo2tamar'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['shafawy']) ?
                                            Center(child: Text('لا يوجد',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text(
                                              ds['shafawy'] + '%',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          )
                                        ]
                                    ),
                                    DataRow(
                                        cells: [
                                          DataCell(Center(
                                            child: Text('(سنة ٢)',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),),
                                          )),
                                          DataCell(
                                              ["", null, false, 0].contains(
                                                  ds['emte7anNos3am2']) ?
                                              Center(child: Text('لا يوجد',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18),)) :
                                              Center(child: Text(
                                                ds['emte7anNos3am2'] + '%',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18),))
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['totalMosab2at2']) ?
                                            Center(child: Text('لا يوجد',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text('${int.tryParse(
                                                ds['totalMosab2at2']
                                                    .toString())}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['ebtyWeAl7an2']) ?
                                            Center(child: Text('لا يوجد',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text(
                                              ds['ebtyWeAl7an2'] + '%',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['a5erEl3am2']) ?
                                            Center(child: Text('لا يوجد',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text(
                                              ds['a5erEl3am2'] + '%',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['mo2tamar2']) ?
                                            Center(child: Text('لا يوجد',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text(ds['mo2tamar2'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['shafawy2']) ?
                                            Center(child: Text('لا يوجد',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text(
                                              ds['shafawy2'] + '%',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          )
                                        ]
                                    ),

                                  ],
                                ),

                              ],

                            ),
                          ),

                        );
                      },
                    ),
                  );
                },
              )
            ],
          )
      ),
    );
  }

}

class Ma5doom{
  var nos3am,mosab2at,qebtyWeAl7an,a5erEl3am,mo2tamar,shafawy,fullName,sanaDeraseyya;

  Ma5doom({this.nos3am  = '0', this.mosab2at = '0', this.qebtyWeAl7an = '0', this.a5erEl3am = '0',
      this.mo2tamar = '0', this.shafawy = '0',this.fullName = '',this.sanaDeraseyya = '0'});
}


