import 'package:flutter/material.dart';
import 'package:medimate/model/data.dart';
import 'package:medimate/screen/form.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<bool> isExpanded = [];
  List<bool> isVibrate = [];

  @override
  void initState() {
    super.initState();
    isExpanded = List<bool>.filled(data.length, false);
    isVibrate = List<bool>.filled(data.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: data.length,
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
                                            height: 300,
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
                                                top: 30,
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
                                                top: 80,
                                                left: 40,
                                                width: 200,
                                                height: 70,
                                                //btn
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    TimeOfDay? pickedTime =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          data[index].alarmTime,
                                                    );
                                                    if (pickedTime != null) {
                                                      setState(() {
                                                        // อัปเดตเวลาที่เลือกกลับไปยัง data[index].alarmTime
                                                        data[index].alarmTime =
                                                            pickedTime;
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
                                                      data[index]
                                                          .alarmTime
                                                          .format(context),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 30,
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
                                      data[index].alarmTime.format(context),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 33,
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
                                              "slot ${data[index].slot} btn Pressed!");
                                        },
                                        child: Text(
                                          "slot ${data[index].slot}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize:
                                                  isExpanded[index] ? 25 : 20),
                                        ),
                                      )
                                    : Text(
                                        "slot ${data[index].slot}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
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
                                                data[index].name,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
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
                                        data[index].name,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 25),
                                      ),
                              ),
                              //doasge per time
                              if (isExpanded[index])
                                Positioned(
                                    top: 65,
                                    right: 25,
                                    child: GestureDetector(
                                      onTap: () {
                                        print(
                                            "NumTablets ${data[index].name} btn Pressed!");
                                      },
                                      child: Text(
                                        "${data[index].dosagePT}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 25),
                                      ),
                                    )),
                              //doasge per time [tablet(s)]
                              if (isExpanded[index])
                                Positioned(
                                    top: 100,
                                    right: 13,
                                    child: GestureDetector(
                                      onTap: () {
                                        print(
                                            "Tablets ${data[index].name} btn Pressed!");
                                      },
                                      child: Text(
                                        "tablet(s)",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 10),
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
                                      print("INFO clicked!!!!!!!!!!!!!!!!");
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
                                            "     ${data[index].info}",
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
                                //Take picture
                                Positioned(
                                  top: 360,
                                  left: 5,
                                  //btn
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print(
                                          "Take picture clicked!!!!!!!!!!!!!!!!");
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
                                      //Take picture img & text
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                              "https://cdn-icons-png.flaticon.com/128/711/711191.png",
                                              color: Colors.white),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Take picture",
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
                                              color: Colors.white),
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
