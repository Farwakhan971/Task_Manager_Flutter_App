import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/task.dart';
import '../models/user.dart';

class ApiService {
  final String baseUrl = 'https://dummyjson.com';

  Future<List<Task>> fetchTasks(int limit, int skip) async {
    final response = await http.get(Uri.parse('$baseUrl/todos?limit=$limit&skip=$skip'));

    if (response.statusCode == 200) {
      try {
        var responseBody = json.decode(response.body);
        if (responseBody is Map && responseBody.containsKey('todos')) {
          List<dynamic> data = responseBody['todos'];
          return data.map((json) => Task.fromJson(json)).toList();
        } else {
          throw FormatException('Unexpected JSON format');
        }
      } catch (e) {
        print('Error decoding response: $e');
        print('Response body: ${response.body}');
        throw Exception('Failed to decode tasks');
      }
    } else {
      print('Failed to fetch tasks. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> addTask(String title, int userId, bool completed) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'todo': title, 'userId': userId, 'completed': completed}),
    );

    if (response.statusCode == 200) {
      try {
        return Task.fromJson(json.decode(response.body));
      } catch (e) {
        print('Error decoding response: $e');
        print('Response body: ${response.body}');
        throw Exception('Failed to decode added task');
      }
    } else {
      print('Failed to add task. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to add task');
    }
  }

  Future<void> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode != 200) {
      print('Failed to update task. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/todos/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      try {
        json.decode(response.body);
      } catch (e) {
        print('Error decoding response: $e');
        print('Response body: ${response.body}');
        throw Exception('Failed to decode deleted task');
      }
    } else {
      print('Failed to delete task. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to delete task');
    }
  }

  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      try {
        return User.fromJson(json.decode(response.body));
      } catch (e) {
        print('Error decoding response: $e');
        print('Response body: ${response.body}');
        throw Exception('Failed to decode user');
      }
    } else {
      print('Failed to login. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }
}

