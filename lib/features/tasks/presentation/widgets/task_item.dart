import 'package:flutter/material.dart';
import '../../../../core/models/task_model.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskItem({
    super.key,
    required this.task,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = task.status == TaskStatus.completed ? Colors.green
        : task.status == TaskStatus.overdue ? Colors.red
        : Colors.blue;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(
          '${task.deadline.toLocal()}'.split(' ')[0],
        ),
        trailing: Icon(Icons.circle, color: color, size: 12),
        onTap: onTap,
      ),
    );
  }
}
