import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class appCubit extends Cubit<appStates> {
  appCubit() : super(appInitialState());

  static appCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    newTasks(),
    doneTasks(),
    archivedTasks(),
  ];

  List<Map> new_tasks = [];
  List<Map> done_tasks = [];
  List<Map> archived_tasks = [];

  late Database database;

  bool isBottomSheetShown = false;
  IconData edit_add = Icons.edit;

  void changeBottomSheet({
    required bool show,
    required IconData icon,
  }) {
    isBottomSheetShown = show;
    edit_add = icon;

    emit(appChangeBottomSheetState());
  }

  void changeIndex(int index) {
    currentIndex = index;
    emit(appChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) => print('table created'))
            .catchError((error) {
          print('error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(appCreateDatabaseState());
    });
  }

  insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
            .then((value) {
          print('$value inserted');
          emit(appInsertDatabaseState());

          getDataFromDatabase(database);
        }).catchError((error) {
          print('error while inserting ${error.toString()}');
        }));
  }

  void getDataFromDatabase(database) {
    new_tasks = [];
    done_tasks = [];
    archived_tasks = [];

    emit(appGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {
      // tasks = value;

      value.forEach((element) {
        if (element['status'] == 'new') {
          new_tasks.add(element);
        } else if (element['status'] == 'done') {
          done_tasks.add(element);
        } else {
          archived_tasks.add(element);
        }
      });

      emit(appGetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', '$id']).then((value) {
      getDataFromDatabase(database);
      emit(appUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?',
        ['$id']).then((value) {
      getDataFromDatabase(database);
      emit(appDeleteDatabaseState());
    });
  }
}
