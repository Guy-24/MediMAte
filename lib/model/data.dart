import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Alarm {
  Alarm({
    required this.slot,
    required this.hour,
    required this.min,
    required this.name,
    required this.dosagePT,
    required this.dosageL,
    required this.info,
  });
  int slot;
  int hour;
  int min;
  String name;
  int dosagePT;
  int dosageL;
  String info;
}

List<Alarm> alarms = [
  Alarm(
    slot: 1,
    hour:12,
    min:0,
    name: "Paracetamol",
    dosagePT: 2,
    dosageL: 6,
    info: "EAT IT",
  ),
  Alarm(
    slot: 2,
    hour:14,
    min:30,
    name: "Aspirin",
    dosagePT: 1,
    dosageL: 5,
    info: "EAT IT NOW",
  ),
  Alarm(
    slot: 3,
    hour:10,
    min:30,
    name: "XXXX",
    dosagePT: 1,
    dosageL: 5,
    info: "EAT IT NOW",
  ),
  Alarm(
    slot: 4,
    hour:22,
    min:10,
    name: "ABCD",
    dosagePT: 30,
    dosageL: 5,
    info: "EAT IT NOW",
  ),
];

// class AlarmListScreen extends StatefulWidget {
//   @override
//   _AlarmListScreenState createState() => _AlarmListScreenState();
// }

// class _AlarmListScreenState extends State<AlarmListScreen> {
//   List<Alarm> data = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchAlarms();
//   }

//   Future<void> fetchAlarms() async {
//     final String apiKey = '76a0acdc-d3a8-4f1f-944c-df0db661a0ac';
//     final String clusterName = 'Cluster0';
//     final String databaseName = 'Alarm';
//     final String collectionName = 'Alarm';

//     final String url =
//         'https://data.mongodb-api.com/app/data-xxxx/endpoint/data/v1/action/find'; // เปลี่ยน URL ตามที่คุณต้องการ

//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'api-key': apiKey,
//       },
//       body: jsonEncode({
//         'dataSource': clusterName,
//         'database': databaseName,
//         'collection': collectionName,
//         'filter': {}
//       }),
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> jsonData = jsonDecode(response.body)['documents'];
//       List<Alarm> alarms = jsonData.map((json) {
//         return Alarm(
//           slot: json['slot'],
//           alarmTime: TimeOfDay(
//               hour: json['alarmTime']['hour'],
//               minute: json['alarmTime']['minute']),
//           name: json['name'],
//           dosagePT: json['dosagePT'],
//           dosageL: json['dosageL'],
//           info: json['info'],
//         );
//       }).toList();

//       setState(() {
//         data = alarms;
//       });
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Alarms'),
//       ),
//       body: ListView.builder(
//         itemCount: data.length,
//         itemBuilder: (context, index) {
//           final alarm = data[index];
//           return ListTile(
//             title: Text(alarm.name),
//             subtitle:
//                 Text('Time: ${alarm.alarmTime.hour}:${alarm.alarmTime.minute}'),
//           );
//         },
//       ),
//     );
//   }
// }
