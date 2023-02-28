import 'dart:async';
import 'package:geocode/geocode.dart';
import 'package:geocoder/geocoder.dart';
import 'package:khedma_app/FirstFiveReport.dart';
import 'Time.dart';
import 'Time2.dart';
import 'sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Students.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'dart:ui' as ui;

class DisplayInformation extends StatefulWidget {
  final Student recordName;
  final String id;
  final List listOfClasses;
  final List listOfMa5domeen;
  const DisplayInformation({this.recordName,this.id,this.listOfClasses,this.listOfMa5domeen});
  DisplayInformationState createState() => DisplayInformationState(recordName,id,listOfClasses,listOfMa5domeen);
}

class DisplayInformationState extends State<DisplayInformation> {
  Student x;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  var listOfHodoorElEgtema3Esboo3y = [];
  var listOfHodoorElEgtema32oddasEsboo3y = [];
  var totalHodoorEgtema3 = 0.0;
  var totalHodoorEgtema32oddas = 0.0;
  var countNumOfDays = 0.0;
  var hieghestHodoorEgtema3 =0.0;
  Future getKhodamOnce;
  Future getImageResized;

  DisplayInformationState(Student s,String id,List listOfClasses,List listOfMa5domeen);
  AlignmentGeometry _alignment = Alignment.topRight;
  AlignmentGeometry _alignmentName = Alignment.topRight;
  AlignmentGeometry _alignmentdivider = Alignment.bottomCenter;
  AlignmentGeometry _alignmentInfo = Alignment.centerRight;
  double opacityLevel = 0.0;
  double opacityLevelImg = 0.0;
  double opacityLevelDivider = 0.0;
  double opacityLevelInfo = 0.0;
  bool enabled = false;
  var phone,address,derasa,sanaDeraseyy,abE3teraf,kenisa,
      telManzel,manteqa,khadem,userName,gehatElDerasa,koleyyaSana,dobDay,dobMonth,dobYear;


  List<SanaDeraseyya> sanaDeraseyya = SanaDeraseyya.getSanaDeraseyya();
  List<DropdownMenuItem<SanaDeraseyya>> _dropdownMenuItems;
  SanaDeraseyya _selectedSanaDeraseyya;

  DateTime newDOB = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: newDOB,
      firstDate: DateTime(1900),
      lastDate: DateTime(2900),
    );
    if (selected != null && selected != newDOB)
      setState(() {
        newDOB = selected;
        dobDay = newDOB.day;
        dobMonth = newDOB.month;
        dobYear = newDOB.year;
      });
  }

  List<DropdownMenuItem<SanaDeraseyya>> buildDropdownMenuItems(List kashafaOrShamas) {
    List<DropdownMenuItem<SanaDeraseyya>> items = List();
    for (SanaDeraseyya company in kashafaOrShamas) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(SanaDeraseyya selectedKashafaOrShamas) {
    setState(() {
      _selectedSanaDeraseyya = selectedKashafaOrShamas;
    });
  }



  void _changeOpacityName() {
    setState(() => opacityLevelImg = opacityLevelImg == 0 ? 1.0 : 0.0);
  }
  void _changeOpacityDivider() {
    setState(() => opacityLevelDivider = opacityLevelDivider == 0 ? 1.0 : 0.0);
  }


  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  void _changeOpacityInfo() {
    setState(() => opacityLevelInfo = opacityLevelInfo == 0 ? 1.0 : 0.0);
  }

  void _changeAlignment() {
    setState(() {
      _alignment = _alignment == Alignment.topRight
          ? Alignment.center
          : Alignment.topRight;
    });
  }

  void _changeAlignmentName() {
    setState(() {
      _alignmentName = _alignmentName == Alignment.topRight
          ? Alignment.center
          : Alignment.topRight;
    });
  }
  void _changeAlignmentDivider() {
    setState(() {
      _alignmentName = _alignmentName == Alignment.bottomCenter
          ? Alignment.topCenter
          : Alignment.bottomCenter;
    });
  }

  void _changeAlignmentInfo() {
    setState(() {
      _alignmentInfo = _alignmentInfo == Alignment.topRight
          ? Alignment.center
          : Alignment.topRight;
    });
  }

  void copyToClipboard(String toClipboard) {
    ClipboardData data = new ClipboardData(text: toClipboard);
    Clipboard.setData(data);
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(duration: Duration(seconds: 1),
      content: new Text(toClipboard + ' copied to clipboard.'),
    ));
  }
  Future getImg;




  String date = "";
  DateTime selectedDate = DateTime.now();
  int day, month, year;

  Future getNumberOfDays() async{
    return users.doc('HodoorCount').get().then((value) {
      setState(() {
        countNumOfDays = value.data()['NumOfDays'];
      });
    });


  }




  @override
  void initState() {
    setDefaultMake = true;
    dobDay = widget.recordName.Day;
    dobMonth = widget.recordName.Month;
    dobYear = widget.recordName.Year;
    koleyyaSana = widget.recordName.elSanaElderaseyya;
    gehatElDerasa = widget.recordName.gehatElDerasa;
    userName = widget.recordName.FullName;
    phone = widget.recordName.StudentPhoneNumber;
    abE3teraf = widget.recordName.abElE3teraf;
    kenisa = widget.recordName.kenistoh;
    telManzel = widget.recordName.telephoneElManzel;
    _3omara = widget.recordName.rakam3omara;
    share3 = widget.recordName.esmElShare3;
    door = widget.recordName.elDoor;
    shaqqa = widget.recordName.rakamShaqqa;
    manteqa = widget.recordName.Manteqa;
    esmElShare3C.text = share3;
    elDoorC.text = door;
    rakamShaqqaC.text = shaqqa;
    rakam3omaraC.text = _3omara;
    manteqaC.text = manteqa;
    khadem = widget.recordName.classNum.split('-').last;
    khademName = khadem;
    getKhodamOnce = getKhodamData();
    _resizeImage(widget.recordName.imgPath);

    _dropdownMenuItems = buildDropdownMenuItems(sanaDeraseyya);
    _selectedSanaDeraseyya = _dropdownMenuItems[0].value;

    _dropdownMenuItems.forEach((e) {
      if (widget.recordName.e3dad5odam3amDerasy.toString() ==
          e.value.name){
          _selectedSanaDeraseyya = _dropdownMenuItems[e.value.id].value;
        print('saddsa ' + _selectedSanaDeraseyya.name);

      }
    });
    Future.delayed(Duration(
      milliseconds: 100,
    )).whenComplete(() {
      _changeOpacityName();
      _changeAlignment();
    });
    Future.delayed(Duration(
      milliseconds: 500,
    )).whenComplete(() {
      _changeOpacity();
      _changeAlignmentName();
      _changeOpacityDivider();
      _changeAlignmentDivider();
    });

    Future.delayed(Duration(
      milliseconds: 800,
    )).whenComplete(() {
      _changeOpacityInfo();
      _changeAlignmentInfo();
    });

    super.initState();
  }

  var khademName ;



  CollectionReference users = FirebaseFirestore.instance.collection('users');
  void update() async {
    await firestoreInstance.collection("users").get().then((querySnapshot) {
      users.doc('Ma5domeen').collection('classes')
          .doc('admin')
          .collection('class')
          .where("FullName", isEqualTo: widget.recordName.FullName)
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
    DocumentReference docRef = users.doc('Ma5domeen').collection('classes')
        .doc('admin')
        .collection('class')
        .doc(x.id);
    print('f shitttttt :  ' + _selectedSanaDeraseyya.name.toString());
    docRef.update({
      'elSanaElderaseyya' : koleyyaSana.toString(),
      'gehatElDerasa' : gehatElDerasa.toString(),
      'FullName' : userName.toString(),
      'e3dad5odam3amDerasy' : _selectedSanaDeraseyya.name.toString(),
      'StudentPhoneNumber' : int.parse(phone.toString()),
      'abElE3teraf' : abE3teraf.toString(),
      'kenistoh' : kenisa.toString(),
      'telephoneElManzel' : int.parse(telManzel.toString()),
      'esmElShare3' : share3,
      'rakam3omara' : (_3omara.toString().isEmpty)?"0":int.parse(_3omara.toString()),
      'elDoor' : (door.toString().isEmpty)?"0":int.parse(door.toString()),
      'rakamShaqqa' : (shaqqa.toString().isEmpty)?"0":int.parse(shaqqa.toString()),
      'Manteqa' : manteqa,
      'ClassNum' : khademName.toString(),
      'BOD' : {
        'Day' : dobDay,
        'Month' : dobMonth,
        'Year' : dobYear
      }

    });


  }
  var setDefaultMake;
  var khodamList = [];

  Future<List> getKhodamData() async {

    await FirebaseFirestore.instance.collection('Khodam').orderBy('Name',descending: false).get().then((value){
      value.docs.forEach((element) {
        khodamList.add(element.data()['Name']);
      });

    });


    return khodamList;
  }


  TextEditingController newInfoC = new TextEditingController();
  TextEditingController esmElShare3C = new TextEditingController();
  TextEditingController rakam3omaraC = new TextEditingController();
  TextEditingController elDoorC = new TextEditingController();
  TextEditingController rakamShaqqaC = new TextEditingController();
  TextEditingController manteqaC = new TextEditingController();
  var share3,_3omara,door,shaqqa;


  void _changeGrade(selectedKhadem) {
    setState(
          () {
            khademName = selectedKhadem;
      },
    );
  }
  StatefulBuilder  showGradDialog(String name){
    return StatefulBuilder(
        builder: (context, _setter){
          return Dialog(
            insetPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              width: MediaQuery.of(context).size.width-100,
              //height: MediaQuery.of(context).size.height-300,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text('$name  الجديد '),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          (name == 'العنوان')?SizedBox(
                            width: MediaQuery.of(context).size.width-150,
                            height: MediaQuery.of(context).size.height-400,
                            child: Column(
                              children: [
                                Expanded(
                                  child: TextFormField(
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
                                ),
                                Expanded(
                                  child: TextFormField(
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
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
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
                                      ),
                                      SizedBox(height: 10,),
                                      Expanded(
                                        child: TextFormField(
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
                                      ),
                                      SizedBox(height: 10,),
                                      Expanded(
                                        child: TextFormField(
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
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ) :
                          (name == 'الخادم')?Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width-140,
                                height: 70,
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius:  const BorderRadius.all(Radius.circular(6))),
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: khademName,
                                      items: khodamList.map((khadem) {
                                        return DropdownMenuItem<String>(
                                          value: khadem,
                                          child: Text('$khadem'),
                                        );

                                      }).toList(),
                                      onChanged: (String _newKhadem) {
                                        _setter(
                                              () {
                                            khademName = _newKhadem;
                                          },
                                        );
                                        _changeGrade(_newKhadem);
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ):Flexible(
                            child: TextFormField(
                              controller: newInfoC,
                              decoration: const InputDecoration(
                                focusColor: Colors.white,
                                fillColor: Colors.black,
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(color: Colors.black),
                              ),

                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration( borderRadius: BorderRadius.circular(3)),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(primary: Colors.red),
                                child: Text('إلغاء'),
                                onPressed: (){
                                  newInfoC.text = '';
                                  esmElShare3C.text = '';
                                  rakamShaqqaC.text = '';
                                  rakam3omaraC.text = '';
                                  elDoorC.text = '';
                                  manteqaC.text = '';
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
                                child: Text('تعديل'),
                                onPressed: (){
                                  if(name == 'الموبايل'){
                                    setState(() {
                                      phone = int.parse(newInfoC.text.toString());
                                    });
                                  }else if(name == 'أب الاعتراف'){
                                    setState(() {
                                      abE3teraf = newInfoC.text.toString();
                                    });
                                  }else if(name == 'كنيسته'){
                                    setState(() {
                                      kenisa = newInfoC.text.toString();
                                    });
                                  }else if(name == 'تليفون المنزل'){
                                    setState(() {
                                      telManzel = newInfoC.text.toString();
                                    });
                                  }else if(name == 'المنطقة'){
                                    manteqa = newInfoC.text.toString();
                                  }else if(name == 'الخادم'){
                                    setState(() {
                                      khadem = khademName;
                                    });
                                  }
                                  else if(name == 'الاسم'){
                                    setState(() {
                                      userName = newInfoC.text.toString();
                                    });
                                  }
                                  else if(name == 'جهة الدراسة'){
                                    setState(() {
                                      gehatElDerasa = newInfoC.text.toString();
                                    });
                                  }
                                  else if(name == 'السنة الدراسية'){
                                    setState(() {
                                      koleyyaSana = newInfoC.text.toString();
                                    });
                                  }
                                  else{
                                    share3 = esmElShare3C.text.toString();
                                    shaqqa = int.parse(rakamShaqqaC.text.toString());
                                    _3omara = int.parse(rakam3omaraC.text.toString());
                                    door = int.parse(elDoorC.text.toString());
                                    manteqa = manteqaC.text.toString();
                                  }
                                  esmElShare3C.text = '';
                                  rakamShaqqaC.text = '';
                                  rakam3omaraC.text = '';
                                  elDoorC.text = '';
                                  newInfoC.text = '';
                                  manteqaC.text = '';
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
              ),
            ),
          );


      }
    );


  }

  Uint8List targetlUinit8List;
  Uint8List originalUnit8List;

  void _resizeImage(String url) async {
    var imageUrl = Uri.parse(url);
    http.Response response = await http.get(imageUrl);
    originalUnit8List = response.bodyBytes;

    ui.Image originalUiImage = await decodeImageFromList(originalUnit8List);
    ByteData originalByteData = await originalUiImage.toByteData();
    print('original image ByteData size is ${originalByteData.lengthInBytes}');

    var codec = await ui.instantiateImageCodec(originalUnit8List,
        targetHeight: 200, targetWidth: 200);
    var frameInfo = await codec.getNextFrame();
    ui.Image targetUiImage = frameInfo.image;

    ByteData targetByteData =
    await targetUiImage.toByteData(format: ui.ImageByteFormat.png);
    print('target image ByteData size is ${targetByteData.lengthInBytes}');
    targetlUinit8List = targetByteData.buffer.asUint8List();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(centerTitle: true,title: Text("بيانات المخدوم",textAlign: TextAlign.center, ),
        actions: <Widget>[
          IconButton(onPressed: (){
            update();
          },
              icon: Icon(Icons.update)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children:[
            Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: AnimatedOpacity(
                      opacity: opacityLevelImg,
                      duration: Duration(
                        milliseconds: 400,
                      ),
                      child: AnimatedAlign(
                        alignment: _alignment,
                        curve: Curves.ease,
                        duration: Duration(milliseconds: 400),
                        child: Container(
                          child:  Container(
                              width: 200,
                              height: 200,
                              child: (targetlUinit8List == null)?CircularProgressIndicator():Image.memory(targetlUinit8List)
                          ),
                          margin: EdgeInsets.only(top: 30, bottom: 10),
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: opacityLevel,
                    duration: Duration(
                      milliseconds: 300,
                    ),
                    child: AnimatedAlign(
                      alignment: _alignmentName,
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 300),
                      child: GestureDetector(
                        onLongPress: (){
                          showDialog(
                              context: context,
                              builder: (context) =>showGradDialog('الاسم')
                          );
                        },
                        child: Container(
                          child: Text(
                            '${userName}',
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                      opacity: opacityLevelDivider,
                      duration: Duration(
                        milliseconds: 300,
                      ),
                      child: AnimatedAlign(
                        alignment: _alignmentdivider,
                        curve: Curves.ease,
                        duration: Duration(milliseconds: 300),
                        child: Divider(
                          height: 5,
                          indent: 1.2,
                          color: Colors.black,
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  AnimatedOpacity(
                    opacity: opacityLevelInfo,
                    duration: Duration(
                      milliseconds: 500,
                    ),
                    child: AnimatedAlign(
                      alignment: _alignmentInfo,
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 500),
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onLongPress: (){
                              showDialog(
                                  context: context,
                                  builder: (context) =>showGradDialog('الموبايل')
                              );

                            },
                            onTap:(){
                              var contactPhoneNumber = widget.recordName.StudentPhoneNumber.toString();
                              launch("tel://0$contactPhoneNumber");
                            } ,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0,8.0,15.0,8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child:IconButton(icon: Image.asset('assets/call_img.png'),),
                                  ),
                                  Text('الموبايل:  ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                  InkWell(
                                      child: Text('0${phone.toString()}',style: TextStyle(fontSize: 18,color: Colors.indigoAccent),)
                                  ),

                                ],),
                            ),
                          ),
                          GestureDetector(
                            onLongPress: (){
                              showDialog(
                                  context: context,
                                  builder: (context) =>showGradDialog('تليفون المنزل')
                              );
                            },

                            onTap:(){
                              var contactPhoneNumber = telManzel.toString();
                              launch("tel://+20$contactPhoneNumber");
                            } ,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0.0,0.0,15.0,0.0),
                                    child:IconButton(icon: Image.asset('assets/telephone.png'),),
                                  ),
                                  Text('تليفون المنزل: ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                  InkWell(
                                      child: Text('02-${telManzel.toString()}',style: TextStyle(fontSize: 18,color: Colors.indigoAccent ),)
                                  ),

                                ],),
                            ),
                          ),
                          GestureDetector(
                            onLongPress: (){
                              showDialog(
                                  context: context,
                                  builder: (context) =>showGradDialog('العنوان')
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                      child: IconButton(icon: Image.asset('assets/home_img.png'),),

                                  ),
                                  GestureDetector(

                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 90,
                                      child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            children: [
                                              Text("العنوان: ",
                                                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.justify,
                                                overflow: TextOverflow.clip,
                                                maxLines: 5,),
                                              Expanded(
                                                child: Text(_3omara.toString() + '  ' + share3 + ' الدور ' + door.toString()
                                                    + ' شقة ' + shaqqa.toString(),
                                                    style: TextStyle(fontSize: 18,color: Colors.indigoAccent),maxLines: 5,),
                                              ),
                                              GestureDetector(
                                                onTap: ()async{
                                                 await _getLocation(_3omara.toString() + share3);
                                                },
                                                child: Icon(Icons.location_on_outlined,color: Colors.red),
                                              )
                                            ],
                                          )
                                      ),
                                    ),
                                  )
                                ],),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(icon: Image.asset('assets/area.png'),),
                                Container(
                                  width: MediaQuery.of(context).size.width - 90,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                        children:[ Text("المنطقة: ",
                                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.justify,
                                          overflow: TextOverflow.clip,
                                          maxLines: 5,),
                                          Text(manteqa,
                                              style: TextStyle(fontSize: 18,color: Colors.indigoAccent))
                                        ]
                                    ),
                                  ),
                                )
                              ],),
                          ),
                          GestureDetector(
                            onLongPress: (){
                              showDialog(
                                  context: context,
                                  builder: (context) =>showGradDialog('جهة الدراسة')
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(icon: Image.asset('assets/gehatderasa_img.png'),),
                                  Flexible(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 90,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                            children:[ Text("جهة الدراسة: ",
                                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.justify,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 5,),
                                              Expanded(
                                                child: Text(gehatElDerasa,
                                                    style: TextStyle(fontSize: 18,color: Colors.indigoAccent),maxLines: 3,overflow: TextOverflow.ellipsis,),
                                              )
                                            ]
                                        ),
                                      ),
                                    ),
                                  )
                                ],),
                            ),
                          ),
                          GestureDetector(
                            onLongPress: (){
                              showDialog(
                                  context: context,
                                  builder: (context) =>showGradDialog('السنة الدراسية')
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(icon: Image.asset('assets/sanaderaseyya_img.png'),),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 90,
                                    child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                            children:[ Text("السنة الدراسية: ",
                                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.justify,
                                              overflow: TextOverflow.clip,
                                              maxLines: 5,),
                                              Text(koleyyaSana,
                                                  style: TextStyle(fontSize: 18,color: Colors.indigoAccent))
                                            ]
                                        )
                                    ),
                                  )
                                ],),
                            ),
                          ),
                          GestureDetector(
                            onLongPress: (){
                              showDialog(
                                  context: context,
                                  builder: (context) =>showGradDialog('أب الاعتراف')
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                      child: IconButton(icon: Image.asset('assets/abe3teraf_img.png'),),

                                  ),
                                  GestureDetector(

                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 90,
                                      child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                              children:[ Text("أب الاعتراف: ",
                                                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.justify,
                                                overflow: TextOverflow.clip,
                                                maxLines: 5,),
                                                Text(abE3teraf,
                                                    style: TextStyle(fontSize: 18,color: Colors.indigoAccent))
                                              ]
                                          )
                                      ),
                                    ),
                                  )
                                ],),
                            ),
                          ),
                          GestureDetector(
                            onLongPress: (){
                              showDialog(
                                  context: context,
                                  builder: (context) =>showGradDialog('كنيسته')
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                      child: IconButton(icon: Image.asset('assets/church_img.png'),),

                                  ),
                                  GestureDetector(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 90,
                                      child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                              children:[ Text("كنيسته: ",
                                                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.justify,
                                                overflow: TextOverflow.clip,
                                                maxLines: 5,),
                                                Text(kenisa,
                                                    style: TextStyle(fontSize: 18,color: Colors.indigoAccent))
                                              ]
                                          )
                                      ),
                                    ),
                                  )
                                ],),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(icon: Image.asset('assets/studyyear_img.png'),),
                                Container(
                                  width: MediaQuery.of(context).size.width - 90,
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                          children:[
                                            Text("العام الدراسي - إعداد خدام: ",
                                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.justify,
                                            overflow: TextOverflow.clip,
                                            maxLines: 5,),
                                            Container(
                                              width: 50,
                                              height: 50,
                                              child: GestureDetector(
                                                onLongPress: (){
                                                  setState(() {
                                                    enabled = !enabled;
                                                  });
                                                },
                                                  child: DropdownButton(
                                                    disabledHint: Text(_selectedSanaDeraseyya.name),
                                                    value: _selectedSanaDeraseyya,
                                                    items: _dropdownMenuItems,
                                                    onChanged: enabled ? onChangeDropdownItem : null,
                                                  ),
                                              ),
                                            ),
                                          ]
                                      )
                                  ),
                                )
                              ],),
                          ),

                          GestureDetector(
                            onLongPress: (){
                              _selectDate(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0.0,8.0,4.0,8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 21.0),
                                    child: IconButton(icon: Image.asset('assets/dob_img.png'),),
                                  ),
                                  Text('تاريخ الميلاد:   ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                  Text('${dobYear}/${dobMonth}/${dobDay}',style: TextStyle(fontSize: 18,color: Colors.indigoAccent),)

                                ],),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onLongPress: (){
                                showDialog(
                                    context: context,
                                    builder: (context) =>showGradDialog('الخادم')
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 22.0),
                                    child: IconButton(icon: Image.asset('assets/5adem_img.png'),),
                                  ),
                                  Text('إسم الخادم: ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                  Text('$khadem',style: TextStyle(fontSize: 18,color: Colors.indigoAccent))
                                ],),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: ElevatedButton(
                                    child: Text('بيانات اخري',style: TextStyle(fontSize: 18),),
                                    onPressed: (){
                                      var name = widget.recordName.FullName;
                                      var id = widget.id;
                                      setState(() {
                                        if(widget.recordName.e3dad5odam3amDerasy == '1'){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Time(recordName: name,id: id,listOfClasses: widget.listOfClasses,)),
                                          );
                                        }else{
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Time2(recordName: name,id: id,listOfClasses: widget.listOfClasses,)),
                                          );
                                        }

                                      });
                                    },
                                  )
                              ),
                              SizedBox(width: 15.0,),
                              Center(
                                  child: ElevatedButton(
                                    child: Text('تقرير كل شهر',style: TextStyle(fontSize: 18),),
                                    onPressed: (){
                                      var name = widget.recordName.FullName;
                                      var id = widget.id;
                                      setState(() {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => FirstFiveReport(listOfClasses: widget.listOfClasses,name: widget.recordName.FullName,)),
                                        );
                                      });
                                    },
                                  )
                              )
                            ],
                          )


                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }

  launchURL(var lat , var long) async {
    final String googleMapslocationUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$long";
    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    if (await canLaunch(encodedURl)) {
      await launch(encodedURl);
    } else {
      print('Could not launch $encodedURl');
      throw 'Could not launch $encodedURl';
    }
  }

  _getLocation(String location) async {
    GeoCode geoCode = GeoCode();
    try {
      var addresses = await Geocoder.local.findAddressesFromQuery(location);
      var first = addresses.first;
      var lat = first.coordinates.latitude;
      var long = first.coordinates.longitude;
      launchURL(lat, long);


    } catch (e) {
      print(e);
    }
  }

}


class SanaDeraseyya {
  int id;
  String name;

  SanaDeraseyya(this.id, this.name);

  static List<SanaDeraseyya> getSanaDeraseyya() {
    return <SanaDeraseyya>[
      SanaDeraseyya(0, ''),
      SanaDeraseyya(1, '1'),
      SanaDeraseyya(2, '2')
    ];
  }
}



