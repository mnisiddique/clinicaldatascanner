import 'package:clinicaldatascanner/navigation/named_route.dart';
import 'package:clinicaldatascanner/screen/ocr_output_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnalysisRoute extends GoRoute {
  AnalysisRoute()
    : super(
        path: NamedRoute.analysis.routePath,
        name: NamedRoute.analysis.routeName,
        builder: (context, state) =>
            OcrOutputScreen(ocrText: state.uri.queryParameters[ocrTextParam]!),
      );
}

class AnalysisScreen extends StatefulWidget {
  final String ocrText;
  const AnalysisScreen({super.key, required this.ocrText});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            widget.ocrText,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}