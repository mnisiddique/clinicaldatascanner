import 'dart:io';

import 'package:clinicaldatascanner/core/doc_scanner/doc_scanner.dart';
import 'package:clinicaldatascanner/core/injector/injector.dart';
import 'package:clinicaldatascanner/core/ocr/ocr_strategy.dart';
import 'package:clinicaldatascanner/main.dart';
import 'package:clinicaldatascanner/navigation/named_route.dart';
import 'package:clinicaldatascanner/screen/ocr_output_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DocScanRoute extends GoRoute {
  DocScanRoute()
    : super(
        path: NamedRoute.documentScan.routePath,
        name: NamedRoute.documentScan.routeName,
        builder: (context, state) => DocScannerScreen(),
      );
}

class DocScannerScreen extends StatefulWidget {
  const DocScannerScreen({super.key});

  @override
  State<DocScannerScreen> createState() => _DocScannerScreenState();
}

class _DocScannerScreenState extends State<DocScannerScreen> {
  String _imagePath = "";
  bool _isLoading = false;
  OcrEngine _ocrEngine = OcrEngine.mlKit;
  late final DocScanner docScanner;

  @override
  void initState() {
    docScanner = getIt<DocScanner>();
    super.initState();
  }

  void scanDocument() async {
    final paths = await docScanner.scanDoc(1);
    if (paths.isNotEmpty) {
      setState(() {
        _imagePath = paths.first;
      });
    }
  }

  String getLoadingMessage() {
    switch (_ocrEngine) {
      case OcrEngine.mlKit:
        return 'Extracting text using ML Kit...';
      case OcrEngine.tessaract:
        return 'Extracting text using Tessaract...';
      case OcrEngine.combined:
        return 'Extracting text using ML Kit and Tessaract...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Document Scanner')),
      body: _imagePath.isEmpty
          ? const Center(child: Text('Scan Document'))
          : Stack(
              children: [
                Center(
                  child: InkWell(
                    onTap: () async {
                      final engine = await showModalBottomSheet<OcrEngine>(
                        context: context,
                        builder: (context) => const OcrOptions(),
                      );

                      if (engine != null) {
                        final ocrStrategy = getIt<OcrStrategy>();
                        goToOcrOutputScreen(String text) {
                          context.pushNamed(
                            NamedRoute.ocrOutput.routeName,
                            queryParameters: {ocrTextParam: text},
                          );
                        }

                        setState(() {
                          _isLoading = true;
                          _ocrEngine = engine;
                        });
                        final ocrResult = await ocrStrategy.ocrText(
                          _imagePath,
                          engine,
                        );
                        goToOcrOutputScreen(ocrResult.text);
                      }
                    },
                    child: Image.file(File(_imagePath), fit: BoxFit.contain),
                  ),
                ),

                _isLoading
                    ? LoadingWidget(message: getLoadingMessage())
                    : SizedBox.shrink(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.scanner_sharp),
      ),
    );
  }
}

class OcrOptions extends StatelessWidget {
  const OcrOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => context.pop(OcrEngine.mlKit),
          child: const Text('ML kit'),
        ),
        ElevatedButton(
          onPressed: () => context.pop(OcrEngine.tessaract),
          child: const Text('Tessaract'),
        ),
        ElevatedButton(
          onPressed: () => context.pop(OcrEngine.combined),
          child: const Text('MLkit + Tessaract'),
        ),
      ],
    );
  }
}
