import 'package:flutter/material.dart';
import '../../core/services/notification_service.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository taskRepository;
  final NotificationService notificationService;

  TaskProvider({
    required this.taskRepository,
    required this.notificationService,
  }) {
    _initializeTasks();
  }

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  // Initialize tasks from the local storage when the provider is created
  Future<void> _initializeTasks() async {
    try {
      _tasks = await taskRepository.getTasks();
      notifyListeners();
    } catch (e) {
      // Handle error (e.g., log it or show a message)
    }
  }

  // Fetch tasks from the repository
  Future<void> fetchTasks() async {
    try {
      _tasks = await taskRepository.getTasks();
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  // Add a new task to the list and save it to the repository
  Future<void> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required bool isCompleted,
  }) async {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID based on timestamp
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: isCompleted,
    );
    _tasks.add(newTask);
    try {
      await taskRepository.saveTasks(_tasks);

      if (!isCompleted) {
        final currentTime = DateTime.now();
        final difference = dueDate.difference(currentTime);
        if (difference.inMinutes <= 60 && difference.inMinutes > 0) {
          await notificationService.showNotification(
            int.parse(newTask.id),  // Ensure this ID is used correctly
            'Task Reminder',
            'Your task "$title" is due soon!',
            dueDate,
          );
        }
      }
    } catch (e) {
      // Handle error
    }
    notifyListeners();
  }

  // Edit an existing task and update the repository
  Future<void> editTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      try {
        await taskRepository.saveTasks(_tasks);

        if (!updatedTask.isCompleted) {
          final currentTime = DateTime.now();
          final difference = updatedTask.dueDate.difference(currentTime);
          if (difference.inMinutes <= 60 && difference.inMinutes > 0) {
            await notificationService.showNotification(
              int.parse(updatedTask.id),  // Ensure this ID is used correctly
              'Task Reminder',
              'Your task "${updatedTask.title}" is due soon!',
              updatedTask.dueDate,
            );
          }
        }
      } catch (e) {
        // Handle error
      }
      notifyListeners();
    }
  }

  // Delete a task from the list and update the repository
  Future<void> deleteTask(Task task) async {
    _tasks.removeWhere((t) => t.id == task.id);
    try {
      await taskRepository.saveTasks(_tasks);
    } catch (e) {
      // Handle error
    }
    notifyListeners();
  }
}
