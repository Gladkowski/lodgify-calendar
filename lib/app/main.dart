import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile_recruitment_test/app/recruitment_app.dart';
import 'package:mobile_recruitment_test/di/di.dart';
import 'package:mobile_recruitment_test/services/analytics_service.dart';
import 'package:mobile_recruitment_test/services/base_service.dart';

Future<void> main() async => runZonedGuarded(
  () async {
    WidgetsFlutterBinding.ensureInitialized();
    configureDependencies();

    // initialize essential services
    final List<BaseService> services = [inject<AnalyticsService>()];
    await Future.wait(services.map((service) => service.initialize()));

    // handle framework errors
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      previousOnError?.call(details);

      inject.get<AnalyticsService>().handleFlutterError(details);
    };

    // handle platform errors
    PlatformDispatcher.instance.onError = (error, stack) {
      inject.get<AnalyticsService>().handleError(error, stack);

      return true;
    };

    runApp(const RecruitmentApp());
  },
  // handle async errors
  (error, stackTrace) {
    inject.get<AnalyticsService>().handleError(error, stackTrace);
  },
);
