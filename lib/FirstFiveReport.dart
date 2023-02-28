import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert' show utf8,base64;

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' show Worksheet,Workbook;

class FirstFiveReport extends StatefulWidget {
  final List listOfMa5domeen;
  final List listOfClasses;
  final String name;
  const FirstFiveReport({this.listOfMa5domeen,this.listOfClasses,this.name});

  @override
  _FirstFiveReportState createState() => _FirstFiveReportState(listOfMa5domeen,listOfClasses,name);
}

class _FirstFiveReportState extends State<FirstFiveReport> with SingleTickerProviderStateMixin  {
  _FirstFiveReportState(listOfMa5domeen,listOfClasses,name);
  List<Ma5doom> ma5domeen = [];
  bool f1 = false, f2 = false;
  Future getGrades;
  String elSana = '3';
  bool filterPressed = false;
  var selectedDate ;

  @override
  void initState() {
    selectedDate = DateTime.now().year;
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

      case 'ترتيب حسب إمتحان نصف العام':
        setState(() {
          ma5domeen.sort((b,a)=>(a.nos3am).toString().compareTo((b.nos3am.toString())));
        });
        break;

      case 'ترتيب حسب إمتحان اخر العام':
        setState(() {
          ma5domeen.sort((b,a)=>(a.a5erEl3am).toString().compareTo((b.a5erEl3am.toString())));
        });
        break;



    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.year,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(3000));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void _pickYear(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final Size size = MediaQuery.of(context).size;
        return AlertDialog(
          title: Text('Select a Year'),
          // Changing default contentPadding to make the content looks better

          contentPadding: const EdgeInsets.all(50),
          content: SizedBox(
            // Giving some size to the dialog so the gridview know its bounds

            height: size.height / 3,
            width: size.width,
            //  Creating a grid view with 3 elements per line.
            child: GridView.count(
              crossAxisCount: 6,
              children: [
                // Generating a list of 123 years starting from 2022
                // Change it depending on your needs.
                ...List.generate(
                  300,
                      (index) => InkWell(
                    onTap: () {
                      // The action you want to happen when you select the year below,
                      setState(() {
                        selectedDate = (DateTime.now().year - index).toString();
                      });
                      // Quitting the dialog through navigator.
                      Navigator.pop(context);
                    },
                    // This part is up to you, it's only ui elements
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Chip(
                        label: Container(
                          padding: const EdgeInsets.all(1),
                          child: Text(
                            // Showing the year text, it starts from 2022 and ends in 1900 (you can modify this as you like)
                            (DateTime.now().year - index).toString(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(95),
        child: AppBar(
          flexibleSpace: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top:30.0,right: 10.0),
                          child: Text('تقرير الشهور',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white),textAlign: TextAlign.center),),
                      ),
                    ]
                ),
              ),
              ElevatedButton(onPressed: (){_pickYear(context);}, child: Text('إختار العام',style: TextStyle(fontSize: 18),),style: ElevatedButton.styleFrom(primary: Colors.black)),

            ],
          ),
          centerTitle: true,

        ),
      ),
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              StreamBuilder(
                stream: users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').where('FullName' ,isEqualTo: widget.name).snapshots(),
                builder: (context , snapshot){
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator());
                  }
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context , int index){
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return ListTile(
                          title: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /*Divider(color: Colors.black,height: 2,thickness: 2,),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Container(width: 60,),
                                        Expanded(child:  Text('',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
                                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                                        Expanded(child: Text('يناير',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,)),
                                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                                        Expanded(child: Text('فبراير',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,)),
                                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                                        Expanded(child: Text('مارس',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,)),
                                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                                        Expanded(child: Text('ابريل',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,)),
                                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                                        Expanded(child: Text('مايو',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,)),
                                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                                        Expanded(child: Text('يونيو',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,)),

                                      ],
                                    ),
                                  ),
                                ),
                                Divider(color: Colors.black,height: 2,thickness: 2,),
                                Row(
                                  children: [
                                    Expanded(child: Text('حضور القداسات',style: TextStyle(fontWeight: FontWeight.w600),),flex: 2,),
                                    !(ds['Dates']['$selectedDate'].toString().contains('January'))?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['January']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),

                                    !ds['Dates']['$selectedDate'].toString().contains('Fabruary')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['Fabruary']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('March')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['March']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('April')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['April']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('May')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['May']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('June')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),):
                                    Text(ds['Dates']['${selectedDate}']['June']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Text('إعتراف و إرشاد',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),flex: 2),
                                    !ds['Dates']['$selectedDate'].toString().contains('January')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['January']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),

                                    !ds['Dates']['$selectedDate'].toString().contains('Fabruary')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['Fabruary']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('March')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['March']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('April')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['April']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('May')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['May']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('June')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),):
                                    Text(ds['Dates']['${selectedDate}']['June']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),

                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Text('متابعة تليفونية',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),flex: 2),
                                    !ds['Dates']['$selectedDate'].toString().contains('January')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['January']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),

                                    !ds['Dates']['$selectedDate'].toString().contains('Fabruary')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['Fabruary']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('March')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['March']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('April')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['April']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('May')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['May']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('June')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),):
                                    Text(ds['Dates']['${selectedDate}']['June']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Text('زيارة منزلية',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),flex: 2),
                                    !ds['Dates']['$selectedDate'].toString().contains('January')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['January']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),

                                    !ds['Dates']['$selectedDate'].toString().contains('Fabruary')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['Fabruary']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('March')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['March']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('April')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['April']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('May')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['May']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('June')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),):
                                    Text(ds['Dates']['${selectedDate}']['June']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Text('كتاب مقدس',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),flex: 2),
                                    !ds['Dates']['$selectedDate'].toString().contains('January')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['January']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),

                                    !ds['Dates']['$selectedDate'].toString().contains('Fabruary')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['Fabruary']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('March')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['March']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('April')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['April']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('May')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['May']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('June')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),):
                                    Text(ds['Dates']['${selectedDate}']['June']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Text('تسليم المسابقات',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),flex: 2),
                                    !ds['Dates']['$selectedDate'].toString().contains('January')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['January']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),

                                    !ds['Dates']['$selectedDate'].toString().contains('Fabruary')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['Fabruary']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('March')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['March']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('April')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['April']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('May')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['May']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('June')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),):
                                    Text(ds['Dates']['${selectedDate}']['June']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),
                                  ],
                                ),
                                Divider(height: 3,thickness: 2,color: Colors.black,),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Container(width: 60,),
                                        Expanded(child:  Text('',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
                                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                                        Expanded(child: Text('يوليو',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,)),
                                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                                        Expanded(child: Text('اغسطس',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,)),
                                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                                        Expanded(child: Text('سبتمبر',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,)),
                                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                                        Expanded(child: Text('اكتوبر',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,)),
                                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                                        Expanded(child: Text('نوفمبر',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,)),
                                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                                        Expanded(child: Text('ديسمبر',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center,)),

                                      ],
                                    ),
                                  ),
                                ),
                                Divider(color: Colors.black,height: 2,thickness: 2,),

                                Row(
                                  children: [
                                    Expanded(child: Text('حضور القداسات',style: TextStyle(fontWeight: FontWeight.w600),),flex: 2),
                                    !ds['Dates']['$selectedDate'].toString().contains('July')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['July']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),

                                    !ds['Dates']['$selectedDate'].toString().contains('August')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['August']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.start)),

                                    !ds['Dates']['$selectedDate'].toString().contains('September')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['September']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('October')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['October']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('November')?
                                    Expanded(child: Text('    ______   ',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['November']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('December')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),):
                                    Text(ds['Dates']['${selectedDate}']['December']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Text('إعتراف و إرشاد',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),flex: 2),
                                    !ds['Dates']['$selectedDate'].toString().contains('July')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['July']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),

                                    !ds['Dates']['$selectedDate'].toString().contains('August')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['August']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.start)),

                                    !ds['Dates']['$selectedDate'].toString().contains('September')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['September']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('October')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['October']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('November')?
                                    Expanded(child: Text('    ______   ',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['November']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('December')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),):
                                    Text(ds['Dates']['${selectedDate}']['December']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Text('متابعة تليفونية',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),flex: 2),
                                    !ds['Dates']['$selectedDate'].toString().contains('July')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['July']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),

                                    !ds['Dates']['$selectedDate'].toString().contains('August')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['August']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.start)),

                                    !ds['Dates']['$selectedDate'].toString().contains('September')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['September']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('October')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['October']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('November')?
                                    Expanded(child: Text('    ______   ',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['November']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('December')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),):
                                    Text(ds['Dates']['${selectedDate}']['December']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Text('زيارة منزلية',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),flex: 2),
                                    !ds['Dates']['$selectedDate'].toString().contains('July')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['July']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),

                                    !ds['Dates']['$selectedDate'].toString().contains('August')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['August']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.start)),

                                    !ds['Dates']['$selectedDate'].toString().contains('September')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['September']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('October')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['October']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('November')?
                                    Expanded(child: Text('    ______   ',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['November']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('December')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),):
                                    Text(ds['Dates']['${selectedDate}']['December']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Text('كتاب مقدس',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),flex: 2),
                                    !ds['Dates']['$selectedDate'].toString().contains('July')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['July']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),

                                    !ds['Dates']['$selectedDate'].toString().contains('August')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['August']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.start)),

                                    !ds['Dates']['$selectedDate'].toString().contains('September')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['September']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('October')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['October']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('November')?
                                    Expanded(child: Text('    ______   ',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['November']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('December')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),):
                                    Text(ds['Dates']['${selectedDate}']['December']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Text('تسليم المسابقات',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),flex: 2),
                                    !ds['Dates']['$selectedDate'].toString().contains('July')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['July']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),

                                    !ds['Dates']['$selectedDate'].toString().contains('August')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['August']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.start)),

                                    !ds['Dates']['$selectedDate'].toString().contains('September')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['September']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('October')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['October']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('November')?
                                    Expanded(child: Text('    ______   ',style: TextStyle(fontWeight: FontWeight.w500))):
                                    Expanded(child: Text(ds['Dates']['${selectedDate}']['November']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),

                                    !ds['Dates']['$selectedDate'].toString().contains('December')?
                                    Expanded(child: Text('______',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),):
                                    Text(ds['Dates']['${selectedDate}']['December']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center),
                                  ],
                                ),*/

                                SingleChildScrollView(scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    border: TableBorder.all(color: Colors.black),
                                    headingRowColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                                    columnSpacing: 10,
                                    columns: [
                                      DataColumn(label: Padding(
                                        padding: const EdgeInsets.only(right: 20.0),
                                        child: Text('$selectedDate',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black,),textAlign: TextAlign.center,),
                                      )),
                                      DataColumn(label: Text('سبتمبر',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                      DataColumn(label: Text('اكتوبر',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                      DataColumn(label: Text('نوفمبر',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                      DataColumn(label: Text('ديسمبر',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                      DataColumn(label: Text('يناير',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),
                                      DataColumn(label: Text('فبراير',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                      DataColumn(label: Text('مارس',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                      DataColumn(label: Text('ابريل',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                      DataColumn(label: Text('مايو',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                      DataColumn(label: Text('يونيو',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                      DataColumn(label: Text('يوليو',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                      DataColumn(label: Text('اغسطس',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),


                                    ],
                                    rows: [
                                      DataRow(cells: [
                                        DataCell(Text('حضور القداسات',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('September')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['September']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('October')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['October']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('November')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['November']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('December')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['December']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),),

                                        DataCell(!(ds['Dates']['$selectedDate'].toString().contains('January'))?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['January']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('Fabruary')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['Fabruary']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('March')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['March']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('April')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['April']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('May')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['May']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('June')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['June']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),)
                                        ,
                                        DataCell(!(ds['Dates']['$selectedDate'].toString().contains('July'))?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['July']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('August')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['August']['hodoor2oddasat'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),

                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('إعتراف و إرشاد',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('September')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['September']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('October')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['October']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('November')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['November']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('December')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['December']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),),

                                        DataCell(!(ds['Dates']['$selectedDate'].toString().contains('January'))?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['January']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('Fabruary')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['Fabruary']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('March')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['March']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('April')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['April']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('May')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['May']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('June')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['June']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),),
                                        DataCell(!(ds['Dates']['$selectedDate'].toString().contains('July'))?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['July']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('August')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['August']['e3terafWeErshad'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),


                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('متابعة تليفونية',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('September')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['September']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('October')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['October']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('November')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['November']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('December')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['December']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),),

                                        DataCell(!(ds['Dates']['$selectedDate'].toString().contains('January'))?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['January']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('Fabruary')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['Fabruary']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('March')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['March']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('April')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['April']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('May')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['May']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('June')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['June']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),),
                                        DataCell(!(ds['Dates']['$selectedDate'].toString().contains('July'))?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['July']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('August')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['August']['motab3aTelephoneyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),


                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('زيارة منزلية',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('September')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['September']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('October')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['October']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('November')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['November']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('December')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['December']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),),

                                        DataCell(!(ds['Dates']['$selectedDate'].toString().contains('January'))?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['January']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('Fabruary')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['Fabruary']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('March')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['March']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('April')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['April']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('May')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['May']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('June')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['June']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),),
                                        DataCell(!(ds['Dates']['$selectedDate'].toString().contains('July'))?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['July']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('August')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['August']['zyaraManzeleyya'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),


                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('كتاب مقدس',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('September')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['September']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('October')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['October']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('November')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['November']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('December')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['December']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),),

                                        DataCell(!(ds['Dates']['$selectedDate'].toString().contains('January'))?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['January']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('Fabruary')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['Fabruary']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('March')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['March']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('April')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['April']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('May')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['May']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('June')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['June']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),),
                                        DataCell(!(ds['Dates']['$selectedDate'].toString().contains('July'))?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['July']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('August')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['August']['ketabMoqaddas'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),


                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('تسليم المسابقات',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('September')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['September']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('October')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['October']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('November')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['November']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('December')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['December']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),),

                                        DataCell(!(ds['Dates']['$selectedDate'].toString().contains('January'))?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['January']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('Fabruary')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['Fabruary']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('March')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['March']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('April')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['April']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('May')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['May']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('June')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['June']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),),
                                        DataCell(!(ds['Dates']['$selectedDate'].toString().contains('July'))?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['July']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
                                        ),
                                        DataCell(!ds['Dates']['$selectedDate'].toString().contains('August')?
                                        Center(child: Text('____',style: TextStyle(fontWeight: FontWeight.w500))):
                                        Center(child: Text(ds['Dates']['${selectedDate}']['August']['tasleemMosab2at'],style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.center)),
                                        ),


                                      ]),
                                    ],
                                  ),
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



