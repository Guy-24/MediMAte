import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medimate/model/data.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';

class Api {
  static const baseUrl = "";

  Future<void> fetchAlarms() async {
    const String apiUrl = "http://10.0.2.2:2000/api/get_all_alarms";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody['status_code'] == 200) {
          List<dynamic> alarmsData = responseBody['data'];
          alarms.clear();
          alarms.addAll(alarmsData.map((alarm) {
            return Alarm(
              slot: int.parse(alarm['slot']),
              hour: int.parse(alarm['hour']),
              min: int.parse(alarm['min']),
              name: alarm['name'],
              dosagePT: int.parse(alarm['dosagePT']),
              dosageL: int.parse(alarm['dosageL']),
              info: alarm['info'],
            );
          }).toList());
          print("Alarms fetched successfully: $alarms");
        } else {
          print("Failed to fetch alarms: ${responseBody['message']}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching alarms: $e");
    }
  }

  static addproduct(Map data) async {
    try {
      final res = await http.post(Uri.parse("uri"), body: data);

      if (res.statusCode == 200) {
      } else {}
    } catch (error) {
      print("Connecting failed:");
      print(error.toString());
    }
  }
}
