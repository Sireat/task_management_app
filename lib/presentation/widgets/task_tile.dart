import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

import '../provider/task_provider.dart';
import 'package:provider/provider.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the width of the screen
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: screenWidth * 0.04, // Adaptive margin based on screen width
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: screenWidth * 0.05, // Adaptive padding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: task.isCompleted ? Colors.green : Colors.red,
                  size: screenWidth * 0.08, // Adjust icon size
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: task.isCompleted ? Colors.grey : Colors.black,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                // Edit Button
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_edit_task', arguments: task);
                  },
                ),
                // Delete Button
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Confirmation dialog before deleting
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Task'),
                        content: Text('Are you sure you want to delete this task?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<TaskProvider>(context, listen: false).deleteTask(task);
                              Navigator.of(context).pop();
                            },
                            child: Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              task.description,
              style: TextStyle(
                fontSize: screenWidth * 0.04, // Adjust font size for description
                color: Colors.black54,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.calendar_today, size: screenWidth * 0.04, color: Colors.blueGrey),
                SizedBox(width: 4),
                Text(
                  'Due: ${task.dueDate}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035, // Responsive text size
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
