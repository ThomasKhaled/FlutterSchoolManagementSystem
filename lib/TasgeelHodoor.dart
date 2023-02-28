import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:khedma_app/Time.dart';
import 'dart:ui' as ui;
import 'Hodoor.dart';
import 'MyStudents.dart';
import 'main_drawer.dart';
import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'Students.dart';
import 'GradesReport.dart';
import 'package:async/async.dart' show StreamGroup, StreamZip;

class TasgeelHodoor extends StatefulWidget {
  TasgeelHodoorState createState() => TasgeelHodoorState();
}

class TasgeelHodoorState extends State<TasgeelHodoor> {
  final firestoreInstance = FirebaseFirestore.instance;
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> tempData = [];
  var HighestHodoorEgtema3 = 0;
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
  bool isSearching = false;
  var hodoorEgtema3Map = new Map();
  var hodoor2oddasEgtema3Map = new Map();
  var listOfHodoorElEgtema3Esboo3y = [];
  var listOfHodoorElEgtema32oddasEsboo3y = [];
  var countNumOfDays=0;
  DateTime now = DateTime.now();
  List<bool> multipleSelected ;
  List<Student> students = <Student>[];
  Widget appBarTitle = new Text("بحث...",textDirection: ui.TextDirection.rtl,);
  Icon actionIcon = new Icon(Icons.search);
  final TextEditingController _searchQuery = new TextEditingController();
  bool _IsSearching = false;
  var listOfClasses = [];
  List<Stream<QuerySnapshot>> streamList = [];
  Stream<QuerySnapshot> combinedStream;
  var myList = ["هليوبوليس", 'النزهة 1', 'النزهة 2', 'أرض الجولف', 'تريومف', 'روكسي', 'الميريلاند', 'لخليفة المأمون', 'سانت فاتيما', 'شيراتون', 'العروبة', 'كلية البنات', 'الكوربة', 'منشية البكري', 'ميدان الإسماعيلية', 'ميدان الحجاز', 'ميدان المحكمة', 'ميدان سفير', 'ميدان صلاح الدين', 'الماظه','اخري'];
  var nameColor = [];
  var ids = [];
  Future<List> getStudents;
  Future getNumOfDays;
  var hieghestHodoorEgtema3;
  var hodoorToDaysCount ;
  var hodoor2oddasToDaysCount ;
  var hodoorToHighest ;
  var hodoor2oddasToHighest ;
  var totalHodoorEgtema3;
  var totalHodoorEgtema32oddas;
  Future getNameRepetition;
  var today;
  var _uploadedFileURL = [];
  bool cancelAttendance = false;



  @override
  void initState() {
    cancelAttendance = false;
    multipleSelected = List.generate(600, (index) => false);
    getStudents = getAllStudents();
    super.initState();
    getNumberOfDays();
    /*zeroeingHieghestHodoor();
    zeroeingHodoorCount();
    zeroeingallHodoorCount();*/
    //updatingHodoor();

  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "بحث...",
        style: new TextStyle(color: Colors.white),textDirection: ui.TextDirection.rtl,
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future updateNumberOfDays(var numOfDays) async{
    return users.doc('HodoorCount').set({
      'NumOfDays' : numOfDays,
      'Today' : now.day
    });
  }






  Future getNumberOfDays() async{
    return users.doc('HodoorCount').get().then((value) {
      setState(() {

        countNumOfDays = value.data()['NumOfDays'];
        today = value.data()['Today'];

      });
    });


  }
  void handleClick(String value) {

    switch (value) {
      case 'إحتساب اليوم كحضور':
        getNumberOfDays();
        if(today == now.day){
          Fluttertoast.showToast(
              msg: "تم إحتساب حضور اليوم مسبقاً!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blueAccent,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }else{
          showDialog(barrierLabel: 'Tsadasd',
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 16,
                child: Container(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      _buildRow(countNumOfDays)
                    ],
                  ),
                ),
              );
            },
          );
        }
        break;
      case 'إحتساب حضور المخدومين':
        updateAttendance();
        break;

    }
  }

  void updateAttendance()async{
    var count =0;
     for(int i=0; i<attandanceNames.length; i++){
          await update();

    }
    if(count == multipleSelected.length){
      Fluttertoast.showToast(
          msg: "برجاء تحديد المخدومين اولاً",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }else
      Fluttertoast.showToast(
          msg: "تم إحتساب الحضور!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0
      );
  }



  Future<List> getAllStudents()async{
    data = [];
    tempData = [];
    HighestHodoorEgtema3 = 0;
    await users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').get().then((value) {
      value.docs.forEach((element) async{

        data.add(element.data());
        tempData.add(element.data());
        ids.add(element.id);


      });
    });


    return tempData;
  }

  Future gethodoorEgtema3ByName(String fullName) async {
    await firestoreInstance
        .collection("users")
        .doc('Ma5domeen')
        .collection('classes')
        .doc('admin')
        .collection('class')
        .where("FullName", isEqualTo: fullName)
        .limit(1)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        DocumentReference docRef = users.doc('Ma5domeen').collection('classes')
            .doc('admin')
            .collection('class')
            .doc(element.id);
        if(element.data().containsKey('Dates')){
          Map<String, dynamic> x = Map<String, dynamic>.from(element.data()['Dates']);
          x.forEach((Year, value) {
            Map<String, dynamic> y = Map<String, dynamic>.from(x[Year]);
            for(var val in y.entries) {
              var month = val.key;
              var va = val.value;
              if(month == DateFormat.MMMM().format(DateTime(0, now.month)) && int.parse(Year) == now.year){
                if (value[month]['hodoorEgtema3'].toString() != null){
                  hodoorEgtema3Map[fullName] = double.tryParse(value[month]['hodoorEgtema3'].toString()??"0.0");
                  if(value[month]['hodoorEgtema3'].toString() == "" || value[month]['hodoorEgtema3'].toString() == null)
                    hodoorEgtema3Map[fullName] = 0.0;


                }
                if (value[month]['hodoor2oddas5edma'].toString() !=  null)  {
                  hodoor2oddasEgtema3Map[fullName+'1'] = double.tryParse(value[month]['hodoor2oddas5edma'].toString()??"0.0");
                  if(value[month]['hodoor2oddas5edma'].toString() == "" || value[month]['hodoor2oddas5edma'].toString() == null)
                    hodoor2oddasEgtema3Map[fullName+'1'] = 0.0;
                }

              }
            }
          });
        }
      });
    });


  }




  Future updateHighest(var tempHighest) async{
    await firestoreInstance.collection("users").doc('Ma5domeen').collection('classes').doc('admin').collection('class').get().then((value) {
      value.docs.forEach((element) {
        upd(element,tempHighest);
      });
    });




  }
  void upd(QueryDocumentSnapshot x,var tempHighest)async{
    bool Update = true;
    DocumentReference docRef = firestoreInstance.collection("users").doc('Ma5domeen').collection('classes')
        .doc('admin')
        .collection('class')
        .doc(x.id);
    await firestoreInstance.collection("users").doc('Ma5domeen').collection('classes')
        .doc('admin').collection('class')
        .doc(x.id).get().then((value){
      if(!value.exists)
        Update = false;
    });
    if(Update){
      docRef.update({'HieghestHodoor':tempHighest,'hodoorToHighest':(x.data()['totalHodoorEgtema3']/tempHighest),'hodoor2oddasToHighest':((x.data()['totalHodoorEgtema3']+x.data()['totalHodoor2oddasEgtema3'])/tempHighest)});

    }
  }

  Future update() async {
    for(var fullName in attandanceNames){
      await firestoreInstance.collection("users").get().then((querySnapshot) {
        firestoreInstance
            .collection("users")
            .doc('Ma5domeen')
            .collection('classes')
            .doc('admin')
            .collection('class')
            .where("FullName", isEqualTo: fullName)
            .limit(1)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((element) async{
            await gethodoorEgtema3ByName(fullName);

            await up(element,fullName);
          });
        });
      });
    }
    attandanceNames.clear();

  }

  static const ro7yFrom = 1;
  static const ro7yToHour = 8, ro7yToMinute = 59;
  static const egtema3From = 9;
  static const egtema3ToHour = 14, egtema3Minute = 59;
  Future up(QueryDocumentSnapshot element,String fullName) async {
    await getNumberOfDays();
    double egtema3 =0,x1 =0;
    double _2oddasEgtema3 =0,x2=0;
    if(hodoorEgtema3Map.length > 0)
      egtema3+= hodoorEgtema3Map[fullName]==null?0.0:hodoorEgtema3Map[fullName];
    if(hodoor2oddasEgtema3Map[fullName+'1'] != null)
      _2oddasEgtema3+= hodoor2oddasEgtema3Map[fullName+'1']==null?0.0:hodoor2oddasEgtema3Map[fullName+'1'];

    print('eg: $egtema3 - 20d: $_2oddasEgtema3' + ' now: ${now.hour}:${now.minute}');
    if((now.hour >= ro7yFrom) && (now.hour<=ro7yToHour && now.minute<=ro7yToMinute)){
      egtema3+=1;
      if(!(_2oddasEgtema3 == 1))
        _2oddasEgtema3+=1;
      print('1st');
    }
    else if((now.hour >= egtema3From && now.minute>=0) && (now.hour <egtema3ToHour && now.minute<=egtema3Minute)){egtema3+=1;print('2nd');}
    else if((now.hour >= egtema3ToHour)){egtema3+=0.5;print('3rd');}
    DocumentReference docRef;
    var month = DateFormat.MMMM().format(DateTime(0, now.month));
    bool moreThanHodoor = false;
    if(egtema3 > 5.5){
      egtema3 = 5.5;
      moreThanHodoor = true;
    }
    bool Update = true;



    docRef = users.doc('Ma5domeen').collection('classes')
        .doc('admin')
        .collection('class')
        .doc(element.id);
    await firestoreInstance.collection("users").doc('Ma5domeen').collection('classes')
        .doc('admin').collection('class')
        .doc(element.id).get().then((value){
      if(!value.exists)
        Update = false;
    });
    if(element.data().containsKey('totalHodoorEgtema3')){
      if( !moreThanHodoor){
        if((now.hour >= ro7yFrom) && (now.hour<=ro7yToHour && now.minute<=ro7yToMinute)){x1+=1;x2+=1;}
        else if((now.hour >= egtema3From && now.minute>=0) && (now.hour <egtema3ToHour && now.minute<=egtema3Minute)){x1+=1;}
        else if((now.hour >= egtema3ToHour)){x1+=0.5;}
        totalHodoorEgtema3 = double.tryParse(element.data()['totalHodoorEgtema3'].toString())+x1;

      }else
        totalHodoorEgtema3 = double.tryParse(element.data()['totalHodoorEgtema3'].toString());
    }
    /*else{
      totalHodoorEgtema3 = double.tryParse(egtema3.toString());
    }*/
    if(element.data().containsKey('totalHodoor2oddasEgtema3')){
      if((now.hour >= 1) && (now.hour<=8 && now.minute<=59)){x2+=1;}
      totalHodoorEgtema32oddas = double.tryParse(element.data()['totalHodoor2oddasEgtema3'].toString()) + x2;
    }
    /*else{
      totalHodoorEgtema32oddas = double.tryParse(_2oddasEgtema3.toString());
    }*/
    if(element.data().containsKey('HieghestHodoor')){
      String  high = element.data()['HieghestHodoor'].toString();
      setState(() {
        hieghestHodoorEgtema3 = double.tryParse(high);
      });
    }else
      hieghestHodoorEgtema3 = 0.0;
    if(totalHodoorEgtema3 != null && totalHodoorEgtema32oddas != null && hieghestHodoorEgtema3.toString().isNotEmpty){

      if((totalHodoorEgtema3 + totalHodoorEgtema32oddas) > hieghestHodoorEgtema3){

        setState(() {
          hieghestHodoorEgtema3 = totalHodoorEgtema3 + totalHodoorEgtema32oddas;
        });
        await updateHighest(hieghestHodoorEgtema3);
      }
    }
    print('hi: $egtema3 + $_2oddasEgtema3 - te $totalHodoorEgtema3 - t2e $totalHodoorEgtema32oddas');



    if((today != null) && (today == DateTime.now().day) && Update){
      docRef.set(
          {
            'Dates':{
              '${now.year}': {
                '$month': {
                  'hodoorEgtema3': egtema3.toString(),
                  'hodoor2oddas5edma': _2oddasEgtema3.toString()
                }
              }
            }
          },SetOptions(merge: true)
      );

      var a = (totalHodoorEgtema3/countNumOfDays*100).toStringAsFixed(2)
      ,b = (((totalHodoorEgtema32oddas+totalHodoorEgtema3)/countNumOfDays)*100).toStringAsFixed(2),
          c = ((totalHodoorEgtema3/hieghestHodoorEgtema3)*100).toStringAsFixed(2),
          d = (((totalHodoorEgtema32oddas+totalHodoorEgtema3)/hieghestHodoorEgtema3)*100).toStringAsFixed(2),
          e = countNumOfDays , f = hieghestHodoorEgtema3;
      docRef.set({
        'totalHodoorEgtema3' : totalHodoorEgtema3,
        'totalHodoor2oddasEgtema3' : totalHodoorEgtema32oddas,
        'hodoorToDaysCount' : a,
        'hodoor2oddasToDaysCount': b,
        'hodoorToHighest' : c,
        'hodoor2oddasToHighest': d,
        'countDays' : e,
        'HieghestHodoor': f,
        'attendanceToday' : now.day

      },SetOptions(merge: true));

    }
    setState(() {
      for(int i=0; i<multipleSelected.length; i++){
        multipleSelected[i] = false;
      }
    });


  }




  void updateAfterCountNumOfDays() async {

    await firestoreInstance.collection("users").get().then((querySnapshot) {
      firestoreInstance
          .collection("users")
          .doc('Ma5domeen')
          .collection('classes')
          .doc('admin')
          .collection('class')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) async{
          await  gethodoorEgtema3ByName(element.data()['FullName']);
          updateAfterCountDays(element,element.data()['FullName']);
        });
      });
    });

  }

  void zeroeingHieghestHodoor() async {

    await firestoreInstance.collection("users").get().then((querySnapshot) {
      firestoreInstance
          .collection("users")
          .doc('Ma5domeen')
          .collection('classes')
          .doc('admin')
          .collection('class')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) async{
          users.doc('Ma5domeen').collection('classes')
              .doc('admin')
              .collection('class')
              .doc(element.id).update({'HieghestHodoor' : 0});
        });
      });
    });

  }
  void zeroeingHodoorCount() async {

    await firestoreInstance.collection("users").get().then((querySnapshot) {
      firestoreInstance
          .collection("users")
          .doc('Ma5domeen')
          .collection('classes')
          .doc('admin')
          .collection('class')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) async{
          users.doc('Ma5domeen').collection('classes')
              .doc('admin')
              .collection('class')
              .doc(element.id).update({'countDays' : 1});
        });
      });
    });

  }

  void updatingHodoor() async {

    await firestoreInstance.collection("users").get().then((querySnapshot) {
      firestoreInstance
          .collection("users")
          .doc('Ma5domeen')
          .collection('classes')
          .doc('admin')
          .collection('class')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) async{
          if(element.data()['totalHodoorEgtema3'] == 1){
            users.doc('Ma5domeen').collection('classes')
                .doc('admin')
                .collection('class')
                .doc(element.id).update({'hodoor2oddasToHighest':66.67});
          }

        });
      });
    });

  }

  void zeroeingallHodoorCount() async {

    await firestoreInstance.collection("users").get().then((querySnapshot) {
      firestoreInstance
          .collection("users")
          .doc('Ma5domeen')
          .collection('classes')
          .doc('admin')
          .collection('class')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) async{
          users.doc('Ma5domeen').collection('classes')
              .doc('admin')
              .collection('class')
              .doc(element.id).update({'Dates':{'2022':{'October':{'hodoor2oddas5edma':0.0,'hodoorEgtema3':0.0}}}});

          users.doc('Ma5domeen').collection('classes')
              .doc('admin')
              .collection('class')
              .doc(element.id).update({'attendanceToday':0});

          users.doc('Ma5domeen').collection('classes')
              .doc('admin')
              .collection('class')
              .doc(element.id).update({'hodoor2oddasToDaysCount':0.0,'hodoor2oddasToHighest':0.0,'hodoorToDaysCount':0.0,'hodoorToHighest':0.0});

          users.doc('Ma5domeen').collection('classes')
              .doc('admin')
              .collection('class')
              .doc(element.id).update({'totalHodoorEgtema3':0,'totalHodoor2oddasEgtema3':0});

        });
      });
    });

  }


  Future updateAfterCountDays(QueryDocumentSnapshot element,String fullName) async {
    await getNumberOfDays();
    double egtema3 =0;
    double _2oddasEgtema3 =0;
    if(hodoorEgtema3Map.length > 0)
      egtema3 += hodoorEgtema3Map[fullName]==null?0.0:hodoorEgtema3Map[fullName];
    if(hodoor2oddasEgtema3Map[fullName+'1'] != null)
      _2oddasEgtema3 += hodoor2oddasEgtema3Map[fullName+'1']==null?0.0:hodoor2oddasEgtema3Map[fullName+'1'];


    DocumentReference docRef;

    bool Update = true;


    docRef = users.doc('Ma5domeen').collection('classes')
        .doc('admin')
        .collection('class')
        .doc(element.id);
    await firestoreInstance.collection("users").doc('Ma5domeen').collection('classes')
        .doc('admin').collection('class')
        .doc(element.id).get().then((value){
      if(!value.exists)
        Update = false;
    });
    if(element.data().containsKey('totalHodoorEgtema3')){
      totalHodoorEgtema3 = double.parse(element.data()['totalHodoorEgtema3'].toString()??'0');
    }
    else{
      totalHodoorEgtema3 = double.tryParse(egtema3.toString());
    }
    if(element.data().containsKey('totalHodoor2oddasEgtema3')){
      totalHodoorEgtema32oddas = double.parse(element.data()['totalHodoor2oddasEgtema3'].toString()??'0');
    }else{
      totalHodoorEgtema32oddas = double.tryParse(_2oddasEgtema3.toString());
    }
    if(element.data().containsKey('HieghestHodoor')){
      String  high = element.data()['HieghestHodoor'].toString();
      setState(() {
        hieghestHodoorEgtema3 = double.parse(high);
      });
    }







    if(Update && totalHodoorEgtema3 != null && totalHodoorEgtema32oddas != null){

      var a = ((totalHodoorEgtema3/countNumOfDays)*100).toStringAsFixed(2),
          b = (((totalHodoorEgtema32oddas+totalHodoorEgtema3)/countNumOfDays)*100).toStringAsFixed(2),
          c = ((totalHodoorEgtema3/hieghestHodoorEgtema3)*100).toStringAsFixed(2),
          d = (((totalHodoorEgtema32oddas+totalHodoorEgtema3)/hieghestHodoorEgtema3)*100).toStringAsFixed(2),
          e = countNumOfDays ;
      docRef.set({
        'hodoorToDaysCount' : a,
        'hodoor2oddasToDaysCount': b,
        'hodoorToHighest' : c,
        'hodoor2oddasToHighest': d,
        'countDays' : e,

      },SetOptions(merge: true));

    }


  }


  Widget _buildRow(var numOfDays) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: <Widget>[
          Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text('عدد المحاضرات و الايام الروحية : ${countNumOfDays}',textDirection: ui.TextDirection.rtl,),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: ElevatedButton(
                          child: Text('+1'),
                          onPressed: (){
                            numOfDays+=1;
                            setState(() {
                              countNumOfDays = numOfDays;
                            });
                            updateNumberOfDays(countNumOfDays).whenComplete((){
                              getNumberOfDays();
                              updateAfterCountNumOfDays();
                              Fluttertoast.showToast(
                                  msg: "تم إحتساب المحاضرة!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blueAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            });
                            Navigator.of(context).pop();

                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: ElevatedButton(
                          child: Text('+2'),
                          onPressed: (){
                            numOfDays+=2;
                            setState(() {
                              countNumOfDays = numOfDays;
                            });
                            updateNumberOfDays(countNumOfDays).whenComplete((){
                              getNumberOfDays();
                              updateAfterCountNumOfDays();
                              Fluttertoast.showToast(
                                  msg: "تم إحتساب المحاضرة و اليوم الروحي!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blueAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }



  var attandanceNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
        new IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close);
                this.appBarTitle = new TextField(
                  autofocus: true,
                  onChanged: onItemChanged,
                  controller: _searchQuery,
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "بحث...",hintTextDirection: ui.TextDirection.rtl,
                      hintStyle: new TextStyle(color: Colors.white)),
                );
                _handleSearchStart();
              } else {
                _handleSearchEnd();
              }
            });
          },
        ),
        PopupMenuButton<String>(
          onSelected: handleClick,
          itemBuilder: (BuildContext context) {
            return {'إحتساب اليوم كحضور','إحتساب حضور المخدومين'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ]),
      drawer: MainDrawer(),
      body: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: StreamBuilder(
            stream: (_searchQuery.text != '' && _searchQuery.text != null)?users.doc('Ma5domeen').collection('classes').doc('admin')
                .collection('class').where("caseSearch", arrayContains: _searchQuery.text).snapshots()
                :users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').orderBy('FullName',descending: false).snapshots(),
            builder: (context , snapshot){
              if(!snapshot.hasData)return Center(child: CircularProgressIndicator(),);
              if(ConnectionState.values == ConnectionState.done && !snapshot.hasData){
                return Center(
                  child: Text('لا يوجد مخدومين مسجلين',style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold)),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: WillPopScope(
                    child: ListView.builder(
                      shrinkWrap: false,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          if(!cancelAttendance){
                            return  Column(
                              children: [

                                (ds['attendanceToday'] != now.day)?
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // if you need this
                                    side: BorderSide(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    height: 60,
                                    child: Center(
                                      child: ListTile(
                                        onTap: () {

                                        },
                                        leading:Container(
                                          margin: const EdgeInsets.only(top: 8),
                                          child: CircleAvatar(
                                            radius: 30,
                                            child: ClipOval(
                                                child: Image.asset('assets/StudentImg.png',filterQuality: FilterQuality.low,)
                                            ),
                                          ),
                                        )/*Container(
                                          margin: const EdgeInsets.only(top: 8),
                                          child: CircleAvatar(
                                            radius: 30,
                                            child: ClipOval(
                                              child: Image.network(
                                                '${ds['imgPath'].toString()}',
                                                fit: BoxFit.fill,
                                                height: 100,
                                                width: 100,
                                              ),
                                            ),
                                          ),
                                        )*/,
                                        title: Text(
                                          ds['FullName']??'',
                                          style: TextStyle(fontSize: 20,color: (nameColor.length != 0)? nameColor[index].c:Colors.black),
                                        ),
                                        trailing: Checkbox(
                                          activeColor: Colors.blueAccent,
                                          value: multipleSelected[index],
                                          onChanged:(today == now.day)? (val){
                                            setState(() {
                                              multipleSelected[index] = val;
                                              gethodoorEgtema3ByName(ds['FullName']);
                                              if(val == true){
                                                attandanceNames.add(ds['FullName']);
                                              }else{
                                                if(attandanceNames.contains(ds['FullName']))
                                                  attandanceNames.remove(ds['FullName']);
                                              }

                                            });
                                          }:null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ):Container(),
                                (ds['attendanceToday'] != now.day)?Divider(height: 7,thickness: 1,):Container()
                              ],
                            );
                          }else{
                            return  Column(
                              children: [
                                ListTile(
                                  onTap: () {

                                  },
                                  leading:Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    child: CircleAvatar(
                                      radius: 30,
                                      child: ClipOval(
                                          child: Image.asset('assets/StudentImg.png',filterQuality: FilterQuality.low,)
                                      ),
                                    ),
                                  )/*Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    child: CircleAvatar(
                                      radius: 30,
                                      child: ClipOval(
                                        child: Image.network(
                                          '${ds['imgPath'].toString()}',
                                          fit: BoxFit.fill,
                                          height: 100,
                                          width: 100,
                                        ),
                                      ),
                                    ),
                                  )*/,
                                  title: Text(
                                    ds['FullName']??'',
                                    style: TextStyle(fontSize: 20,color: (nameColor.length != 0)? nameColor[index].c:Colors.black),
                                  ),
                                  trailing: Checkbox(
                                    activeColor: Colors.blueAccent,
                                    value: multipleSelected[index],
                                    onChanged:(today == now.day)? (val){
                                      setState(() {
                                        multipleSelected[index] = val;
                                        gethodoorEgtema3ByName(ds['FullName']);
                                      });

                                    }:null,
                                  ),
                                ),
                               Divider(height: 7,thickness: 1,)
                              ],
                            );
                          }


                        })
                ),
              );
            },
          )
      ),
    );
  }

  onItemChanged(String value) {
    List<Map<String, dynamic>> tempD = [];
    if (value != '') {
      setState(() {
        isSearching = true;
        for(var map in tempData){

          if(map['FullName'].toString().toLowerCase().contains(value.toLowerCase())) {
            tempD.add(map);
          }
        }
        tempData.clear();
        tempData.addAll(tempD);


      });
    } else {
      setState(() {
        isSearching = false;
        tempData = data;
      });
    }
  }
}

