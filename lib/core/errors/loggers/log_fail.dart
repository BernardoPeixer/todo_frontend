import 'package:http/http.dart';
import 'package:logger/logger.dart';

/// Function to show log infos in console
void logFail(Response response, String path) {
  final log = Logger();
  return log.e(
    'Error in $path',
    error: 'Status: ${response.statusCode} - ${response.reasonPhrase}',
    stackTrace: StackTrace.current,
  );
}
