import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khedma_app/KhodamInformation.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' show Workbook,Worksheet;
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_in.dart';
import 'package:group_list_view/group_list_view.dart';
import 'dart:ui' as ui;

class KhodamFasly extends StatefulWidget {
  KhodamFaslyState createState() => KhodamFaslyState();
}

class KhodamFaslyState extends State<KhodamFasly> {
  final FirebaseFirestoreInstance = FirebaseFirestore.instance;
  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController ManzelC = TextEditingController();
  TextEditingController abE3terafC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  int day , month, year;
  var list = [];
  var tmpList = [];
  var names = [];
  var khadem = [];
  var selectedDateForReport ;

  Future getKhodam;
  final bgsOfStudents = <int, Color>{
    1:Colors.red,
    2:Colors.blueAccent,
    3:Colors.deepPurple,
    4:Colors.yellowAccent,
    5:Colors.cyan,
    6:Colors.green,
    7:Colors.orange,
    8:Colors.teal,
    9:Colors.purple,
    10:Colors.brown
  };

  @override
  void initState() {
    //getKhodam = getData();
    super.initState();
    day = DateTime.now().day;
    month = DateTime.now().month;
    year = DateTime.now().year;
    selectedDateForReport = DateTime.now().year;

  }

 /* Future getData() async {
    var x,cl,ph;
    await FirebaseFirestoreInstance
        .collection("Khodam")
        .get()
        .then((value) {
          value.docs.forEach((element) {
              x = element.data()['Name'].toString();
              cl = element.data()['Class'].toString();
              ph = int.parse(element.data()['Phone'].toString());
              x[0].toString().toUpperCase();
              Khodam k = Khodam(name: x, phone: ph, Class: cl);
              khadem.add(k);

          });
    });
    return khadem;
  }*/
  void handleClick(String value) {

    switch (value) {
      case 'إضافة خادم':
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState){
                return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 16,
                  child: Container(
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        _buildRow(setState)
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
        break;



    }
  }


  TextEditingController esmElShare3C = new TextEditingController();
  TextEditingController rakam3omaraC = new TextEditingController();
  TextEditingController elDoorC = new TextEditingController();
  TextEditingController rakamShaqqaC = new TextEditingController();
  TextEditingController manteqaC = new TextEditingController();

  String date = "";
  DateTime selectedDate = DateTime.now();


  _selectDate(BuildContext context, setState) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2900),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        day = selectedDate.day;
        month = selectedDate.month;
        year = selectedDate.year;
      });
  }



  Widget _buildRow(setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(

        children: <Widget>[
          Padding(
            padding:const EdgeInsets.all(8.0),
            child: Text('بيانات الخادم',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
          ),
          Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 140,
                            child: TextFormField(
                              controller: nameC,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'الاسم',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width-140,
                          height: MediaQuery.of(context).size.height-400,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.right,
                                controller: esmElShare3C,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'اسم الشارع',
                                    labelStyle: TextStyle(color: Colors.black)
                                ),
                                validator: (String value) {
                                  if (value.trim().isEmpty) {
                                    return 'Required Field';
                                  }
                                },
                              ),
                              SizedBox(height: 10,),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.right,
                                controller: manteqaC,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'المنطقة',
                                    labelStyle: TextStyle(color: Colors.black)
                                ),
                                validator: (String value) {
                                  if (value.trim().isEmpty) {
                                    return 'Required Field';
                                  }
                                },
                              ),
                              SizedBox(height: 10,),
                              Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.right,
                                    controller: rakam3omaraC,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'رقم العمارة',
                                        labelStyle: TextStyle(color: Colors.black)
                                    ),
                                    validator: (String value) {
                                      if (value.trim().isEmpty) {
                                        return 'Required Field';
                                      }
                                    },
                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.right,
                                    controller: elDoorC,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'الدور',
                                        labelStyle: TextStyle(color: Colors.black)
                                    ),
                                    validator: (String value) {
                                      if (value.trim().isEmpty) {
                                        return 'Required Field';
                                      }
                                    },
                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.right,
                                    controller: rakamShaqqaC,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'رقم الشقة',
                                        labelStyle: TextStyle(color: Colors.black)
                                    ),
                                    validator: (String value) {
                                      if (value.trim().isEmpty) {
                                        return 'Required Field';
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 140,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: phoneC,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'الموبايل',
                            ),

                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width - 140,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: ManzelC,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'تليفون المنزل',
                            ),

                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width - 140,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: abE3terafC,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'أب الإعتراف',
                            ),

                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width - 140,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: emailC,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'الايميل',
                            ),

                          ),
                        ),
                        SizedBox(height: 10,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width-140,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width-100,
                                  child: ElevatedButton(
                                    child: Text('إختيار تاريخ الميلاد',style: TextStyle(fontSize: 14)),
                                    onPressed: () {
                                      setState(() {
                                        _selectDate(context,setState);
                                      });

                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Container(padding: EdgeInsets.only(top: 12),
                                height: 50,
                                width: MediaQuery.of(context).size.width-250,
                                child: Text(
                                  '${day}/$month/$year',style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 250,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(primary: Colors.red),
                                  onPressed: () async{
                                      Navigator.pop(context);
                                  },
                                  child: Text(
                                      'الغاء'
                                  ),

                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 250,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(primary: Colors.green),
                                  onPressed: () async{
                                    await firestoreInstance.collection("Khodam").add(
                                        {
                                          'Name' : nameC.text,
                                          'esmElShare3' : esmElShare3C.text,
                                          'manteqa' : manteqaC.text,
                                          'rakam3omara' : rakam3omaraC.text,
                                          'rakamShaqqa' : rakamShaqqaC.text,
                                          'elDoor' : elDoorC.text,
                                          'Manzel' : ManzelC.text,
                                          'Email' : emailC.text,
                                          'Phone' : phoneC.text,
                                          'abE3teraf' : abE3terafC.text,
                                          'day' : day,
                                          'month' : month,
                                          'year' : year,

                                        }
                                    ).whenComplete(() {
                                      nameC.text = '';
                                      phoneC.text = '';
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Text(
                                      'إضافة'
                                  ),

                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void Delete(String fullName) async {
    print('f: $fullName');
    await firestoreInstance.collection("Khodam").get().then((querySnapshot) {
      firestoreInstance
          .collection("Khodam")
          .where("Name", isEqualTo: fullName)
          .limit(1)
          .get()
          .then((value){
        value.docs.forEach((element) {
          DocumentReference docRef;
          docRef = firestoreInstance.collection("Khodam").doc(element.id);
          docRef.delete();
        });

      });
    });



  }

  Widget _buildDialogForDelete(var Name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: <Widget>[
          Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'حذف ',
                          style: TextStyle(fontSize: 18,color: Colors.black),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            // Single tapped.
                          },
                        ),

                        TextSpan(
                            text: '$Name',
                            style: TextStyle(color: Colors.blue[300],fontSize: 18,decoration: TextDecoration.underline),
                            recognizer:  DoubleTapGestureRecognizer()..onDoubleTap = () {
                              // Double tapped.
                            }
                        ),
                        TextSpan(
                            text: '؟',
                            style: TextStyle(color: Colors.black,fontSize: 18),
                            recognizer:  DoubleTapGestureRecognizer()..onDoubleTap = () {
                              // Double tapped.
                            }
                        ),

                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration( borderRadius: BorderRadius.circular(3)),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          child: Text('لا',style: TextStyle(fontSize: 18),),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration( borderRadius: BorderRadius.circular(5)),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.green),
                          child: Text('نعم',style: TextStyle(fontSize: 18)),
                          onPressed: (){
                            Delete(Name);
                            Fluttertoast.showToast(
                                msg: "تم حذف ${Name} !",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueAccent,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void deleteKhadem(var Name){
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 16,
          child: Container(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                _buildDialogForDelete(Name)
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
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'إضافة خادم'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],

          centerTitle: true,
          title: Text('الخدام')
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: StreamBuilder(
            stream:  FirebaseFirestoreInstance.collection("Khodam").orderBy('Name',descending: false).snapshots(),
            builder: (context , AsyncSnapshot snapshot){
              if(snapshot.hasData){
                 return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      /*var colorIdx;
                      var listTileColor;
                      colorIdx = int.parse(khadem[index].Class.toString())-1;
                      listTileColor = bgsOfStudents.values.elementAt(colorIdx);*/
                      final item = snapshot.data.docs[index].toString();
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: [
                            Dismissible(
                              background: Container(color: Colors.red),
                              key: Key(item),
                              confirmDismiss: (DismissDirection direction)async{
                                await deleteKhadem(ds['Name']);
                              },
                              onDismissed: (direction){

                              },
                              child: GestureDetector(
                                onTap: (){
                                  Khadem k = new Khadem.name(ds['Name'],
                                      ds.data().containsKey('esmElShare3')?ds['esmElShare3']:"Not found",
                                      ds.data().containsKey('manteqa')?ds['manteqa']:"Not found",
                                      ds.data().containsKey('rakam3omara')?ds['rakam3omara'].toString():'0',
                                      ds.data().containsKey('elDoor')?ds['elDoor']:0,
                                      ds.data().containsKey('rakamShaqqa')?ds['rakamShaqqa']:0,
                                      ds.data().containsKey('Phone')?ds['Phone']:"Not found",
                                      ds.data().containsKey('Manzel')?ds['Manzel']:"Not found",
                                      ds.data().containsKey('abE3teraf')?ds['abE3teraf']:"Not found",
                                      ds.data().containsKey('Email')?ds['Email']:"Not found",
                                      ds.data().containsKey('day')?ds['day']:0,
                                      ds.data().containsKey('month')?ds['month']:0,
                                      ds.data().containsKey('year')?ds['year']:0);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => KhodamInformation(khadem: k,)));
                                },
                                child: ListTile(
                                  /*leading: CircleAvatar(
                                child: Text('Class ${ds.get('Class')}',style: TextStyle(fontSize: 10)),
                          ),*/
                                    title: Text('${index+1} - ' + ds['Name']??'',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,),
                                    trailing: IconButton(icon:Icon(Icons.call,color: Colors.green,textDirection: TextDirection.rtl),onPressed: (){
                                      var ContactPhoneNumber = '${ds['Phone']??''}';
                                      launch("tel://$ContactPhoneNumber");
                                    }),

                                ),
                              ),
                            ),
                            Divider(height: 10, thickness: 2,)
                          ],
                        )
                      );
                    });
              }
              return Center(
                child: CircularProgressIndicator(
                ),
              );
            },

          )

        ));
  }
}

class Khodam{
  String name;
  int phone;
  String Class;

  Khodam({this.name, this.phone,this.Class});
}