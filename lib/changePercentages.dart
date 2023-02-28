




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui' as ui;
class changePercentages extends StatefulWidget {
  const changePercentages({Key key}) : super(key: key);

  @override
  _changePercentagesState createState() => _changePercentagesState();
}

class _changePercentagesState extends State<changePercentages> {


  Future getPercentages;
  Future getGradesPercentages() async{
    await FirebaseFirestore.instance.collection('gradesPercentage').doc('Percentages').get().then((value){
      setState(() {
        nos3amC.text = value.data()['nos3am'].toString();
        a5erEl3amC.text = value.data()['a5erEl3am'].toString();
        ebtyWeAl7anC.text = value.data()['ebtyWeAl7an'].toString();
        mosab2atC.text = value.data()['mosab2at'].toString();
        shafawyC.text = value.data()['shafawy'].toString();
        hodoorC.text = value.data()['hodoor'].toString();
      });
    });
  }

  Future updateGradesPercentages(var nos3am,var mosab2at , var ebtyWeAl7an , var a5erEl3am , var shafawy , var hodoor) async{
    await FirebaseFirestore.instance.collection('gradesPercentage').doc('Percentages').get().then((value){
      if(value.exists) {
        return FirebaseFirestore.instance.collection('gradesPercentage').doc(
            'Percentages').set({
          'nos3am': '$nos3am',
          'mosab2at': '$mosab2at',
          'ebtyWeAl7an': '$ebtyWeAl7an',
          'a5erEl3am': '$a5erEl3am',
          'shafawy': '$shafawy',
          'hodoor': '$hodoor',
        }, SetOptions(merge: true));
      }
    });
  }



  TextEditingController nos3amC = new TextEditingController();
  TextEditingController a5erEl3amC = new TextEditingController();
  TextEditingController ebtyWeAl7anC = new TextEditingController();
  TextEditingController mosab2atC = new TextEditingController();
  TextEditingController shafawyC = new TextEditingController();
  TextEditingController hodoorC = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text('تغيير نسب النجاح'),),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column( 
              children: [
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(child: Text('نصف العام : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),)),
                    Expanded(flex: 2,child: TextFormField(
                      controller: nos3amC,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'نصف العام',
                      ),
                    ),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(child: Text('اخر العام : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22))) ,
                    Expanded(flex: 2,child: TextFormField(
                      controller: a5erEl3amC,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'اخر العام',
                      ),
                    ),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(child: Text('قبطي و الحان : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22))),
                    Expanded(flex: 2,child: TextFormField(
                      controller: ebtyWeAl7anC,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'قبطي و الحان',
                      ),
                    ),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(child: Text('مسابقات : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22))),
                    Expanded(flex: 2,child: TextFormField(
                      controller: mosab2atC,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'مسابقات',
                      ),
                    ),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(child: Text('شفوي : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22))),
                    Expanded(flex: 2,child: TextFormField(
                      controller: shafawyC,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'شفوي',
                      ),
                    ),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(child: Text('حضور : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22))),
                    Expanded(flex: 2,child: TextFormField(
                      controller: hodoorC,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'حضور',
                      ),
                    ),)
                  ],
                ),
                SizedBox(height: 50,),
                ElevatedButton(onPressed: ()async{
                  await updateGradesPercentages(nos3amC.text, mosab2atC.text, ebtyWeAl7anC.text,
                      a5erEl3amC.text, shafawyC.text, hodoorC.text).whenComplete((){
                    Fluttertoast.showToast(
                        msg: "تم تعديل النسب بنجاح!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueAccent,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  });

                },
                    child: Text('تعديل النسب'))
              ],
            ),
          ),
        ),
      ),
    );
  }
  TextEditingController passC = new TextEditingController();
  Widget _buildDialogSettings() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: <Widget>[
            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text('برجاء إدخال كلمة السر',textDirection: ui.TextDirection.rtl,style: TextStyle(fontSize: 22.0)),
                  ),
                  TextFormField(
                    controller: passC,
                    keyboardType: TextInputType.text,
                    obscureText: !_passwordVisible,
                    decoration:  InputDecoration(
                      focusColor: Colors.white,
                      fillColor: Colors.black,
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: 'يرجي إدخال كلمة السر',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration( borderRadius: BorderRadius.circular(5)),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.red),
                            child: Text('الغاء'),
                            onPressed: (){
                                Navigator.of(context, rootNavigator: true).pop();
                                Navigator.of(context, rootNavigator: true).pop();

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
                            child: Text('تأكيد'),
                            onPressed: (){
                              if(passC.text == 'الكتيبةالطيبية'){
                                Navigator.of(context, rootNavigator: true).pop();
                              }else{
                                Fluttertoast.showToast(
                                    msg: "تأكد من كلمة السر!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.blueAccent,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                Navigator.of(context, rootNavigator: true).pop();
                                Navigator.of(context, rootNavigator: true).pop();


                              }
                            },
                          ),
                        ),
                      ),



                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _passwordVisible,passTrue;

  @override
  void initState() {
    _passwordVisible = false;

    SchedulerBinding.instance.addPostFrameCallback((_) {

      showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 16,
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _buildDialogSettings()
                  ],
                ),
              ),
            ),
          );
        },
      );
    });

    getPercentages = getGradesPercentages();
    super.initState();
  }
}
