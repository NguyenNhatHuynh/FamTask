import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/task_model.dart';
import '../../../../core/providers/app_providers.dart';

class TaskDetailScreen extends ConsumerWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksNotifier = ref.read(tasksProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết công việc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              await tasksNotifier.completeTask(task.id);
              if (context.mounted) Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await tasksNotifier.deleteTask(task.id);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Tên: ${task.title}', style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 8),
            Text('Mô tả: ${task.description}'),
            const SizedBox(height: 8),
            Text('Deadline: ${task.deadline.toLocal()}'.split(' ')[0]),
            const SizedBox(height: 8),
            Text('Điểm: ${task.points}'),
            const SizedBox(height: 8),
            Text('Trạng thái: ${task.status.name}'),
          ],
        ),
      ),
    );
  }
}
