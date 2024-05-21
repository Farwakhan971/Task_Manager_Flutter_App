import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/task_provider.dart';
import '../mocks/mocks.mocks.dart';

void main() {
  late TaskProvider taskProvider;
  late MockApiService mockApiService;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockApiService = MockApiService();
    mockDatabaseHelper = MockDatabaseHelper();
    taskProvider = TaskProvider(apiService: mockApiService, databaseHelper: mockDatabaseHelper);
  });

  group('TaskProvider', () {
    test('fetchTasks fetches tasks from API and local database', () async {
      final apiTasks = [
        Task(id: 1, title: 'Do something nice for someone I care about', completed: true, userId: 26),
        Task(id: 127, title: 'Prepare a dish from a foreign culture', completed: false, userId: 7),
      ];
      final localTasks = [
        Task(id: 3, title: 'Local Task 1', completed: false, userId: 2),
      ];

      when(mockApiService.fetchTasks(10, 0)).thenAnswer((_) async => apiTasks);
      when(mockDatabaseHelper.getTasks()).thenAnswer((_) async => localTasks);

      await taskProvider.fetchTasks();

      expect(taskProvider.tasks.length, 3);
      expect(taskProvider.tasks[0].title, 'Local Task 1');
      expect(taskProvider.tasks[1].title, 'Do something nice for someone I care about');
      expect(taskProvider.tasks[2].title, 'Prepare a dish from a foreign culture');
    });

    test('fetchTasks appends tasks when isLoadMore is true', () async {
      final apiTasks = [
        Task(id: 1, title: 'Do something nice for someone I care about', completed: true, userId: 26),
        Task(id: 127, title: 'Prepare a dish from a foreign culture', completed: false, userId: 7),
      ];

      when(mockApiService.fetchTasks(10, 0)).thenAnswer((_) async => apiTasks);
      when(mockDatabaseHelper.getTasks()).thenAnswer((_) async => []);

      await taskProvider.fetchTasks(isLoadMore: true);

      expect(taskProvider.tasks.length, 2);
      expect(taskProvider.tasks[0].title, 'Do something nice for someone I care about');
      expect(taskProvider.tasks[1].title, 'Prepare a dish from a foreign culture');
    });

    test('addTask adds a new task to the local database and updates the provider', () async {
      final newTask = Task(id: 1, title: 'New Task', completed: false, userId: 1);

      when(mockDatabaseHelper.insertTask(any)).thenAnswer((_) async => 1);

      await taskProvider.addTask(newTask.title, newTask.userId, newTask.completed);

      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks[0].title, 'New Task');
    });

    test('updateTask updates the task in the local database and provider', () async {
      final existingTask = Task(id: 1, title: 'Existing Task', completed: false, userId: 1);
      taskProvider.tasks.add(existingTask);

      final updatedTask = Task(id: 1, title: 'Updated Task', completed: true, userId: 1);

      when(mockDatabaseHelper.updateTask(updatedTask)).thenAnswer((_) async => 1);

      await taskProvider.updateTask(updatedTask);

      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks[0].title, 'Updated Task');
      expect(taskProvider.tasks[0].completed, true);
    });

    test('deleteTask removes the task from the local database and provider', () async {
      final existingTask = Task(id: 1, title: 'Existing Task', completed: false, userId: 1);
      taskProvider.tasks.add(existingTask);

      when(mockDatabaseHelper.deleteTask(1)).thenAnswer((_) async => 1);

      await taskProvider.deleteTask(1);

      expect(taskProvider.tasks.length, 0);
    });
  });
}
