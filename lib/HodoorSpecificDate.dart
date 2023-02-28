import 'dart:io';
import 'dart:io' as io;
import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' show Worksheet, Workbook;
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert' show utf8, base64;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';


class HodoorSpecificDate extends StatefulWidget {
  const HodoorSpecificDate({Key key}) : super(key: key);

  @override
  _HodoorSpecificDateState createState() => _HodoorSpecificDateState();
}

class _HodoorSpecificDateState extends State<HodoorSpecificDate> {
  DateTime selectedDate = DateTime.now();
  ReceivePort _port = ReceivePort();
  static const _channel = const MethodChannel('vn.hunghd/downloader');
  bool buttonEnabled = false;
  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });
    

  }
  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }



  Future<void> _selectDate(BuildContext context) async {
    setState(() {
      isButtonAvail = false;
    });
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      await readExcel(selectedDate);



    }
  }
  bool fileExists = false;

  Future readExcel(DateTime now)async{
    Directory directory;
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
        print(directory.path);


        final String savePath = directory.path + '/${now.day}-${now.month}-${now.year}.xlsx';
        final File file =await File(savePath).create();

        final String savePathAbscent = directory.path + '/abscent ${now.day}-${now.month}-${now.year}.xlsx';
        final File fileAbscent =await File(savePathAbscent).create();

        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('attendance/${now.day}-${now.month}-${now.year}.xlsx');

        firebase_storage.Reference refAbscent = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('abscent/abscent ${now.day}-${now.month}-${now.year}.xlsx');
        String url,urlAbscent;
        try{
          url = await ref.getDownloadURL();
          urlAbscent = await refAbscent.getDownloadURL();
        }
        catch(error){
          print('file not found');
          setState(() {
            isButtonAvail = false;
          });
          Fluttertoast.showToast(
              msg: "لا يوجد حضور",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blueAccent,
              textColor: Colors.white,
              fontSize: 16.0
          );
          url = null;
          urlAbscent = null;
        }

        if(url != null){
          print(url);
          final status = await Permission.storage.request();
          if(status.isGranted){
            final taskId = await FlutterDownloader.enqueue(
                url: url,
                headers: {}, // optional: header send with url (auth token etc)
                savedDir: directory.path,
                saveInPublicStorage: true,
                openFileFromNotification: true,
                showNotification: true,
                fileName: '${now.day}-${now.month}-${now.year}.xlsx'
            ).whenComplete(() => Fluttertoast.showToast(
                msg: "تم تحميل الحضور",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blueAccent,
                textColor: Colors.white,
                fontSize: 16.0
            ).onError((error, stackTrace) => Fluttertoast.showToast(
                msg: "$error",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blueAccent,
                textColor: Colors.white,
                fontSize: 16.0
            )
            )
            );

            final taskIdAbscent = await FlutterDownloader.enqueue(
                url: urlAbscent,
                headers: {}, // optional: header send with url (auth token etc)
                savedDir: directory.path,
                saveInPublicStorage: true,
                openFileFromNotification: true,
                showNotification: true,
                fileName: 'abscent ${now.day}-${now.month}-${now.year}.xlsx'
            ).whenComplete(() => Fluttertoast.showToast(
                msg: "تم تحميل الغياب",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blueAccent,
                textColor: Colors.white,
                fontSize: 16.0
            ).onError((error, stackTrace) => Fluttertoast.showToast(
                msg: "$error",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blueAccent,
                textColor: Colors.white,
                fontSize: 16.0
            )
            )
            );
            setState(() {
              isButtonAvail = true;
            });


          }
        }


      }else{
        return false;
      }

    }


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
  bool isButtonAvail = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('حضور يوم معين'),
        actions: [],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0, right: 12.0),
                  child: Center(
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 220,
                      child: Center(
                        child: ElevatedButton(
                          child: Text('إختيار تاريخ الحضور',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            setState(() {
                              _selectDate(context);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 20),
                ),
                  ),
                )
              ],
            ),
          ),
          (isButtonAvail)?Row(
            children: [
              Expanded(
                child: Padding( 
                  padding: const EdgeInsets.only(top: 18.0, right: 12.0),
                  child: Center(
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 100,
                      child: Center(
                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(primary: Colors.green),
                          child: Text('إفتح ملف الحضور',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            setState(() {
                              OpenFile.open('/storage/emulated/0/Download/${selectedDate.day}-${selectedDate.month}-${selectedDate.year}.xlsx');

                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0, right: 12.0),
                  child: Center(
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 100,
                      child: Center(
                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(primary: Colors.green),
                          child: Text('إفتح ملف الغياب',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            setState(() {
                              OpenFile.open('/storage/emulated/0/Download/abscent ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}.xlsx');

                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ):SizedBox(),
        ],
      ),
    );
  }

}
