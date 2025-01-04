import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../../../core/errors/exceptions/api_response_exception.dart';
import '../../../../../../core/errors/loggers/log_fail.dart';
import '../../../../../../core/errors/loggers/log_success.dart';
import '../../../../../../core/todo_webservice.dart';
import '../../dto/board_dto.dart';
import '../home_page_datasource.dart';

/// Class to make request to external server
class HomePageRemoteDatasourceImp extends TodoWebservice
    implements HomePageDatasource {
  @override
  Future<Either<Exception, List<dynamic>>> getAllBoards() async {
    try {
      final url = '$path/board/getAll';
      final uri = Uri.parse(url);

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        logFail(response, uri.path);
        return Left(
          throw ApiResponseException(response),
        );
      }
      logSuccess('Get all frames success!', uri.path);
      return Right(jsonDecode(response.body));
    } on ApiResponseException {
      return Left(throw Exception('Error server'));
    }
  }

  @override
  Future<void> addNewBoard(BoardDto board) async {
    try {
      final url = '$path/board/add';
      final uri = Uri.parse(url);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'title': board.title ?? '',
          },
        ),
      );

      if (response.statusCode != 200) {
        logFail(response, uri.path);
        throw ApiResponseException(response);
      }

      logSuccess('New board added success', uri.path);
    } on ApiResponseException {
      throw Exception('Error');
    }
  }
}
