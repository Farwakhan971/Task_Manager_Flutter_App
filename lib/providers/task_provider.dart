import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';
import '../services/database.helper.dart';

class TaskProvider with ChangeNotifier {
  final ApiService apiService;
  final DatabaseHelper databaseHelper;

  TaskProvider({required this.apiService, required this.databaseHelper});

  List<Task> _tasks = [];
  bool _isLoading = false;
  bool _hasMore = true;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks({int limit = 10, int skip = 0, bool isLoadMore = false}) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      List<Task> apiTasks = await apiService.fetchTasks(limit, skip);
      List<Task> localTasks = isLoadMore ? [] : await databaseHelper.getTasks();
      if (isLoadMore) {
        _tasks.addAll(apiTasks);
      } else {
        _tasks = [...localTasks, ...apiTasks];
      }
      _hasMore = apiTasks.length == limit;
    } catch (e) {
      print('Error fetching tasks: $e');
      _tasks = await databaseHelper.getTasks();
      _hasMore = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, int userId, bool completed) async {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      completed: completed,
      userId: userId,
    );

    try {
      await databaseHelper.insertTask(task);
      _tasks.insert(0, task);
      notifyListeners();
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await databaseHelper.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await databaseHelper.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
