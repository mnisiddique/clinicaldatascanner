// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart' as _i225;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../doc_scanner/doc_scanner.dart' as _i338;
import '../documant_analyzer/document_analyzer.dart' as _i146;
import '../documant_analyzer/gemni_service/analyzer/gemni_analyzer.dart'
    as _i583;
import '../documant_analyzer/gemni_service/api/gemni_api_service.dart' as _i327;
import '../documant_analyzer/gemni_service/response/gemni_response_model.dart'
    as _i989;
import '../documant_analyzer/open_ai_service/analyzer/gpt_analyzer.dart'
    as _i738;
import '../documant_analyzer/open_ai_service/api_service/open_ai_api_service.dart'
    as _i726;
import '../documant_analyzer/open_ai_service/response/open_ai_response_model.dart'
    as _i518;
import '../image_preprocessor/image_processor.dart' as _i146;
import '../ocr/ocr_service.dart' as _i290;
import '../ocr/ocr_strategy.dart' as _i514;
import 'module_registry.dart' as _i544;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i146.ImageProcessor>(() => _i146.ImageProcessor());
    gh.factory<_i225.FlutterDocScanner>(() => registerModule.docScanner);
    gh.factory<_i361.Dio>(() => registerModule.chatGptDio);
    gh.factory<_i290.OCRService>(
      () => _i290.TessaractBenOnlyImpl(),
      instanceName: 'TessaractBenOnlyImpl',
    );
    gh.factory<_i290.OCRService>(
      () => _i290.GoogleMLKitImpl(),
      instanceName: 'GoogleMLKitImpl',
    );
    gh.factory<_i327.GemniApiService>(
      () => _i327.GemniApiService(gh<_i361.Dio>()),
    );
    gh.factory<_i726.OpenAiApiService>(
      () => _i726.OpenAiApiService(gh<_i361.Dio>()),
    );
    gh.factory<_i146.DocumentAnalyzer<_i989.GemniResponseModel>>(
      () => _i583.GemniAnalyzer(gemniApiService: gh<_i327.GemniApiService>()),
    );
    gh.factory<_i338.DocScanner>(() => _i338.DocScannerImpl());
    gh.factory<_i290.OCRService>(
      () => _i290.TessaractImpl(),
      instanceName: 'TessaractImpl',
    );
    gh.factory<_i146.DocumentAnalyzer<_i518.OpenAiResponseModel>>(
      () =>
          _i738.ChatGPTAnalyzer(openAiApiService: gh<_i726.OpenAiApiService>()),
    );
    gh.factory<_i514.OcrStrategy>(
      () => _i514.OcrStrategyImpl(
        mlkitService: gh<_i290.OCRService>(instanceName: 'GoogleMLKitImpl'),
        tessaractOcrService: gh<_i290.OCRService>(
          instanceName: 'TessaractImpl',
        ),
        tessaractBenOcrService: gh<_i290.OCRService>(
          instanceName: 'TessaractBenOnlyImpl',
        ),
        imageProcessor: gh<_i146.ImageProcessor>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i544.RegisterModule {}
