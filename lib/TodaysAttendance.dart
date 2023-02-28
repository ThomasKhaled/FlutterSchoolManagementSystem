import 'dart:io';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khedma_app/HodoorSpecificDate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert' show utf8,base64;
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class TodaysAttendance extends StatefulWidget {
  const TodaysAttendance({Key key}) : super(key: key);

  @override
  _TodaysAttendanceState createState() => _TodaysAttendanceState();
}

class _TodaysAttendanceState extends State<TodaysAttendance> {


  DateTime now = DateTime.now();
  bool isHodoor = true;


  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference attendance = FirebaseFirestore.instance.collection('attendance');

  var addAll = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('حضور اليوم'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'الحضور','الغياب','غياب و حضور يوم معين','حفظ الغياب و الحضور'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: (isHodoor)?StreamBuilder(
        stream: users.doc('Ma5domeen').collection('classes').doc('admin')
            .collection('class')
            .where('attendanceToday', isEqualTo: DateTime
            .now()
            .day).orderBy('FullName')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text('لا يوجد حضور اليوم', style: TextStyle(fontSize: 50,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, i) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: WillPopScope(
                      child: GestureDetector(
                        onLongPress: () {

                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            // if you need this
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
                                title: Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: Text('${i + 1} -  ' +
                                      snapshot.data.docs[i]['FullName']
                                          .toString() ?? '',
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )

                  ),
                ),
              );
            },
          );
        },
      ):StreamBuilder(
        stream: users.doc('Ma5domeen').collection('classes').doc('admin')
            .collection('class')
            .where('attendanceToday', isNotEqualTo: DateTime.now().day)
            .orderBy('attendanceToday')
            .orderBy('ClassNum')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text('لا يوجد غياب اليوم', style: TextStyle(fontSize: 50,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, i) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: WillPopScope(
                      child: GestureDetector(
                        onLongPress: () {

                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            // if you need this
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
                                title: Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: Text('${i + 1} -  ' +
                                      snapshot.data.docs[i]['FullName']
                                          .toString() ?? '',
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.black),
                                  ),
                                ),
                                subtitle: Container(
                                  child: Text('            ' +
                                      snapshot.data.docs[i]['ClassNum']
                                          .toString() ?? '',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.blue),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )

                  ),
                ),
              );
            },
          );
        },
      ),

    );


  }


  void handleClick(String value) {

    switch (value) {

      case 'حفظ الغياب و الحضور':
        saveExcel();
        break;

      case 'غياب و حضور يوم معين':
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HodoorSpecificDate()));
        break;

      case 'الغياب':
        setState(() {
          isHodoor = false;
        });
        break;
      case 'الحضور':
        setState(() {
          isHodoor = true;
        });
        break;
    }
  }


  Future saveExcel()async{
    Directory directory;
    final Workbook workbook = Workbook();
    final Worksheet worksheet = workbook.worksheets[0];
    worksheet.getRangeByName('A1').setText('حضور يوم (${now.day}-${now.month}-${now.year})');

    final Workbook workbookAbscent = Workbook();
    final Worksheet worksheetAbscent = workbookAbscent.worksheets[0];
    worksheetAbscent.getRangeByName('A1').setText('غياب يوم (${now.day}-${now.month}-${now.year})');
    var namesPDF = [],abscentNames = [];
    await users.doc('Ma5domeen').collection('classes').doc('admin')
        .collection('class')
        .where('attendanceToday', isEqualTo: DateTime.now().day).orderBy('FullName')
        .get().then((element) {
      element.docs.forEach((element) {
        namesPDF.add(element['FullName']);
      });
    });

    await users.doc('Ma5domeen').collection('classes').doc('admin')
        .collection('class')
        .where('attendanceToday', isNotEqualTo: DateTime.now().day)
        .orderBy('attendanceToday')
        .orderBy('ClassNum')
        .get().then((element) {
          element.docs.forEach((element) {
            abscentNames.add(element['FullName']);
          });

    });

    for(int i=0; i<namesPDF.length; i++){
      worksheet.setColumnWidthInPixels(i+1, 230);
      worksheet.getRangeByName('A${i+2}').setText('${namesPDF[i]}');
    }

    for(int i=0; i<abscentNames.length; i++){
      worksheetAbscent.setColumnWidthInPixels(i+1, 230);
      worksheetAbscent.getRangeByName('A${i+2}').setText('${abscentNames[i]}');
    }


    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final List<int> bytesAbscent = workbookAbscent.saveAsStream();
    workbookAbscent.dispose();

    if(kIsWeb){
      AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
          ..setAttribute('download', '${now.day}-${now.month}-${now.year}.xlsx')
          ..click();
      AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytesAbscent)}')
        ..setAttribute('download', 'abscent ${now.day}-${now.month}-${now.year}.xlsx')
        ..click();
    }else{
      if(Platform.isAndroid){

        if(await _requestPermission(Permission.storage)){

          directory = await getExternalStorageDirectory();
          String newPath = '';
          List<String> Folders = directory.path.split('/');
          for(int i=0; i<Folders.length; i++){
            String folder = Folders[i];
            if(folder != "Android"){
              newPath += '/' + folder;
            }else{
              break;
            }
          }
          newPath = newPath + '/Download';
          directory = Directory(newPath);
          bool hasExisted = await directory.exists();
          if (!hasExisted) {
            await directory.create();
          }


          final String savePath = directory.path + '/${now.day}-${now.month}-${now.year}.xlsx';
          final File file =await File(savePath).writeAsBytes(bytes);

          final String savePathAbscent = directory.path + '/abscent ${now.day}-${now.month}-${now.year}.xlsx';
          final File fileAbscent =await File(savePathAbscent).writeAsBytes(bytesAbscent);

          await uploadAttendance('${now.day}-${now.month}-${now.year}.xlsx', file);
          await uploadAbscent('abscent ${now.day}-${now.month}-${now.year}.xlsx', fileAbscent).whenComplete((){
            Fluttertoast.showToast(
                msg: "تم الحفظ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.lightGreen,
                textColor: Colors.white,
                fontSize: 16.0
            );
          });



        }else{
          return false;
        }

      }
    }
  }
  var url, urlAbscent;

  Future uploadAttendance(var path,File file) async{
    final _firebaseStorage = FirebaseStorage.instance;
    var snapshot = await _firebaseStorage.ref()
        .child('attendance/$path')
        .putFile(file,SettableMetadata(contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'));
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      url = downloadUrl;
    });

  }

  Future uploadAbscent(var path,File file) async{
    final _firebaseStorage = FirebaseStorage.instance;
    var snapshot = await _firebaseStorage.ref()
        .child('abscent/$path')
        .putFile(file,SettableMetadata(contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'));
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      urlAbscent = downloadUrl;
    });

  }

  Future<bool> _requestPermission(Permission permission) async{
    if(await permission.isGranted){
      return true;
    }else {
      var result = await permission.request();
      if(result == PermissionStatus.granted ){
        return true;
      }else
        return false;
    }
  }

}