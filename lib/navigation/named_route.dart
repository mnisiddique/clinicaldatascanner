enum NamedRoute {
  analysis('Analysis'),
  ocrOutput('ocr-output'),
  documentScan('');

  final String _routeName;
  const NamedRoute(this._routeName);

  String get routePath => '/$_routeName';
  String get routeName => _routeName.isEmpty ? '/' : _routeName;
}
