import 'package:clinicaldatascanner/screen/analysis_screen.dart';
import 'package:clinicaldatascanner/screen/document_scan_screen.dart';
import 'package:clinicaldatascanner/screen/ocr_output_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class AppRouter {
  final GoRouter _routerConfig;
  GoRouter get config => _routerConfig;

  AppRouter._init(this._routerConfig);

  factory AppRouter() {
    return _appRouter;
  }

  static final AppRouter _appRouter = AppRouter._init(
    GoRouter(
      routes: [
        DocScanRoute(),
        OcrOutputRoute(),
        AnalysisRoute(),
       
      ],
    ),
  );
}
