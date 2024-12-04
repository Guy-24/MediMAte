import 'package:flutter/material.dart';

class Alarm {
  Alarm({
    required this.slot,
    required this.alarmTime,
    required this.alarmTotal,
    required this.name,
    required this.dosagePT,
    required this.dosageL,
    required this.info,
  });
  int slot;
  TimeOfDay alarmTime;
  int alarmTotal;
  String name;
  int dosagePT;
  int dosageL;
  String info;
}

List<Alarm> data = [
  Alarm(
    slot: 1,
    alarmTime: TimeOfDay(hour: 12, minute: 0),
    alarmTotal: 1,
    name: "Paracetamol",
    dosagePT: 2,
    dosageL: 6,
    info: "EAT IT",
  ),
  Alarm(
    slot: 2,
    alarmTime: TimeOfDay(hour: 14, minute: 30),
    alarmTotal: 3,
    name: "Aspirin",
    dosagePT: 1,
    dosageL: 5,
    info: "EAT IT NOW",
  ),
  Alarm(
    slot: 3,
    alarmTime: TimeOfDay(hour: 22, minute: 30),
    alarmTotal: 3,
    name: "Aspirin",
    dosagePT: 1,
    dosageL: 5,
    info: "EAT IT NOW",
  ),
  Alarm(
    slot: 4,
    alarmTime: TimeOfDay(hour: 22, minute: 30),
    alarmTotal: 3,
    name: "Aspirin",
    dosagePT: 30,
    dosageL: 5,
    info: "EAT IT NOW",
  ),
];
