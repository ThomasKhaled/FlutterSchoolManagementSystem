import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khedma_app/sign_in.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;


class Hodoor extends StatefulWidget {
  final List listOfMa5domeen;
  final List listOfClasses;
  final String elSana;
  const Hodoor({this.listOfMa5domeen,this.listOfClasses,this.elSana});

  @override
  _HodoorState createState() => _HodoorState(listOfMa5domeen,listOfClasses,elSana);
}

class _HodoorState extends State<Hodoor> with SingleTickerProviderStateMixin  {
  _HodoorState(listOfMa5domeen,listOfClasses,elSana);
  var countNumOfDays;
  double hieghestHodoorEgtema3;
  String hodoorToDaysCount ;
  String hodoor2oddasToDaysCount ;
  String hodoorToHighest ;
  String hodoor2oddasToHighest ;
  String sanaDeraseyya;
  String fullName;
  var hodoorList1 = [];
  Future<List> getHodoor;
  Future getCountDays;
  String elSana = '3';
  bool filterPressed = false;
  bool f1 = false, f2 = false;

  Future getNumberOfDays() async{
    return users.doc('HodoorCount').get().then((value) {
      setState(() {
        countNumOfDays = value.data()['NumOfDays'];
      });
    });
  }
  @override
  void initState() {
    getCountDays = getNumberOfDays();
    //getHodoor = getListOfMa5domeen('3');
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

  }
  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  /*Future<List> getListOfMa5domeen(String elSana) async{
    getCountDays = await getNumberOfDays();
    int idx = 0;
    if(elSana == '1'){
      hodoorList1 = [];
      int i=0;
        await users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').get().then((value){
          value.docs.forEach((element) {
            if(mounted){
              setState(() {
                hieghestHodoorEgtema3 = double.parse(element.data()['HieghestHodoor'].toString())??0;
                hodoorToDaysCount = element.data()['hodoorToDaysCount']??'0';
                hodoor2oddasToDaysCount = element.data()['hodoor2oddasToDaysCount']??'0';
                hodoorToHighest = element.data()['hodoorToHighest']??'0';
                hodoor2oddasToHighest = element.data()['hodoor2oddasToHighest']??'0';
                sanaDeraseyya = element.data()['e3dad5odam3amDerasy']??'0';
                (idx <=widget.listOfMa5domeen.length-1)?fullName = widget.listOfMa5domeen[idx]['FullName']:'';
                Ma5doomHodoor m = Ma5doomHodoor(FullName: fullName,countNumOfDays: countNumOfDays,hieghestHodoorEgtema3: hieghestHodoorEgtema3,
                    hodoorToDaysCount: hodoorToDaysCount,hodoor2oddasToDaysCount: hodoor2oddasToDaysCount
                    ,hodoor2oddasToHighest: hodoor2oddasToHighest,hodoorToHighest: hodoorToHighest,sanaDeraseyya: sanaDeraseyya);

                if(m.sanaDeraseyya.toString() == '1' && (idx <=widget.listOfMa5domeen.length-1)){
                  hodoorList1.add(m);
                }
                idx++;
              });
            }

          });
        });


      return hodoorList1;
    }
    else if(elSana == '2'){
      hodoorList1 = [];
      int i=0;
        await users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').get().then((value){
          value.docs.forEach((element) {
            if(mounted){
              setState(() {
                hieghestHodoorEgtema3 = double.parse(element.data()['HieghestHodoor'].toString())??0;
                hodoorToDaysCount = element.data()['hodoorToDaysCount']??'0';
                hodoor2oddasToDaysCount = element.data()['hodoor2oddasToDaysCount']??'0';
                hodoorToHighest = element.data()['hodoorToHighest']??'0';
                hodoor2oddasToHighest = element.data()['hodoor2oddasToHighest']??'0';
                sanaDeraseyya = element.data()['e3dad5odam3amDerasy']??'0';
                (idx <=widget.listOfMa5domeen.length-1)?fullName = widget.listOfMa5domeen[idx]['FullName']:'';
                Ma5doomHodoor m = Ma5doomHodoor(FullName: fullName,countNumOfDays: countNumOfDays,hieghestHodoorEgtema3: hieghestHodoorEgtema3,
                    hodoorToDaysCount: hodoorToDaysCount,hodoor2oddasToDaysCount: hodoor2oddasToDaysCount
                    ,hodoor2oddasToHighest: hodoor2oddasToHighest,hodoorToHighest: hodoorToHighest,sanaDeraseyya: sanaDeraseyya);

                if(m.sanaDeraseyya.toString() == '2' && (idx <=widget.listOfMa5domeen.length-1)){
                  hodoorList1.add(m);
                }
                idx++;
              });
            }

          });
        });


      return hodoorList1;
    }
    else {
      hodoorList1 = [];

        users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').get().then((value){
          value.docs.forEach((element) {


              setState(() {
                hieghestHodoorEgtema3 = double.parse(element.data()['HieghestHodoor'].toString())??0;
                hodoorToDaysCount = element.data()['hodoorToDaysCount']??'0';
                hodoor2oddasToDaysCount = element.data()['hodoor2oddasToDaysCount']??'0';
                hodoorToHighest = element.data()['hodoorToHighest']??'0';
                hodoor2oddasToHighest = element.data()['hodoor2oddasToHighest']??'0';
                sanaDeraseyya = element.data()['e3dad5odam3amDerasy']??'0';
                (idx <=widget.listOfMa5domeen.length-1)?fullName = widget.listOfMa5domeen[idx]['FullName']:'';
                Ma5doomHodoor m = Ma5doomHodoor(FullName: fullName,countNumOfDays: countNumOfDays,hieghestHodoorEgtema3: hieghestHodoorEgtema3,
                    hodoorToDaysCount: hodoorToDaysCount,hodoor2oddasToDaysCount: hodoor2oddasToDaysCount
                    ,hodoor2oddasToHighest: hodoor2oddasToHighest,hodoorToHighest: hodoorToHighest,sanaDeraseyya: sanaDeraseyya);
                if((idx <=widget.listOfMa5domeen.length-1))
                  hodoorList1.add(m);
                idx++;

              });


          });
        });




      return hodoorList1;
    }


  }*/



  void handleClick(String value) {

    switch (value) {
      case 'سنة 1 فقط':
        setState(() {
          elSana = '1';
          filterPressed = true;
        });
        break;

      case 'سنة 2 فقط':
        setState(() {
          elSana = '2';
          filterPressed = true;
        });
        break;

      case 'إظهار الكل':
        setState(() {
          elSana = '3';
          filterPressed = true;
        });
        break;



    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: AppBar(
          flexibleSpace: SingleChildScrollView(
            child: Column(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top:30.0,right: 10.0),
                            child: Center(child: Text('تقرير الحضور',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white),)),),
                        ),

                      ]
                  ),
                )
              ],

            ),
          ),
          centerTitle: true,

        ),
      ),
      body: Directionality(
          textDirection: TextDirection.rtl,
          child:Column(
            children: [
              StreamBuilder(
                stream: users.doc('Ma5domeen').collection('classes').doc('admin').collection('class')
                    .where("e3dad5odam3amDerasy" ,isEqualTo: widget.elSana).orderBy('FullName').snapshots(),
                builder: (context , snapshot){
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator());
                  }
                  /*if(filterPressed){
                    getHodoor = getListOfMa5domeen(elSana);
                    filterPressed = false;
                  }*/
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context , int index){
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return ListTile(
                          title: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: [
                                DataTable(
                                  border: TableBorder.all(color: Colors.black),
                                  headingRowColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                                  columnSpacing: 10,
                                    horizontalMargin: 3,
                                    headingRowHeight: 20,
                                    columns: [
                                      DataColumn(label: Text('الاسم',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18, color: Colors.white))),
                                      DataColumn(label: Text('حضور الاجتماع',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, color: Colors.white))),
                                      DataColumn(label: Text('حضور القداس',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, color: Colors.white))),
                                      DataColumn(label: Text('عدد الاجتماعات',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, color: Colors.white))),
                                      DataColumn(label: Text('نسبة الحضور',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, color: Colors.white))),
                                      DataColumn(label: Text('أعلي نسبة حضور',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, color: Colors.white)))
                                    ],
                                    rows: [
                                      DataRow(
                                          cells: [
                                            DataCell(SizedBox(width: 200,child: Text( (index+1).toString()+ '-  ' + ds['FullName'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),))),
                                            DataCell(["", null, false, 0].contains(ds['hodoorToDaysCount'])?
                                            Center(child: Text('لا يوجد',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),)):
                                            Center(child: Text('${ds['totalHodoorEgtema3']}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13),))
                                            ),
                                            DataCell(["", null, false, 0].contains(ds['hodoor2oddasToDaysCount'])?
                                            Center(child: Text('لا يوجد',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),)):
                                            Center(child: Text('${ds['totalHodoor2oddasEgtema3']}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13),)),
                                            ),
                                            DataCell(["", null, false, 0].contains(countNumOfDays)?
                                            Center(child: Text('لا يوجد',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),)):
                                            Center(child: Text('${countNumOfDays}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13),)),
                                            ),
                                            DataCell(["", null, false, 0].contains(ds['hodoor2oddasToHighest'])?
                                            Center(child: Text('لا يوجد',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),)):
                                            Center(child: Text('${(ds['hodoor2oddasToHighest'] != 'NaN')?toFixed((((ds['totalHodoorEgtema3']+ds['totalHodoor2oddasEgtema3'])/ds['HieghestHodoor'])*100),2):'0'}%',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13),)),
                                            ),
                                            DataCell(["", null, false, 0].contains(ds['HieghestHodoor'])?
                                            Center(child: Text('لا يوجد',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),)):
                                            Center(child: Text('${ds['HieghestHodoor']}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13),)),
                                            )
                                          ]
                                      )
                                    ]
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
  String toFixed(double value, [int decimalPlace = 1]) {
    try {
      String originalNumber = value.toString();
      List<String> formattedNumber = originalNumber.split('.');
      return "${formattedNumber[0]}.${formattedNumber[1].substring(0, decimalPlace)}";
    } catch (_) {}
    return value.toString();
  }
}

class Ma5doomHodoor{
  String FullName;
  double hieghestHodoorEgtema3 ;
  String hodoorToDaysCount ;
  String hodoor2oddasToDaysCount ;
  String hodoorToHighest ;
  String hodoor2oddasToHighest ;
  num countNumOfDays;
  String sanaDeraseyya;

  Ma5doomHodoor({this.FullName,this.hieghestHodoorEgtema3  , this.hodoorToDaysCount , this.hodoor2oddasToDaysCount , this.hodoorToHighest ,
    this.hodoor2oddasToHighest , this.countNumOfDays , this.sanaDeraseyya });
}



/*
SingleChildScrollView(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.listOfMa5domeen.length,
              itemBuilder: (context , int index){
                return ListTile(
                  title: IntrinsicHeight(
                    child: Row(
                      children: [
                        Divider(height: 2,color: Colors.black,thickness: 2,),
                        Expanded(child: Text((index+1).toString()+ '-  ' + widget.listOfMa5domeen[index]['FullName'],style: TextStyle(fontWeight: FontWeight.w500),),flex: 2,),
                        VerticalDivider(color: Colors.black,thickness: 2,),
                        Expanded(child: Text('${hodoorList[index].hodoorToDaysCount}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),))
                        ,
                        VerticalDivider(color: Colors.black,thickness: 2),
                        Expanded(child: Text('${hodoorList[index].hodoor2oddasToDaysCount}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)),

                        VerticalDivider(color: Colors.black,thickness: 2),
                        Expanded(child: Text('${hodoorList[index].hodoorToHighest}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)),
                        VerticalDivider(color: Colors.black,thickness: 2),
                        Expanded(child: Text('${hodoorList[index].hodoor2oddasToHighest}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)),
                        VerticalDivider(color: Colors.black,thickness: 2),
                        Expanded(child: Text('${hodoorList[index].countNumOfDays}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)),
                        VerticalDivider(color: Colors.black,thickness: 2),
                        Expanded(child: Text('${hodoorList[index].hieghestHodoorEgtema3}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),)),






                      ],

                    ),
                  ),

                );
              },
            ),
          )
* */