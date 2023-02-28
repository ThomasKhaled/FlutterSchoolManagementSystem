import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Students.dart';
import 'sign_in.dart';
import 'first_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
class StudentInfo extends StatefulWidget {
  @override
  StudentState createState() => StudentState();
}

class e5tyarClass {
  int id;
  String choice;

  e5tyarClass(this.id, this.choice);

  static List<e5tyarClass> gete5tyarClass() {
    return <e5tyarClass>[
      e5tyarClass(0, '1 - أبونا داود'),
      e5tyarClass(1, '2 - أبونا موسي'),
      e5tyarClass(2, '3 - د.عفاف'),
      e5tyarClass(3, '4 - د.الهامى'),
      e5tyarClass(4, '5 - د.جورج البير'),
      e5tyarClass(5, '6 - ا.بشارة طرابلسي'),
      e5tyarClass(6, '7 - مينا ايهاب'),
      e5tyarClass(7, '8 - أنطونيوس اسكرن'),
      e5tyarClass(8, '9 - جون سمير'),
      e5tyarClass(9, '10 - بيتر فيليب'),
      e5tyarClass(10, '11 - د.عماد'),
      e5tyarClass(11, '12 - ا.مكرم'),
      e5tyarClass(12, '13 - مرفت عدلى'),
      e5tyarClass(13, '14 - امانى منير'),
      e5tyarClass(14, '15 - د.فيول'),
      e5tyarClass(15, '16 - استير الفونس'),
      e5tyarClass(16, '17 - د.منال صادق'),
      e5tyarClass(17, '18 - د.ناديه'),
      e5tyarClass(18, '19 - د.منال'),
      e5tyarClass(19, '20 - مايكل الفى'),
      e5tyarClass(20, '21 - نرمين'),
      e5tyarClass(21, '22 - سامي عطيه'),
    ];
  }
}

class StudentState extends State<StudentInfo> {
  TextEditingController FullNameC = TextEditingController();
  TextEditingController rakam3omaraC = TextEditingController();
  TextEditingController esmElShare3C = TextEditingController();
  TextEditingController elDoorC = TextEditingController();
  TextEditingController rakamShaqqaC = TextEditingController();
  TextEditingController StudentPhoneNumberC = TextEditingController();
  TextEditingController gehatElDerasaC = TextEditingController();
  TextEditingController elSanaElDeraseyyaC = TextEditingController();
  TextEditingController abElE3terafC = TextEditingController();
  TextEditingController kenistohC = TextEditingController();
  TextEditingController TelephoneElManzelC = TextEditingController();
  TextEditingController gehatEl3amalC = TextEditingController();
  TextEditingController ClassNameC = TextEditingController();
  var setDefaultMake = true;
  List khodam = [];

  Student s;
  int day , month, year;
  final firestoreInstance = FirebaseFirestore.instance;
  List<e5tyarClass> ListOfHodoor2oddasat =
  e5tyarClass.gete5tyarClass();
  List<DropdownMenuItem<e5tyarClass>> _dropdownMenue5tyarClass;
  e5tyarClass _selectede5tyarClass;



  _onChangeDropdowne5tyarClass(
      e5tyarClass selectedKashafaOrListOfHodoor2oddasat) {
    setState(() {
      _selectede5tyarClass = selectedKashafaOrListOfHodoor2oddasat;
    });
  }


  List<DropdownMenuItem<e5tyarClass>> buildDropdownMenuItemse5tyarClass(
      List kashafaOrListOfHodoor2oddasat) {
    List<DropdownMenuItem<e5tyarClass>> items = [];
    for (e5tyarClass company in kashafaOrListOfHodoor2oddasat) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.choice),
        ),
      );
    }
    return items;
  }


  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(kashafaOrShamas);
    _selectedkashafaOrShamas = _dropdownMenuItems[0].value;

    _dropdownMenu3amDerasyE3dad5odam = buildDropdownMenuItems(Shamas);
    _selected3amDerasyE3dad5odam = _dropdownMenu3amDerasyE3dad5odam[0].value;

    _dropdownMenuManteqaItems = buildDropdownMenuManteqaItems(_Manteqa);
    _selectedManteqa = _dropdownMenuManteqaItems[0].value;

    _dropdownMenue5tyarClass =
        buildDropdownMenuItemse5tyarClass(ListOfHodoor2oddasat);
    _selectede5tyarClass = _dropdownMenue5tyarClass[0].value;

    day = DateTime.now().day;
    month = DateTime.now().month;
    year = DateTime.now().year;


    super.initState();
  }
  PickedFile imageFile;
  void _openCamera(BuildContext context)  async{
    final pickedFile = await ImagePicker().getImage(
      imageQuality: 60,
      source: ImageSource.camera ,
    );
    setState(() {
      imageFile = pickedFile;
    });
    Navigator.pop(context);
  }
  void _openGallery(BuildContext context) async{
    final pickedFile = await ImagePicker().getImage(
      imageQuality: 60,
      source: ImageSource.gallery ,
    );
    setState(() {
      imageFile = pickedFile;
    });

    Navigator.pop(context);
  }

  Future<void>_showChoiceDialog(BuildContext context)
  {
    return showDialog(context: context,builder: (BuildContext context){

      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.blue),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  _openGallery(context);
                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.blue,),
              ),

              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  _openCamera(context);
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
            ],
          ),
        ),);
    });
  }
  var imgPath;
  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = Path.basename(imageFile.path);
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('${FullNameC.text}');
    UploadTask uploadTask = firebaseStorageRef.putFile(File(imageFile.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value){
        imgPath = value;
    });
    return imgPath;
  }

  var _uploadedFileURL;
  Future loadImage(var FullName) async {
    var storageReference = FirebaseStorage.instance
        .ref()
        .child('$FullName');
    await storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
    return _uploadedFileURL;
  }



  List<KashafaOrShamas> kashafaOrShamas = KashafaOrShamas.getKashafaOrShamas();
  List<DropdownMenuItem<KashafaOrShamas>> _dropdownMenuItems;
  KashafaOrShamas _selectedkashafaOrShamas;

  List<KashafaOrShamas> Shamas = KashafaOrShamas.getKashafaOrShamas();
  List<DropdownMenuItem<KashafaOrShamas>> _dropdownMenu3amDerasyE3dad5odam;
  KashafaOrShamas _selected3amDerasyE3dad5odam;

  List<Manteqa> _Manteqa = Manteqa.getManateq();
  List<DropdownMenuItem<Manteqa>> _dropdownMenuManteqaItems;
  Manteqa _selectedManteqa;

  List<DropdownMenuItem<KashafaOrShamas>> buildDropdownMenuItems(List kashafaOrShamas) {
    List<DropdownMenuItem<KashafaOrShamas>> items = List();
    for (KashafaOrShamas company in kashafaOrShamas) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Manteqa>> buildDropdownMenuManteqaItems(List kashafaOrShamas) {
    List<DropdownMenuItem<Manteqa>> items = List();
    for (Manteqa company in kashafaOrShamas) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }


  onChangeDropdownItem(KashafaOrShamas selectedKashafaOrShamas) {
    setState(() {
      _selectedkashafaOrShamas = selectedKashafaOrShamas;
    });
  }
  _onChangeDropdown3amDerasyE3dad5odam(KashafaOrShamas selectedKashafaOrShamas) {
    setState(() {
      _selected3amDerasyE3dad5odam = selectedKashafaOrShamas;
    });
  }

  onChangeDropdownManteqaItem(Manteqa selectedManteqa) {
    setState(() {
      _selectedManteqa = selectedManteqa;
    });
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

  var khademName ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة مخدوم جديد'),
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text('إدخال بيانات المخدوم',
                      style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap:()=>_showChoiceDialog(context),
                  child: Container(
                    color: Colors.grey[400],
                    width: 150,
                    height: 150,
                    child: (imageFile != null)
                        ? Image.file(File(imageFile.path),height: 150,width: 150,fit: BoxFit.fill,)
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined,size: 40.0),
                        Text('Upload your image here')
                      ],
                    ),
                  )
                ),
                SizedBox(height: 15,),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.right,
                  controller: FullNameC,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'الاسم الثلاثي',
                    labelStyle: TextStyle(color: Colors.black)
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Required Field';
                    }
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(11),
                  ],
                  controller: StudentPhoneNumberC,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'الموبايل',
                      labelStyle: TextStyle(color: Colors.black)
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Required Field';
                    }
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(8),
                  ],
                  textAlign: TextAlign.right,
                  controller: TelephoneElManzelC,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'تليفون المنزل',
                      labelStyle: TextStyle(color: Colors.black)
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Required Field';
                    }
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.right,
                  controller: gehatElDerasaC,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'جهة الدراسة',
                      labelStyle: TextStyle(color: Colors.black)
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Required Field';
                    }
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  controller: elSanaElDeraseyyaC,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'السنة الدراسية',
                      labelStyle: TextStyle(color: Colors.black)
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Required Field';
                    }
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.right,
                  controller: gehatEl3amalC,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'جهة العمل',
                      labelStyle: TextStyle(color: Colors.black)
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Required Field';
                    }
                  },
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width-100,
                        child: ElevatedButton(
                          child: Text('إختيار تاريخ الميلاد',style: TextStyle(fontSize: 18)),
                          onPressed: () {
                            _selectDate(context);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Container(padding: EdgeInsets.only(top: 12),
                      height: 50,
                      width: MediaQuery.of(context).size.width-250,
                      child: Text(
                        '${day}/$month/$year',style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 15,),
                    TextFormField(
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
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Flexible(
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
                        SizedBox(width: 15,),
                        Flexible(
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

                        SizedBox(width: 15,),
                        Flexible(
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
                  ],
                ),
                SizedBox(height: 15),
                Container(
                    alignment: Alignment.centerRight,
                    child: Text('المنطقة السكنية')
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius:  const BorderRadius.all(Radius.circular(6))),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _selectedManteqa,
                        items: _dropdownMenuManteqaItems,
                        onChanged: onChangeDropdownManteqaItem,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Divider(height: 4,thickness: 2,),
                SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.right,
                  controller: abElE3terafC,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'اب الاعتراف',
                      labelStyle: TextStyle(color: Colors.black)
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Required Field';
                    }
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.right,
                  controller: kenistohC,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'كنيسته',
                      labelStyle: TextStyle(color: Colors.black)
                  ),
                  validator: (String value) {
                    if (value.trim().isEmpty) {
                      return 'Required Field';
                    }
                  },
                ),
                SizedBox(height: 20),
                Container(
                    alignment: Alignment.centerRight,
                    child: Text('العام الدراسي - إعداد خدام')
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius:  const BorderRadius.all(Radius.circular(6))),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _selected3amDerasyE3dad5odam,
                        items: _dropdownMenu3amDerasyE3dad5odam,
                        onChanged: _onChangeDropdown3amDerasyE3dad5odam,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    alignment: Alignment.centerRight,
                    child: Text('فصل إعداد خدام')
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Khodam').orderBy('Name',descending: false).snapshots(),
                  builder: (context , AsyncSnapshot snapshot){
                    if(!snapshot.hasData)return Center(child: CircularProgressIndicator(),);
                    else{
                      if (setDefaultMake) {
                        khademName = snapshot.data.docs[0].get('Name');
                      }

                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius:  const BorderRadius.all(Radius.circular(6))),
                            contentPadding: EdgeInsets.all(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: false,
                              value: khademName,
                              items: snapshot.data.docs.map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.get('Name'),
                                  child: Text('${value.get('Name')}'),
                                );
                              }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                      khademName = value;
                                      setDefaultMake = false;

                                    },
                                  );
                                },
                            ),
                          ),
                        ),
                      );

                    }
                  },
                ),
                /*Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: DropdownButton(
                    value: _selectede5tyarClass,
                    items: _dropdownMenue5tyarClass,
                    onChanged: _onChangeDropdowne5tyarClass,
                  ),
                ),*/




                SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green[600]),

                  onPressed: () async {
                      Center(child: CircularProgressIndicator());
                      await uploadImageToFirebase(context).whenComplete((){
                        loadImage(FullNameC.text).whenComplete((){
                          if(_uploadedFileURL == null){
                            Fluttertoast.showToast(
                                msg: "برجاء إضافة صورة اولاً!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueAccent,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }else{
                            s = Student(
                                _uploadedFileURL,
                                FullNameC.text,
                                int.parse(StudentPhoneNumberC.text),
                                rakam3omaraC.text,
                                'شارع ' + esmElShare3C.text,
                                elDoorC.text,
                                rakamShaqqaC.text,
                                _selectedManteqa.name,
                                gehatElDerasaC.text,
                                elSanaElDeraseyyaC.text,
                                abElE3terafC.text,
                                kenistohC.text,
                                _selected3amDerasyE3dad5odam.name,
                                int.parse(TelephoneElManzelC.text),
                                gehatEl3amalC.text,
                                day,
                                month,
                                year,
                                khademName,
                                className);
                            s.addStudent();
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(builder: (context) {
                              return FirstScreen();
                            }));
                          }

                        });

                      });

                  },

                  child: Text('إضافة', style: TextStyle(fontSize: 24,color: Colors.white))
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KashafaOrShamas {
  int id;
  String name;

  KashafaOrShamas(this.id, this.name);

  static List<KashafaOrShamas> getKashafaOrShamas() {
    return <KashafaOrShamas>[
      KashafaOrShamas(1, '1'),
      KashafaOrShamas(2, '2')
    ];
  }
}


class Manteqa {
  int id;
  String name;

  Manteqa(this.id, this.name);

  static List<Manteqa> getManateq() {
    return <Manteqa>[
      Manteqa(1, 'هليوبوليس'),
      Manteqa(2, 'تريومف'),
      Manteqa(3, 'سانت فاتيما'),
      Manteqa(4, 'ميدان الحجاز'),
      Manteqa(5, 'ميدان المحكمة'),
      Manteqa(6, 'جامع الفتح'),
      Manteqa(7, 'نادي الشمس'),
      Manteqa(8, 'الكلية الحربية'),
      Manteqa(9, 'جسر السويس'),
      Manteqa(10, 'اخري'),
    ];
  }
}

