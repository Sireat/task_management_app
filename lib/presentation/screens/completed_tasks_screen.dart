import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../widgets/task_tile.dart';

class CompletedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final completedTasks = provider.tasks.where((task) => task.isCompleted).toList();

          if (completedTasks.isEmpty) {
            return Center(
              child: Text(
                'No completed tasks yet!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
              ),
            );
          }

          return ListView.builder(
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              final task = completedTasks[index];
              return TaskTile(task: task);
            },
          );
        },
      ),
    );
  }
}
