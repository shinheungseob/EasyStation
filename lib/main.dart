import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'homeui.dart';
import 'MyApp.dart';
import 'style.dart' as style;
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() async{
  await GetStorage.init();
  runApp(
    GetMaterialApp(

        home: MyApp()
    )
);}


