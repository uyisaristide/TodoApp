import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../constants/colors.dart';
import '../models/task_model.dart';
import '../riverpod_state_mgt/tasks_state_notifier_provider.dart';
import '../utls/callbacks.dart';
import '../utls/font_sizes.dart';
import '../utls/text_fields.dart';
import 'widgets/custom_appbar.dart';

class NewTaskScreen extends ConsumerStatefulWidget {
  final TaskModel? task;
  const NewTaskScreen({super.key, this.task});

  @override
  ConsumerState<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends ConsumerState<NewTaskScreen> {
  late TextEditingController title;
  late TextEditingController description;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    title = TextEditingController(text: widget.task?.title ?? '');
    description = TextEditingController(text: widget.task?.description ?? '');
    _rangeStart = widget.task?.startDateTime;
    _rangeEnd = widget.task?.stopDateTime;
    _selectedDay = _focusedDay;
    super.initState();
  }

  _onRangeSelected(DateTime? start, DateTime? end, DateTime focusDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusDay;
      _rangeStart = start;
      _rangeEnd = end;
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);
    final taskNotifier = ref.read(taskProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: CustomAppBar(
            title: widget.task == null ? 'Create New Task' : 'Update Task'),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                TableCalendar(
                  calendarFormat: _calendarFormat,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                    CalendarFormat.week: 'Week',
                  },
                  rangeSelectionMode: RangeSelectionMode.toggledOn,
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2030, 1, 1),
                  onPageChanged: (focusDay) {
                    _focusedDay = focusDay;
                  },
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onRangeSelected: _onRangeSelected,
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(.1),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: buildText(
                    text: _rangeStart != null && _rangeEnd != null
                        ? 'Task starting at ${formatDate(dateTime: _rangeStart.toString())} - ${formatDate(dateTime: _rangeEnd.toString())}'
                        : 'Select a date range',
                    color: kPrimaryColor,
                    fontSize: textSmall,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 20),
                buildText(
                  text: 'Title',
                  color: kBlackColor,
                  fontSize: textMedium,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10),
                BuildTextField(
                  hint: "Task Title",
                  controller: title,
                  inputType: TextInputType.text,
                  fillColor: kWhiteColor,
                  onChange: (value) {},
                ),
                const SizedBox(height: 20),
                buildText(
                  text: 'Description',
                  color: kBlackColor,
                  fontSize: textMedium,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10),
                BuildTextField(
                  hint: "Task Description",
                  controller: description,
                  inputType: TextInputType.multiline,
                  fillColor: kWhiteColor,
                  onChange: (value) {},
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: buildText(
                          text: 'Cancel',
                          color: kBlackColor,
                          fontSize: textMedium,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: taskState.isLoading
                            ? null
                            : () async {
                                final task = TaskModel(
                                  id: widget.task?.id ??
                                      DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                  title: title.text,
                                  description: description.text,
                                  completed: widget.task?.completed ?? false,
                                  startDateTime: _rangeStart ?? DateTime.now(),
                                  stopDateTime: _rangeEnd ??
                                      DateTime.now()
                                          .add(const Duration(hours: 1)),
                                );
                                if (widget.task != null) {
                                  await taskNotifier.updateTask(context, task);
                                } else {
                                  await taskNotifier.addTask(context, task);
                                }
                                if (!mounted) return;
                                Navigator.pop(context);
                              },
                        child: taskState.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : buildText(
                                text: widget.task != null ? 'Update' : 'Save',
                                color: kWhiteColor,
                                fontSize: textMedium,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
