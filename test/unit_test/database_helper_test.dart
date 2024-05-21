import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/services/database.helper.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  TestWidgetsFlutterBinding.ensureInitialized();
  late DatabaseHelper databaseHelper;

  setUp(() {
    databaseHelper = DatabaseHelper();
  });

  test('insertTask inserts a task into the database', () async {
    final task = Task(id: 1, title: 'Do something nice for someone I care about', completed: true, userId: 26);
    await databaseHelper.insertTask(task);

    final tasks = await databaseHelper.getTasks();
    expect(tasks.first.title, 'Do something nice for someone I care about');
  });

  test('getTasks retrieves all tasks from the database', () async {
    final task1 = Task(id: 1, title: 'Do something nice for someone I care about', completed: true, userId: 26);

    await databaseHelper.insertTask(task1);

    final tasks = await databaseHelper.getTasks();
    expect(tasks.length, 2);
    expect(tasks[0].title, 'Do something nice for someone I care about');
  });

  test('updateTask updates a task in the database', () async {
    final task = Task(id: 1, title: 'Do something nice for someone I care about', completed: true, userId: 26);
    await databaseHelper.insertTask(task);

    final updatedTask = Task(id: 1, title: 'Updated Task', completed: true, userId: 26);
    await databaseHelper.updateTask(updatedTask);

    final tasks = await databaseHelper.getTasks();
    expect(tasks.first.title, 'Updated Task');
    expect(tasks.first.completed, true);
  });

  test('deleteTask deletes a task from the database', () async {
    final task = Task(id: 1, title: 'Do something nice for someone I care about', completed: true, userId: 26);
    await databaseHelper.insertTask(task);

    await databaseHelper.deleteTask(task.id);

    final tasks = await databaseHelper.getTasks();
    expect(tasks.length, 1);
  });
}
