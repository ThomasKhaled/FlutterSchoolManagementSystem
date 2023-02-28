import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:khedma_app/sign_in.dart';

class Student {
  String imgPath;
  String FullName;
  int StudentPhoneNumber;
  String rakam3omara;
  String esmElShare3;
  String elDoor;
  String rakamShaqqa;
  String Manteqa;
  String gehatElDerasa;
  String elSanaElderaseyya;
  String abElE3teraf;
  String kenistoh;
  String e3dad5odam3amDerasy;
  int telephoneElManzel;
  String gehatEl3amal;
  int Day;
  int Month;
  int Year;
  String ClassName;
  String classNum;
  int hourAttendance = 0;
  int minuteAttendance = 0;
  int dayAttendance = 0;
  int monthAttendance = 0;

  Student(
      this.imgPath,
      this.FullName,
      this.StudentPhoneNumber,
      this.rakam3omara,
      this.esmElShare3,
      this.elDoor,
      this.rakamShaqqa,
      this.Manteqa,
      this.gehatElDerasa,
      this.elSanaElderaseyya,
      this.abElE3teraf,
      this.kenistoh,
      this.e3dad5odam3amDerasy,
      this.telephoneElManzel,
      this.gehatEl3amal,
      this.Day,
      this.Month,
      this.Year,
      this.classNum,
      this.ClassName,
     );


  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  var month = DateFormat.MMMM().format(DateTime.now());
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addStudent() async{
    return users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').add(({
      'imgPath' : imgPath,
      'FullName': FullName,
      'caseSearch' : setSearchParam('$FullName'),
      'StudentPhoneNumber': StudentPhoneNumber,
      'rakam3omara' : rakam3omara,
      'esmElShare3' : esmElShare3,
      'elDoor' : elDoor,
      'rakamShaqqa' : rakamShaqqa,
      'Manteqa' : Manteqa,
      'gehatElDerasa' : gehatElDerasa,
      'elSanaElderaseyya' : elSanaElderaseyya,
      'abElE3teraf' : abElE3teraf,
      'kenistoh' : kenistoh,
      'e3dad5odam3amDerasy' : e3dad5odam3amDerasy,
      'telephoneElManzel' : telephoneElManzel,
      'gehatEl3amal' : gehatEl3amal,
      'BOD': {'Day': Day, 'Month': Month, 'Year': Year},
      'ClassName': ClassName,
      'ClassNum' : classNum,
      'attendanceToday' : 0,
      'hodoorToDaysCount' : '',
      'totalHodoorEgtema3' : '0',
      'totalHodoor2oddasEgtema3' : '0',
      'hodoor2oddasToDaysCount' : '',
      'hodoor2oddasToHighest' : '',
      'HieghestHodoor' : '0',
      'hodoorToHighest' : '',
      'emte7anNos3am' : 0.0,
      'emte7anNos3am2' : 0.0,
      'totalMosab2at' : '0',
      'totalMosab2at2' : '0',
      'ebtyWeAl7an' : '',
      'ebtyWeAl7an2' : '',
      'a5erEl3am' : 0.0,
      'a5erEl3am2' : 0.0,
      'mo2tamar' : '',
      'mo2tamar2' : '',
      'shafawy' : '',
      'shafawy2' : '',
      'Ye5demFeMargirgis' : '',
      'ra8ba1' : '',
      'ra8ba2' : '',
      'ra8ba3' : '',
      'ra8baTarshee7' : '',
      'mee3ad5edma' : '',
      'e5tebarHay2a' : '',
      'Mewaf2aMnAbE3teraf' : '',

      'Dates': {
        '${DateTime.now().year}': {
          '$month': {
            'hodoor2oddasat': '',
            'e3terafWeErshad': '',
            'motab3aTelephoneyya': '',
            'zyaraManzeleyya': '',
            'ketabMoqaddas': '',
            'tasleemMosab2at': '',
            'hodoorEgtema3': '',
            'hodoor2oddas5edma': ''
          }
        }
      }
    })).whenComplete(() {
      Fluttertoast.showToast(
          msg: "تم إضافة المخدوم!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }
}
