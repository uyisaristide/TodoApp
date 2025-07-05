import '../database/database_helper.dart';
import '../models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskProvider =
StateNotifierProvider<TaskNotifier, TaskState>((ref) => TaskNotifier());

class TaskNotifier extends StateNotifier<TaskState> {
  TaskNotifier() : super(TaskState.initial()) {
    fetchTasks(); // load tasks on init
  }

  final dbHelper = TaskDatabaseHelper();

  Future<void> fetchTasks() async {
    state = state.copyWith(isLoading: true);
    final tasks = await dbHelper.getAllTasks();
    state = state.copyWith(tasks: tasks, isLoading: false);
    // print(state.tasks);
  }

  Future<void> addTask(BuildContext context,TaskModel task) async {
    try {
      state = state.copyWith(isLoading: true);
      await dbHelper.insertTask(context, task);
      await fetchTasks(); // Refresh the list from database

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }


  Future<void> updateTask(BuildContext context, TaskModel task) async {
    await dbHelper.updateTask(context, task);
    await fetchTasks();
  }

  Future<void> deleteTask(BuildContext context ,String id) async {
    await dbHelper.deleteTask(context,id);
    await fetchTasks();
  }

  Future<void> toggleComplete(BuildContext context, TaskModel task) async {
    final updatedTask = task.copyWith(completed: !task.completed);
    await TaskDatabaseHelper().updateTask(context, updatedTask);
    await fetchTasks(); // triggers UI rebuild
  }


  void searchTasks(String query) {
    final results = state.tasks
        .where((task) =>
    task.title.toLowerCase().contains(query.toLowerCase()) ||
        task.description.toLowerCase().contains(query.toLowerCase()))
        .toList();

    state = state.copyWith(tasks: results);
  }


  void filterByPriority() {
    final filtered = [...state.tasks];
    filtered.sort((a, b) => a.priority.compareTo(b.priority)); // Ascending by default
    state = state.copyWith(tasks: filtered);
  }

  void filterByCompleted({bool completed = true}) {
    final filtered = state.tasks.where((t) => t.completed == completed).toList();
    state = state.copyWith(tasks: filtered);
  }

  void sortByStartDate({bool ascending = true}) {
    final sorted = [...state.tasks];
    sorted.sort((a, b) =>
    ascending ? a.startDateTime.compareTo(b.startDateTime) : b.startDateTime.compareTo(a.startDateTime));
    state = state.copyWith(tasks: sorted);
  }
  Future<void> restoreAll() async => await fetchTasks();
// Add to TaskNotifier class


}


class TaskState {
  final List<TaskModel> tasks;
  final bool isLoading;

  TaskState({required this.tasks, required this.isLoading});

  factory TaskState.initial() => TaskState(tasks: [], isLoading: false);

  TaskState copyWith({List<TaskModel>? tasks, bool? isLoading}) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
