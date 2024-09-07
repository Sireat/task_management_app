import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

abstract class LocalDataSource {
  Future<List<TaskModel>> getCachedTasks();
  Future<void> cacheTasks(List<TaskModel> tasks);
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TaskModel>> getCachedTasks() async {
    final jsonString = sharedPreferences.getString('cached_tasks');
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => TaskModel.fromJson(e)).toList();
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final jsonList = tasks.map((task) => task.toJson()).toList();
    sharedPreferences.setString('cached_tasks', json.encode(jsonList));
  }
}
