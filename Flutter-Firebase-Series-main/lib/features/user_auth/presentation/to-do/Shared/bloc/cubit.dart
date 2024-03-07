import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/features/user_auth/presentation/to-do/Shared/bloc/states.dart';
import 'package:sqflite/sqflite.dart';

import '../../Modules/archived_tasks.dart';
import '../../Modules/done_tasks.dart';
import '../../Modules/new_tasks.dart';

class ToDoAppCubit extends Cubit<ToDoAppStates> {
  ToDoAppCubit() : super(AppInitialState());

  static ToDoAppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  List<Widget> titleScreen = [
    Text("New Tasks"),
    Text("Done Tasks"),
    Text("Archived Tasks"),
  ];

  late Database database;
  List<Map>? taskResult = [];

  changeIndex(index) {
    currentIndex = index;
    emit(ChangeNavBarState());
  }

  void createDataBase() async {
    openDatabase("todo.db", version: 1, onCreate: (database, version) {
      print("Database is created");

      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print("Table is Created");
      }).catchError((error) {
        print("Error while creating table ${error.toString()}");
      });
    }, onOpen: (database) {
      emit(GetLoadingState());

      print("Database is opened");

      getDataFromDatabase(database);
    }).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  Future insertToDatabase(
      {required String title,
      required String date,
      required String time}) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              "INSERT INTO tasks(title, date, time, status) VALUES('$title', '$date', '$time', 'New Task')")
          .then((value) {
        print("Item is Inserted Successfully ${value.toString()}");
        emit(InsertToDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error) {
        print("Error is happened ${error.toString()}");
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    archivedTasks = [];
    doneTasks = [];

    emit(GetLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        print("IIIIIIIIIIIIIIIIAAAAAAAAAAAMMMMMMMMMMMMM");

        print(element['status']);
        if (element['status'] == 'done') {
          doneTasks.add(element);
        } else if (element['status'] == 'New Task') {
          newTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(GetDatabaseState());
    });
  }

  bool isBottomSheetShown = false;

  IconData fabIcon = Icons.edit;

  changeBottomSheetShown({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    emit(ChangeBottomSheetShownState());
  }

  void UpdateDB({required String status, required int id}) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      print(">>>>>>>>>>>>>$id");
      getDataFromDatabase(database);
      emit(UpdateDataBaseState());
    });
  }

  void deleteDB({required int id}) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(DeleteDataBaseState());
    });
  }
}
