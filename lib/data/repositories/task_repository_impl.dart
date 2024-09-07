import '../../core/error/exceptions.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getTasks() async {
    try {
      final taskModels = await localDataSource.getCachedTasks();
      return taskModels.map((model) => Task(
        id: model.id,
        title: model.title,
        description: model.description,
        dueDate: model.dueDate,
        isCompleted: model.isCompleted,
      )).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    final taskModels = tasks.map((task) => TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompleted: task.isCompleted,
    )).toList();
    await localDataSource.cacheTasks(taskModels);
  }
}
