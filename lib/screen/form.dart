import 'package:flutter/material.dart';
import 'package:medimate/screen/home.dart';
import 'package:medimate/model/data.dart';

class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  int _dosagePT = 1;
  int _dosageL = 1;
  String _info = "";
  int _slot = 1;
  int _hour = 0;
  int _min = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black), 
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xFF393939), width: 2.0), 
          ),
          labelStyle: TextStyle(color: Colors.black), 
          floatingLabelStyle:
              TextStyle(color: Color(0xFF191c23)), 
        ),
        textTheme: const TextTheme(
          bodyMedium:
              TextStyle(fontSize: 18, color: Colors.black), 
        ),
      ),
      title: "Title",
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text("Edit details"),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 20,
                      decoration: const InputDecoration(
                        label: Text(
                          "Phill's name:",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please insert name.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value!;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      maxLength: 40,
                      decoration: const InputDecoration(
                        label: Text(
                          "Phill's details:",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please insert details.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _info = value!;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          label: Text(
                        "Dosage per time:",
                        style: TextStyle(fontSize: 20),
                      )),
                      validator: (value) {
                        //ระบุเป็น func
                        if (value == null || value.isEmpty) {
                          //if
                          return "Please insert dosage per time.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _dosagePT = int.parse(value.toString());
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          label: Text(
                        "Dosage left:",
                        style: TextStyle(fontSize: 20),
                      )),
                      validator: (value) {
                        //ระบุเป็น func
                        if (value == null || value.isEmpty) {
                          //if
                          return "Please insert dosage left.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _dosageL = int.parse(value.toString());
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    // ปุ่ม submit-------------------------------
                    FilledButton(
                        onPressed: () {
                          _formKey.currentState!.validate();
                          _formKey.currentState!.save(); //save
                          alarms.add(
                            Alarm(
                              name: _name,
                              dosagePT: _dosagePT,
                              dosageL: _dosageL,
                              info: _info,
                              slot: _slot,
                              hour:_hour,
                              min:_min,
                            ),
                          ); //สร้าง object Person และผูก state กับ propoties
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()));
                          _formKey.currentState!.reset(); //บันทึกแล้วเคลียร์
                        },
                        style: FilledButton.styleFrom(
                            backgroundColor: Color(0xFF393939)),
                        child: const Text("Submit",
                            style: TextStyle(
                              fontSize: 20,
                            ))),
                    const SizedBox(
                      height: 40,
                    ),
                    // ปุ่ม cancel-------------------------------
                    FilledButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()));
                          _formKey.currentState!.reset();
                        },
                        style: FilledButton.styleFrom(
                            backgroundColor: Color(0xFF393939)),
                        child: const Text("Cancel",
                            style: TextStyle(
                              fontSize: 20,
                            )))
                  ],
                ))),
      ),
    );
  }
}
