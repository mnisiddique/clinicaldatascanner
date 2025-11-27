import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

@module
abstract class RegisterModule {
  FlutterDocScanner get docScanner => FlutterDocScanner();
  Dio get chatGptDio => Dio();
}
