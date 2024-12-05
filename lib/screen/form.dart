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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Details"),
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
                decoration: const InputDecoration(labelText: "Dosage per Time"),
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
                decoration: const InputDecoration(labelText: "Dosage Left"),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    alarms.add(Alarm(
                      name: _name,
                      dosagePT: _dosagePT,
                      dosageL: _dosageL,
                      info: _info,
                      slot: _slot,
                      hour: _hour,
                      min: _min,
                    ));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
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
    );
  }
}
