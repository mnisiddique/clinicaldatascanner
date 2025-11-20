
import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';

abstract class DocScanner {
  Future<List<String>> scanDoc(int? pageNumber);
}

class DocScannerImpl implements DocScanner {
  List<String> parsePath(String raw) {
    final regex = RegExp(r'imageUri=([^}]+?\.jpg)');
    final matches = regex.allMatches(raw);

    final paths = matches.map((m) => m.group(1)!.trim()).toList();

    return paths;
  }

  @override
  Future<List<String>> scanDoc(int? pageNumber) async {
    // Implementation for scanning the document at the given page number
    dynamic scannedDocuments;
    int numberOfPages = pageNumber ?? 1;
    final flutterDocScanner = FlutterDocScanner();
    try {
      scannedDocuments =
          await flutterDocScanner.getScannedDocumentAsImages(
            page: numberOfPages,
          ) ??
          'Unknown platform documents';
    } on PlatformException {
      scannedDocuments = 'Failed to get scanned documents.';
    }

    return parsePath(scannedDocuments.toString());
  }
}

DocScanner get docScanner => DocScannerImpl();
