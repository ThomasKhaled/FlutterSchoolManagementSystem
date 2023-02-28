import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:khedma_app/sign_in.dart';

import 'Students.dart';

class Time2 extends StatefulWidget {
  final String recordName;
  final String id;
  final List listOfClasses;
  const Time2({Key key, this.recordName, this.id,this.listOfClasses}) : super(key: key);

  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time2> with TickerProviderStateMixin {
  bool pickerIsExpanded = false;
  var listOfHodoorElEgtema3Esboo3y = [];
  var listOfHodoorElEgtema32oddasEsboo3y = [];
  var totalHodoorEgtema3 = 0.0;
  var totalHodoorEgtema32oddas = 0.0;
  var countNumOfDays = 0.0;
  var hieghestHodoorEgtema3 =0.0;
  var mosab2at = 0;
  var sefat = '';
  var sefatmotab3a = '';
  var mola7zat = '';
  var mola7zatBeet = '';
  var tempData = [];
  bool f1= false,f2= false,f3= false,f4= false,f5= false,f6 = false,f7 = false;
  TextEditingController sefatGayyedaC = new TextEditingController();
  TextEditingController sefatTa7takMotab3aC = new TextEditingController();
  TextEditingController mola7zatO5raC = new TextEditingController();
  TextEditingController mola7zat3anElBeetC = new TextEditingController();
  TextEditingController KenisaO5raC = new TextEditingController();
  TextEditingController nos3amC0 = new TextEditingController();
  TextEditingController ebtyWeAl7anC0 = new TextEditingController();
  TextEditingController a5erEl3amC0 = new TextEditingController();
  TextEditingController mo2tamarC0 = new TextEditingController();
  TextEditingController shafawyC0 = new TextEditingController();
  TextEditingController mosab2atC0 = new TextEditingController();
  TextEditingController nos3amC = new TextEditingController();
  TextEditingController ebtyWeAl7anC = new TextEditingController();
  TextEditingController a5erEl3amC = new TextEditingController();
  TextEditingController mo2tamarC = new TextEditingController();
  TextEditingController shafawyC = new TextEditingController();
  TextEditingController mosab2atC = new TextEditingController();
  TextEditingController hodoorZoroofC = new TextEditingController();
  TextEditingController ra8batO5ra1C = new TextEditingController();
  TextEditingController ra8batO5ra2C = new TextEditingController();
  TextEditingController ra8batO5ra3C = new TextEditingController();
  TextEditingController khademRa8batO5raC = new TextEditingController();
  TextEditingController mee3adKhademRa8batO5raC = new TextEditingController();


  Future applyNewHighest;
  Future applyAllValues,futureGetHighest,getNumOfDays;


  var e1 = false;
  var e2 = false;
  var e3 = false;
  var e4 = false;
  var e5 = false;


  int _pickerYear = DateTime.now().year;
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );


  Future UpdateHighestScore()async{
    var tempHighest = 0.0;
    var list = [];
    HighestHodoorEgtema3 = 0;
      await firestoreInstance.collection("users").doc('Ma5domeen').collection('classes').doc('admin').collection('class').get().then((value) {
        value.docs.forEach((element) {
          String a = element.data()['HieghestHodoor'].toString();
          if (a.isNotEmpty && a != null  && a!= "null") {
            num actualHigh = double.parse(a);
            list.add(actualHigh);
          }


        });
      });


    tempHighest = list.reduce((curr, next) => curr > next? curr: next);
    setState(() {
      hieghestHodoorEgtema3 = tempHighest;
    });
    await updateHighest(tempHighest);

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

  Future updateHighest(var tempHighest) async{
    for(var khadem in listOfClasses){
      await firestoreInstance.collection("users").doc('Ma5domeen').collection('classes').doc(khadem).collection('class').get().then((value) {
        value.docs.forEach((element) {
          upd(element,tempHighest);
        });
      });

    }


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
    if(Update)
      docRef.update({'HieghestHodoor':tempHighest});
  }
  dynamic _pickerOpen = false;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  //Hodoor 2oddassat dropdown
  List<Hodoor2odassat> ListOfHodoor2oddasat =
      Hodoor2odassat.getHodoor2odassat();
  List<DropdownMenuItem<Hodoor2odassat>> _dropdownMenuHodoor2odassat;
  Hodoor2odassat _selectedHodoor2odassat;




  List<e5tebarHay2a> ListOfe5tebarHay2a =
  e5tebarHay2a.gete5tebarHay2a();
  List<DropdownMenuItem<e5tebarHay2a>> _dropdownMenue5tebarHay2a;
  e5tebarHay2a _selectede5tebarHay2a;

  List<Ra8abat> ListOfRa8abat =
  Ra8abat.getRa8abat();
  List<DropdownMenuItem<Ra8abat>> _dropdownMenuRa8abat;
  Ra8abat _selectedRa8abat;
  Ra8abat _selectedRa8abat2;
  Ra8abat _selectedRa8abat3;
  Ra8abat _selectedRa8abatTarshee7;

  //Na3ama and La2 dropdown
  List<YesOrNo> ListOfYesOrNo = YesOrNo.getYesOrNo();
  List<DropdownMenuItem<YesOrNo>> _dropdownMenuYesOrNo;
  YesOrNo _selectedYesOrNoE3teraf;
  YesOrNo _selectedYesOrNoMotab3a;
  YesOrNo _selectedYesOrNoZyara;
  YesOrNo _selectedYesOrNoTasleemMosab2at;
  YesOrNo _selectedYesOrNoYe5demfeMargirgis;
  YesOrNo _selectedYesOrNoMewaf2aMnAbE3teraf;

  //Ketab Moqaddas dropdown
  List<KetabMoqaddas> ListOfKetabMoqaddas = KetabMoqaddas.getKetabMoqaddas();
  List<DropdownMenuItem<KetabMoqaddas>> _dropdownMenuKetabMoqaddas;
  KetabMoqaddas _selectedKetabMoqaddas;


  List<Mee3adEl5edma> ListOfMee3adEl5edma = Mee3adEl5edma.getKetabMoqaddas();
  List<DropdownMenuItem<Mee3adEl5edma>> _dropdownMenuMee3adEl5edma;
  Mee3adEl5edma _selectedMee3adEl5edma;

 /* //HodoorEgtema3 dropdown
  List<HodoorEgtema3> ListOfHodoorEgtema3 = HodoorEgtema3.getHodoorEgtema3();
  List<DropdownMenuItem<HodoorEgtema3>> _dropdownMenuHodoorEgtema3;
  HodoorEgtema3 _selectedHodoorEgtema3;

  //Hodoor2oddasEgtema3 dropdown
  List<Hodoor2oddasEgtema3> ListOfHodoor2oddasEgtema3 =
      Hodoor2oddasEgtema3.getHodoor2oddasEgtema3();
  List<DropdownMenuItem<Hodoor2oddasEgtema3>> _dropdownMenuHodoor2oddasEgtema3;
  Hodoor2oddasEgtema3 _selectedHodoor2oddasEgtema3;
*/
  Future<List> getAllStudents()async{
    tempData = [];
    for(var khadem in widget.listOfClasses){
      await users.doc('Ma5domeen').collection('classes').doc(khadem).collection('class').get().then((value) {
        value.docs.forEach((element) {
          tempData.add(element.data());
        });
      });

    }

    return tempData;
  }

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero, ()
      {
        getNumberOfDays();
        switchPicker();
        _pickerOpen ^= true;

      });

    });


    //Hodoor 2oddassat dropdown
    _dropdownMenuHodoor2odassat =
        buildDropdownMenuItemsHodoor2odassat(ListOfHodoor2oddasat);
    _selectedHodoor2odassat = _dropdownMenuHodoor2odassat[0].value;

    _dropdownMenuRa8abat =
        buildDropdownMenuItemsRa8abat(ListOfRa8abat);
    _selectedRa8abat = _dropdownMenuRa8abat[0].value;
    _selectedRa8abat2 = _dropdownMenuRa8abat[0].value;
    _selectedRa8abat3 = _dropdownMenuRa8abat[0].value;
    _selectedRa8abatTarshee7 = _dropdownMenuRa8abat[0].value;

    _dropdownMenue5tebarHay2a =
        buildDropdownMenuItemse5tebarHay2a(ListOfe5tebarHay2a);
    _selectede5tebarHay2a = _dropdownMenue5tebarHay2a[0].value;


    _dropdownMenuMee3adEl5edma =
        buildDropdownMenuItemsMee3adEl5edma(ListOfMee3adEl5edma);
    _selectedMee3adEl5edma = _dropdownMenuMee3adEl5edma[0].value;

    //Na3ama and La2 dropdown
    _dropdownMenuYesOrNo = buildDropdownMenuItemsYesOrNo(ListOfYesOrNo);
    _selectedYesOrNoE3teraf = _dropdownMenuYesOrNo[0].value;
    _selectedYesOrNoMotab3a = _dropdownMenuYesOrNo[0].value;
    _selectedYesOrNoZyara = _dropdownMenuYesOrNo[0].value;
    _selectedYesOrNoTasleemMosab2at = _dropdownMenuYesOrNo[0].value;
    _selectedYesOrNoYe5demfeMargirgis = _dropdownMenuYesOrNo[0].value;
    _selectedYesOrNoMewaf2aMnAbE3teraf = _dropdownMenuYesOrNo[0].value;

    //Ketab Moqaddas dropdown
    _dropdownMenuKetabMoqaddas =
        buildDropdownMenuItemsKetabMoqaddas(ListOfKetabMoqaddas);
    _selectedKetabMoqaddas = _dropdownMenuKetabMoqaddas[0].value;

   /* //HodoorEgtema3 dropdown
    _dropdownMenuHodoorEgtema3 =
        buildDropdownMenuItemsHodoorEgtema3(ListOfHodoorEgtema3);
    _selectedHodoorEgtema3 = _dropdownMenuHodoorEgtema3[0].value;

    //Hodoor2oddasEgtema3 dropdown
    _dropdownMenuHodoor2oddasEgtema3 =
        buildDropdownMenuItemsHodoor2oddasEgtema3(ListOfHodoor2oddasEgtema3);
    _selectedHodoor2oddasEgtema3 = _dropdownMenuHodoor2oddasEgtema3[0].value;*/

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  _onChangeDropdownHodoor2odassat(
      Hodoor2odassat selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedHodoor2odassat = selectedKashafaOrListOfHodoor2oddasat;
    });
  }

  _onChangeDropdownYesOrNoE3teraf(
      YesOrNo selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedYesOrNoE3teraf = selectedKashafaOrListOfHodoor2oddasat;
    });
  }

  _onChangeDropdownYesOrNoMotab3a(
      YesOrNo selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedYesOrNoMotab3a = selectedKashafaOrListOfHodoor2oddasat;
    });
  }

  _onChangeDropdownYesOrNoZyara(YesOrNo selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedYesOrNoZyara = selectedKashafaOrListOfHodoor2oddasat;
    });
  }

  _onChangeDropdownYesOrNoMewaf2aMnAbe3teraf(YesOrNo selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedYesOrNoMewaf2aMnAbE3teraf = selectedKashafaOrListOfHodoor2oddasat;
    });
  }

  _onChangeDropdownYesOrNoTasleemMosab2at(
      YesOrNo selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedYesOrNoTasleemMosab2at = selectedKashafaOrListOfHodoor2oddasat;
    });
  }

 /* _onChangeDropdownHodoorEgtema3(
      HodoorEgtema3 selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedHodoorEgtema3 = selectedKashafaOrListOfHodoor2oddasat;
    });
  }*/

  _onChangeDropdownKetabMoqaddas(
      KetabMoqaddas selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedKetabMoqaddas = selectedKashafaOrListOfHodoor2oddasat;
    });
  }

 /* _onChangeDropdownHodoor2oddasEgtema3(
      Hodoor2oddasEgtema3 selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedHodoor2oddasEgtema3 = selectedKashafaOrListOfHodoor2oddasat;
    });
  }*/

  _onChangeDropdownYe5demfeMargirgis(
      YesOrNo selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedYesOrNoYe5demfeMargirgis = selectedKashafaOrListOfHodoor2oddasat;
    });
  }

  _onChangeDropdownRa8abat(
      Ra8abat selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedRa8abat = selectedKashafaOrListOfHodoor2oddasat;
    });
  }
  _onChangeDropdownRa8abat2(
      Ra8abat selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedRa8abat2 = selectedKashafaOrListOfHodoor2oddasat;
    });
  }
  _onChangeDropdownRa8abat3(
      Ra8abat selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedRa8abat3 = selectedKashafaOrListOfHodoor2oddasat;
    });
  }
  _onChangeDropdownRa8abatTarshee7(
      Ra8abat selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedRa8abatTarshee7 = selectedKashafaOrListOfHodoor2oddasat;
    });
  }

  _onChangeDropdownMee3adEl5edma(
      Mee3adEl5edma selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectedMee3adEl5edma = selectedKashafaOrListOfHodoor2oddasat;
    });
  }

  _onChangeDropdownE5tebarHay2a(
      e5tebarHay2a selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectede5tebarHay2a = selectedKashafaOrListOfHodoor2oddasat;
    });
  }

  List<DropdownMenuItem<Hodoor2odassat>> buildDropdownMenuItemsHodoor2odassat(
      List kashafaOrListOfHodoor2oddasat) {
    List<DropdownMenuItem<Hodoor2odassat>> items = [];
    for (Hodoor2odassat company in kashafaOrListOfHodoor2oddasat) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.choice),
        ),
      );
    }
    return items;
  }


  List<DropdownMenuItem<e5tebarHay2a>> buildDropdownMenuItemse5tebarHay2a(
      List kashafaOrListOfHodoor2oddasat) {
    List<DropdownMenuItem<e5tebarHay2a>> items = [];
    for (e5tebarHay2a company in kashafaOrListOfHodoor2oddasat) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.choice),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Mee3adEl5edma>> buildDropdownMenuItemsMee3adEl5edma(
      List kashafaOrListOfHodoor2oddasat) {
    List<DropdownMenuItem<Mee3adEl5edma>> items = [];
    for (Mee3adEl5edma company in kashafaOrListOfHodoor2oddasat) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.choice),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Ra8abat>> buildDropdownMenuItemsRa8abat(
      List kashafaOrListOfHodoor2oddasat) {
    List<DropdownMenuItem<Ra8abat>> items = [];
    for (Ra8abat company in kashafaOrListOfHodoor2oddasat) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.choice),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<YesOrNo>> buildDropdownMenuItemsYesOrNo(
      List kashafaOrListOfHodoor2oddasat) {
    List<DropdownMenuItem<YesOrNo>> items = [];
    for (YesOrNo company in kashafaOrListOfHodoor2oddasat) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.choice),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<KetabMoqaddas>> buildDropdownMenuItemsKetabMoqaddas(
      List kashafaOrListOfHodoor2oddasat) {
    List<DropdownMenuItem<KetabMoqaddas>> items = [];
    for (KetabMoqaddas company in kashafaOrListOfHodoor2oddasat) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.choice),
        ),
      );
    }
    return items;
  }

  /*List<DropdownMenuItem<HodoorEgtema3>> buildDropdownMenuItemsHodoorEgtema3(
      List kashafaOrListOfHodoor2oddasat) {
    List<DropdownMenuItem<HodoorEgtema3>> items = [];
    for (HodoorEgtema3 company in kashafaOrListOfHodoor2oddasat) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.choice),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Hodoor2oddasEgtema3>>
      buildDropdownMenuItemsHodoor2oddasEgtema3(
          List kashafaOrListOfHodoor2oddasat) {
    List<DropdownMenuItem<Hodoor2oddasEgtema3>> items = [];
    for (Hodoor2oddasEgtema3 company in kashafaOrListOfHodoor2oddasat) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.choice),
        ),
      );
    }
    return items;
  }*/

  void switchPicker() async {
    setState(() {
      _pickerOpen ^= true;
      listOfHodoorElEgtema3Esboo3y = [];
      listOfHodoorElEgtema32oddasEsboo3y = [];
      f4 = false;
      f3 = false;
      f1 = false;
      f2 = false;
    });
  }

  List<Widget> generateRowOfMonths(from, to) {
    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(_pickerYear, i, 1);
      final backgroundColor = dateTime.isAtSameMomentAs(_selectedMonth)
          ? Colors.grey[400]
          : Colors.transparent;
      months.add(
        AnimatedSwitcher(
          duration: kThemeChangeDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: TextButton(
            key: ValueKey(backgroundColor),
            onPressed: () {
              setState(() {
                _selectedMonth = dateTime;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: CircleBorder(),
            ),
            child: Text(
              DateFormat('MMMM').format(dateTime),
            ),
          ),
        ),
      );
    }
    return months;
  }

  List<Widget> generateMonths() {
    return [
      Wrap(
        children: generateRowOfMonths(1, 12),
      ),
    ];
  }

  Future update() async {
    await firestoreInstance.collection("users").get().then((querySnapshot) {
      users.doc('Ma5domeen').collection('classes')
          .doc('admin')
          .collection('class')
          .where("FullName", isEqualTo: widget.recordName)
          .limit(1)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          up(element);
        });
      });
    });
  }

  Future up(QueryDocumentSnapshot x) async {
    var hodoor2oddasat = _selectedHodoor2odassat.choice;
    var e3teraf = _selectedYesOrNoE3teraf.choice;
    var motab3a = _selectedYesOrNoMotab3a.choice;
    var zyara = _selectedYesOrNoZyara.choice;
    var ketab = _selectedKetabMoqaddas.choice;
    var tasleem = _selectedYesOrNoTasleemMosab2at.choice;
    var sefat = sefatGayyedaC.text.toString();
    var sefatmotab3a = sefatTa7takMotab3aC.text.toString();
    var mola7zat = mola7zatO5raC.text.toString();
    var mola7zatBeet = mola7zat3anElBeetC.text.toString();
    var ye5demMargirgis = _selectedYesOrNoYe5demfeMargirgis.choice;
    var tempTotalMosab2at = mosab2at;
    getNumOfDays = await getNumberOfDays();
    await getB4Updating().whenComplete((){
      if(mounted)
      setState(() {
        f1 = false;
        f4 = false;
      });
      var a,b,c,d,e,f;
      if(hodoorZoroofC.text.toString() != '' && hodoorZoroofC.text.toString() != null){
        f = hieghestHodoorEgtema3;
        if(hieghestHodoorEgtema3 == 0 ) hieghestHodoorEgtema3 = 1;

        a = (((totalHodoorEgtema3 + int.parse(hodoorZoroofC.text.toString()))/countNumOfDays)*100).toStringAsFixed(2);
        b = (((totalHodoorEgtema32oddas+totalHodoorEgtema3)/countNumOfDays)*100).toStringAsFixed(2);
        c = (((totalHodoorEgtema3 + int.parse(hodoorZoroofC.text.toString()))/hieghestHodoorEgtema3)*100).toStringAsFixed(2);
        d = (((totalHodoorEgtema32oddas+totalHodoorEgtema3)/hieghestHodoorEgtema3)*100).toStringAsFixed(2);
        e = countNumOfDays ;

        if(f < totalHodoorEgtema3 + int.parse(hodoorZoroofC.text.toString())){
          f = totalHodoorEgtema3 + int.parse(hodoorZoroofC.text.toString());
        }
        totalHodoorEgtema3+=int.parse(hodoorZoroofC.text.toString());
      }else{
         f = hieghestHodoorEgtema3;
        if(hieghestHodoorEgtema3 == 0)hieghestHodoorEgtema3 = 1;
         a = ((totalHodoorEgtema3/countNumOfDays)*100).toStringAsFixed(2);
        b = (((totalHodoorEgtema32oddas+totalHodoorEgtema3)/countNumOfDays)*100).toStringAsFixed(2);
            c = ((totalHodoorEgtema3/hieghestHodoorEgtema3)*100).toStringAsFixed(2);
            d = (((totalHodoorEgtema32oddas+totalHodoorEgtema3)/hieghestHodoorEgtema3)*100).toStringAsFixed(2);
            e = countNumOfDays ;

      }

      DocumentReference docRef = users.doc('Ma5domeen').collection('classes')
          .doc('admin')
          .collection('class')
          .doc(x.id);
      print('r: ${_selectedRa8abat.choice} - RT: ${_selectedRa8abatTarshee7.choice} - a5er : ${a5erEl3amC.text.toString()}');

      docRef.set({
        'SefatGayyeda' : sefat,
        'SefatMotab3a' : sefatmotab3a,
        'Mola7zatO5ra' : mola7zat,
        'Mola7zatBeet' : mola7zatBeet,
        'Ye5demFeMargirgis' : ye5demMargirgis,
        'emte7anNos3am2' : double.tryParse(nos3amC.text),
        'kenisaO5ra' : KenisaO5raC.text.toString(),
        'ebtyWeAl7an2' : ebtyWeAl7anC.text.toString(),
        'a5erEl3am2' : double.tryParse(a5erEl3amC.text),
        'mo2tamar2' : mo2tamarC.text.toString(),
        'shafawy2' : shafawyC.text.toString(),
        'ra8ba1' : _selectedRa8abat.choice,
        'ra8ba2' : _selectedRa8abat2.choice,
        'ra8ba3' : _selectedRa8abat3.choice,
        'ra8baO5ra1' : ra8batO5ra1C.text,
        'ra8baO5ra2' : ra8batO5ra2C.text,
        'ra8baO5ra3' : ra8batO5ra3C.text,
        'khademRa8batO5ra' : khademRa8batO5raC.text,
        'mee3ad5edmaA5r' : mee3adKhademRa8batO5raC.text,
        'ra8baTarshee7' : _selectedRa8abatTarshee7.choice,
        'mee3ad5edma' : _selectedMee3adEl5edma.choice,
        'e5tebarHay2a' : _selectede5tebarHay2a.choice,
        'Mewaf2aMnAbE3teraf' : _selectedYesOrNoMewaf2aMnAbE3teraf.choice,
        'totalMosab2at2' : tempTotalMosab2at,
        'totalHodoorEgtema3' : totalHodoorEgtema3,
        'totalHodoor2oddasEgtema3' : totalHodoorEgtema32oddas,
        'hodoorToDaysCount' : a,
        'hodoor2oddasToDaysCount': b,
        'hodoorToHighest' : c,
        'hodoor2oddasToHighest': d,
        'countDays' : e,
        'HieghestHodoor': f

      },SetOptions(merge: true));

      var month = DateFormat.MMMM().format(_selectedMonth);
      docRef.set(
        {
          'Dates': {
            '$_pickerYear': {
              '$month': {
                'hodoor2oddasat': hodoor2oddasat,
                'e3terafWeErshad': e3teraf,
                'motab3aTelephoneyya': motab3a,
                'zyaraManzeleyya': zyara,
                'ketabMoqaddas': ketab,
                'tasleemMosab2at': tasleem,

              }
            }
          }
        },
        SetOptions(merge: true),
      );
      if(mounted){
        setState(() {
          _selectedHodoor2odassat = _dropdownMenuHodoor2odassat[0].value;
          _selectedYesOrNoE3teraf = _dropdownMenuYesOrNo[0].value;
          _selectedYesOrNoMotab3a = _dropdownMenuYesOrNo[0].value;
          _selectedYesOrNoZyara = _dropdownMenuYesOrNo[0].value;
          _selectedYesOrNoTasleemMosab2at = _dropdownMenuYesOrNo[0].value;
          _selectedKetabMoqaddas = _dropdownMenuKetabMoqaddas[0].value;
          listOfHodoorElEgtema3Esboo3y = [];
          listOfHodoorElEgtema32oddasEsboo3y = [];
          f4 = false;
          f3 = false;
          f1 = false;
          f2 = false;
        });
      }
    });

  }




  Future update3() async {
    await firestoreInstance.collection("users").get().then((querySnapshot) {
      users.doc('Ma5domeen').collection('classes')
          .doc('admin')
          .collection('class')
          .where("FullName", isEqualTo: widget.recordName)
          .limit(1)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          up3(element);
        });
      });
    });
  }

  Future up3(QueryDocumentSnapshot x) async {
    getNumOfDays = await getNumberOfDays();
    await getB4Updating();
    setState(() {
      f1 = false;
      f4 = false;
    });
    var  f = hieghestHodoorEgtema3;
    if(hieghestHodoorEgtema3 == 0 )hieghestHodoorEgtema3 = 1;
    var a = (((totalHodoorEgtema3+int.parse(hodoorZoroofC.text.toString())) /countNumOfDays)*100).toStringAsFixed(2),
        c = (((totalHodoorEgtema3+ int.parse(hodoorZoroofC.text.toString()))/hieghestHodoorEgtema3)*100).toStringAsFixed(2),
        e = countNumOfDays;

    if(f < (totalHodoorEgtema3 + int.parse(hodoorZoroofC.text.toString()))){
      f = (totalHodoorEgtema3 + int.parse(hodoorZoroofC.text.toString()));
      UpdateHighestScore();
    }

    DocumentReference docRef = users.doc('Ma5domeen').collection('classes')
        .doc('admin')
        .collection('class')
        .doc(x.id);

    docRef.set({
      'totalHodoorEgtema3' : totalHodoorEgtema3,
      'hodoorToDaysCount' : a,
      'hodoorToHighest' : c,
      'countDays' : e,
      'HieghestHodoor': f

    },SetOptions(merge: true));

    if(mounted){
      setState(() {
        _selectedHodoor2odassat = _dropdownMenuHodoor2odassat[0].value;
        _selectedYesOrNoE3teraf = _dropdownMenuYesOrNo[0].value;
        _selectedYesOrNoMotab3a = _dropdownMenuYesOrNo[0].value;
        _selectedYesOrNoZyara = _dropdownMenuYesOrNo[0].value;
        _selectedYesOrNoTasleemMosab2at = _dropdownMenuYesOrNo[0].value;
        _selectedKetabMoqaddas = _dropdownMenuKetabMoqaddas[0].value;
        listOfHodoorElEgtema3Esboo3y = [];
        listOfHodoorElEgtema32oddasEsboo3y = [];
        f4 = false;
        f3 = false;
        f1 = false;
        f2 = false;
      });
    }
  }




  Future getNumberOfDays() async{
    return users.doc('HodoorCount').get().then((value) {
      if(mounted)
      setState(() {
        if(value.data().values != null || value.data().values.isNotEmpty)
        countNumOfDays = double.parse(value.data()['NumOfDays'].toString());
      });
    });
  }



  Future getHighest()async{
    for(var x in widget.listOfClasses){
      await users.doc('Ma5domeen').collection('classes').doc(x).collection('class').get().then((value){
        value.docs.forEach((element) {
          if(mounted){
            setState(() {
                  hieghestHodoorEgtema3 = element.data()['HieghestHodoor'];
            });
          }

        });
      });
    }
  }

  Future getB4Updating()async{
      await users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').where("FullName", isEqualTo: widget.recordName)
          .limit(1)
          .get().then((value){
        value.docs.forEach((element) {
          updateF4(element);

        });
      });

  }
  void updateF4(var element){
    listOfHodoorElEgtema3Esboo3y = [];
    listOfHodoorElEgtema32oddasEsboo3y = [];
    if(element.data().containsKey('Dates')){
      Map<String, dynamic> x = Map<String, dynamic>.from(element.data()['Dates']);
      x.forEach((Year, value) {
        Map<String, dynamic> y = Map<String, dynamic>.from(x[Year]);
        for(var val in y.entries){
          var month = val.key;
          if (value[month]['hodoorEgtema3'].toString().isNotEmpty){
            listOfHodoorElEgtema3Esboo3y.add(double.tryParse(value[month]['hodoorEgtema3'].toString()??0.0)??0.0);
            print('eh el 5ara da : ${double.tryParse(value[month]['hodoorEgtema3'].toString()??0.0)??0.0} - $month');

          }
          if (value[month]['hodoor2oddas5edma'].toString().isNotEmpty)
            listOfHodoorElEgtema32oddasEsboo3y.add(double.tryParse(value[month]['hodoor2oddas5edma'].toString()??0.0)??0.0);

        }
      });
      if(mounted)
      setState(() {
        double temp = 0.0;
        for(var element in listOfHodoorElEgtema3Esboo3y){
          temp += element;
        }
        totalHodoorEgtema3 = temp;
        print('fT: $totalHodoorEgtema3');

        double temp2 = 0.0;
        for(var element in listOfHodoorElEgtema32oddasEsboo3y){
          temp2 = temp2 + element;
        }

          totalHodoorEgtema32oddas = temp2;


        print('fTT: $totalHodoorEgtema32oddas');
        f4 = true;
      });

    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(

          centerTitle: true,
          title: Text(
            'إختار الشهر و السنة',
            style: TextStyle(fontSize: 22),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Theme.of(context).cardColor,
                child: AnimatedSize(
                  curve: Curves.easeInOut,
                  vsync: this,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    height: _pickerOpen ? null : 0.0,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _pickerYear = _pickerYear - 1;
                                });
                              },
                              icon: Icon(Icons.navigate_before_rounded),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  _pickerYear.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _pickerYear = _pickerYear + 1;
                                });
                              },
                              icon: Icon(Icons.navigate_next_rounded),
                            ),
                          ],
                        ),
                        ...generateMonths(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(DateFormat.yMMMM().format(_selectedMonth)),
              ElevatedButton(
                onPressed: switchPicker,
                child: Text(
                  'Select date',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: users.doc('Ma5domeen').collection('classes')
                    .doc('admin')
                    .collection('class').where('FullName', isEqualTo: widget.recordName).snapshots(),
                  builder: (context , AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData)return Center(child: CircularProgressIndicator());
                  WidgetsBinding.instance.addPostFrameCallback((_){
                    snapshot.data.docs.forEach((element) {

                      if(!f1) {
                        var temp = 0.0;
                        hieghestHodoorEgtema3 = 0.0;
                        temp = 0;
                        if(element.data().containsKey('Dates')){
                          Map<String, dynamic> x = Map<String, dynamic>.from(element.data()['Dates']);
                          x.forEach((Year, value) {
                            Map<String, dynamic> y = Map<String, dynamic>.from(x[Year]);
                            for(var val in y.entries){
                              var month = val.key;
                              if (value[month]['hodoorEgtema3'].toString().isNotEmpty) {
                                temp += double.tryParse(value[month]['hodoorEgtema3'].toString()??0.0)??0.0;
                              }
                              if (value[month]['hodoor2oddas5edma'].toString().isNotEmpty) {
                                temp += double.tryParse(value[month]['hodoor2oddas5edma'].toString()??0.0)??0.0;
                              }
                              print('temp : $temp');
                              if (hieghestHodoorEgtema3 < temp){
                                setState(() {
                                  hieghestHodoorEgtema3 = temp;
                                });
                              }
                            }


                          });

                        }
                        f1 = true;
                      }
                      if(!f3 ){

                        if(!f2){
                          var temp =0;
                          mosab2at = 0;
                          if(element.data().containsKey('Dates')) {
                            temp = 0;
                            Map<String, dynamic> x = Map<String, dynamic>.from(element.data()['Dates']);
                            x.forEach((Year, value) {
                              Map<String, dynamic> y = Map<String, dynamic>.from(x[Year]);
                              for(var val in y.entries){
                                var month = val.key;
                                _dropdownMenuYesOrNo.forEach((e) {
                                  if (value[month]['tasleemMosab2at'].toString() == e.value.choice) {
                                    if (value[month]['tasleemMosab2at'].toString() == 'نعم') {
                                      temp += 1;
                                    }
                                  }
                                });
                              }

                            });

                            setState(() {
                              mosab2at = temp;
                              mosab2atC.text = mosab2at.toString();
                            });
                          }
                          f2 = true;
                        }



                          sefat = element.data()['SefatGayyeda'];
                          sefatmotab3a = element.data()['SefatMotab3a'];
                          mola7zat = element.data()['Mola7zatO5ra'];
                          mola7zatBeet = element.data()['Mola7zatBeet'];
                          setState(() {
                            sefatGayyedaC.text = sefat;
                            sefatTa7takMotab3aC.text = sefatmotab3a;
                            mola7zatO5raC.text = mola7zat;
                            mola7zat3anElBeetC.text = mola7zatBeet;
                            KenisaO5raC.text = element.data()['kenisaO5ra'];
                            nos3amC0.text = element.data()['emte7anNos3am'];
                            ebtyWeAl7anC0.text = element.data()['ebtyWeAl7an'];
                            a5erEl3amC0.text = element.data()['a5erEl3am'];
                            mo2tamarC0.text = element.data()['mo2tamar'];
                            shafawyC0.text = element.data()['shafawy'];
                            nos3amC.text = element.data()['emte7anNos3am2'];
                            ebtyWeAl7anC.text = element.data()['ebtyWeAl7an2'];
                            a5erEl3amC.text = element.data()['a5erEl3am2'].toString();
                            mo2tamarC.text = element.data()['mo2tamar2'];
                            shafawyC.text = element.data()['shafawy2'];
                            _dropdownMenuYesOrNo.forEach((e) {
                              if (element.get('Ye5demFeMargirgis').toString() ==
                                  e.value.choice)
                                _selectedYesOrNoYe5demfeMargirgis =
                                    _dropdownMenuYesOrNo[e.value.id].value;
                            });
                            _dropdownMenuRa8abat.forEach((e) {
                              if (element['ra8ba1'].toString() ==
                                  e.value.choice)
                                _selectedRa8abat =
                                    _dropdownMenuRa8abat[e.value.id].value;
                            });
                            _dropdownMenuRa8abat.forEach((e) {
                              if (element['ra8ba2'].toString() ==
                                  e.value.choice)
                                _selectedRa8abat2 =
                                    _dropdownMenuRa8abat[e.value.id].value;
                            });
                            _dropdownMenuRa8abat.forEach((e) {
                              if (element['ra8ba3'].toString() ==
                                  e.value.choice)
                                _selectedRa8abat3 =
                                    _dropdownMenuRa8abat[e.value.id].value;
                            });
                            _dropdownMenuRa8abat.forEach((e) {
                              if (element['ra8baTarshee7'].toString() ==
                                  e.value.choice)
                                _selectedRa8abatTarshee7 =
                                    _dropdownMenuRa8abat[e.value.id].value;
                            });

                            _dropdownMenuMee3adEl5edma.forEach((e) {
                              if (element['mee3ad5edma'].toString() ==
                                  e.value.choice)
                                _selectedMee3adEl5edma =
                                    _dropdownMenuMee3adEl5edma[e.value.id].value;
                            });

                            _dropdownMenue5tebarHay2a.forEach((e) {
                              if (element['e5tebarHay2a'].toString() ==
                                  e.value.choice)
                                _selectede5tebarHay2a =
                                    _dropdownMenue5tebarHay2a[e.value.id].value;
                            });

                            _dropdownMenue5tebarHay2a.forEach((e) {
                              if (element['Mewaf2aMnAbE3teraf'].toString() ==
                                  e.value.choice)
                                _selectedYesOrNoMewaf2aMnAbE3teraf =
                                    _dropdownMenuYesOrNo[e.value.id].value;
                            });
                            ra8batO5ra1C.text = element.data()['ra8baO5ra1'];
                            ra8batO5ra2C.text = element.data()['ra8baO5ra2'];
                            ra8batO5ra3C.text = element.data()['ra8baO5ra3'];
                            khademRa8batO5raC.text = element.data()['khademRa8batO5ra'];
                            mee3adKhademRa8batO5raC.text = element.data()['mee3ad5edmaA5r'];

                          });
                          if(element.data().containsKey('Dates')){
                            Map<String, dynamic> x = Map<String, dynamic>.from(element.data()['Dates']);
                            x.forEach((Year, value) {
                              Map<String, dynamic> y = Map<String, dynamic>.from(x[Year]);
                              for(var val in y.entries){
                              var month = val.key;
                                if (value[month]['hodoorEgtema3'].toString().isNotEmpty)
                                  listOfHodoorElEgtema3Esboo3y.add(double.tryParse(value[month]['hodoorEgtema3'].toString()??0.0)??0.0);
                                if (value[month]['hodoor2oddas5edma'].toString().isNotEmpty)
                                  listOfHodoorElEgtema32oddasEsboo3y.add(double.tryParse(value[month]['hodoor2oddas5edma'].toString()??0.0)??0.0);

                              }
                            });

                          }

                          if(!f4){
                            updateF4(element);
                          }



                          bool getOut = false,getIn = false;
                          if(element.data()['Dates'].toString() != '' && element.data().containsKey('Dates')){
                            Map<String, dynamic> x = Map<String, dynamic>.from(element.data()['Dates']);

                            if(!getOut){
                              x.forEach((Year, value) {
                                Map<String, dynamic> y = Map<String, dynamic>.from(x[Year]);
                                for(var val in y.entries){
                                var month = val.key;
                                    setState(() {
                                      if (month == DateFormat.MMMM().format(_selectedMonth) && int.parse(Year) == _pickerYear) {
                                        for(var element in _dropdownMenuHodoor2odassat){
                                          if (value[month]['hodoor2oddasat'].toString() == element.value.choice){
                                            _selectedHodoor2odassat =
                                                _dropdownMenuHodoor2odassat[element.value.id].value;
                                            break;
                                          }
                                          else
                                            _selectedHodoor2odassat =
                                                _dropdownMenuHodoor2odassat[0].value;
                                        }


                                        for(var element in _dropdownMenuYesOrNo){
                                          if (value[month]['e3terafWeErshad'].toString() == element.value.choice){
                                            _selectedYesOrNoE3teraf =
                                                _dropdownMenuYesOrNo[element.value.id].value;
                                            break;
                                          }
                                          else _selectedYesOrNoE3teraf =
                                              _dropdownMenuYesOrNo[0].value;
                                        }

                                        for(var element in _dropdownMenuYesOrNo){
                                          if (value[month]['motab3aTelephoneyya'].toString() == element.value.choice){
                                            _selectedYesOrNoMotab3a =
                                                _dropdownMenuYesOrNo[element.value.id].value;
                                            break;
                                          }
                                          else _selectedYesOrNoMotab3a =
                                              _dropdownMenuYesOrNo[0].value;
                                        }
                                        for(var element in _dropdownMenuYesOrNo){
                                          if (value[month]['zyaraManzeleyya'].toString() == element.value.choice){
                                            _selectedYesOrNoZyara =
                                                _dropdownMenuYesOrNo[element.value.id].value;
                                            break;
                                          }
                                          else _selectedYesOrNoZyara =
                                              _dropdownMenuYesOrNo[0].value;
                                        }

                                        for(var element in _dropdownMenuYesOrNo){
                                          if (value[month]['tasleemMosab2at'].toString() == element.value.choice){
                                            _selectedYesOrNoTasleemMosab2at =
                                                _dropdownMenuYesOrNo[element.value.id].value;
                                            break;
                                          }
                                          else _selectedYesOrNoTasleemMosab2at =
                                              _dropdownMenuYesOrNo[0].value;
                                        }



                                        for(var element in _dropdownMenuKetabMoqaddas){
                                          if (value[month]['ketabMoqaddas'].toString() == element.value.choice){
                                            _selectedKetabMoqaddas =
                                                _dropdownMenuKetabMoqaddas[element.value.id].value;
                                            break;
                                          }
                                          else _selectedKetabMoqaddas =
                                              _dropdownMenuKetabMoqaddas[0].value;
                                        }



                                       /* for(var element in _dropdownMenuHodoorEgtema3 ){
                                          if (element.value.choice.contains(value[month]['hodoorEgtema3'].toString())) {
                                            _selectedHodoorEgtema3 = _dropdownMenuHodoorEgtema3[element.value.id].value;
                                            break;
                                          }
                                          else _selectedHodoorEgtema3 =
                                              _dropdownMenuHodoorEgtema3[0].value;
                                        }

                                        for(var element in _dropdownMenuHodoor2oddasEgtema3){
                                          if (element.value.choice.contains(value[month]['hodoor2oddas5edma'].toString())){
                                            _selectedHodoor2oddasEgtema3 = _dropdownMenuHodoor2oddasEgtema3[element.value.id].value;
                                            break;
                                          }
                                          else _selectedHodoor2oddasEgtema3 =
                                              _dropdownMenuHodoor2oddasEgtema3[0].value;
                                        }*/

                                        getOut = true;
                                        getIn = true;
                                      }

                                    });

                                }
                              });

                            }if(!getIn){
                              _selectedHodoor2odassat = _dropdownMenuHodoor2odassat[0].value;
                              _selectedYesOrNoE3teraf = _dropdownMenuYesOrNo[0].value;
                              _selectedYesOrNoMotab3a = _dropdownMenuYesOrNo[0].value;
                              _selectedYesOrNoZyara = _dropdownMenuYesOrNo[0].value;
                              _selectedYesOrNoTasleemMosab2at = _dropdownMenuYesOrNo[0].value;
                              _selectedKetabMoqaddas = _dropdownMenuKetabMoqaddas[0].value;
                            }
                          }

                        f3 = true;
                      }

                    });
                  });

                  return Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'حضور القداسات',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                child: Expanded(
                                  child: DropdownButton(
                                    value: _selectedHodoor2odassat,
                                    items: _dropdownMenuHodoor2odassat,
                                    onChanged: _onChangeDropdownHodoor2odassat,
                                    style: TextStyle(
                                        color: Colors.blueAccent, fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('إعتراف و إرشاد',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                child: DropdownButton(
                                  value: _selectedYesOrNoE3teraf,
                                  items: _dropdownMenuYesOrNo,
                                  onChanged: _onChangeDropdownYesOrNoE3teraf,
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('متابعة تليفونية',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                child: DropdownButton(
                                  value: _selectedYesOrNoMotab3a,
                                  items: _dropdownMenuYesOrNo,
                                  onChanged: _onChangeDropdownYesOrNoMotab3a,
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('زيارة منزلية',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                child: DropdownButton(
                                  value: _selectedYesOrNoZyara,
                                  items: _dropdownMenuYesOrNo,
                                  onChanged: _onChangeDropdownYesOrNoZyara,
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('كتاب مقدس',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                child: DropdownButton(
                                  value: _selectedKetabMoqaddas,
                                  items: _dropdownMenuKetabMoqaddas,
                                  onChanged: _onChangeDropdownKetabMoqaddas,
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('تسليم مسابقات',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                child: DropdownButton(
                                  value: _selectedYesOrNoTasleemMosab2at,
                                  items: _dropdownMenuYesOrNo,
                                  onChanged: _onChangeDropdownYesOrNoTasleemMosab2at,
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          /*SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('إحتساب حضور لظروف',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  maxLines: null,
                                  textAlign: TextAlign.right,
                                  controller: hodoorZoroofC,
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'إضافة حضور لظروف',
                                    labelStyle: TextStyle(color: Colors.black),
                                    hintText: 'يرجي إدخال رقم'

                                  ),
                                ),
                              ),
                            ],
                          ),*/
                          SizedBox(height: 15),
                          GestureDetector(
                            onLongPress: (){
                              setState(() {

                                e1 = !e1;
                              });
                            },
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlign: TextAlign.right,
                              controller: sefatGayyedaC,
                              enabled: e1,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'صفات جيدة',

                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          GestureDetector(
                            onLongPress: (){
                              setState(() {
                                e2 = !e2;
                              });
                            },
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlign: TextAlign.right,
                              enabled: e2,
                              controller: sefatTa7takMotab3aC,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'صفات تحتاج متابعة'
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          GestureDetector(
                            onLongPress: (){
                              setState(() {
                                e3 = !e3;
                              });
                            },
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlign: TextAlign.right,
                              enabled: e3,
                              controller: mola7zatO5raC,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'ملاحظات اخري',
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          GestureDetector(
                            onLongPress: (){
                              e4 = !e4;
                            },
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlign: TextAlign.right,
                              enabled: e4,
                              controller: mola7zat3anElBeetC,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'ملاحظات عن حالة البيت و الاهل',
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('إقتراحات خاصة بنوع الخدمة التي سيتم الإلتحاق بها',
                                      style: TextStyle(
                                          fontSize: 18,
                                          decoration: TextDecoration.underline,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),

                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [ Text('يخدم في كنيسة مارجرجس هليوبوليس',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                              Expanded(
                                child: DropdownButton(
                                  value: _selectedYesOrNoYe5demfeMargirgis,
                                  items: _dropdownMenuYesOrNo,
                                  onChanged: _onChangeDropdownYe5demfeMargirgis,
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 18),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 15),
                          GestureDetector(
                            onLongPress: (){
                              setState(() {
                                e5 =! e5;
                              });
                            },
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlign: TextAlign.right,
                              enabled: e5,
                              controller: KenisaO5raC,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'كنيسة اخري',
                              ),
                            ),
                          ),


                          SizedBox(height: 15),
                          Row(
                            children: [ Text('رغبات المخدوم        ',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [ Text('1: ',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                      DropdownButton(
                                        value: _selectedRa8abat,
                                        items: _dropdownMenuRa8abat,
                                        onChanged: _onChangeDropdownRa8abat,
                                        style: TextStyle(
                                            color: Colors.blueAccent, fontSize: 18),
                                      ),

                                      (_selectedRa8abat.choice == 'اخري')?Padding(
                                        padding: const EdgeInsets.only(right: 15.0),
                                        child: Container(
                                          width: 150,
                                          child: TextFormField(
                                            controller: ra8batO5ra1C,
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'رغبة اخري',
                                            ),
                                          ),),
                                      ):Container(),
                                    ],
                                  ),
                                  Row(
                                    children: [Text('2: ',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                      DropdownButton(
                                        value: _selectedRa8abat2,
                                        items: _dropdownMenuRa8abat,
                                        onChanged: _onChangeDropdownRa8abat2,
                                        style: TextStyle(
                                            color: Colors.blueAccent, fontSize: 18),
                                      ),
                                      (_selectedRa8abat2.choice == 'اخري')?Padding(
                                        padding: const EdgeInsets.only(right: 15.0),
                                        child: Container(
                                          width: 150,
                                          child: TextFormField(
                                            controller: ra8batO5ra2C,
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'رغبة اخري',
                                            ),
                                          ),),
                                      ):Container(),

                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('3: ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)), DropdownButton(
                                        value: _selectedRa8abat3,
                                        items: _dropdownMenuRa8abat,
                                        onChanged: _onChangeDropdownRa8abat3,
                                        style: TextStyle(
                                            color: Colors.blueAccent, fontSize: 18),
                                      ),

                                      (_selectedRa8abat3.choice == 'اخري')?Padding(
                                        padding: const EdgeInsets.only(right: 15.0),
                                        child: Container(
                                          width: 150,
                                          child: TextFormField(
                                            controller: ra8batO5ra3C,
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'رغبة اخري',
                                            ),
                                          ),),
                                      ):Container(),
                                    ],
                                  )
                                ],
                              )

                            ],
                          ),


                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [ Text('رأي الخادم',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 35.0),
                                        child: Text('تربية كنسية ',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      DropdownButton(
                                        value: _selectedRa8abatTarshee7,
                                        items: _dropdownMenuRa8abat,
                                        onChanged: _onChangeDropdownRa8abatTarshee7,
                                        style: TextStyle(
                                            color: Colors.blueAccent, fontSize: 18),
                                      ),
                                      (_selectedRa8abatTarshee7.choice == 'اخري')?Padding(
                                        padding: const EdgeInsets.only(right: 15.0),
                                        child: Container(
                                          width: 150,
                                          child: TextFormField(
                                            controller: khademRa8batO5raC,
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'رغبة اخري',
                                            ),
                                          ),),
                                      ):Container(),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 35.0),
                                        child: Text('ميعاد الخدمة',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      DropdownButton(
                                        value: _selectedMee3adEl5edma,
                                        items: _dropdownMenuMee3adEl5edma,
                                        onChanged: _onChangeDropdownMee3adEl5edma,
                                        style: TextStyle(
                                            color: Colors.blueAccent, fontSize: 18),
                                      ),
                                      (_selectedMee3adEl5edma.choice == 'اخري')?Padding(
                                        padding: const EdgeInsets.only(right: 87.0,top: 15.0),
                                        child: Container(
                                          width: 150,
                                          child: TextFormField(
                                            controller: mee3adKhademRa8batO5raC,
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'ميعاد الخدمة',
                                            ),
                                          ),),
                                      ):Container(),
                                    ],
                                  )

                                ],
                              )

                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [ Text('تم إحضار موافقة من أب الاعتراف',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      DropdownButton(
                                        value: _selectedYesOrNoMewaf2aMnAbE3teraf,
                                        items: _dropdownMenuYesOrNo,
                                        onChanged: _onChangeDropdownYesOrNoMewaf2aMnAbe3teraf,
                                        style: TextStyle(
                                            color: Colors.blueAccent, fontSize: 18),
                                      ),
                                    ],
                                  )

                                ],
                              )

                            ],
                          ),


                          SizedBox(height: 15),
                          Row(
                            children: [ Text('اختبار الهيئة(خاص بالاباء الكهنة فقط)',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      DropdownButton(
                                        value: _selectede5tebarHay2a,
                                        items: _dropdownMenue5tebarHay2a,
                                        onChanged: _onChangeDropdownE5tebarHay2a,
                                        style: TextStyle(
                                            color: Colors.blueAccent, fontSize: 18),
                                      ),
                                    ],
                                  )

                                ],
                              )

                            ],
                          ),


                          SizedBox(height: 15),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                          headingRowColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                                          columnSpacing: 20,
                                          headingRowHeight: 30,
                                          columns: [
                                            DataColumn(label: Text('') ),
                                            DataColumn(label: Text('إمتحان نصف العام',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold)) ),
                                            DataColumn(label: Text('مسابقات الكتاب المقدس',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold))),
                                            DataColumn(label: Text('قبطي و الحان',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold))),
                                            DataColumn(label: Text('امتحان اخر العام',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold))),
                                            DataColumn(label: Text('حضور المؤتمر',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold))),
                                            DataColumn(label: Text('امتحان شفوي',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold)))
                                          ],border: TableBorder.all(borderRadius: BorderRadius.all(Radius.circular(6))),
                                          rows: [
                                            DataRow(
                                                cells: [
                                                  DataCell(Text('سنة ١	',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold))),
                                                  DataCell(TextField(
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.grey[400],
                                                      filled: true
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    maxLines: 1,

                                                    textAlign: TextAlign.center,
                                                    readOnly: true,
                                                    enabled: false,
                                                    controller: nos3amC0,
                                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                                  )),
                                                  DataCell(TextField(
                                                    decoration: InputDecoration(
                                                        fillColor: Colors.grey[400],
                                                        filled: true
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    controller: mosab2atC,
                                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                                    readOnly: true,
                                                    enabled: false,
                                                  )),
                                                  DataCell(TextField(
                                                    decoration: InputDecoration(
                                                        fillColor: Colors.grey[400],
                                                        filled: true
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    controller: ebtyWeAl7anC0,
                                                    readOnly: true,
                                                    enabled: false,
                                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                                  )),
                                                  DataCell(TextField(
                                                    decoration: InputDecoration(
                                                        fillColor: Colors.grey[400],
                                                        filled: true
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    controller: a5erEl3amC0,
                                                    readOnly: true,
                                                    enabled: false,
                                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                                  )),
                                                  DataCell(TextField(
                                                    decoration: InputDecoration(
                                                        fillColor: Colors.grey[400],
                                                        filled: true
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    readOnly: true,
                                                    enabled: false,
                                                    controller: mo2tamarC0,
                                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                                  )),
                                                  DataCell(TextField(
                                                    decoration: InputDecoration(
                                                        fillColor: Colors.grey[400],
                                                        filled: true
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    controller: shafawyC0,
                                                    readOnly: true,
                                                    enabled: false,
                                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                                  ),)
                                                ]
                                            )
                                          ]
                                      ),
                                    ),

                                  ]
                              ),
                            ),
                          ),

                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                          headingRowColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                                          headingRowHeight: 30,
                                          columnSpacing: 20,

                                          columns: [
                                            DataColumn(label: Text('') ),
                                            DataColumn(label: Text('إمتحان نصف العام',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold)) ),
                                            DataColumn(label: Text('مسابقات الكتاب المقدس',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold))),
                                            DataColumn(label: Text('قبطي و الحان',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold))),
                                            DataColumn(label: Text('امتحان اخر العام',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold))),
                                            DataColumn(label: Text('حضور المؤتمر',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold))),
                                            DataColumn(label: Text('امتحان شفوي',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold))),
                                          ],border: TableBorder.all(borderRadius: BorderRadius.all(Radius.circular(6))),
                                          rows: [
                                            DataRow(
                                                cells: [
                                                  DataCell(Text('سنة ٢	',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold))),
                                                  DataCell(TextField(
                                                    keyboardType: TextInputType.number,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    controller: nos3amC,
                                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                                  )),
                                                  DataCell(TextField(
                                                    keyboardType: TextInputType.number,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    controller: mosab2atC,
                                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                                    readOnly: true,
                                                  )),
                                                  DataCell(TextField(
                                                    keyboardType: TextInputType.number,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    controller: ebtyWeAl7anC,
                                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                                  )),
                                                  DataCell(TextField(
                                                    keyboardType: TextInputType.number,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    controller: a5erEl3amC,
                                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                                  )),
                                                  DataCell(TextField(
                                                    keyboardType: TextInputType.number,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    controller: mo2tamarC,
                                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                                  )),
                                                  DataCell(TextField(
                                                    keyboardType: TextInputType.number,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    controller: shafawyC,
                                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),

                                                  ),)
                                                ]
                                            )
                                          ]
                                      ),
                                    ),

                                  ]
                              ),
                            ),
                          ),


                        















                          /*

                          SizedBox(height: 15),
                          Container(
                            color: Colors.blue[300],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text('الاجتماع الاسبوعي',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '$totalHodoorEgtema3',
                                      style:
                                      TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Text('اليوم الروحي الشهري',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '$totalHodoorEgtema32oddas',
                                      style:
                                      TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Text('إجمالي الحضور',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${totalHodoorEgtema3 + totalHodoorEgtema32oddas}',
                                      style:
                                      TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    flex: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            color: Colors.blue[300],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text('نسبة حضور المحاضرات',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${((totalHodoorEgtema3/countNumOfDays)*100).toStringAsFixed(2)}%',
                                      style:
                                      TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Text('نسبة الحضور شاملة الايام الروحية',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${(((totalHodoorEgtema32oddas+totalHodoorEgtema3)/countNumOfDays)*100).toStringAsFixed(2)}%',
                                      style:
                                      TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Text('إجمالي المحاضرات و الايام الروحية',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${countNumOfDays}',
                                      style:
                                      TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    flex: 2,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            color: Colors.blue[300],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text('نسبة حضور المحاضرات',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    flex: 3,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${((totalHodoorEgtema3/hieghestHodoorEgtema3)*100).toStringAsFixed(2)}%',
                                      style:
                                      TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Text('نسبة الحضور شاملة الايام الروحية',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    flex: 3,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${(((totalHodoorEgtema32oddas+totalHodoorEgtema3)/hieghestHodoorEgtema3)*100).toStringAsFixed(2)}%',
                                      style:
                                      TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    flex: 3,
                                  ),
                                  Expanded(
                                    child: Text('اعلي نسبة حضور',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${hieghestHodoorEgtema3}',
                                      style:
                                      TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ),
                          )





                          */
                        ],
                      ),
                    ),
                  );

                  }
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () async{
                    applyAllValues = await update().whenComplete(()async{
                      applyNewHighest = await UpdateHighestScore().whenComplete((){
                         Navigator.of(context,rootNavigator: true).pop();
                      /* update2().whenComplete((){
                       });*/

                      });

                    });
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF032847),
                          Color(0xFF3A72C6),
                          Color(0xFF3172AD),
                          Color(0xFF032847),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child:
                        const Text('حفظ البيانات', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future update2() async {

    await getNumberOfDays();
    await getB4Updating();
    await UpdateHighestScore();
    await firestoreInstance.collection("users").get().then((querySnapshot) {
      users.doc('Ma5domeen').collection('classes')
          .doc('admin')
          .collection('class')
          .where("FullName", isEqualTo: widget.recordName)
          .limit(1)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          up2(element);
        });
      });
    });
  }

  Future up2(QueryDocumentSnapshot x) async {
    print('tot: $totalHodoorEgtema3 - 2oddas : $totalHodoorEgtema32oddas\n days : $countNumOfDays\n high : $hieghestHodoorEgtema3\nnumofdays : $countNumOfDays');
    var a,b,c,d,e,f;
    if(hodoorZoroofC.text.toString() != '' && hodoorZoroofC.text.toString() != null){
      f = hieghestHodoorEgtema3;
       if(hieghestHodoorEgtema3 == 0 ) hieghestHodoorEgtema3 = 1;

       a = (((totalHodoorEgtema3 + int.parse(hodoorZoroofC.text.toString()))/countNumOfDays)*100).toStringAsFixed(2);
      b = (((totalHodoorEgtema32oddas+totalHodoorEgtema3)/countNumOfDays)*100).toStringAsFixed(2);
          c = (((totalHodoorEgtema3 + int.parse(hodoorZoroofC.text.toString()))/hieghestHodoorEgtema3)*100).toStringAsFixed(2);
          d = (((totalHodoorEgtema32oddas+totalHodoorEgtema3)/hieghestHodoorEgtema3)*100).toStringAsFixed(2);
          e = countNumOfDays ;

       if(f < totalHodoorEgtema3 + int.parse(hodoorZoroofC.text.toString())){
         f = totalHodoorEgtema3 + int.parse(hodoorZoroofC.text.toString());
       }
      totalHodoorEgtema3+=int.parse(hodoorZoroofC.text.toString());
    }
    else{
      a = (((totalHodoorEgtema3 )/countNumOfDays)*100).toStringAsFixed(2);
      b = (((totalHodoorEgtema32oddas+totalHodoorEgtema3)/countNumOfDays)*100).toStringAsFixed(2);
      c = (((totalHodoorEgtema3)/hieghestHodoorEgtema3)*100).toStringAsFixed(2);
      d = (((totalHodoorEgtema32oddas+totalHodoorEgtema3)/hieghestHodoorEgtema3)*100).toStringAsFixed(2);
      e = countNumOfDays ;
      f = hieghestHodoorEgtema3;
    }

    DocumentReference docRef = users.doc('Ma5domeen').collection('classes')
        .doc('admin')
        .collection('class')
        .doc(x.id);

    docRef.set({
      'totalHodoorEgtema3' : totalHodoorEgtema3,
      'totalHodoor2oddasEgtema3' : totalHodoorEgtema32oddas,
      'hodoorToDaysCount' : a,
      'hodoor2oddasToDaysCount': b,
      'hodoorToHighest' : c,
      'hodoor2oddasToHighest': d,
      'HieghestHodoor': f

    },SetOptions(merge: true));

  }
}

class Hodoor2odassat {
  int id;
  String choice;

  Hodoor2odassat(this.id, this.choice);

  static List<Hodoor2odassat> getHodoor2odassat() {
    return <Hodoor2odassat>[
      Hodoor2odassat(0, ''),
      Hodoor2odassat(1, 'اسبوعياً'),
      Hodoor2odassat(2, 'كل اسبوعين'),
      Hodoor2odassat(3, 'مرة شهرياً'),
      Hodoor2odassat(4, 'لم أحضر')
    ];
  }
}


class e5tebarHay2a {
  int id;
  String choice;

  e5tebarHay2a(this.id, this.choice);

  static List<e5tebarHay2a> gete5tebarHay2a() {
    return <e5tebarHay2a>[
      e5tebarHay2a(0, ''),
      e5tebarHay2a(1, 'لا مانع بالبركة'),
      e5tebarHay2a(2, 'يؤجل نصف عام'),
      e5tebarHay2a(3, 'يتم إستبعادة'),
      e5tebarHay2a(4, 'يؤجل عام'),
      e5tebarHay2a(5, 'اخري'),
    ];
  }
}

class YesOrNo {
  int id;
  String choice;

  YesOrNo(this.id, this.choice);

  static List<YesOrNo> getYesOrNo() {
    return <YesOrNo>[
      YesOrNo(0, ''),
      YesOrNo(1, 'نعم'),
      YesOrNo(2, 'لا'),
    ];
  }
}

class Ra8abat {
  int id;
  String choice;

  Ra8abat(this.id, this.choice);

  static List<Ra8abat> getRa8abat() {
    return <Ra8abat>[
      Ra8abat(0, ''),
      Ra8abat(1, 'ثانوي'),
      Ra8abat(2, 'إعدادي'),
      Ra8abat(3, 'إبتدائي 1-2-3'),
      Ra8abat(4, 'إبتدائي 4-5-6'),
      Ra8abat(5, 'احباء الله'),
      Ra8abat(6, 'عشوائيات'),
      Ra8abat(7, 'وسائل إيضاح'),
      Ra8abat(8, 'خدمة الاوتوبيس'),
      Ra8abat(9, 'اخوة الرب'),
      Ra8abat(10, 'KG'),
      Ra8abat(11, 'اخري'),

    ];
  }
}

class Mee3adEl5edma {
  int id;
  String choice;

  Mee3adEl5edma(this.id, this.choice);

  static List<Mee3adEl5edma> getKetabMoqaddas() {
    return <Mee3adEl5edma>[
      Mee3adEl5edma(0, ''),
      Mee3adEl5edma(1, 'جمعة ص'),
      Mee3adEl5edma(2, 'جمعة م'),
      Mee3adEl5edma(3, 'الأحد م'),
      Mee3adEl5edma(4, 'الاتنين م'),
      Mee3adEl5edma(5, 'اخري'),
    ];
  }
}

class KetabMoqaddas {
  int id;
  String choice;

  KetabMoqaddas(this.id, this.choice);

  static List<KetabMoqaddas> getKetabMoqaddas() {
    return <KetabMoqaddas>[
      KetabMoqaddas(0, ''),
      KetabMoqaddas(1, 'منتظم'),
      KetabMoqaddas(2, 'غير منتطم'),
      KetabMoqaddas(3, 'علي فترات'),
    ];
  }
}

/*class HodoorEgtema3 {
  int id;
  String choice;

  HodoorEgtema3(this.id, this.choice);

  static List<HodoorEgtema3> getHodoorEgtema3() {
    return <HodoorEgtema3>[
      HodoorEgtema3(0, ''),
      HodoorEgtema3(1, '0.0'),
      HodoorEgtema3(2, '0.5'),
      HodoorEgtema3(3, '1.0'),
      HodoorEgtema3(4, '1.5'),
      HodoorEgtema3(5, '2.0'),
      HodoorEgtema3(6, '2.5'),
      HodoorEgtema3(7, '3.0'),
      HodoorEgtema3(8, '3.5'),
      HodoorEgtema3(9, '4.0'),
      HodoorEgtema3(10, '4.5'),
      HodoorEgtema3(11, '5.0'),
      HodoorEgtema3(12, '5.5'),
    ];
  }
}*/

/*class Hodoor2oddasEgtema3 {
  int id;
  String choice;

  Hodoor2oddasEgtema3(this.id, this.choice);

  static List<Hodoor2oddasEgtema3> getHodoor2oddasEgtema3() {
    return <Hodoor2oddasEgtema3>[
      Hodoor2oddasEgtema3(0, ''),
      Hodoor2oddasEgtema3(1, '0'),
      Hodoor2oddasEgtema3(2, '1'),
    ];
  }
}*/
class Ma5doomHighest{
  double hieghestHodoorEgtema3 ;
  Ma5doomHighest({this.hieghestHodoorEgtema3});

}