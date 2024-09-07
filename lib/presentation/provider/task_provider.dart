import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository taskRepository;

  TaskProvider({required this.taskRepository}) {
    // Fetch tasks when the provider is created to ensure persistence
    _initializeTasks();
  }

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  // Initialize tasks from the local storage when the provider is created
  Future<void> _initializeTasks() async {
    await fetchTasks(); // Load tasks from storage
  }

  // Fetch tasks from the repository
  Future<void> fetchTasks() async {
    _tasks = await taskRepository.getTasks();
    notifyListeners();
  }

  // Add a new task to the list and save it to the repository
  Future<void> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required bool isCompleted,
  }) async {
    final newTask = Task(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: isCompleted,
    );
    _tasks.add(newTask);
    await taskRepository.saveTasks(_tasks);
    notifyListeners();
  }

  // Edit an existing task and update the repository
  Future<void> editTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      await taskRepository.saveTasks(_tasks);
      notifyListeners();
    }
  }

  // Delete a task from the list and update the repository
  Future<void> deleteTask(Task task) async {
    _tasks.removeWhere((t) => t.id == task.id);
    await taskRepository.saveTasks(_tasks);
    notifyListeners();
  }
}