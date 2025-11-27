import 'dart:typed_data' show Uint8List;

import 'package:clinicaldatascanner/core/doc_scanner/doc_scanner.dart';
import 'package:clinicaldatascanner/core/image_preprocessor/image_processor.dart';
import 'package:clinicaldatascanner/core/injector/injector.dart';
import 'package:clinicaldatascanner/main.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageProcessorWidget extends StatefulWidget {
  const ImageProcessorWidget({super.key});

  @override
  State<ImageProcessorWidget> createState() => _ImageProcessorWidgetState();
}

class _ImageProcessorWidgetState extends State<ImageProcessorWidget> {
  late final ImageProcessor imageProcessor;
  late final DocScanner docScanner;

  bool isProcessing = false;
  Uint8List? processedImage;

  @override
  void initState() {
    imageProcessor = getIt<ImageProcessor>();
    docScanner = getIt<DocScanner>();
    super.initState();
  }

  Uint8List convertToUint8List(img.Image image) {
    final pngBytes = img.encodePng(image);
    return Uint8List.fromList(pngBytes);
  }

  void scanDocument() async {
    // Example usage of imageProcessor
    final paths = await docScanner.scanDoc(1);

    if (paths.isEmpty) return;
    // Do something with processedImage
    setState(() {
      isProcessing = true;
    });
    final processedImg = await imageProcessor.removeBg(paths.first);
    if (processedImg == null) {
      setState(() {
        isProcessing = false;
      });
      return;
    }
    final bytes = convertToUint8List(processedImg);
    setState(() {
      processedImage = bytes;
      isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Image Processing Test"),
      ),
      body: isProcessing
          ? LoadingWidget(message: "Processing image...")
          : processedImage != null
          ? Image.memory(processedImage!, fit: BoxFit.contain)
          : Center(child: Text("No image processed yet.")),
      floatingActionButton: FloatingActionButton(
        onPressed: scanDocument,
        tooltip: 'Scan Document',
        child: const Icon(Icons.add),
      ),
    );
  }
}
