import 'package:flutter/material.dart';
import 'package:medimate/model/data.dart';
import 'package:medimate/screen/form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<bool> isExpanded = [];
  List<bool> isVibrate = [];
  String formatTime(int hour, int minute) {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  // Add these variables
  List<File?> _images = [];
  final picker = ImagePicker();
  List<bool> _isUploadingList = [];
  List<String?> _messageList = [];
  List<Map<String, dynamic>?> _jsonResponseList = [];

  @override
  void initState() {
    super.initState();
    isExpanded = List<bool>.filled(alarms.length, false);
    isVibrate = List<bool>.filled(alarms.length, false);

    // Initialize the new lists
    _images = List<File?>.filled(alarms.length, null);
    _isUploadingList = List<bool>.filled(alarms.length, false);
    _messageList = List<String?>.filled(alarms.length, null);
    _jsonResponseList = List<Map<String, dynamic>?>.filled(alarms.length, null);
  }

  Future<void> _pickImage(int index) async {
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
      );

      if (pickedFile != null) {
        setState(() {
          _images[index] = File(pickedFile.path);
          _messageList[index] = null;
        });
      } else {
        setState(() {
          _messageList[index] = 'No image selected.';
        });
      }
    } catch (e) {
      setState(() {
        _messageList[index] = 'Error selecting image: $e';
      });
    }
  }

  Future<void> _uploadImage(int index) async {
    if (_images[index] == null) return;

    setState(() {
      _isUploadingList[index] = true;
      _messageList[index] = null;
    });

    const String uploadUrl = 'http://10.0.2.2:8000/process-image/';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
        ..files.add(
          await http.MultipartFile.fromPath(
            'file',
            _images[index]!.path,
          ),
        );

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        setState(() {
          _messageList[index] = 'Upload successful';
          _jsonResponseList[index] = jsonDecode(responseData);

          // Map the API response to the Alarm object
          Map<String, dynamic>? apiData = _jsonResponseList[index];

          if (apiData != null) {
            // Update name
            alarms[index].name = apiData['pill_name'] ?? alarms[index].name;

            // Update dosagePT
            alarms[index].dosagePT =
                int.tryParse(apiData['amount'].toString()) ??
                    alarms[index].dosagePT;

            // Concatenate datae, time_condition, and warning into info
            alarms[index].info =
                '${apiData['datae'] ?? ''}, ${apiData['time_condition'] ?? ''}, ${apiData['warning'] ?? ''}';

            // Update alarmTime
            if (apiData['time'] != -1) {
              int hour = int.tryParse(apiData['time'].toString()) ??
                  alarms[index].hour;
              int min =
                  int.tryParse(apiData['time'].toString()) ?? alarms[index].min;
              // alarms[index] = TimeOfDay(hour: hour, minute: 0);
            }
            _messageList[index] = 'Invalid response data from API';
          }
        });
        print(_jsonResponseList[index]);
        print(index);
      } else {
        setState(() {
          _messageList[index] =
              'Upload failed with status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _messageList[index] = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isUploadingList[index] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              //ช่องว่าง
              const SizedBox(
                height: 20,
              ),
              //Card
              Center(
                //Card action
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded[index] = !isExpanded[index];
                      });
                    },
                    //Alarm Card ยืด/หด
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: isExpanded[index] ? 700 : 220,
                      //Card
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20.0),
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30.0),
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(28.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(2, 3),
                              ),
                            ],
                          ),
                          //เรียงข้อความใน Card
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              //ExpandedBtn
                              AnimatedPositioned(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  top: isExpanded[index] ? 600 : -12,
                                  right: 0,
                                  child: Image.network(
                                      isExpanded[index]
                                          ? "https://cdn-icons-png.flaticon.com/128/8000/8000283.png"
                                          : "https://static.thenounproject.com/png/5133265-200.png",
                                      width: 30,
                                      height: 30,
                                      color: Colors.white)),
                              //Time
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                top: isExpanded[index] ? 60 : 15,
                                left: 20,
                                child: TextButton(
                                  onPressed: () {
                                    //pop up
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(28)),
                                          elevation: 5.0,
                                          //Card set time
                                          child: Container(
                                            width: 200,
                                            height: 150,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ]),

                                            //Text in Card set time
                                            child: Stack(children: [
                                              //Select time
                                              const Positioned(
                                                top: 15,
                                                left: 30,
                                                width: 110,
                                                height: 45,
                                                child: Text(
                                                  "Select Time",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              //Time Picker
                                              Positioned(
                                                top: 56,
                                                left: 40,
                                                width: 200,
                                                height: 70,
                                                //btn
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    TimeOfDay? pickedTime =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay(
                                                          hour: alarms[index]
                                                              .hour,
                                                          minute: alarms[index]
                                                              .min),
                                                    );
                                                    if (pickedTime != null) {
                                                      setState(() {
                                                        // อัปเดตเวลาที่เลือกกลับไปยัง data[index].alarmTime
                                                        alarms[index].hour =
                                                            pickedTime.hour;
                                                        alarms[index].min =
                                                            pickedTime.minute;
                                                      });
                                                      print(
                                                          "Selected time: ${pickedTime.format(context)}");
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.zero,
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  //text
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10,
                                                        horizontal: 0),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  28.0)),
                                                    ),
                                                    //Show Time
                                                    child: Text(
                                                      formatTime(
                                                          alarms[index].hour,
                                                          alarms[index].min),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 35,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 3,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSecondary,
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondary,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  //Show time in Home
                                  child: Container(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 200,
                                    child: Text(
                                      formatTime(alarms[index].hour,
                                          alarms[index].min),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //slot
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                top: isExpanded[index] ? 0 : 60,
                                right: 5,
                                child: isExpanded[index]
                                    ? GestureDetector(
                                        onTap: () {
                                          print(
                                              "slot ${alarms[index].slot} btn Pressed!");
                                        },
                                        child: Text(
                                          "slot ${alarms[index].slot}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Colors.white,
                                              decoration: TextDecoration.none,
                                              fontSize:
                                                  isExpanded[index] ? 22 : 20),
                                        ),
                                      )
                                    : Text(
                                        "slot ${alarms[index].slot}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                            fontSize:
                                                isExpanded[index] ? 25 : 20),
                                      ),
                              ),
                              //name
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                top: isExpanded[index] ? 0 : 110,
                                left: 5,
                                child: isExpanded[index]
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      const AddForm()));
                                        },
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                alarms[index].name,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    decoration:
                                                        TextDecoration.none,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Image.network(
                                                "https://cdn-icons-png.flaticon.com/128/1159/1159633.png",
                                                color: Colors.white,
                                                width: 15,
                                                height: 15,
                                              ),
                                            ]))
                                    : Text(
                                        alarms[index].name,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            decoration: TextDecoration.none),
                                      ),
                              ),
                              //doasge per time
                              if (isExpanded[index])
                                Positioned(
                                    top: 65,
                                    right: 25,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    const AddForm()));
                                      },
                                      child: Text(
                                        "${alarms[index].dosagePT}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            decoration: TextDecoration.none),
                                      ),
                                    )),
                              //doasge per time [tablet(s)]
                              if (isExpanded[index])
                                Positioned(
                                    top: 100,
                                    right: 13,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        "tablet(s)",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            decoration: TextDecoration.none),
                                      ),
                                    )),
                              if (isExpanded[index])
                                //Info
                                Positioned(
                                  top: 150,
                                  left: 5,
                                  //btn
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const AddForm()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    //Card
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 300, maxHeight: 120),
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.6),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      //Info text
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Infomation",
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 4,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "     ${alarms[index].info}",
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 4,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if (isExpanded[index])
                                //Manual recieve
                                Positioned(
                                  top: 290,
                                  left: 5,
                                  //btn
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print(
                                          "Manual receive clicked!!!!!!!!!!!!!!!!");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    //Card
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          maxWidth: 250, maxHeight: 50),
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.6),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      //img & text
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                              "https://cdn-icons-png.flaticon.com/128/3018/3018413.png",
                                              color: Colors.white),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Manual receive now",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              if (isExpanded[index])
                                // Take picture
                                Positioned(
                                  top: 360,
                                  left: 5,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await _pickImage(index);
                                      await _uploadImage(index);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          maxWidth: 182, maxHeight: 50),
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.6),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            "https://cdn-icons-png.flaticon.com/128/711/711191.png",
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Gallary",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              // // Optionally display messages or loading indicators
                              // if (_isUploadingList[index])
                              //   CircularProgressIndicator(),
                              // if (_messageList[index] != null)
                              //   Text(
                              //     _messageList[index]!,
                              //     style: TextStyle(color: Colors.yellow),
                              //   ),

                              if (isExpanded[index])
                                //Vibrate
                                Positioned(
                                  top: 430,
                                  left: 5,
                                  //Card
                                  child: Container(
                                    height: 50,
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.8),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    //img & text
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                            "https://cdn-icons-png.flaticon.com/128/4212/4212211.png",
                                            color: Colors.white),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Vibrate",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              decoration: TextDecoration.none),
                                        ),
                                        SizedBox(
                                          width: 152,
                                        ),
                                        //Vibrate btn
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isVibrate[index] =
                                                    !isVibrate[index];
                                                print("Vibrate btn clicked!!!");
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          28)),
                                              child: Image.network(
                                                isVibrate[index]
                                                    ? "https://cdn-icons-png.flaticon.com/128/3161/3161410.png"
                                                    : "https://cdn-icons-png.flaticon.com/128/446/446163.png",
                                                color: Colors.white,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),

                              if (isExpanded[index])
                                //Delete
                                Positioned(
                                  top: 580,
                                  left: 5,
                                  //btn
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print(
                                          "Reset btn clicked!!!!!!!!!!!!!!!!");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    //Card
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          maxWidth: 130, maxHeight: 50),
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.6),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      //img & text
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                              "https://cdn-icons-png.flaticon.com/128/7134/7134699.png",
                                              color: Colors.white),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Reset",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                    )),
              )
            ],
          );
        });
  }
}
