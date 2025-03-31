import 'package:flutter/foundation.dart';

void log(String value, {Level level = Level.info}) {
  switch(level) {
    case Level.error:
      if (kDebugMode) {
        print('EnoughHtmlEditor|ERROR:: $value');
      }
      break;
    case Level.info:
      if (kDebugMode) {
        print('EnoughHtmlEditor|INFO:: $value');
      }
      break;
  }
}

void logError(String value) => log(value, level: Level.error);

enum Level {
  info,
  error
}