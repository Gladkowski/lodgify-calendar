import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_recruitment_test/services/base_service.dart';


@singleton
class AnalyticsService implements BaseService {
  @override
  Future<void> initialize() async {
    // Analytics service initialization
  }

  void handleFlutterError(FlutterErrorDetails details) {
    // Analytics service error handling
  }

  void handleError(Object error, StackTrace stackTrace) {
    // Analytics service error handling
  }
}
