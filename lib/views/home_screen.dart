import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/riverpod_state_mgt/tasks_state_notifier_provider.dart';
import '../constants/colors.dart';
import '../utls/callbacks.dart';
import '../utls/font_sizes.dart';
import '../utls/text_fields.dart';
import 'widgets/custom_appbar.dart';
import 'widgets/task_item_view.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskProvider.notifier).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);
    final taskNotifier = ref.read(taskProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: ScaffoldMessenger(
        child: Scaffold(
          backgroundColor: kWhiteColor,
          appBar: CustomAppBar(
            title: 'Hi Aristide',
            showBackArrow: false,
            actionWidgets: [
              PopupMenuButton<int>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 1,
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      taskNotifier.sortByStartDate();
                      break;
                    case 1:
                      taskNotifier.filterByCompleted(completed: true);
                      break;
                    case 2:
                      taskNotifier.filterByPriority();
                      break;
                    case 3:
                      taskNotifier.restoreAll();
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<int>(
                      value: 2,
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svgs/task.svg', width: 15),
                          const SizedBox(width: 10),
                          buildText(
                            text: 'Sort by priority',
                            color: kBlackColor,
                            fontSize: textSmall,
                            fontWeight: FontWeight.normal,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svgs/task_checked.svg',
                              width: 15),
                          const SizedBox(width: 10),
                          buildText(
                            text: 'Sort by completed',
                            color: kBlackColor,
                            fontSize: textSmall,
                            fontWeight: FontWeight.normal,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svgs/calender.svg',
                              width: 15),
                          const SizedBox(width: 10),
                          buildText(
                            text: 'Sort by start date',
                            color: kBlackColor,
                            fontSize: textSmall,
                            fontWeight: FontWeight.normal,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 3,
                      child: Row(
                        children: [
                          Icon(Icons.refresh, size: 16),
                          SizedBox(width: 10),
                          Text(
                            'Reset filters',
                            style: TextStyle(
                                fontSize: textSmall, color: kBlackColor),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SvgPicture.asset('assets/svgs/filter.svg'),
                ),
              ),
            ],
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  BuildTextField(
                    hint: "Search recent task",
                    controller: searchController,
                    inputType: TextInputType.text,
                    prefixIcon: const Icon(Icons.search, color: kGrey2),
                    fillColor: kWhiteColor,
                    onChange: (value) {
                      if (value.isEmpty) {
                        taskNotifier.restoreAll();
                      } else {
                        taskNotifier.searchTasks(value);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  taskState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: taskState.tasks.isEmpty
                              ? const Center(child: Text("No tasks available"))
                              : ListView.separated(
                                  itemCount: taskState.tasks.length,
                                  itemBuilder: (context, index) {
                                    return TaskItemView(
                                      key: ValueKey(taskState.tasks[index].id),
                                      taskModel: taskState.tasks[index],
                                    );
                                  },
                                  separatorBuilder: (_, __) =>
                                      const Divider(color: kGrey3),
                                ),
                        ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add_circle, color: kPrimaryColor),
            onPressed: () {
              context.push('/createTask');
            },
          ),
        ),
      ),
    );
  }
}
