import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<void> saveTasks(List<Task> tasks);
}
