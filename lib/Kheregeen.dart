import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:khedma_app/sign_in.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';


class Kheregeen extends StatefulWidget {
  final List listOfMa5domeen;
  final List listOfClasses;
  const Kheregeen({this.listOfMa5domeen,this.listOfClasses});

  @override
  _KheregeenState createState() => _KheregeenState(listOfMa5domeen,listOfClasses);
}

class _KheregeenState extends State<Kheregeen> with SingleTickerProviderStateMixin  {
  _KheregeenState(listOfMa5domeen,listOfClasses);
  var countNumOfDays;
  double hieghestHodoorEgtema3;
  String hodoorToDaysCount ;
  String hodoor2oddasToDaysCount ;
  String hodoorToHighest ;
  String sanaDeraseyya;
  String fullName;
  var hodoorList1 = [];
  Future<List> getHodoor;
  Future getCountDays;
  String elSana = '3';
  bool filterPressed = false;
  bool f1 = false, f2 = false;
  bool graduated;

  Future getNumberOfDays() async{
    return users.doc('HodoorCount').get().then((value) {
      setState(() {
        countNumOfDays = value.data()['NumOfDays'];
      });
    });
  }
  @override
  void initState() {
    graduated = false;
    getCountDays = getNumberOfDays();
    getPercentages = getGradesPercentages();
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



    }
  }
  Future getPercentages;
  Future getGradesPercentages() async{
    await FirebaseFirestore.instance.collection('gradesPercentage').doc('Percentages').get().then((value){
      setState(() {
        nos3amPerc = double.tryParse(value.data()['emte7anNos3am'].toString()??0)??0.0;
        a5erEl3amPerc = double.tryParse(value.data()['a5erEl3am'].toString()??0)??0.0;
        ebtyWeAl7anPerc = double.tryParse(value.data()['ebtyWeAl7an'].toString()??0)??0.0;
        mosab2atPerc = double.tryParse(value.data()['mosab2at'].toString()??'0')??0;
        shafawyPerc = double.tryParse(value.data()['shafawy'].toString()??0)??0.0;
        hodoor2oddasToHighestPerc = double.tryParse(value.data()['hodoor'].toString()??'0')??0.0;
      });
    });
  }

  var nos3amPerc =0.0,a5erEl3amPerc=0.0,ebtyWeAl7anPerc=0.0,mosab2atPerc=0.0,shafawyPerc=0.0,hodoor2oddasToHighestPerc=0.0;
  var nos3am =0.0, a5erEl3am=0.0 , ebtyWeAl7an=0.0, mosab2at=0.0 , shafawy =0.0, hodoor2oddasToHighest=0.0;

  bool isGraduated(DocumentSnapshot ds){
    //getPercentages = getGradesPercentages();
     nos3am = double.tryParse(ds['emte7anNos3am2'].toString()??'0')??0.0;
     a5erEl3am = double.tryParse(ds['a5erEl3am2'].toString()??'0')??0.0;
     ebtyWeAl7an = double.tryParse(ds['ebtyWeAl7an2'].toString()??'0')??0.0;
     mosab2at = double.tryParse(ds['totalMosab2at2'].toString()??'0')??0.0;
     shafawy = double.tryParse(ds['shafawy2'].toString()??'0')??0.0;
     hodoor2oddasToHighest = double.tryParse(ds['hodoor2oddasToHighest'].toString()??'0')??0.0;


    if(nos3am >= nos3amPerc && mosab2at >= mosab2atPerc && ebtyWeAl7an >= ebtyWeAl7anPerc
        && a5erEl3am >= a5erEl3amPerc && shafawy >= shafawyPerc && hodoor2oddasToHighest >= hodoor2oddasToHighestPerc)
      {
          graduated = true;
      }
    else{
        graduated = false;
    }


    return graduated;

  }
  void showGradDialog(String name,String tel , String ra2y5adem, String mee3adEl5edma){

     showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          actionsAlignment: MainAxisAlignment.start,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              IconButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close,color: Colors.red,)
              ),
              Text('$name',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          ),
          actions: <Widget>[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'ترشيح الخادم للخدمة :',
                    style: TextStyle(color: Colors.red[300]),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      // Single tapped.
                    },
                  ),

                  TextSpan(
                      text: '  $ra2y5adem',
                      style: TextStyle(color: Colors.green[500]),
                      recognizer:  DoubleTapGestureRecognizer()..onDoubleTap = () {
                        // Double tapped.
                      }
                  ),
                  TextSpan(
                      text: '  ( $mee3adEl5edma )',
                      style: TextStyle(color: Colors.green[500]),
                      recognizer:  DoubleTapGestureRecognizer()..onDoubleTap = () {
                        // Double tapped.
                      }
                  ),

                ],
              ),
            ),
            SizedBox(width: 50),
            IconButton(
                onPressed: (){
                  launch("tel://0$tel");
                },
                icon: Image.asset('assets/call_img.png')
            )
          ],
        ),
      );
    },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(92),
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
                            child: Text('الخريجين',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 32,color: Colors.white),textAlign: TextAlign.center),),
                        ),


                      ]
                  ),
                ),
                Divider(color: Colors.black,height: 2,thickness: 2,),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(width: 80,),
                        Expanded(child:  Text('الاسم',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),),
                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                        Expanded(child: Text('نصف العام',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center)),
                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                        Expanded(child: Text('اخر العام',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center)),
                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                        Expanded(child: Text('القبطي و الألحان',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center)),
                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                        Expanded(child: Text('الشفوي',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center)),
                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                        Expanded(child: Text('عدد المسابقات',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center)),
                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                        Expanded(child: Text('الحضور شامل الايام الروحية',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center)),
                        VerticalDivider(width: 2,thickness: 2,color: Colors.black,),
                        Expanded(child: Text('تم إحضار موافقة من أب الإعتراف',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),textAlign: TextAlign.center)),

                      ],
                    ),

                  ),
                ),
                Divider(color: Colors.black,height: 2,thickness: 2,),
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
                    .where('e3dad5odam3amDerasy',isEqualTo: '2').snapshots(),
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
                        var isGrad;
                        isGrad = isGraduated(ds);

                        if(isGrad){
                          return GestureDetector(
                            onLongPress: (){
                              if(ds['ra8baTarshee7'] == 'اخري' ){
                                if(ds['mee3ad5edma'] == 'اخري'){
                                  showGradDialog(ds['FullName'], ds['StudentPhoneNumber'].toString(), ds['khademRa8batO5ra'],ds['mee3ad5edmaA5r']);
                                }else{
                                  showGradDialog(ds['FullName'], ds['StudentPhoneNumber'].toString(), ds['khademRa8batO5ra'],ds['mee3ad5edma']);
                                }
                              }else{
                                if(ds['mee3ad5edma'] == 'اخري'){
                                  showGradDialog(ds['FullName'], ds['StudentPhoneNumber'].toString(), ds['khademRa8batO5ra'],ds['mee3ad5edmaA5r']);
                                }else{
                                  showGradDialog(ds['FullName'], ds['StudentPhoneNumber'].toString(), ds['ra8baTarshee7'],ds['mee3ad5edma']);

                                }
                              }
                            },
                            child: ListTile(
                              title: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Divider(height: 2,color: Colors.black,thickness: 2,),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Text((index+1).toString()+ '-  ' + ds['FullName'],style: TextStyle(fontWeight: FontWeight.w500),),flex: 2
                                    ),
                                    VerticalDivider(color: Colors.black,thickness: 2,),

                                    Expanded(child: Text(ds['emte7anNos3am2'].toString() + '%',style: TextStyle(fontWeight: FontWeight.w500),),),
                                    VerticalDivider(color: Colors.black,thickness: 2,),

                                    Expanded(child: Text(ds['a5erEl3am2'].toString() + '%',style: TextStyle(fontWeight: FontWeight.w500),),),
                                    VerticalDivider(color: Colors.black,thickness: 2,),

                                    Expanded(child: Text(ds['ebtyWeAl7an2'].toString() + '%',style: TextStyle(fontWeight: FontWeight.w500),),),
                                    VerticalDivider(color: Colors.black,thickness: 2,),

                                    Expanded(child: Text(ds['shafawy2'].toString() + '%',style: TextStyle(fontWeight: FontWeight.w500),),),
                                    VerticalDivider(color: Colors.black,thickness: 2,),

                                    Expanded(child: Text(ds['totalMosab2at2'].toString(),style: TextStyle(fontWeight: FontWeight.w500),),),
                                    VerticalDivider(color: Colors.black,thickness: 2,),

                                    Expanded(child: Text(ds['hodoor2oddasToHighest'].toString() + '%',style: TextStyle(fontWeight: FontWeight.w500),),),
                                    VerticalDivider(color: Colors.black,thickness: 2,),

                                    (ds['Mewaf2aMnAbE3teraf'].toString() == 'نعم')?
                                    Expanded(child: Text(ds['Mewaf2aMnAbE3teraf'].toString(),style: TextStyle(fontWeight: FontWeight.w500),),):
                                    Expanded(child: Text('لا',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.red),),)







                                  ],

                                ),
                              ),

                            ),
                          );
                        }else
                          return Container();

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