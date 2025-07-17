import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:famtask/core/models/task_model.dart';
import 'package:famtask/core/providers/app_providers.dart';
import 'package:famtask/routes/route_names.dart';
import 'package:go_router/go_router.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công việc'),
        backgroundColor: const Color(0xFFF5F5F7),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter options (e.g., by status, date)
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Công việc theo trạng thái',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 15),
            _buildTaskCategory(tasks.where((t) => t.status == TaskStatus.pending).toList(), 'Chưa hoàn thành', const Color(0xFFE8F3FF), const Color(0xFF4A90E2)),
            const SizedBox(height: 12),
            _buildTaskCategory(tasks.where((t) => t.status == TaskStatus.inProgress).toList(), 'Đang thực hiện', const Color(0xFFE8F0FF), const Color(0xFF6B46C1)),
            const SizedBox(height: 12),
            _buildTaskCategory(tasks.where((t) => t.status == TaskStatus.completed).toList(), 'Đã hoàn thành', const Color(0xFFE0FFE8), const Color(0xFF2ECC71)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteNames.addTask),
        backgroundColor: const Color(0xFF6B46C1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTaskCategory(List<Task> tasks, String title, Color bgColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
          const SizedBox(height: 10),
          ...tasks.map((task) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(task.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                subtitle: Text(
                  'Deadline: ${DateFormat('dd/MM/yyyy').format(task.deadline)} - ${task.points} điểm',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onPressed: () => context.push('${RouteNames.taskDetail}/${task.id}'),
                ),
              )),
        ],
      ),
    );
  }
}