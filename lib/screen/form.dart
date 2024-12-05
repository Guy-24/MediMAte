import 'package:flutter/material.dart';
import 'package:medimate/screen/home.dart';
import 'package:medimate/model/data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddForm extends StatefulWidget {
  final int slot;
  final int hour;
  final int min;
  const AddForm(
      {Key? key, required this.slot, required this.hour, required this.min})
      : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

Future<void> updateAlarm(int slot, Map<String, dynamic> alarmData) async {
  final url = Uri.parse(
      "http://10.0.2.2:2000/api/update_alarm/$slot"); // ใส่ URL ที่ถูกต้อง
  try {
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json", // ระบุว่าใช้ JSON
      },
      body: jsonEncode(alarmData), // แปลงข้อมูลให้เป็น JSON
    );

    if (response.statusCode == 200) {
      print("Alarm updated successfully");
      print(jsonDecode(response.body)); // ดูข้อมูลที่ได้จาก API
    } else {
      print("Failed to update alarm: ${response.statusCode}");
      print(response.body);
    }
  } catch (error) {
    print("Error: $error");
  }
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  int _dosagePT = 1;
  int _dosageL = 1;
  String _info = "";
  late int _slot = 0;
  late int _hour = 0;
  late int _min = 0;

  @override
  void initState() {
    super.initState();
    _slot = widget.slot;
    _hour = widget.hour;
    _min = widget.min;
  }

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
              borderSide: BorderSide(color: Color(0xFF393939), width: 2.0),
            ),
            labelStyle: TextStyle(color: Colors.black),
            floatingLabelStyle: TextStyle(color: Color(0xFF191c23)),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Edit Details to slot ${_slot}"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 20,
                      decoration: const InputDecoration(
                        labelText: "Pill's Name",
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Please insert name."
                          : null,
                      onSaved: (value) => _name = value ?? '',
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      maxLength: 40,
                      decoration: const InputDecoration(
                        labelText: "Pill's Details",
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Please insert details."
                          : null,
                      onSaved: (value) => _info = value ?? '',
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: "Dosage per Time"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please insert dosage per time.";
                        }
                        return null;
                      },
                      onSaved: (value) => _dosagePT = int.tryParse(value!) ?? 1,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: "Dosage Left"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please insert dosage left.";
                        }
                        return null;
                      },
                      onSaved: (value) => _dosageL = int.tryParse(value!) ?? 1,
                    ),
                    const SizedBox(height: 40),
                    FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final alarmData = {
                            "name": _name,
                            "dosagePT": _dosagePT,
                            "dosageL": _dosageL,
                            "info": _info,
                            "slot": _slot,
                            "hour": _hour,
                            "min": _min,
                          };

                          await updateAlarm(_slot, alarmData);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()),
                          );
                          _formKey.currentState!.reset();
                        }
                      },
                      child: const Text("Submit"),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                        _formKey.currentState!.reset();
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
