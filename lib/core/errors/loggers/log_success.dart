import 'package:logger/logger.dart';

/// Function to show log infos in console
void logSuccess(String message, String path) {
  final log = Logger();
  return log.i(
    '$message - $path',

    time: DateTime.now(),
  );
}
