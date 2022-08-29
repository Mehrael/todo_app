import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

import '../shared/components/constants.dart';
import '../shared/cubit/states.dart';

class homeLayout extends StatelessWidget {
  homeLayout({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => appCubit()..createDatabase(),
      child: BlocConsumer<appCubit, appStates>(
        listener: (BuildContext context, appStates state) {
          if (state is appInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, appStates state) {
          appCubit cubit = appCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                'ToDo App',
              ),
              backgroundColor: Color(0xff1f2f98),
              // backgroundColor: Colors.white24,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(cubit.edit_add),
                  // backgroundColor: Color(0xfffad4c0),
                  // elevation: 0,
                  onPressed: () {
                    if (cubit.isBottomSheetShown &&
                        formKey.currentState!.validate()) {
                      cubit.insertDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                      );
                      // getDataFromDatabase(database).then((value) {
                      //   tasks = value;
                      //   Navigator.pop(context);
                      //
                      //   edit_add = Icons.edit;
                      //   isBottomSheetShown = false;
                      // }
                      // );
                    } else {
                      scaffoldKey.currentState
                          ?.showBottomSheet((context) => Container(
                                  color: Colors.white,

                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        myTextFormField(
                                          controller: titleController,
                                          ttype: TextInputType.text,
                                          label: 'Task title',
                                          prefix: Icons.title,
                                          onTap: () {
                                            print('title tapped');
                                          },
                                          validate: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'title can\'t be empty';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        myTextFormField(
                                          controller: timeController,
                                          ttype: TextInputType.datetime,
                                          label: 'Task time',
                                          prefix: Icons.more_time_sharp,
                                          onTap: () {
                                            print('timming tapped');
                                            showTimePicker(
                                              context: context,
                                              builder: (context, child) {
                                                return Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                          colorScheme:
                                                              ColorScheme.light(
                                                    primary: Color(0xff536ec5),
                                                    onPrimary: Colors.white,
                                                    onSurface:
                                                        Color(0xff1ca7ec),
                                                  )),
                                                  child: child!,
                                                );
                                              },
                                              initialTime: TimeOfDay.now(),
                                            ).then((value) {
                                              if (value != null) {
                                                timeController.text = value
                                                    .format(context)
                                                    .toString();
                                              }
                                              // print(value.format(context));
                                            });
                                          },
                                          validate: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'time can\'t be empty';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        myTextFormField(
                                          controller: dateController,
                                          ttype: TextInputType.datetime,
                                          label: 'Task date',
                                          prefix: Icons.calendar_month_rounded,
                                          onTap: () {
                                            print('date tapped');
                                            showDatePicker(
                                              context: context,
                                              builder: (context, child) {
                                                return Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                          colorScheme:
                                                              ColorScheme.light(
                                                    primary: Color(0xff536ec5),
                                                    onPrimary: Colors.white,
                                                    onSurface:
                                                        Color(0xff1ca7ec),
                                                  )),
                                                  child: child!,
                                                );
                                              },
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse("2022-12-31"),
                                            ).then((value) {
                                              // print(DateFormat.yMMMEd().format(value).toString());
                                              if (value != null) {
                                                dateController.text =
                                                    DateFormat.yMMMEd()
                                                        .format(value)
                                                        .toString();
                                              }
                                            });
                                          },
                                          validate: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'date can\'t be empty';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          .closed
                          .then((value) {
                        cubit.changeBottomSheet(show: false, icon: Icons.edit);
                      });
                      cubit.changeBottomSheet(show: true, icon: Icons.add);
                    }
                  },
                ),
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.white,
              selectedItemColor: Color(0xff787ff6),
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.task_alt,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
