import 'package:get/get.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/home/views/home_view.dart';
import '../../features/tasks/views/task_detail_view.dart';
import '../../features/materials/views/material_entry_view.dart';
import '../../features/customers/views/customer_view.dart';
import '../../features/sync/views/sync_status_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String taskDetail = '/task-detail';
  static const String materialEntry = '/material-entry';
  static const String customer = '/customer';
  static const String syncStatus = '/sync-status';

  static List<GetPage> routes = [
    GetPage(name: login, page: () => const LoginView()),
    GetPage(name: home, page: () => const HomeView()),
    GetPage(name: taskDetail, page: () => const TaskDetailView()),
    GetPage(name: materialEntry, page: () => const MaterialEntryView()),
    GetPage(name: customer, page: () => const CustomerView()),
    GetPage(name: syncStatus, page: () => const SyncStatusView()),
  ];
}
