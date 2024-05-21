import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../providers/auth_provider.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _scrollController = ScrollController();
  final _taskTitleController = TextEditingController();
  bool _isLoadingMore = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        _loadMoreTasks();
      }
    });
  }

  Future<void> _loadMoreTasks() async {
    if (_isLoadingMore) return;

    _isLoadingMore = true;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    await taskProvider.fetchTasks(limit: 10, skip: taskProvider.tasks.length, isLoadMore: true);
    _isLoadingMore = false;
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[900]!,
          title: const Text(
            'Tasks',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            if (taskProvider.isLoading && taskProvider.tasks.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[900]!),
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: taskProvider.tasks.length + 1,
                    itemBuilder: (context, index) {
                      if (index == taskProvider.tasks.length) {
                        return taskProvider.isLoading
                            ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[900]!),
                            ),
                          ),
                        )
                            : SizedBox.shrink();
                      }
                      Task task = taskProvider.tasks[index];
                      return ListTile(
                        title: Text(
                          task.title.isNotEmpty ? task.title : 'No Title',
                          style: task.completed
                              ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)
                              : const TextStyle(),
                        ),
                        trailing: Checkbox(
                          value: task.completed,
                          onChanged: (bool? value) {
                            if (value != null) {
                              int userId = Provider.of<AuthProvider>(context, listen: false).user!.id;
                              Task updatedTask = Task(
                                id: task.id,
                                title: task.title,
                                completed: value,
                                userId: userId,
                              );
                              Provider.of<TaskProvider>(context, listen: false).updateTask(updatedTask);
                            }
                          },
                          activeColor: Colors.orange[900],
                        ),
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Task'),
                              content: const Text('Are you sure you want to delete this task?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Yes'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.orange[900],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('No'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.orange[900],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                bool isCompleted = false;
                TextEditingController _taskTitleController = TextEditingController();

                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text('Add Task'),
                      backgroundColor: Colors.white,
                      elevation: 24.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Theme(
                            data: ThemeData(
                              textSelectionTheme: TextSelectionThemeData(
                                cursorColor: Colors.orange[900],
                                selectionColor: Colors.orange[200],
                                selectionHandleColor: Colors.orange[900],
                              ),
                            ),
                            child: TextField(
                              controller: _taskTitleController,
                              decoration: InputDecoration(
                                labelText: 'Task',
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange[900]!),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              cursorColor: Colors.orange[900],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          CheckboxListTile(
                            title: const Text('Completed'),
                            value: isCompleted,
                            onChanged: (bool? value) {
                              setState(() {
                                isCompleted = value ?? false;
                              });
                            },
                            activeColor: Colors.orange[900],
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (_taskTitleController.text.isNotEmpty) {
                              int userId = Provider.of<AuthProvider>(context, listen: false).user!.id;
                              Provider.of<TaskProvider>(context, listen: false).addTask(
                                _taskTitleController.text,
                                userId,
                                isCompleted,
                              );
                              _taskTitleController.clear();
                              Navigator.of(context).pop();
                              _scrollToTop();
                            }
                          },
                          child: Text('Add'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.orange[900],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.orange[900],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          backgroundColor: Colors.orange[900],
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
