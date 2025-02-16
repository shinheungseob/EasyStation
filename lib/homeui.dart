import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class homeUI extends StatefulWidget {
  homeUI({
    Key? key,
    this.data,
    required this.onButtonPowerOn,
    required this.onButtonPowerOff,
  }) : super(key: key);
  final data;
  final VoidCallback onButtonPowerOn;
  final VoidCallback onButtonPowerOff;

  @override
  State<homeUI> createState() => _homeUIState();
}

class _homeUIState extends State<homeUI> {
  final box = GetStorage();
  lightOn() {}
  void showPowerOnDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('게임장 전원 제어'),
          content: Text('게임장 전원을 켜기를 원하십니까?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                widget.onButtonPowerOn();
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: Text('켜기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showPowerOffDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('게임장 전원 제어'),
          content: Text('게임장 전원을 끄기를 원하십니까?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                widget.onButtonPowerOff();
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: Text('끄기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget changeLight() {
    if (widget.data == 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.light_outlined, size: 250, color: Colors.yellow),
          SizedBox(width: 8), // 아이콘과 텍스트 간격 조절을 위해 SizedBox를 추가합니다.
          Text('현재게임장 상태'),
          Text('ON') // 여기에 원하는 텍스트를 추가합니다.
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.light_outlined, size: 250),
          SizedBox(width: 8), // 아이콘과 텍스트 간격 조절을 위해 SizedBox를 추가합니다.
          Text('현재게임장 상태'),
          Text('OFF'), // 여기에 원하는 텍스트를 추가합니다.
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        changeLight(),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: Size(100, 50)),
                onPressed: showPowerOnDialog,
                child: Text('ON')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: Size(100, 50)),
                onPressed: showPowerOffDialog,
                child: Text('OFF'))
          ],
        ))
      ],
    );
  }
}
