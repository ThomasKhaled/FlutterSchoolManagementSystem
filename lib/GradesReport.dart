import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khedma_app/sign_in.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' show LineStyle, Style, Workbook, Worksheet;
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
class GradesReport extends StatefulWidget {
  final List listOfMa5domeen;
  final List listOfClasses;
  final String elSana;
  const GradesReport({this.listOfMa5domeen,this.listOfClasses,this.elSana});

  @override
  _GradesReportState createState() => _GradesReportState(listOfMa5domeen,listOfClasses,elSana);
}

class _GradesReportState extends State<GradesReport> with SingleTickerProviderStateMixin {
  _GradesReportState(listOfMa5domeen, listOfClasses, elSana);

  List<Ma5doom> ma5domeen = [];
  bool f1 = false,
      f2 = false;
  Future getGrades;
  String elSana = '3';
  bool filterPressed = false;


  @override
  void initState() {
    getGrades = getListOfMa5domeenAll('1','nos3am');
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }


  CollectionReference users = FirebaseFirestore.instance.collection('users');

   Future getListOfMa5domeenAll(String elSana,var orderby) async{
    if(orderby == 'no'){
      ma5domeen = [];
      int i=0;
        await users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').get().then((value){
          value.docs.forEach((element) {
            Ma5doom ma5doom = Ma5doom(nos3am: element.data()['emte7anNos3am'],
                mosab2at:  element.data()['totalMosab2at'],
                qebtyWeAl7an: element.data()['ebtyWeAl7an'],
                a5erEl3am: element.data()['a5erEl3am'],
                mo2tamar: element.data()['mo2tamar'],
                nesbetHodoor: (((element.data()['totalHodoorEgtema3']+element.data()['totalHodoor2oddasEgtema3'])/element.data()['HieghestHodoor'])*100).toStringAsFixed(2),
                shafawy: element.data()['shafawy'],fullName: element.data()['FullName']
                ,sanaDeraseyya: element.data()['e3dad5odam3amDerasy']);
            ma5domeen.add(ma5doom);

          });
        });
      return ma5domeen;
    }
    if(orderby == 'nos3am'){
      ma5domeen = [];
      int i=0;
      await users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').orderBy('emte7anNos3am',descending: true).get().then((value){
        value.docs.forEach((element) {
          Ma5doom ma5doom = Ma5doom(nos3am: element.data()['emte7anNos3am'],
              mosab2at:  element.data()['totalMosab2at'],
              qebtyWeAl7an: element.data()['ebtyWeAl7an'],
              a5erEl3am: element.data()['a5erEl3am'],
              mo2tamar: element.data()['mo2tamar'],
              nesbetHodoor: (((element.data()['totalHodoorEgtema3']+element.data()['totalHodoor2oddasEgtema3'])/element.data()['HieghestHodoor'])*100).toStringAsFixed(2),
              shafawy: element.data()['shafawy'],fullName: element.data()['FullName']
              ,sanaDeraseyya: element.data()['e3dad5odam3amDerasy']);
          ma5domeen.add(ma5doom);

        });
      });
      return ma5domeen;
    }

    else if(orderby == 'final'){
      ma5domeen = [];
      int i=0;
      await users.doc('Ma5domeen').collection('classes').doc('admin').collection('class').orderBy('a5erEl3am',descending: true).get().then((value){
        value.docs.forEach((element) {
          Ma5doom ma5doom = Ma5doom(nos3am: element.data()['emte7anNos3am'],
              mosab2at:  element.data()['totalMosab2at'],
              qebtyWeAl7an: element.data()['ebtyWeAl7an'],
              a5erEl3am: element.data()['a5erEl3am'],
              mo2tamar: element.data()['mo2tamar'],
              nesbetHodoor: (((element.data()['totalHodoorEgtema3']+element.data()['totalHodoor2oddasEgtema3'])/element.data()['HieghestHodoor'])*100).toStringAsFixed(2),
              shafawy: element.data()['shafawy'],fullName: element.data()['FullName']
              ,sanaDeraseyya: element.data()['e3dad5odam3amDerasy']);
          ma5domeen.add(ma5doom);

        });
      });
      return ma5domeen;
    }

  }



  bool nos3am = false,
      a5erel3am = false;

  void handleClick(String value) {
    switch (value) {
      case 'ترتيب حسب إمتحان نصف العام':
        setState(() {
          nos3am = true;
          a5erel3am = false;
          getGrades = getListOfMa5domeenAll('1','nos3am');
        });
        break;

      case 'ترتيب حسب إمتحان اخر العام':
        setState(() {
          nos3am = false;
          a5erel3am = true;
          getGrades = getListOfMa5domeenAll('1','final');
        });
        break;

      case 'Export Data':
        saveExcel();
        break;
    }
  }
  DateTime now = DateTime.now();
  Future saveExcel()async{
    now = DateTime.now();
    Directory directory;
    final Workbook workbook = Workbook(1);
    Worksheet worksheet;
    Style globalStyle = workbook.styles.add('style');
    globalStyle = workbook.styles.add('style1');
//set back color by RGB value.
    globalStyle.backColorRgb = Color.fromARGB(245, 0, 0, 0);
//set font color by RGB value.
    globalStyle.fontColorRgb = Color.fromARGB(255, 255, 255, 255);
//set border line style.
    globalStyle.borders.all.lineStyle = LineStyle.double;
//set border color by RGB value.
    globalStyle.borders.all.colorRgb = Color.fromARGB(255, 0, 0, 0);

    Style globalStyleData = workbook.styles.add('style2');
    globalStyleData = workbook.styles.add('style3');
//set back color by RGB value.
    globalStyleData.backColorRgb = Color.fromARGB(245, 116, 116, 116);
//set font color by RGB value.
    globalStyleData.fontColorRgb = Color.fromARGB(255, 255, 255, 255);
//set border color by RGB value.
    globalStyleData.borders.all.colorRgb = Color.fromARGB(255, 0, 0, 0);
    var count = 0;
    worksheet = workbook.worksheets[0];
    worksheet.name = 'البيانات الروحية';
    worksheet.getRangeByName('H1').setText('الاسم');
    worksheet.getRangeByName('G1').setText('نصف العام');
    worksheet.getRangeByName('F1').setText('مسابقات');
    worksheet.getRangeByName('E1').setText('قبطي و الحان');
    worksheet.getRangeByName('D1').setText('اخر العام');
    worksheet.getRangeByName('C1').setText('نسبة الحضور');
    worksheet.getRangeByName('B1').setText('مؤتمر');
    worksheet.getRangeByName('A1').setText('شفوي');
    worksheet.getRangeByName('A1:H1').cellStyle = globalStyle;
    worksheet.setColumnWidthInPixels(13, 100);
    worksheet.setColumnWidthInPixels(14, 120);

    for(int i=0; i<ma5domeen.length; i++) {
      worksheet.getRangeByName('H${i+2}').setText("${ma5domeen[i].fullName}");
      worksheet.getRangeByName('H${i+2}').columnWidth = 19;
      worksheet.getRangeByName('G${i+2}').setText("${ma5domeen[i].nos3am}%");
      worksheet.getRangeByName('F${i+2}').setText("${ma5domeen[i].mosab2at}");
      worksheet.getRangeByName('E${i+2}').setText("${ma5domeen[i].qebtyWeAl7an}%");
      worksheet.getRangeByName('D${i+2}').setText("${ma5domeen[i].a5erEl3am}%");
      worksheet.getRangeByName('C${i+2}').setText("${ma5domeen[i].nesbetHodoor}%");
      worksheet.getRangeByName('B${i+2}').setText("${ma5domeen[i].mo2tamar}");
      worksheet.getRangeByName('A${i+2}').setText("${ma5domeen[i].shafawy}");

      if(i%2==0){
        worksheet.getRangeByName('A${i+2}:H${i+2}').cellStyle = globalStyleData;
      }

    }



    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if(kIsWeb){
      AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Grades-${now.year}.xlsx')
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


          final String savePath = directory.path + '/Grades-${now.year}.xlsx';
          deleteFile(File(savePath));
          final File file = File(savePath);
          if(await file.exists()) {
            await deleteFile(file);
            file.writeAsBytes(bytes);
          }else
            file.create(recursive: true);
          file.writeAsBytes(bytes);

          Fluttertoast.showToast(
              msg: "تم حفظ الملف في (Downloads Folder)!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blueAccent,
              textColor: Colors.white,
              fontSize: 16.0
          );


        }else{
          return false;
        }

      }
    }
  }
  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('تقرير الدرجات', style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {
                'ترتيب حسب إمتحان نصف العام',
                'ترتيب حسب إمتحان اخر العام',
                'Export Data'
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],

      ),
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              StreamBuilder(
                stream: (nos3am) ? users.doc('Ma5domeen').collection('classes')
                    .doc('admin').collection('class')
                    .where("e3dad5odam3amDerasy", isEqualTo: widget.elSana)
                    .orderBy('emte7anNos3am', descending: true)
                    .snapshots() :
                (a5erel3am) ? users.doc('Ma5domeen').collection('classes').doc(
                    'admin').collection('class')
                    .where("e3dad5odam3amDerasy", isEqualTo: widget.elSana)
                    .orderBy('a5erEl3am', descending: true)
                    .snapshots() :
                users.doc('Ma5domeen').collection('classes').doc('admin')
                    .collection('class')
                    .where("e3dad5odam3amDerasy", isEqualTo: widget.elSana).orderBy('FullName')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  /*if(filterPressed){
                      getGrades = getListOfMa5domeenAll(elSana);
                      filterPressed = false;
                    }*/

                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, int index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];

                        return ListTile(
                          title: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: [
                                DataTable(
                                  border: TableBorder.all(color: Colors.black),
                                  headingRowHeight: 20,
                                  horizontalMargin: 2,
                                  headingRowColor: MaterialStateProperty.all<
                                      Color>(Colors.lightBlue),
                                  columnSpacing: 9,
                                  columns: [
                                    DataColumn(label: Text('الاسم',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16, color: Colors.white))),
                                    DataColumn(label: Text('نصف العام',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16, color: Colors.white))),
                                    DataColumn(label: Text(' مسابقات',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16, color: Colors.white))),
                                    DataColumn(label: Text('قبطي و الحان',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16, color: Colors.white))),
                                    DataColumn(label: Text('اخر العام',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16, color: Colors.white))),
                                    DataColumn(label: Text('نسبة الحضور',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16, color: Colors.white))),
                                    DataColumn(label: Text('مؤتمر',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16, color: Colors.white))),
                                    DataColumn(label: Text('شفوي',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16, color: Colors.white)))
                                  ],
                                  rows: [
                                    DataRow(
                                        cells: [
                                          DataCell(SizedBox(width: 200,
                                            child: Text(
                                              (index + 1).toString() + '-  ' +
                                                  ds['FullName'] ,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),),
                                          )),
                                          DataCell(
                                              ["", null, false, 0].contains(
                                                  ds['emte7anNos3am']) ?
                                              Center(child: Text('0.0',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18),)) :
                                              Center(child: Text(
                                                '${ds['emte7anNos3am']}%',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18),))
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['totalMosab2at']) ?
                                            Center(child: Text('0',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text('${int.tryParse(
                                                ds['totalMosab2at']
                                                    .toString())}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['ebtyWeAl7an']) ?
                                            Center(child: Text('0.0',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text(
                                              ds['ebtyWeAl7an'] + '%',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['a5erEl3am']) ?
                                            Center(child: Text('0.0',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text(
                                              ds['a5erEl3am'] + '%',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['totalHodoorEgtema3']) ?
                                            Center(child: Text('0.0',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text(
                                              '${(((ds['totalHodoorEgtema3']+ds['totalHodoor2oddasEgtema3'])/ds['HieghestHodoor'])*100).toStringAsFixed(2)}%',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['mo2tamar']) ?
                                            Center(child: Text('0',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text(ds['mo2tamar'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          ),
                                          DataCell(
                                            ["", null, false, 0].contains(
                                                ds['shafawy']) ?
                                            Center(child: Text('0',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)) :
                                            Center(child: Text(
                                              ds['shafawy'] + '%',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),)),
                                          )
                                        ]
                                    ),

                                  ],
                                ),

                              ],

                            ),
                          ),

                        );
                      },
                    ),
                  );
                },
              )
            ],
          )
      ),
    );
  }

}

class Ma5doom{
  var nos3am,mosab2at,qebtyWeAl7an,a5erEl3am,mo2tamar,shafawy,fullName,sanaDeraseyya,nesbetHodoor;

  Ma5doom({this.nos3am  = '0', this.mosab2at = '0', this.qebtyWeAl7an = '0', this.a5erEl3am = '0',
      this.mo2tamar = '0', this.shafawy = '0',this.fullName = '',this.sanaDeraseyya = '0',this.nesbetHodoor});
}


