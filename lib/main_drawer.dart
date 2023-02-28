import 'package:fluttertoast/fluttertoast.dart';
import 'package:khedma_app/TasgeelHodoor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'KhodamFasly.dart';
import 'Ma5domeenTanya.dart';
import 'addStudent.dart';
import 'changePercentages.dart';
import 'first_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'sign_in.dart';
import 'dart:ui' as ui;

class MainDrawer extends StatefulWidget{
  MainDrawerState createState() => MainDrawerState();
}

class MainDrawerState extends State<MainDrawer>{
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  bool _passwordVisible;

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
  SharedPreferences prefs;
  @override
  void initState() {

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
      },
      child: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              //padding: EdgeInsets.all(20),
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 35,),
                    ClipOval(
                        child: Image.asset(
                          "assets/admin.png",
                          fit: BoxFit.cover,
                          width: 70.0,
                          height: 70.0,
                        )
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10,bottom: 10),
                    ),
                    Text(
                      'Admin',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Image.asset('assets/first.png',width: 45,height: 45,),
              title: Text('مخدومين سنة 1',style: TextStyle(fontSize: 20),),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) {
                          return FirstScreen();
                        })
                );
              },
            ),
            Divider(height: 2,thickness: 2,),
            ListTile(
              leading: Image.asset('assets/second.png',width: 45,height: 45,),
              title: Text('مخدومين سنة 2',style: TextStyle(fontSize: 20),),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) {
                          return Ma5domeenTanya();
                        })
                );
              },
            ),
            Divider(height: 2,thickness: 2,),
            ListTile(
              leading: Image.asset('assets/checkAtten.png',width: 45,height: 45,),
              title: Text('تسجيل الحضور',style: TextStyle(fontSize: 20),),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) {
                          return TasgeelHodoor();
                        })
                );
              },
            ),
            Divider(height: 2,thickness: 2,),
            ListTile(
              leading: Image.asset('assets/proff.png',width: 45,height: 45,),
              title: Text('الخدام',style: TextStyle(fontSize: 20),),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return KhodamFasly();
                    })
                );
              },
            ),
            Divider(height: 2,thickness: 2,),
            ListTile(
              leading: Image.asset('assets/addNew.png',width: 45,height: 45,),
              title: Text('إضافة مخدوم جديد',style: TextStyle(fontSize: 20),),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return StudentInfo();
                    })
                );
              },
            ),
            Divider(height: 2,thickness: 2,),
            ListTile(
              leading: Image.asset('assets/percentage.png',width: 45,height: 45,),
              title: Text('تغيير نسب التخرج',style: TextStyle(fontSize: 20),),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return changePercentages();
                    })
                );


              },
            ),Divider(height: 2,thickness: 2,),
            SizedBox(height: 70,),
            Container(
              width: MediaQuery.of(context).size.width-80,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.only(left: 38.0),
                child: ListTile(
                  leading: Image.asset('assets/logout.png',width: 25,height: 25,),
                  title: Text('تسجيل خروج',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
                  onTap: ()async{
                    prefs = await SharedPreferences.getInstance();
                    await prefs.setBool("isLoggedIn", false);
                    signOutGoogle();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        })
                    );
                  },
                ),
              ),
            ),
           // SizedBox(height: 100,),

          ],
        ),
      ),
    );
  }
}