import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:khedma_app/sign_in.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class shrootEl5edma extends StatefulWidget {

  const shrootEl5edma();

  @override
  _shrootEl5edmaState createState() => _shrootEl5edmaState();
}

class _shrootEl5edmaState extends State<shrootEl5edma> with SingleTickerProviderStateMixin  {
  _shrootEl5edmaState();

  @override
  void initState() {
    getPercentages = getGradesPercentages();
    super.initState();

  }



  Future getPercentages;
  Future getGradesPercentages() async{
    await FirebaseFirestore.instance.collection('gradesPercentage').doc('Percentages').get().then((value){
      setState(() {
        nos3amPerc = double.parse(value.data()['nos3am'].toString())??0.0;
        a5erEl3amPerc = double.parse(value.data()['a5erEl3am'].toString())??0.0;
        ebtyWeAl7anPerc = double.parse(value.data()['ebtyWeAl7an'].toString())??0.0;
        mosab2atPerc = int.parse(value.data()['mosab2at'].toString())??0;
        shafawyPerc = double.parse(value.data()['shafawy'].toString())??0.0;
        hodoor2oddasToHighestPerc = double.parse(value.data()['hodoor'].toString())??0.0;
      });
    });
  }

  var nos3amPerc ,a5erEl3amPerc,ebtyWeAl7anPerc,mosab2atPerc,shafawyPerc,hodoor2oddasToHighestPerc;





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          title: Text('التخرج و شروط الخدمة',
              style: TextStyle(
                  fontFamily: ArabicFonts.El_Messiri,
                  package: 'google_fonts_arabic',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white
              )),


        ),
      ),
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text('" أَخْدِمُ الرَّبَّ بِكُلِّ تَوَاضُعٍ وَدُمُوعٍ كَثِيرَةٍ" (سفر أعمال الرسل ١٩:٢٠)',textAlign: TextAlign.center,style: TextStyle(
                        fontFamily: ArabicFonts.Rakkas,
                        package: 'google_fonts_arabic',
                        fontSize: 31,
                        color: Colors.blue

                    ),),
                  ),
                  SizedBox(height: 20,),
                  Text('١ - أن يكون من المربع السكني بالكنيسة او مسجل في برنامج العضوية الكنسية.',style: TextStyle(
                    fontFamily: ArabicFonts.El_Messiri,
                    package: 'google_fonts_arabic',
                    fontSize: 24,

                  ),),
                  SizedBox(height: 20,),
                  Text('٢ - أن يكون منتظم في حضور إجتماع إعداد الخدام و نسبة حضوره لا تقل عن ${hodoor2oddasToHighestPerc} %.',style: TextStyle(
                      fontFamily: ArabicFonts.El_Messiri,
                      package: 'google_fonts_arabic',
                      fontSize: 24
                  ),),
                  SizedBox(height: 20,),
                  Text('٣ - أن يجتاز إمتحان نصف العام بنسبه أعلي من ${nos3amPerc} % و آخر العام بنسبه أعلي من ${a5erEl3amPerc} %.',style: TextStyle(
                      fontFamily: ArabicFonts.El_Messiri,
                      package: 'google_fonts_arabic',
                      fontSize: 24
                  ),),
                  SizedBox(height: 20,),
                  Text('٤ - أن يجتاز الإمتحان الشفوي.',style: TextStyle(
                      fontFamily: ArabicFonts.El_Messiri,
                      package: 'google_fonts_arabic',
                      fontSize: 24
                  ),),
                  SizedBox(height: 20,),
                  Text('٥ - إحضار موافقة من أب الإعتراف.',style: TextStyle(
                      fontFamily: ArabicFonts.El_Messiri,
                      package: 'google_fonts_arabic',
                      fontSize: 24
                  ),),
                  SizedBox(height: 20,),
                  Text('٦ - تسليم مسابقات الكتاب المقدس حد أدني ${mosab2atPerc} مسابقات.',style: TextStyle(
                      fontFamily: ArabicFonts.El_Messiri,
                      package: 'google_fonts_arabic',
                      fontSize: 24
                  ),),

                  SizedBox(height: 20,),
                  Text('٧ - إجتياز إختبار الهيئة مع الآباء الكهنة.',style: TextStyle(
                      fontFamily: ArabicFonts.El_Messiri,
                      package: 'google_fonts_arabic',
                      fontSize: 24
                  ),),

                  SizedBox(height: 60,),
                  Align(
                    alignment: Alignment.center,
                    child: Text('الرب يبارك في كل عمل صالح يؤول إلي مجد اسمه القدوس.',textAlign: TextAlign.center,style: TextStyle(
                        fontFamily: ArabicFonts.Rakkas,
                        package: 'google_fonts_arabic',
                        fontSize: 25,
                        color: Colors.blue

                    ),),
                  ),

                ],
              ),
            ),
          )
      ),
    );
  }
}


