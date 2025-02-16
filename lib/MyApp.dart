import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sibar/camera.dart';
import 'homeui.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? selectedTime;
  var tab = 0;
  var data; // 0x0000001
  final box = GetStorage();
  late Timer _timer;

  String extractTimeFromNtime(String ntime) {
    // ntime 문자열에서 시간 부분만 추출
    String timeString = ntime.substring(11);
    List<String> timeParts = timeString.split(':');
    String formattedTime = '${timeParts[0]}:${timeParts[1]}:${timeParts[2]}';
    return formattedTime;
  }

  getData() async {
    var result = await http.get(
        Uri.parse('https://heung0427.mycafe24.com/iot_update.php?device=1'));
    var result2 = jsonDecode(result.body);
    print(result.body);
    var newData = result2['light'];
    if (newData != data) {
      setState(() {
        data = newData;
        box.write('data', data);
      });
    }
  }

  TimeOfDay _starttime = TimeOfDay(hour: 0, minute: 00);
  TimeOfDay _endttime = TimeOfDay(hour: 0, minute: 00);
  void _stTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _starttime,
    );
    if (newTime != null) {
      setState(() {
        _starttime = newTime;
      });
      var stime = await http.get(Uri.parse(
          'https://heung0427.mycafe24.com/iot_update.php?device=1&stime=' +
              '$_starttime'));
      print(_starttime);
    }
    _etTime();
  }

  TimeOfDay _endtime = TimeOfDay(hour: 0, minute: 00);
  void _etTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _endtime,
    );
    if (newTime != null) {
      setState(() {
        _endtime = newTime;
      });
      var etime = await http.get(Uri.parse(
          'https://heung0427.mycafe24.com/iot_update.php?device=1&stime=' +
              '$_endtime'));
      print(_endtime);
    }
  }

  void sendDataOff() async {
    var x = await http.get(Uri.parse(
        'https://heung0427.mycafe24.com/iot_update.php?device=1&light=0'));
    print(x.body);
  }

  void sendDataOn() async {
    var x = await http.get(Uri.parse(
        'https://heung0427.mycafe24.com/iot_update.php?device=1&light=1'));
    print(x.body);
  }

  void disposeChage() {
    box.listenKey('data', (value) {
      if (value == 1) {
        Get.snackbar('게임장', '전원이 성공적으로 켜졌습니다');
      } else if (value == 0) {
        Get.snackbar('게임장', '전원이 성공적으로 꺼졌습니다');
      } else {
        Get.snackbar('인터넷', '문제입니다');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    disposeChage();
    getData();
    _timer = Timer.periodic(Duration(seconds: 5), _incrementCounter);
  }

  void _incrementCounter(Timer timer) {
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  void changeTab(int value) {
    setState(() {
      tab = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: style.theme,
        home: Scaffold(
          appBar: AppBar(
            actions: [
              ElevatedButton(
                  onPressed: () {
                    _stTime();
                  },
                  child: Text('예약 `$_starttime ~ $_endtime'))
            ],
            title: Text('IOT 제어센터'),
          ),
          floatingActionButton: FloatingActionButton(
            child: Text('+'),
            onPressed: () {
              Get.snackbar('고장 문의', '010-8954-9098');
            },
          ),
          body: [
            homeUI(
              data: data,
              onButtonPowerOff: () => sendDataOff(),
              onButtonPowerOn: () => sendDataOn(),
            ),
            cameraUi()
          ][tab],
          bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => changeTab(0),
                    icon: Icon(
                      Icons.home_outlined,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () => changeTab(1),
                    icon: Icon(
                      Icons.camera,
                      size: 25,
                    ),
                  ),
                ],
              ),
              height: 50),
        ));
  }
}
