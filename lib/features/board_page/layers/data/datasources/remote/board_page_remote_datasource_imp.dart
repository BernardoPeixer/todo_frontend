import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../../core/errors/exceptions/api_response_exception.dart';
import '../../../../../../core/errors/loggers/log_fail.dart';
import '../../../../../../core/errors/loggers/log_success.dart';
import '../../../../../../core/todo_webservice.dart';
import '../../dto/task_dto.dart';
import '../../dto/task_list_dto.dart';
import '../../dto/task_list_positions_dto.dart';
import '../../dto/task_postition_dto.dart';
import '../board_page_datasource.dart';

/// Class to make request to external server
class BoardPageRemoteDatasourceImp extends TodoWebservice
    implements BoardPageDatasource {
  @override
  Future<void> saveNewTaskList(TaskListDto taskList) async {
    try {
      final url = '$path/taskList/add';
      final uri = Uri.parse(url);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'name': taskList.name ?? '',
            'description': taskList.description ?? '',
            'position': taskList.position ?? 0,
            'status_code': 0,
            'board_id': taskList.boardId,
          },
        ),
      );

      if (response.statusCode != 200) {
        logFail(response, uri.path);
        throw ApiResponseException(response);
      }

      logSuccess('Tasks list addedd success', uri.path);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getBoardInfo(int? boardId) async {
    try {
      final url = '$path/board/getBoardInfo/$boardId';
      final uri = Uri.parse(url);

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        logFail(response, uri.path);
        throw ApiResponseException(response);
      }

      logSuccess('Get board information successfully', uri.path);
      return jsonDecode(response.body);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<void> addNewTask(TaskDto task) async {
    try {
      final url = '$path/task/add';
      final uri = Uri.parse(url);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'name': task.name ?? '',
            'description': task.description ?? '',
            'position': task.position ?? 0,
            'status_code': task.statusCode ?? 0,
            'board_id': task.boardId ?? 0,
            'task_list_id': task.listId ?? 0,
          },
        ),
      );

      if (response.statusCode != 200) {
        logFail(response, uri.path);
        throw ApiResponseException(response);
      }

      logSuccess('Task addedd successfully', uri.path);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<void> editTask(TaskDto task) async {
    try {
      final url = '$path/task/update';
      final uri = Uri.parse(url);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'id': task.id ?? 0,
            'name': task.name ?? '',
            'description': task.description ?? '',
            'board_id': task.boardId ?? 0,
          },
        ),
      );

      if (response.statusCode != 200) {
        logFail(response, uri.path);
        throw ApiResponseException(response);
      }

      logSuccess('Task update successfully', uri.path);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<void> changeListTaskPosition(TaskListPositionsDto list) async {
    try {
      final url = '$path/taskList/positionUpdate';
      final uri = Uri.parse(url);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'dragged_list_id': list.draggedItemId ?? 0,
            'target_list_id': list.targetItemId ?? 0,
            'dragged_list_pos': list.draggedItemPosition ?? 0,
            'target_list_pos': list.targetItemPosition ?? 0,
            'board_id': list.boardId ?? 0,
          },
        ),
      );

      if (response.statusCode != 200) {
        logFail(response, uri.path);
        throw ApiResponseException(response);
      }

      logSuccess('Position changed success', uri.path);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<void> changeTaskPosition(TaskPostitionDto task) async {
    try {
      final url = '$path/task/positionUpdate';
      final uri = Uri.parse(url);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': task.taskId ?? 0,
          'position': task.newPosition ?? 0,
          'list_id': task.newListId ?? 0,
          'board_id': task.boardId ?? 0,
        }),
      );

      if (response.statusCode != 200) {
        logFail(response, uri.path);
        throw ApiResponseException(response);
      }

      logSuccess('Task position changed successfully', uri.path);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<void> addNewBoard(String boardTitle) async {
    try {
      final url = '$path/board/add';
      final uri = Uri.parse(url);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'title': boardTitle,
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

  @override
  Future<List<dynamic>?> getAllBoards() async {
    try {
      final url = '$path/board/getAll';
      final uri = Uri.parse(url);

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        logFail(response, uri.path);

        throw ApiResponseException(response);
      }
      logSuccess('Get all frames success!', uri.path);
      return jsonDecode(response.body);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<void> deactivateTask(TaskDto task) async {
    try {
      final url = '$path/task/deactivate/${task.id}';
      final uri = Uri.parse(url);

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        logFail(response, uri.path);
        throw ApiResponseException(response);
      }

      logSuccess('Task deactivate successfully', uri.path);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<void> deactivateTaskList(TaskListDto? taskList) async {
    try {
      final url = '$path/taskList/deactivate/${taskList?.id}';
      final uri = Uri.parse(url);

      final response = await http.delete(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        logFail(response, uri.path);
        throw ApiResponseException(response);
      }

      logSuccess('Tasklist deactivate successfully', uri.path);
    } on Exception {
      rethrow;
    }
  }
}
