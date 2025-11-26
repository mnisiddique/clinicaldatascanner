import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:tflite_flutter/tflite_flutter.dart';


const String kEasyOcrDetectorInterpreter = "EasyOcrDetector";
const String kEasyOcrRecognizerInterpreter = "EasyOcrRecognizer";
const String kBnChars = "BnChars";

@module
abstract class RegisterModule {
  FlutterDocScanner get docScanner => FlutterDocScanner();
  Dio get chatGptDio => Dio();

  @preResolve
  @lazySingleton
  @Named(kEasyOcrDetectorInterpreter)
  Future<Interpreter> get detectorInterpreter async =>  await Interpreter.fromAsset(
      'assets/models/easyocr-easyocrdetector.tflite',
    );
  
  @preResolve
  @lazySingleton
  @Named(kEasyOcrRecognizerInterpreter)
  Future<Interpreter> get recognizerInterpreter async =>  await Interpreter.fromAsset(
      'assets/models/easyocr-easyocrrecognizer.tflite',
    );
  
  @preResolve
  @lazySingleton
  @Named(kBnChars)
  Future<List<String>> get bnChars async =>   rootBundle.loadString("assets/txts/bn_char.txt").then((data) => data.split(''));
}
