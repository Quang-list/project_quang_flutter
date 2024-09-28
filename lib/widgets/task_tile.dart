import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(Task) toggleDone;

  TaskTile({required this.task, required this.toggleDone});

  @override
  Widget build(BuildContext context) {
    DateTime deadline = DateTime.parse(task.deadline);
    DateTime now = DateTime.now();
    bool isOverdue = deadline.isBefore(now);
    String formattedDeadline = DateFormat('yyyy-MM-dd – kk:mm').format(deadline);

    Color taskColor = task.isDone
        ? Colors.green.withOpacity(0.1)
        : (isOverdue ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1));

    Icon taskIcon = task.isDone
        ? Icon(Icons.check_circle, color: Colors.green)
        : (isOverdue
        ? Icon(Icons.error, color: Colors.red)
        : Icon(Icons.schedule, color: Colors.blue));

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      color: taskColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            taskIcon,
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: task.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: 'Hạn chót: ',
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: formattedDeadline,
                          style: TextStyle(
                            color: isOverdue ? Colors.red : Colors.black54,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  if (isOverdue && !task.isDone)
                    Text(
                      'Task đã quá hạn!',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
            Checkbox(
              value: task.isDone,
              onChanged: (value) {
                toggleDone(task);
              },
            ),
          ],
        ),
      ),
    );
  }
}
