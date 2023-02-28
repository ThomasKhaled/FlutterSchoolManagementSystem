

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' show LineStyle, Style, Workbook, Worksheet;
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;

class BayanatRoheyya extends StatefulWidget {
  const BayanatRoheyya({Key key}) : super(key: key);

  @override
  _BayanatRoheyyaState createState() => _BayanatRoheyyaState();
}

class _BayanatRoheyyaState extends State<BayanatRoheyya> {
  var selectedDate ;

  void _pickYear(BuildContext context) {
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
              crossAxisCount: 3,
              children: [
                // Generating a list of 123 years starting from 2022
                // Change it depending on your needs.
                ...List.generate(
                  300,
                      (index) => InkWell(
                    onTap: () {
                      // The action you want to happen when you select the year below,
                      setState(() {
                        selectedDate = (DateTime.now().year - index).toString();
                      });
                      getInfo();
                      saveExcel();
                      Future.delayed(Duration(seconds: 2)).whenComplete(() => saveExcel());
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
  List<FirstFiveInfo> firstFiveInfo = [];
  List<FullInfo> fullInfo = [];
  Future getInfo()async{
    await users.doc('Ma5domeen')
        .collection('classes')
        .doc('admin')
        .collection('class')
        .snapshots()
        .forEach((element) {
            element.docs.forEach((element) {
              FirstFiveInfo sep,oct,nov,dec,jan,feb,mar,apr,may,jun,jul,aug;
              if(element['Dates']['$selectedDate'].toString().contains('September')){
                 sep =
                new FirstFiveInfo(hodoor2oddas: element['Dates']['${selectedDate}']['September']['hodoor2oddasat'],
                    e3terafWeErshad: element['Dates']['${selectedDate}']['September']['e3terafWeErshad'],
                    motab3aTelephoneyya: element['Dates']['${selectedDate}']['September']['motab3aTelephoneyya'],
                    zyaraManzeleyya: element['Dates']['${selectedDate}']['September']['zyaraManzeleyya'],
                    ketabMokaddas: element['Dates']['${selectedDate}']['September']['ketabMoqaddas'],
                    tasleemMosab2at: element['Dates']['${selectedDate}']['September']['tasleemMosab2at']);
              }
              if(element['Dates']['$selectedDate'].toString().contains('October')){
                 oct =
                new FirstFiveInfo(hodoor2oddas: element['Dates']['${selectedDate}']['October']['hodoor2oddasat'],
                    e3terafWeErshad: element['Dates']['${selectedDate}']['October']['e3terafWeErshad'],
                    motab3aTelephoneyya: element['Dates']['${selectedDate}']['October']['motab3aTelephoneyya'],
                    zyaraManzeleyya: element['Dates']['${selectedDate}']['October']['zyaraManzeleyya'],
                    ketabMokaddas: element['Dates']['${selectedDate}']['October']['ketabMoqaddas'],
                    tasleemMosab2at: element['Dates']['${selectedDate}']['October']['tasleemMosab2at']);
              }
              if(element['Dates']['$selectedDate'].toString().contains('November')){
                 nov =
                new FirstFiveInfo(hodoor2oddas: element['Dates']['${selectedDate}']['November']['hodoor2oddasat'],
                    e3terafWeErshad: element['Dates']['${selectedDate}']['November']['e3terafWeErshad'],
                    motab3aTelephoneyya: element['Dates']['${selectedDate}']['November']['motab3aTelephoneyya'],
                    zyaraManzeleyya: element['Dates']['${selectedDate}']['November']['zyaraManzeleyya'],
                    ketabMokaddas: element['Dates']['${selectedDate}']['November']['ketabMoqaddas'],
                    tasleemMosab2at: element['Dates']['${selectedDate}']['November']['tasleemMosab2at']);
              }
              if(element['Dates']['$selectedDate'].toString().contains('December')){
                 dec =
                new FirstFiveInfo(hodoor2oddas: element['Dates']['${selectedDate}']['December']['hodoor2oddasat'],
                    e3terafWeErshad: element['Dates']['${selectedDate}']['December']['e3terafWeErshad'],
                    motab3aTelephoneyya: element['Dates']['${selectedDate}']['December']['motab3aTelephoneyya'],
                    zyaraManzeleyya: element['Dates']['${selectedDate}']['December']['zyaraManzeleyya'],
                    ketabMokaddas: element['Dates']['${selectedDate}']['December']['ketabMoqaddas'],
                    tasleemMosab2at: element['Dates']['${selectedDate}']['December']['tasleemMosab2at']);
              }
              if(element['Dates']['$selectedDate'].toString().contains('January')){
                 jan =
                new FirstFiveInfo(hodoor2oddas: element['Dates']['${selectedDate}']['January']['hodoor2oddasat'],
                    e3terafWeErshad: element['Dates']['${selectedDate}']['January']['e3terafWeErshad'],
                    motab3aTelephoneyya: element['Dates']['${selectedDate}']['January']['motab3aTelephoneyya'],
                    zyaraManzeleyya: element['Dates']['${selectedDate}']['January']['zyaraManzeleyya'],
                    ketabMokaddas: element['Dates']['${selectedDate}']['January']['ketabMoqaddas'],
                    tasleemMosab2at: element['Dates']['${selectedDate}']['January']['tasleemMosab2at']);
              }
              if(element['Dates']['$selectedDate'].toString().contains('February')){
                 feb =
                new FirstFiveInfo(hodoor2oddas: element['Dates']['${selectedDate}']['February']['hodoor2oddasat'],
                    e3terafWeErshad: element['Dates']['${selectedDate}']['February']['e3terafWeErshad'],
                    motab3aTelephoneyya: element['Dates']['${selectedDate}']['February']['motab3aTelephoneyya'],
                    zyaraManzeleyya: element['Dates']['${selectedDate}']['February']['zyaraManzeleyya'],
                    ketabMokaddas: element['Dates']['${selectedDate}']['February']['ketabMoqaddas'],
                    tasleemMosab2at: element['Dates']['${selectedDate}']['February']['tasleemMosab2at']);
              }
              if(element['Dates']['$selectedDate'].toString().contains('March')){
                 mar =
                new FirstFiveInfo(hodoor2oddas: element['Dates']['${selectedDate}']['March']['hodoor2oddasat'],
                    e3terafWeErshad: element['Dates']['${selectedDate}']['March']['e3terafWeErshad'],
                    motab3aTelephoneyya: element['Dates']['${selectedDate}']['March']['motab3aTelephoneyya'],
                    zyaraManzeleyya: element['Dates']['${selectedDate}']['March']['zyaraManzeleyya'],
                    ketabMokaddas: element['Dates']['${selectedDate}']['March']['ketabMoqaddas'],
                    tasleemMosab2at: element['Dates']['${selectedDate}']['March']['tasleemMosab2at']);
              }
              if(element['Dates']['$selectedDate'].toString().contains('April')){
                 apr =
                new FirstFiveInfo(hodoor2oddas: element['Dates']['${selectedDate}']['April']['hodoor2oddasat'],
                    e3terafWeErshad: element['Dates']['${selectedDate}']['April']['e3terafWeErshad'],
                    motab3aTelephoneyya: element['Dates']['${selectedDate}']['April']['motab3aTelephoneyya'],
                    zyaraManzeleyya: element['Dates']['${selectedDate}']['April']['zyaraManzeleyya'],
                    ketabMokaddas: element['Dates']['${selectedDate}']['April']['ketabMoqaddas'],
                    tasleemMosab2at: element['Dates']['${selectedDate}']['April']['tasleemMosab2at']);
              }
              if(element['Dates']['$selectedDate'].toString().contains('May')){
                 may =
                new FirstFiveInfo(hodoor2oddas: element['Dates']['${selectedDate}']['May']['hodoor2oddasat'],
                    e3terafWeErshad: element['Dates']['${selectedDate}']['May']['e3terafWeErshad'],
                    motab3aTelephoneyya: element['Dates']['${selectedDate}']['May']['motab3aTelephoneyya'],
                    zyaraManzeleyya: element['Dates']['${selectedDate}']['May']['zyaraManzeleyya'],
                    ketabMokaddas: element['Dates']['${selectedDate}']['May']['ketabMoqaddas'],
                    tasleemMosab2at: element['Dates']['${selectedDate}']['May']['tasleemMosab2at']);
              }
              if(element['Dates']['$selectedDate'].toString().contains('June')){
                 jun =
                new FirstFiveInfo(hodoor2oddas: element['Dates']['${selectedDate}']['June']['hodoor2oddasat'],
                    e3terafWeErshad: element['Dates']['${selectedDate}']['June']['e3terafWeErshad'],
                    motab3aTelephoneyya: element['Dates']['${selectedDate}']['June']['motab3aTelephoneyya'],
                    zyaraManzeleyya: element['Dates']['${selectedDate}']['June']['zyaraManzeleyya'],
                    ketabMokaddas: element['Dates']['${selectedDate}']['June']['ketabMoqaddas'],
                    tasleemMosab2at: element['Dates']['${selectedDate}']['June']['tasleemMosab2at']);
              }
              if(element['Dates']['$selectedDate'].toString().contains('July')){
                 jul =
                new FirstFiveInfo(hodoor2oddas: element['Dates']['${selectedDate}']['July']['hodoor2oddasat'],
                    e3terafWeErshad: element['Dates']['${selectedDate}']['July']['e3terafWeErshad'],
                    motab3aTelephoneyya: element['Dates']['${selectedDate}']['July']['motab3aTelephoneyya'],
                    zyaraManzeleyya: element['Dates']['${selectedDate}']['July']['zyaraManzeleyya'],
                    ketabMokaddas: element['Dates']['${selectedDate}']['July']['ketabMoqaddas'],
                    tasleemMosab2at: element['Dates']['${selectedDate}']['July']['tasleemMosab2at']);
              }
              if(element['Dates']['$selectedDate'].toString().contains('August')){
                 aug =
                new FirstFiveInfo(hodoor2oddas: element['Dates']['${selectedDate}']['August']['hodoor2oddasat'],
                    e3terafWeErshad: element['Dates']['${selectedDate}']['August']['e3terafWeErshad'],
                    motab3aTelephoneyya: element['Dates']['${selectedDate}']['August']['motab3aTelephoneyya'],
                    zyaraManzeleyya: element['Dates']['${selectedDate}']['August']['zyaraManzeleyya'],
                    ketabMokaddas: element['Dates']['${selectedDate}']['August']['ketabMoqaddas'],
                    tasleemMosab2at: element['Dates']['${selectedDate}']['August']['tasleemMosab2at']);
              }
              Grades g = Grades(mosab2at: int.parse(element['totalMosab2at'].toString()),emte7anNos3am: element['emte7anNos3am'],
              a5erEl3am: element['a5erEl3am'],mo2tamar: element['mo2tamar'],shafawy: element['shafawy'],ebtyWeAl7an: element['ebtyWeAl7an']);
              var beet = '';
              if( element.data().toString().contains('Mola7zatBeet')){
                beet = element['Mola7zatBeet'];
              }
              var mola7zatO5ra = '';
              if( element.data().toString().contains('Mola7zatO5ra')){
                mola7zatO5ra = element['Mola7zatO5ra'];
              }
              var SefatGayyeda = '';
              if( element.data().toString().contains('SefatGayyeda')){
                SefatGayyeda = element['SefatGayyeda'];
              }
              var SefatMotab3a = '';
              if( element.data().toString().contains('SefatMotab3a')){
                SefatMotab3a = element['SefatMotab3a'];
              }
              HodoorExcell h = HodoorExcell(totalHodoor: element['totalHodoorEgtema3'],totalHodoor2oddas: element['totalHodoor2oddasEgtema3']
                  ,highestHodoor: element['HieghestHodoor'],Mola7zatBeet: beet,
                  Mola7zatO5ra: mola7zatO5ra, SefatGayyeda:  SefatGayyeda,SefatMotab3a:  SefatMotab3a);
              firstFiveInfo.add(sep);
              firstFiveInfo.add(oct);
              firstFiveInfo.add(nov);
              firstFiveInfo.add(dec);
              firstFiveInfo.add(jan);
              firstFiveInfo.add(feb);
              firstFiveInfo.add(mar);
              firstFiveInfo.add(apr);
              firstFiveInfo.add(may);
              firstFiveInfo.add(jun);
              firstFiveInfo.add(jul);
              firstFiveInfo.add(aug);
              fullInfo.add(FullInfo(element["FullName"], firstFiveInfo,g,h));
              firstFiveInfo = [];
            });
    });
  }
  Future getCountDays;
  @override
  void initState() {
    selectedDate = DateTime.now().year;
    getCountDays = getNumberOfDays();
    super.initState();
  }
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('تقرير البيانات الروحية')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child:ElevatedButton(onPressed: (){_pickYear(context);},
                child: Text('إختار العام',style: TextStyle(fontSize: 32),),
                style: ElevatedButton.styleFrom(primary: Colors.blue))
          ),

        ],
      ),
    );
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
    globalStyle.backColorRgb = Color.fromARGB(245, 132, 146, 217);
//set font color by RGB value.
    globalStyle.fontColorRgb = Color.fromARGB(255, 255, 255, 255);
//set border line style.
    globalStyle.borders.all.lineStyle = LineStyle.double;
//set border color by RGB value.
    globalStyle.borders.all.colorRgb = Color.fromARGB(255, 0, 0, 0);
    var count = 0;
    worksheet = workbook.worksheets[0];
    worksheet.name = 'البيانات الروحية';
    for(int i=0; i<fullInfo.length; i++) {
      worksheet.getRangeByName('N${i+1+count}').setText('الاسم');
      worksheet.getRangeByName('N${i+2+count}').setText(fullInfo[i].name);
      worksheet.setColumnWidthInPixels(13, 100);
      worksheet.setColumnWidthInPixels(14, 120);
      worksheet.getRangeByName('M${i+1+count}').setText(selectedDate);
      worksheet.getRangeByName('M${i+2+count}').setText("حضور القداسات");
      worksheet.getRangeByName('M${i+3+count}').setText("اعتراف و ارشاد");
      worksheet.getRangeByName('M${i+4+count}').setText("متابعة تليفونية");
      worksheet.getRangeByName('M${i+5+count}').setText("زيارة منزلية");
      worksheet.getRangeByName('M${i+6+count}').setText("كتاب مقدس");
      worksheet.getRangeByName('M${i+7+count}').setText("تسليم المسابقات");
      worksheet.getRangeByName('L${i+1+count}').setText('سبتمبر');
      worksheet.getRangeByName('K${i+1+count}').setText('اكتوبر');
      worksheet.getRangeByName('J${i+1+count}').setText('نوفمبر');
      worksheet.getRangeByName('I${i+1+count}').setText('ديسمبر');
      worksheet.getRangeByName('H${i+1+count}').setText("يناير");
      worksheet.getRangeByName('G${i+1+count}').setText("فبراير");
      worksheet.getRangeByName('F${i+1+count}').setText("مارس");
      worksheet.getRangeByName('E${i+1+count}').setText("ابريل");
      worksheet.getRangeByName('D${i+1+count}').setText("مايو");
      worksheet.getRangeByName('C${i+1+count}').setText("يونيو");
      worksheet.getRangeByName('B${i+1+count}').setText("يوليو");
      worksheet.getRangeByName('A${i+1+count}').setText("اغسطس");
      worksheet.getRangeByName('A${i+1+count}:N${i+1+count}').cellStyle = globalStyle;
      worksheet.getRangeByName('M${i+1+count}:M${i+7+count}').cellStyle = globalStyle;
      worksheet.getRangeByName('I${i+8+count}:N${i+8+count}').cellStyle = globalStyle;
      worksheet.getRangeByName('J${i+11+count}:N${i+11+count}').cellStyle = globalStyle;

      worksheet.getRangeByName('N${i+8+count}').setText("نصف العام");
      worksheet.getRangeByName('M${i+8+count}').setText("مسابقات");
      worksheet.getRangeByName('L${i+8+count}').setText("قبطي و الحان");
      worksheet.getRangeByName('K${i+8+count}').setText("اخر العام");
      worksheet.getRangeByName('J${i+8+count}').setText("مؤتمر");
      worksheet.getRangeByName('I${i+8+count}').setText("شفوي");

      worksheet.getRangeByName('N${i+11+count}').setText("حضور الاجتماع");
      worksheet.getRangeByName('M${i+11+count}').setText("حضور القداس");
      worksheet.getRangeByName('L${i+11+count}').setText("عدد الاجتماعات");
      worksheet.getRangeByName('K${i+11+count}').setText("نسبة الحضور");
      worksheet.getRangeByName('J${i+11+count}').setText("أعلي نسبة حضور");
      for(int j=0; j<fullInfo[i].firstFive.length; j++){
        worksheet.setColumnWidthInPixels(j+1, 90);
        worksheet.getRangeByName('${String.fromCharCode(76-j)}${i+2+count}').setText('${fullInfo[i].firstFive[j]?.hodoor2oddas??""}');
        worksheet.getRangeByName('${String.fromCharCode(76-j)}${i+3+count}').setText('${fullInfo[i].firstFive[j]?.e3terafWeErshad??""}');
        worksheet.getRangeByName('${String.fromCharCode(76-j)}${i+4+count}').setText('${fullInfo[i].firstFive[j]?.motab3aTelephoneyya??""}');
        worksheet.getRangeByName('${String.fromCharCode(76-j)}${i+5+count}').setText('${fullInfo[i].firstFive[j]?.zyaraManzeleyya??""}');
        worksheet.getRangeByName('${String.fromCharCode(76-j)}${i+6+count}').setText('${fullInfo[i].firstFive[j]?.ketabMokaddas??""}');
        worksheet.getRangeByName('${String.fromCharCode(76-j)}${i+7+count}').setText('${fullInfo[i].firstFive[j]?.tasleemMosab2at??""}');
      }
      worksheet.getRangeByName('N${i+9+count}').setText('${fullInfo[i].grades?.emte7anNos3am??""}');
      worksheet.getRangeByName('M${i+9+count}').setText('${fullInfo[i].grades?.mosab2at??""}');
      worksheet.getRangeByName('L${i+9+count}').setText('${fullInfo[i].grades?.ebtyWeAl7an??""}');
      worksheet.getRangeByName('K${i+9+count}').setText('${fullInfo[i].grades?.a5erEl3am??""}');
      worksheet.getRangeByName('J${i+9+count}').setText('${fullInfo[i].grades?.mo2tamar??""}');
      worksheet.getRangeByName('I${i+9+count}').setText('${fullInfo[i].grades?.shafawy??""}');

      worksheet.getRangeByName('N${i+12+count}').setText('${fullInfo[i].hodoor?.totalHodoor??""}');
      worksheet.getRangeByName('M${i+12+count}').setText('${fullInfo[i].hodoor?.totalHodoor2oddas??""}');
      worksheet.getRangeByName('L${i+12+count}').setText('${countNumOfDays}');
      worksheet.getRangeByName('K${i+12+count}').setText('${(((fullInfo[i].hodoor?.totalHodoor + fullInfo[i].hodoor?.totalHodoor2oddas)/fullInfo[i].hodoor?.highestHodoor)*100).toStringAsFixed(2)}');
      worksheet.getRangeByName('J${i+12+count}').setText('${fullInfo[i].hodoor?.highestHodoor??""}');


      worksheet.getRangeByName('N${i+14+count}:N${i+17+count}').cellStyle = globalStyle;
      worksheet.getRangeByName('N${i+14+count}').setText("صفات جيدة");
      worksheet.getRangeByName('N${i+15+count}').setText("صفات تحتاج متابعة");
      worksheet.getRangeByName('N${i+16+count}').setText("ملاحظات اخري");
      worksheet.getRangeByName('N${i+17+count}').setText("ملاحظات عن حالة البيت و الأهل");
      worksheet.getRangeByName('N${i+17+count}').columnWidth = 25;

      worksheet.getRangeByName('M${i+14+count}').setText("${fullInfo[i].hodoor.SefatGayyeda}");
      worksheet.getRangeByName('M${i+15+count}').setText("${fullInfo[i].hodoor.SefatMotab3a}");
      worksheet.getRangeByName('M${i+16+count}').setText("${fullInfo[i].hodoor.Mola7zatO5ra}");
      worksheet.getRangeByName('M${i+17+count}').setText("${fullInfo[i].hodoor.Mola7zatBeet}");
      count += 17;
    }



    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if(kIsWeb){
      AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', '${now.day}-${now.month}-${now.year}.xlsx')
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


          final String savePath = directory.path + '/FullInfo-${now.year}.xlsx';
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
  var countNumOfDays;

  Future getNumberOfDays() async{
    return users.doc('HodoorCount').get().then((value) {
      setState(() {
        countNumOfDays = value.data()['NumOfDays'];
      });
    });
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
}
class FullInfo {
  String name;
  List<FirstFiveInfo> firstFive;
  Grades grades;
  HodoorExcell hodoor;

  FullInfo(this.name, this.firstFive, this.grades, this.hodoor);
}

class FirstFiveInfo{
  String hodoor2oddas,e3terafWeErshad,motab3aTelephoneyya,zyaraManzeleyya,ketabMokaddas,tasleemMosab2at;

  FirstFiveInfo({this.hodoor2oddas, this.e3terafWeErshad,
      this.motab3aTelephoneyya, this.zyaraManzeleyya, this.ketabMokaddas,
      this.tasleemMosab2at});
}

class Grades {
  String ebtyWeAl7an,mo2tamar,shafawy;
  var emte7anNos3am,a5erEl3am;
  int mosab2at;

  Grades({this.emte7anNos3am, this.ebtyWeAl7an, this.a5erEl3am, this.mo2tamar,
      this.shafawy, this.mosab2at});
}

class HodoorExcell {
  var totalHodoor, totalHodoor2oddas, highestHodoor, SefatGayyeda, SefatMotab3a, Mola7zatO5ra, Mola7zatBeet;

  HodoorExcell({this.totalHodoor, this.totalHodoor2oddas, this.highestHodoor, this.SefatGayyeda, this.SefatMotab3a, this.Mola7zatO5ra, this.Mola7zatBeet});
}
