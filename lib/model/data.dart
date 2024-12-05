// data.dart
import 'dart:convert';
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

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      slot:
          json['slot'] != null ? int.tryParse(json['slot'].toString()) ?? 0 : 0,
      hour:
          json['hour'] != null ? int.tryParse(json['hour'].toString()) ?? 0 : 0,
      min: json['min'] != null ? int.tryParse(json['min'].toString()) ?? 0 : 0,
      name: json['name']?.toString() ?? 'Unknown',
      dosagePT: json['dosagePT'] != null
          ? int.tryParse(json['dosagePT'].toString()) ?? 1
          : 1,
      dosageL: json['dosageL'] != null
          ? int.tryParse(json['dosageL'].toString()) ?? 1
          : 1,
      info: json['info']?.toString() ?? 'No Info',
    );
  }
}

List<Alarm> alarms = []; // Global variable

Future<void> initializeAlarms() async {
  alarms = await fetchAlarmsFromApi();
}

Future<List<Alarm>> fetchAlarmsFromApi() async {
  const apiUrl = "http://10.0.2.2:2000/api/get_all_alarms";
  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      final List<dynamic> data = responseData['data'];
      if (data != null && data is List) {
        List<Alarm> alarmsList =
            data.map((item) => Alarm.fromJson(item)).toList();
        alarmsList.sort((a, b) => a.slot.compareTo(b.slot));
        return alarmsList;
        // return data.map((item) => Alarm.fromJson(item)).toList();
      } else {
        throw Exception('Invalid data format: "data" is not a list');
      }
    } else {
      throw Exception(
          'Failed to load data with status code ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data: $e');
    // Return default alarms if the API request fails
    return [
      Alarm(
        slot: 1,
        hour: 12,
        min: 0,
        name: "Paracetamol",
        dosagePT: 2,
        dosageL: 6,
        info: "Take after meals",
      ),
      Alarm(
        slot: 2,
        hour: 14,
        min: 30,
        name: "Aspirin",
        dosagePT: 1,
        dosageL: 5,
        info: "Take before meals",
      ),
    ];
  }
}
