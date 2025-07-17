import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:famtask/core/models/task_model.dart';
import 'package:famtask/core/providers/app_providers.dart';
import 'package:famtask/routes/route_names.dart';

class DashboardScreen extends ConsumerWidget {
  final String location;
  const DashboardScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 30),
              _buildTodayProgressCard(context, ref),
              const SizedBox(height: 30),
              _buildQuickStats(ref),
              const SizedBox(height: 30),
              const SizedBox(height: 20), // Placeholder for future content
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context, location),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF4A90E2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 30),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Xin chào!', style: TextStyle(fontSize: 16, color: Colors.grey)),
              Text('Livia Vaccaro', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
        ),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2)),
            ],
          ),
          child: const Icon(Icons.notifications_outlined, color: Colors.black, size: 24),
        ),
      ],
    );
  }

  Widget _buildTodayProgressCard(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(tasksProvider.notifier).getTodayProgress();
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6B46C1), Color(0xFF9333EA)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color(0xFF6B46C1).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tiến độ hôm nay', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text('Sắp hoàn thành rồi!', style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => context.push(RouteNames.addTask),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: const Text('Thêm công việc', style: TextStyle(color: Color(0xFF6B46C1), fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.white30,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Text('${(progress * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(WidgetRef ref) {
    final userStats = ref.watch(tasksProvider.notifier).getUserStats();
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
          const Text('Thống kê nhanh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng nhiệm vụ: ${userStats['totalTasks'] ?? 0}', style: TextStyle(color: Colors.grey[600])),
              Text('Hoàn thành: ${userStats['completedTasks'] ?? 0}', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Điểm: ${userStats['totalPoints'] ?? 0}', style: TextStyle(color: Colors.grey[600])),
              Text('Cấp độ: ${userStats['level'] ?? 1}', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, String location) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, RouteNames.dashboard, location, context),
          _buildNavItem(Icons.calendar_today_outlined, '/calendar', location, context),
          GestureDetector(
            onTap: () => context.push(RouteNames.addTask),
            child: Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6B46C1), Color(0xFF9333EA)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF6B46C1).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
          ),
          _buildNavItem(Icons.list, RouteNames.taskList, location, context),
          _buildNavItem(Icons.person_outline, '/profile', location, context),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String route, String currentLocation, BuildContext context) {
    final isActive = currentLocation == route || (route == RouteNames.dashboard && currentLocation == '/dashboard');
    return IconButton(
      icon: Icon(icon, color: isActive ? const Color(0xFF6B46C1) : Colors.grey, size: 24),
      onPressed: () {
        if (currentLocation != route) {
          context.go(route);
        }
      },
    );
  }
}