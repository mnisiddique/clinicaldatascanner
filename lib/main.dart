import 'package:clinicaldatascanner/core/documant_analyzer/document_analyzer.dart';
import 'package:clinicaldatascanner/core/injector/injector.dart';
import 'package:clinicaldatascanner/core/doc_scanner/doc_scanner.dart';
import 'package:clinicaldatascanner/core/ocr/ocr_strategy.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clicnical Data Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Clicnical Data Scanner Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String scannedText = "07";
  String loadingMessage = "";
  String category = "";
  String summary = "";
  String data = "";

  late final DocScanner docScanner;
  late final OcrStrategy ocrStrategy;
  late final DocumentAnalyzer docAnalyzer;
  @override
  void initState() {
    docScanner = getIt<DocScanner>();
    ocrStrategy = getIt<OcrStrategy>();
    docAnalyzer = getIt<DocumentAnalyzer>(instanceName: "ChatGPTAnalyzer");
    super.initState();
  }

  void _incrementCounter() async {
    final paths = await docScanner.scanDoc(1);

    if (paths.isEmpty) return;

    setState(() {
      loadingMessage = "Scaaning Document...";
      category = "";
      summary = "";
      data = "";
    });

    final ocrText = await ocrStrategy.ocrText(paths.first);

    setState(() {
      loadingMessage = "Analzing Document...";
      category = "";
      summary = "";
      data = "";
    });
    final analyzedText = await docAnalyzer.analyze(ocrText);

    setState(() {
      loadingMessage = "";
      category = analyzedText.category;
      summary = analyzedText.summary;
      data = analyzedText.structuredData.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent = SizedBox();
    if (loadingMessage.isNotEmpty) {
      bodyContent = LoadingWidget(message: loadingMessage);
    } else if (data.isNotEmpty) {
      bodyContent = AnalysisOutputWidget(
        category: category,
        summary: summary,
        data: data,
      );
    } else {
      bodyContent = Center(
        child: Text(
          'Press the button to scan a document',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: bodyContent,
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          const Gap(16),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class AnalysisOutputWidget extends StatelessWidget {
  const AnalysisOutputWidget({
    super.key,
    required this.category,
    required this.summary,
    required this.data,
  });

  final String category;
  final String summary;
  final String data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              'Prescription',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              "Blood tests including RBS, CBC, SGPT.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Gap(32),
            SelectableText(data, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
