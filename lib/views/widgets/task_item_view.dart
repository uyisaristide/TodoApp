import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/riverpod_state_mgt/tasks_state_notifier_provider.dart';

import '../../constants/colors.dart';
import '../../models/task_model.dart';
import '../../utls/callbacks.dart';
import '../../utls/font_sizes.dart';

class TaskItemView extends ConsumerStatefulWidget {
  final TaskModel taskModel;
  const TaskItemView({super.key, required this.taskModel});

  @override
  ConsumerState<TaskItemView> createState() => _TaskItemViewState();
}

class _TaskItemViewState extends ConsumerState<TaskItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
                value: widget.taskModel.completed,
                onChanged: (_) {
                  ref.read(taskProvider.notifier).toggleComplete(context, widget.taskModel);
                }
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: buildText(
                             text:  widget.taskModel.title,
                             color:  kBlackColor,
                             fontSize:  textMedium,
                             fontWeight:  FontWeight.w500,
                             textAlign:  TextAlign.start)),
                      PopupMenuButton<int>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: kWhiteColor,
                        elevation: 1,
                        onSelected: (value) {
                          switch (value) {
                            case 0:
                              {
                                context.push('/createTask', extra: widget.taskModel);

                                break;
                              }
                            case 1:
                              {
                                break;
                              }
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<int>(
                              value: 0,
                              child: Row(
                                children: [
                                  Icon(Icons.edit),

                                  const SizedBox(
                                    width: 10,
                                  ),
                                  buildText(
                                      text: 'Edit task',
                                      color: kBlackColor,
                                      fontSize: textMedium,
                                     fontWeight:  FontWeight.normal,
                                     textAlign:  TextAlign.start,
                                      )
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  buildText(
                                    text: 'Delete task',
                                    color: kBlackColor,
                                    fontSize: textMedium,
                                    fontWeight:  FontWeight.normal,
                                    textAlign:  TextAlign.start,
                                  )
                                ],
                              ),
                              onTap: () {
                                 ref.read(taskProvider.notifier).deleteTask(context, widget.taskModel.id);
                              },
                            ),
                          ];
                        },
                        child:
                        Icon(Icons.more_vert)
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  buildText(
                    text: widget.taskModel.description,
                    color: kBlackColor,
                    fontSize: textMedium,
                    fontWeight:  FontWeight.normal,
                    textAlign:  TextAlign.start,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(.1),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child:  buildText(
                             text: '${formatDate(dateTime: widget.taskModel.startDateTime.toString())} - ${formatDate(dateTime: widget.taskModel.stopDateTime.toString())}',
                              color: kBlackColor,
                              fontSize: textMedium,
                              fontWeight:  FontWeight.normal,
                              textAlign:  TextAlign.start,
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ));
  }
}