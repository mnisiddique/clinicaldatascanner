import 'dart:io';

import 'package:clinicaldatascanner/core/doc_scanner/doc_scanner.dart';
import 'package:clinicaldatascanner/core/injector/injector.dart';
import 'package:clinicaldatascanner/navigation/named_route.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Document Scanner')),
      body: _imagePath.isEmpty
          ? const Center(child: Text('Scan Document'))
          : Center(child: Image.file(File(_imagePath), fit: BoxFit.contain)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.scanner_sharp),
      ),
    );
  }
}
