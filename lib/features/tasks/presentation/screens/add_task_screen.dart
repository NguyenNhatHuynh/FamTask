import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/task_model.dart';
import '../../../../core/providers/app_providers.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String? assignedUserId;
  DateTime? deadline;
  int points = 0;
  TaskType taskType = TaskType.oneTime;
  RecurrenceType? recurrenceType;
  int? recurrenceInterval;

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(familyMembersProvider).maybeWhen(
          data: (users) => users,
          orElse: () => [],
        );
    assignedUserId ??= users.isNotEmpty ? users.first.id : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm công việc mới'),
        backgroundColor: const Color(0xFFF5F5F7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tên công việc',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onSaved: (value) => title = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Không được để trống' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mô tả chi tiết',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 3,
                onSaved: (value) => description = value ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: assignedUserId,
                items: users.map((user) {
                  return DropdownMenuItem<String>(
                    value: user.id,
                    child: Text(user.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => assignedUserId = value);
                },
                decoration: InputDecoration(
                  labelText: 'Người phụ trách',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) =>
                    value == null ? 'Vui lòng chọn người phụ trách' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Điểm thưởng',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => points = int.tryParse(value ?? '0') ?? 0,
                validator: (value) =>
                    value == null || int.tryParse(value) == null ? 'Vui lòng nhập số' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  deadline == null
                      ? 'Chọn deadline'
                      : 'Deadline: ${DateFormat('dd/MM/yyyy').format(deadline!)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selected != null) {
                    setState(() => deadline = selected);
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.grey),
                ),
                tileColor: Colors.white,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskType>(
                value: taskType,
                items: TaskType.values.map((type) {
                  return DropdownMenuItem<TaskType>(
                    value: type,
                    child: Text(
                      {
                        TaskType.oneTime: 'Một lần',
                        TaskType.daily: 'Hàng ngày',
                        TaskType.weekly: 'Hàng tuần',
                      }[type]!,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    taskType = value!;
                    if (taskType == TaskType.oneTime) {
                      recurrenceType = null;
                      recurrenceInterval = null;
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Loại công việc',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              if (taskType != TaskType.oneTime) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<RecurrenceType>(
                  value: recurrenceType,
                  items: RecurrenceType.values.map((type) {
                    return DropdownMenuItem<RecurrenceType>(
                      value: type,
                      child: Text(
                        {
                          RecurrenceType.daily: 'Hàng ngày',
                          RecurrenceType.weekly: 'Hàng tuần',
                          RecurrenceType.monthly: 'Hàng tháng',
                          RecurrenceType.custom: 'Tùy chỉnh',
                        }[type]!,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => recurrenceType = value);
                  },
                  decoration: InputDecoration(
                    labelText: 'Chu kỳ lặp lại',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) =>
                      value == null && taskType != TaskType.oneTime
                          ? 'Vui lòng chọn chu kỳ'
                          : null,
                ),
                if (recurrenceType == RecurrenceType.custom) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Số ngày lặp lại',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => recurrenceInterval = int.tryParse(value ?? '1') ?? 1,
                    validator: (value) =>
                        value == null || int.tryParse(value) == null
                            ? 'Vui lòng nhập số ngày'
                            : null,
                  ),
                ],
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    final newTask = Task(
                      id: const Uuid().v4(),
                      title: title,
                      description: description,
                      assignedUserId: assignedUserId ?? '',
                      createdAt: DateTime.now(),
                      deadline: deadline ?? DateTime.now().add(const Duration(days: 1)),
                      status: TaskStatus.pending,
                      type: taskType,
                      points: points,
                      recurrenceType: taskType != TaskType.oneTime ? recurrenceType : null,
                      recurrenceInterval: taskType != TaskType.oneTime && recurrenceType == RecurrenceType.custom ? recurrenceInterval : null,
                    );
                    await ref.read(tasksProvider.notifier).addTask(newTask);
                    if (mounted) Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B46C1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Tạo công việc', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}