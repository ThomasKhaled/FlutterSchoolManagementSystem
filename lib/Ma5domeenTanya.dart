import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:khedma_app/Kheregeen.dart';
import 'package:khedma_app/Time.dart';
import 'package:khedma_app/shrootEl5edma.dart';
import 'dart:ui' as ui;
import 'GradesReport2.dart';
import 'Hodoor.dart';
import 'MyStudents.dart';
import 'main_drawer.dart';
import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'Students.dart';
import 'GradesReport.dart';
import 'package:async/async.dart' show StreamGroup, StreamZip;

class Ma5domeenTanya extends StatefulWidget {
  Ma5domeenTanyaState createState() => Ma5domeenTanyaState();
}

class Ma5domeenTanyaState extends State<Ma5domeenTanya> {
  final firestoreInstance = FirebaseFirestore.instance;
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> tempData = [];
  List<String> qDS = [];
  var indicies = [];

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
  var totalHodoorEgtema3 = 0.0;
  var totalHodoorEgtema32oddas = 0.0;
  Future getNameRepetition;
  var today;
  var _uploadedFileURL = [];
  var checkBoxVis = false;

  Future classNamesFuture;


  @override
  void initState() {
    checkBoxVis = false;
    multipleSelected = List.generate(600, (index) => false);
    getStudents = getAllStudents();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getPercentages = getGradesPercentages();
    });

    super.initState();
    getNumberOfDays();
    classNamesFuture = getclassNames();

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



  bool isAnyoneSelected(){
    multipleSelected.forEach((element) {
      if(element)
        return true;
    });
    return false;
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
      case 'تقرير درجات الامتحانات':
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => GradesReport2(listOfMa5domeen: tempData,listOfClasses: listOfClasses,elSana: '2',)));
        break;

      case 'تقرير الحضور':
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Hodoor(listOfMa5domeen: tempData,listOfClasses: listOfClasses,elSana: '2',)));
        break;

      case 'تقرير الخريجين':
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Kheregeen(listOfMa5domeen: tempData,listOfClasses: listOfClasses)));
        break;

      case 'شروط التخرج':
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => shrootEl5edma()));
        break;

    }
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



  Future getPercentages;
  Future getGradesPercentages() async{
    await FirebaseFirestore.instance.collection('gradesPercentage').doc('Percentages').get().then((value){
      setState(() {
        nos3amPerc = double.parse(value.data()['nos3am'].toString())??0.0;
        a5erEl3amPerc = double.parse(value.data()['a5erEl3am'].toString())??0.0;
        ebtyWeAl7anPerc = double.parse(value.data()['ebtyWeAl7an'].toString())??0.0;
        mosab2atPerc = double.parse(value.data()['mosab2at'].toString())??0.0;
        shafawyPerc = double.parse(value.data()['shafawy'].toString())??0.0;
        hodoor2oddasToHighestPerc = double.parse(value.data()['hodoor'].toString())??0.0;
      });
    });
  }

  var nos3amPerc ,a5erEl3amPerc,ebtyWeAl7anPerc,mosab2atPerc,shafawyPerc,hodoor2oddasToHighestPerc;



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
                if (value[month]['hodoorEgtema3'].toString().isNotEmpty){
                  hodoorEgtema3Map[fullName] = double.parse(value[month]['hodoorEgtema3'].toString());

                }
                if (value[month]['hodoor2oddas5edma'].toString().isNotEmpty){
                  hodoor2oddasEgtema3Map[fullName+'1'] = double.parse(value[month]['hodoor2oddas5edma'].toString());
                }

              }
            }
          });
        }
      });
    });


  }



  void Delete(String fullName) async {
    print('f: $fullName');
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
          .then((value){
        value.docs.forEach((element) {
          DocumentReference docRef;
          docRef = users.doc('Ma5domeen').collection('classes')
              .doc('admin')
              .collection('class')
              .doc(element.id);

          docRef.delete();
        });

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
      docRef.update({'HieghestHodoor':tempHighest});
      print('high : $tempHighest - name : ${x.data()['FullName']}');

    }
  }

  void update(String fullName) async {

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
        querySnapshot.docs.forEach((element) {

          up(element,fullName);
        });
      });
    });

  }


  Future up(QueryDocumentSnapshot element,String fullName) async {
    await getNumberOfDays();
    double egtema3 =0,x1 =0;
    double _2oddasEgtema3 =0,x2=0;
    if(hodoorEgtema3Map.length > 0)
      egtema3+= hodoorEgtema3Map[fullName];
    if(hodoor2oddasEgtema3Map[fullName+'1'] != null)
      _2oddasEgtema3+= hodoor2oddasEgtema3Map[fullName+'1'];
    if((now.hour >= 0) && (now.hour<=11 && now.minute<=59)){
      egtema3+=1;
      if(!(_2oddasEgtema3 == 1))
        _2oddasEgtema3+=1;
    }
    else if((now.hour == 12 && now.minute>=0) && (now.hour==12 && now.minute<=59)){egtema3+=1;}
    else if((now.hour >= 13)){egtema3+=0.5;}
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
      print(value.exists);
      if(!value.exists)
        Update = false;
    });
    if(element.data().containsKey('totalHodoorEgtema3')){
      if( !moreThanHodoor){
        if((now.hour > 5) && (now.hour<=11 && now.minute<=59)){x1+=1;}
        else if((now.hour == 12 && now.minute>=0) && (now.hour==12 && now.minute<=59)){x1+=1;}
        else if((now.hour >= 13)){x1+=0.5;}
        totalHodoorEgtema3 = double.parse(element.data()['totalHodoorEgtema3'].toString())+x1;

      }else
        totalHodoorEgtema3 = double.parse(element.data()['totalHodoorEgtema3'].toString());
    }
    else{
      totalHodoorEgtema3 = double.tryParse(egtema3.toString());
    }
    if(element.data().containsKey('totalHodoor2oddasEgtema3')){
      if((now.hour > 5) && (now.hour<=11 && now.minute<=59)){x2+=1;}
      totalHodoorEgtema32oddas = double.parse(element.data()['totalHodoor2oddasEgtema3'].toString())+x2;
    }else{
      totalHodoorEgtema32oddas = double.tryParse(_2oddasEgtema3.toString());
    }
    if(element.data().containsKey('HieghestHodoor')){
      String  high = element.data()['HieghestHodoor'].toString();
      setState(() {
        hieghestHodoorEgtema3 = double.parse(high);
      });
    }
    if((totalHodoorEgtema3 + totalHodoorEgtema32oddas) > hieghestHodoorEgtema3){
      setState(() {
        hieghestHodoorEgtema3 = totalHodoorEgtema3 + totalHodoorEgtema32oddas;
      });
      await updateHighest(hieghestHodoorEgtema3);
    }



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
          c = (totalHodoorEgtema3/hieghestHodoorEgtema3*100).toStringAsFixed(2),
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
        'HieghestHodoor': f

      },SetOptions(merge: true));

    }


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


  Future updateAfterCountDays(QueryDocumentSnapshot element,String fullName) async {
    await getNumberOfDays();
    double egtema3 =0;
    double _2oddasEgtema3 =0;
    if(hodoorEgtema3Map.length > 0)
      egtema3 += hodoorEgtema3Map[fullName];
    if(hodoor2oddasEgtema3Map[fullName+'1'] != null)
      _2oddasEgtema3 += hodoor2oddasEgtema3Map[fullName+'1'];

    DocumentReference docRef;

    bool Update = true;


    docRef = users.doc('Ma5domeen').collection('classes')
        .doc('admin')
        .collection('class')
        .doc(element.id);
    await firestoreInstance.collection("users").doc('Ma5domeen').collection('classes')
        .doc('admin').collection('class')
        .doc(element.id).get().then((value){
      print(value.exists);
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



    print('hi : $totalHodoorEgtema3 - $totalHodoorEgtema32oddas - $countNumOfDays');




    if(Update && totalHodoorEgtema3 != null && totalHodoorEgtema32oddas != null){
      print('ana up');

      var a = ((totalHodoorEgtema3/countNumOfDays)*100).toStringAsFixed(2),
          b = (((totalHodoorEgtema32oddas+totalHodoorEgtema3)/countNumOfDays)*100).toStringAsFixed(2),
          c = ((totalHodoorEgtema3/hieghestHodoorEgtema3)*100).toStringAsFixed(2),
          d = (((totalHodoorEgtema32oddas+totalHodoorEgtema3)/hieghestHodoorEgtema3)*100).toStringAsFixed(2),
          e = countNumOfDays ;
      print('a: $a\nb: $b\n c: $c\n d: $d\n');
      docRef.set({
        'hodoorToDaysCount' : a,
        'hodoor2oddasToDaysCount': b,
        'hodoorToHighest' : c,
        'hodoor2oddasToHighest': d,
        'countDays' : e,

      },SetOptions(merge: true));

    }


  }
  Widget _buildDialogForDelete(var qDS) {
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
                  child: Text('تأكيد حذف المخدوم',textDirection: ui.TextDirection.rtl,style: TextStyle(fontSize: 22.0)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          child: Text('لا'),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.green),
                          child: Text('نعم'),
                          onPressed: (){
                            for(int i=0; i<indicies.length; i++){
                              Delete(qDS[indicies[i]]);

                              /*if(multipleSelected[i] == true){
                                Delete(qDS[i]['FullName']);
                                setState(() {
                                  multipleSelected[i] = false;
                                });
                              }*/
                            }
                            Fluttertoast.showToast(
                                msg: "تم حذف المخدومين!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueAccent,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            Navigator.of(context).pop();
                            setState(() {
                              multipleSelected = List.generate(600, (index) => false);
                              indicies.clear();
                              checkBoxVis = false;
                            });
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
                  decoration: BoxDecoration(color: Colors.yellow[900], borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(8.0),
                  child: Text('عدد المحاضرات و الايام الروحية : ${countNumOfDays}',textDirection: ui.TextDirection.rtl,),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.yellow[900], borderRadius: BorderRadius.circular(5)),
                        child: FloatingActionButton(
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
                        decoration: BoxDecoration(color: Colors.yellow[900], borderRadius: BorderRadius.circular(3)),
                        child: FloatingActionButton(
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

  Map<String,String> classNames = {};
  Future getclassNames(){
    firestoreInstance.collection("Khodam").snapshots().forEach((e) {

      e.docs.forEach((e1) {
        if(e1.get('className') != null && e1.get('className').toString() != ''){
          classNames.putIfAbsent(e1.get('Name'), () => e1.get('className'));
        }else{
          classNames.putIfAbsent(e1.get('Name'), () => '');
        }
      });
    });
  }

  bool graduated;
  Future<bool> isGraduated(DocumentSnapshot ds)async{
    await getGradesPercentages().whenComplete((){
      var nos3am = double.tryParse(ds['emte7anNos3am'].toString()??0)??0.0;
      var a5erEl3am = double.tryParse(ds['a5erEl3am'].toString()??0)??0.0;
      var ebtyWeAl7an = double.tryParse(ds['ebtyWeAl7an'].toString()??0)??0.0;
      var mosab2at = int.tryParse(ds['totalMosab2at'].toString()??0)??0;
      var shafawy = double.tryParse(ds['shafawy'].toString()??0)??0.0;
      var hodoor2oddasToHighest = double.tryParse(ds['hodoor2oddasToHighest'].toString()??'0')??0.0;


      if(nos3am >= nos3amPerc && mosab2at >= mosab2atPerc && ebtyWeAl7an >= ebtyWeAl7anPerc
          && a5erEl3am >= a5erEl3amPerc && shafawy >= shafawyPerc && hodoor2oddasToHighest >= hodoor2oddasToHighestPerc)
      {
        graduated = true;
      }
      else{
        graduated = false;
      }
      print(graduated);

    });


    return graduated;

  }
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          leading: Row(
            children: [
              (checkBoxVis)?IconButton(
                  onPressed: (){
                    setState(() {
                      checkBoxVis = false;
                      for(int i=0; i<multipleSelected.length; i++){
                        multipleSelected[i] = false;
                        indicies.clear();
                      }
                    });

                  },
                  icon: Icon(Icons.arrow_back)):IconButton(
                  onPressed: (){
                    scaffoldKey.currentState.openDrawer();

                  },
                  icon: Icon(Icons.list_outlined)),
              (checkBoxVis)?Text('${indicies.length}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),):Container()


            ],
          ),
          title: (checkBoxVis == false)?appBarTitle:Text(''),
          actions: <Widget>[
            (checkBoxVis == false)?new IconButton(
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
            ):IconButton(onPressed: (){
              setState(() {
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
                            _buildDialogForDelete(qDS)
                          ],
                        ),
                      ),
                    );
                  },
                );


              });

            },
                icon: Icon(Icons.delete)),
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'تقرير درجات الامتحانات','تقرير الحضور','تقرير الخريجين','شروط التخرج'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ]),
      drawer: (checkBoxVis == false)?MainDrawer():null,
      body: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: StreamBuilder(
            stream:(_searchQuery.text != '' && _searchQuery.text != null)?users.doc('Ma5domeen').collection('classes').doc('admin')
                .collection('class').where('FullName',isEqualTo: _searchQuery.text).where('e3dad5odam3amDerasy',isEqualTo: '2').snapshots()
                :users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').where('e3dad5odam3amDerasy',isEqualTo: '2').snapshots(),
            builder: (context , snapshot){
              if(snapshot.connectionState == ConnectionState.waiting)return Center(child: CircularProgressIndicator(),);
              if(snapshot.connectionState == ConnectionState.none ){
                return Center(
                  child: Text('لا يوجد مخدومين مسجلين',style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold)),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: WillPopScope(
                    child:
                    GroupedListView<dynamic, String>(
                      elements: snapshot.data.docs,
                      groupBy: (element) => element['ClassNum'],
                      groupHeaderBuilder: (element){
                        print(element['ClassNum'] == classNames.containsKey(element['ClassNum']));
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 75,
                          child: Column(
                            children: [
                              Center(child: Text('${element['ClassNum']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.blue,),)),
                              (classNames.containsKey(element['ClassNum']))?
                              Center(child: Text('${classNames[element['ClassNum']]}',style: TextStyle(fontSize: 20,color: Colors.black),)):Text(''),
                            ],
                          ),
                        );

                      },
                      itemComparator: (item1, item2) => item1['FullName'].compareTo(item2['FullName']),
                      useStickyGroupSeparators: true,
                      floatingHeader: false,
                      order: GroupedListOrder.ASC,
                      groupComparator: (value1, value2) => value1.compareTo(value2),
                      groupSeparatorBuilder: (String value) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 26,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      indexedItemBuilder: (context, dynamic ds,index) {
                        qDS.add(ds['FullName'].toString());

                        return GestureDetector(
                          onLongPress: (){
                            setState(() {
                              indicies.clear();
                              checkBoxVis = true;
                              multipleSelected[index] = true;
                              indicies.add(index);
                            });
                          },
                          child: Card(
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
                                    if(checkBoxVis == false){
                                      Student s = Student(
                                          ds['imgPath'].toString(),
                                          ds['FullName'].toString(),
                                          ds['StudentPhoneNumber'],
                                          ds['rakam3omara'].toString(),
                                          ds['esmElShare3'].toString(),
                                          ds['elDoor'].toString(),
                                          ds['rakamShaqqa'].toString(),
                                          ds['Manteqa'].toString(),
                                          ds['gehatElDerasa'].toString(),
                                          ds['elSanaElderaseyya'].toString(),
                                          ds['abElE3teraf'].toString(),
                                          ds['kenistoh'].toString(),
                                          ds['e3dad5odam3amDerasy'].toString(),
                                          ds['telephoneElManzel'],
                                          ds['gehatEl3amal'].toString(),
                                          ds["BOD"]["Day"],
                                          ds["BOD"]["Month"],
                                          ds["BOD"]["Year"],
                                          ds['ClassNum'].toString(),
                                          ds['ClassName'].toString());
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            DisplayInformation(recordName: s,id: "0",listOfClasses: listOfClasses,listOfMa5domeen: tempData),
                                      ));
                                    }else{
                                      if(multipleSelected[index] == false){
                                        setState(() {
                                          multipleSelected[index] = true;

                                        });
                                        if(!indicies.contains(index))
                                          indicies.add(index);
                                        else
                                          indicies.remove(index);
                                      }else{
                                        setState(() {
                                          multipleSelected[index] = false;
                                        });
                                        indicies.remove(index);
                                      }



                                      if(indicies.length == 0){
                                        checkBoxVis = false;
                                        indicies.clear();
                                      }
                                    }
                                  },
                                  leading:Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    child: CircleAvatar(
                                      radius: 30,
                                      child: ClipOval(
                                          child: Image.asset('assets/StudentImg.png',filterQuality: FilterQuality.low,)
                                      ),
                                    ),
                                  ),
                                  /*Container(
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
                                  ),*/
                                  title: Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      ds['FullName']??'',
                                      style: TextStyle(fontSize: 22,color: (nameColor.length != 0)? nameColor[index].c:Colors.black),
                                    ),
                                  ),
                                  /* subtitle: Text(
                                      '${ds['ClassNum'].toString().split('-').last}',style: TextStyle(fontSize: 16),
                                    ),*/
                                  trailing: (checkBoxVis == true)?Checkbox(
                                    activeColor: Colors.blueAccent,
                                    value: multipleSelected[index],
                                    onChanged: (val){
                                      setState(() {
                                        multipleSelected[index] = val;
                                        if(!indicies.contains(index))
                                          indicies.add(index);
                                        else
                                          indicies.remove(index);
                                        if(indicies.length == 0){
                                          checkBoxVis = false;
                                          indicies.clear();
                                        }
                                      });
                                    },
                                  ):(graduated == true)? Image.asset('assets/khareeg.png'):null,
                                ),
                              ),
                            ),
                          ),
                        );
                      },

                    ),
                   /* ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          if(ds.data().isNotEmpty){
                            isGraduated(ds);
                          }


                          getAllStudents();

                          return  Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Student s = Student(
                                      ds['imgPath'].toString(),
                                      ds['FullName'].toString(),
                                      ds['StudentPhoneNumber'],
                                      ds['rakam3omara'].toString(),
                                      ds['esmElShare3'].toString(),
                                      ds['elDoor'].toString(),
                                      ds['rakamShaqqa'].toString(),
                                      ds['Manteqa'].toString(),
                                      ds['gehatElDerasa'].toString(),
                                      ds['elSanaElderaseyya'].toString(),
                                      ds['abElE3teraf'].toString(),
                                      ds['kenistoh'].toString(),
                                      ds['e3dad5odam3amDerasy'].toString(),
                                      ds['telephoneElManzel'],
                                      ds['gehatEl3amal'].toString(),
                                      ds["BOD"]["Day"],
                                      ds["BOD"]["Month"],
                                      ds["BOD"]["Year"],
                                      ds['ClassNum'].toString(),
                                      ds['ClassName'].toString());
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        DisplayInformation(recordName: s,id: ids[index],listOfClasses: listOfClasses),
                                  ));
                                },
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                    bottomLeft: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0),
                                  ),
                                  child: FadeInImage(
                                    image : NetworkImage(
                                      '${ds['imgPath'].toString()}',

                                    ),
                                    fit: BoxFit.fill,
                                    width: 70,
                                    height: 90,
                                    placeholder: AssetImage('assets/proff.png'),
                                  ),
                                ),
                                title: Text(
                                  ds['FullName']??'',
                                  style: TextStyle(fontSize: 26,color: (nameColor.length != 0)? nameColor[index].c:Colors.black),
                                ),
                                subtitle: Text(
                                    '${ds['ClassNum'].toString()}',style: TextStyle(fontSize: 16)
                                ),
                                trailing: (checkBoxVis == true)?Checkbox(
                                  activeColor: Colors.blueAccent,
                                  value: multipleSelected[index],
                                  onChanged: (val){
                                    setState(() {
                                      multipleSelected[index] = val;
                                    });
                                  },
                                ):(graduated == true)? Image.asset('assets/khareeg.png'):null,
                              ),
                              Divider(height: 10,thickness: 1.5,)
                            ],
                          );
                        })*/
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
        tempData= [];
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

