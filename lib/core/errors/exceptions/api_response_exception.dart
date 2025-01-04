import 'package:http/http.dart';

/// Class to treat a api exception
class ApiResponseException implements Exception {

  /// API response
  final Response response;

  /// Constructor
  ApiResponseException(this.response);

  @override
  String toString() {
    return 'ApiResponseException: Status code ${response.statusCode}';
  }


}