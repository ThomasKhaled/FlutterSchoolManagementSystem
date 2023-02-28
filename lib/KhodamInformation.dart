import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoder/geocoder.dart';
import 'package:khedma_app/sign_in.dart';
import 'package:url_launcher/url_launcher.dart';


import 'dart:async';
import 'dart:io';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' show Workbook,Worksheet;


class KhodamInformation extends StatefulWidget {
  final Khadem khadem;
  const KhodamInformation({this.khadem});

  @override
  _KhodamInformationState createState() => _KhodamInformationState(khadem);
}

class _KhodamInformationState extends State<KhodamInformation> {
  _KhodamInformationState(Khadem khadem);
  var name,esmShare3,Manteqa,rakam3omara,door,shaqqa,mobile,manzel,abE3teraf,email,day,month,year;
  var selectedDateForReport ;

  @override
  void initState() {

    super.initState();
    name = widget.khadem.Name;
    esmShare3 = widget.khadem.esmElShare3;
    Manteqa = widget.khadem.elManteqa;
    rakam3omara = widget.khadem.rakamEl3oamara;
    door = widget.khadem.elDoor;
    shaqqa = widget.khadem.rakamElShaqqa;
    mobile = widget.khadem.mobile;
    manzel = widget.khadem.manzel;
    abE3teraf = widget.khadem.abE3teraf;
    email = widget.khadem.email;
    day = widget.khadem.day;
    month = widget.khadem.month;
    year = widget.khadem.year;
    selectedDateForReport = DateTime.now().year;

  }


  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future _pickYear(BuildContext context) async{
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
                         selectedDateForReport = (DateTime.now().year - index).toString();
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








  TextEditingController newInfoC = new TextEditingController();
  TextEditingController esmElShare3C = new TextEditingController();
  TextEditingController rakam3omaraC = new TextEditingController();
  TextEditingController elDoorC = new TextEditingController();
  TextEditingController rakamShaqqaC = new TextEditingController();
  TextEditingController manteqaC = new TextEditingController();
  var phone,address,derasa,sanaDeraseyy,kenisa,telManzel,manteqa,khadem;
  StatefulBuilder  showGradDialog(String name){
    print('$name');
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
                          ):(name == 'تاريخ الميلاد')?Expanded(
                        child: Container(
                          height: 40,
                          width: 100,
                          child: ElevatedButton(
                            child: Text('تاريخ الميلاد',style: TextStyle(fontSize: 18)),
                            onPressed: () {
                              _selectDate(context);
                            },
                          ),
                        ),
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
                                      mobile = int.parse(newInfoC.text.toString());
                                    });
                                    update('mobile');
                                  }else if(name == 'أب الاعتراف'){
                                    setState(() {
                                      abE3teraf = newInfoC.text.toString();
                                    });
                                    update('abE3teraf');
                                  }else if(name == 'تليفون المنزل'){
                                    setState(() {
                                      telManzel = newInfoC.text.toString();
                                      manzel = newInfoC.text.toString();
                                    });
                                    update('manzel');
                                  }
                                  else if(name == 'email'){
                                    setState(() {
                                      email = newInfoC.text.toString();
                                    });
                                    update('Email');
                                  }
                                  else if(name == 'تاريخ الميلاد'){
                                    update('dob');
                                  }
                                  else{
                                    esmShare3 = esmElShare3C.text.toString()??'---';
                                    shaqqa = int.tryParse(rakamShaqqaC.text.toString()??"0")??0;
                                    rakam3omara = rakam3omaraC.text.toString()??'-';
                                    door = int.tryParse(elDoorC.text.toString()??"0")??0;
                                    manteqa = manteqaC.text.toString()??'---';
                                    update('address');
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
  CollectionReference khodam = firestoreInstance.collection('Khodam');
  void update(var upWhat) async {
    await khodam.get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) { 
        if(element.get('Name').toString().toLowerCase() == name){
          up(element,upWhat);
        }
      });
    });
  }

  Future up(QueryDocumentSnapshot x,var upWhat) async {
    DocumentReference docRef = khodam.doc(x.id);
    if(upWhat =='mobile'){
      docRef.set({
        'Phone' : int.parse(mobile.toString()),
      },SetOptions(merge: true));
    }
    else if(upWhat =='manzel'){
      docRef.set({
        'Manzel' : int.parse(manzel.toString()),
      },SetOptions(merge: true));
    }
    else if(upWhat =='Email'){
      docRef.set({
        'Email' : email.toString(),
      },SetOptions(merge: true));
    }
    else if(upWhat =='abE3teraf'){
      docRef.set({
        'abE3teraf' : abE3teraf.toString(),
      },SetOptions(merge: true));
    }
    else if(upWhat =='address'){
      docRef.set({
        'esmElShare3' : esmShare3,
        'rakam3omara' : (rakam3omara.toString().isEmpty)?"0":rakam3omara.toString(),
        'elDoor' : (door.toString().isEmpty)?"0":int.parse(door.toString()),
        'rakamShaqqa' : (shaqqa.toString().isEmpty)?"0":int.parse(shaqqa.toString()),
        'manteqa' : Manteqa,
      },SetOptions(merge: true));
    }
    else if(upWhat =='dob'){
      docRef.set({

        'day':day,
        'month' : month,
        'year' : year

      },SetOptions(merge: true));
    }

  }
  String date = "";
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(''),
      actions: [

      ]),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Container(
                    child: Text(
                      '$name',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Divider(height: 3,thickness: 3,color: Colors.blueAccent,),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right:14.0),
                      child:GestureDetector(
                          onLongPress: (){
                            showDialog(context: context, builder: (context)=>showGradDialog('الموبايل'));
                          },
                          onTap:(){
                            var contactPhoneNumber = mobile.toString();
                            launch("tel://0$contactPhoneNumber");
                          } ,
                          child: IconButton(icon: Image.asset('assets/call_img.png'),)
                      ),
                    ),
                    Text('الموبايل:  ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                    InkWell(
                        child: Text('0${mobile.toString()}',style: TextStyle(fontSize: 18,color: Colors.indigoAccent),)
                    ),

                  ],),
              ),
              GestureDetector(
                onLongPress: (){
                  showDialog(context: context, builder: (context)=>showGradDialog('تليفون المنزل'));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Row(textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0,right: 15.0),
                        child:GestureDetector(
                          onLongPress: (){
                            showDialog(context: context, builder: (context)=>showGradDialog('تليفون المنزل'));
                          },

                            onTap:(){
                              var contactPhoneNumber = manzel.toString();
                              launch("tel://+20$contactPhoneNumber");
                            } ,
                            child: IconButton(icon: Image.asset('assets/telephone.png'),)
                        ),
                      ),
                      Text('تليفون المنزل: ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                      InkWell(
                          child: Text('02-${manzel.toString()}',style: TextStyle(fontSize: 18,color: Colors.indigoAccent ),)
                      ),

                    ],),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: IconButton(icon: Image.asset('assets/home_img.png'),),
                      onLongPress: (){
                        showDialog(context: context, builder: (context)=>showGradDialog('العنوان'));


                      },
                    ),
                    GestureDetector(
                      onLongPress: (){
                        showDialog(context: context, builder: (context)=>showGradDialog('العنوان'));

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 90,
                        child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Text("العنوان: ",
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.clip,
                                  maxLines: 5,),
                                Expanded(
                                  child: Text(rakam3omara + '  ' + esmShare3 + ' الدور ' + door.toString()
                                      + ' شقة ' + shaqqa.toString(),
                                    style: TextStyle(fontSize: 18,color: Colors.indigoAccent),maxLines: 5,),
                                ),
                                GestureDetector(
                                  onTap: ()async{
                                    await _getLocation(rakam3omara.toString() + esmShare3);
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
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
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
                              Text(Manteqa,
                                  style: TextStyle(fontSize: 18,color: Colors.indigoAccent))
                            ]
                        ),
                      ),
                    )
                  ],),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: IconButton(icon: Image.asset('assets/abe3teraf_img.png'),),
                      onLongPress: (){
                        showDialog(context: context, builder: (context)=>showGradDialog('أب الاعتراف'));

                      },
                    ),
                    GestureDetector(
                      onLongPress: (){
                        showDialog(context: context, builder: (context)=>showGradDialog('أب الاعتراف'));
                      },
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

              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: IconButton(icon: Image.asset('assets/email.png'),),
                      onLongPress: (){
                        showDialog(context: context, builder: (context)=>showGradDialog('email'));

                      },
                    ),
                    GestureDetector(
                      onLongPress: (){
                        showDialog(context: context, builder: (context)=>showGradDialog('email'));

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 90,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                                children:[ Text("الايميل: ",
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.clip,
                                  maxLines: 5,),
                                  Text(email,
                                      style: TextStyle(fontSize: 18,color: Colors.indigoAccent))
                                ]
                            )
                        ),
                      ),
                    )
                  ],),
              ),
              GestureDetector(
                onLongPress: (){
                  showDialog(context: context, builder: (context)=>showGradDialog('تاريخ الميلاد'));

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
                      Text('${year}/${month}/${day}',style: TextStyle(fontSize: 18,color: Colors.indigoAccent),)

                    ],),
                ),
              ),
            ],
          ),
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


class Khadem{
  var Name,esmElShare3,elManteqa,rakamEl3oamara,elDoor,rakamElShaqqa,mobile,manzel,abE3teraf,email;
  int day,month,year;

  Khadem.name(
      this.Name,
      this.esmElShare3,
      this.elManteqa,
      this.rakamEl3oamara,
      this.elDoor,
      this.rakamElShaqqa,
      this.mobile,
      this.manzel,
      this.abE3teraf,
      this.email,
      this.day,
      this.month,
      this.year);
}

class StudentReportInfo{
  var _2oddas,e3teraf,motab3aTelephone,zyaraManzeleyya,ketabMokaddas,tasleemMosab2at,month;


  StudentReportInfo();

  StudentReportInfo.name(this._2oddas, this.e3teraf, this.motab3aTelephone,
      this.zyaraManzeleyya, this.ketabMokaddas, this.tasleemMosab2at,this.month);
}
