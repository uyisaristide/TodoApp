import 'package:go_router/go_router.dart';
import 'package:todo/views/other_challenges/corrected_codes.dart';

import '../models/task_model.dart';
import '../views/home_screen.dart';
import '../views/new_task.dart';
import '../views/splash_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    // Splash Screen Route
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),


    // Tasks Screen Route
    GoRoute(
      path: '/home',
      builder: (context, state) => const TasksScreen(),
    ),
    GoRoute(
      path: '/userList',
      builder: (context, state) =>  UserListScreen(),
    ),

    // Create or Edit Task Route
    GoRoute(
      path: '/createTask',
      builder: (context, state) {
        final task = state.extra as TaskModel?;
        return NewTaskScreen(task: task); // Pass the task (can be null)
      },
    ),


  ],
);


