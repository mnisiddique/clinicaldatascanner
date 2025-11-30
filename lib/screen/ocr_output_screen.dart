import 'package:clinicaldatascanner/navigation/named_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const String ocrTextParam = 'ocrText';

class OcrOutputRoute extends GoRoute {
  OcrOutputRoute()
    : super(
        path: NamedRoute.ocrOutput.routePath,
        name: NamedRoute.ocrOutput.routeName,
        builder: (context, state) =>
            OcrOutputScreen(ocrText: state.uri.queryParameters[ocrTextParam]!),
      );
}

class OcrOutputScreen extends StatelessWidget {
  final String ocrText;
  const OcrOutputScreen({super.key, required this.ocrText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OCR Output Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SelectableText(
            ocrText,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
