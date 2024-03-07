import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/features/user_auth/presentation/to-do/Shared/bloc/cubit.dart';
import 'package:flutter_firebase/features/user_auth/presentation/to-do/Shared/bloc/states.dart';
import 'package:flutter_firebase/features/user_auth/presentation/to-do/Shared/components/component.dart';
import 'package:flutter_firebase/global/common/toast.dart';
import 'package:intl/intl.dart';
// import 'package:todoapp/Shared/bloc/cubit.dart';
// import 'package:todoapp/Shared/bloc/states.dart';
// import 'package:todoapp/Shared/components/component.dart';

// ignore: must_be_immutable
class ToDoApp extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  bool isBottomSheetShown = false;

  Icon fabIcon = Icon(Icons.edit);

  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  ToDoApp({super.key});

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //
  //   createDataBase();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoAppCubit()..createDataBase(),
      child: BlocConsumer<ToDoAppCubit, ToDoAppStates>(
        listener: (context, state) {
          if (state is InsertToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          ToDoAppCubit cubit = ToDoAppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: cubit.titleScreen[cubit.currentIndex],
              actions: [
                GestureDetector(
                  child: Icon(Icons.logout_outlined),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, "/login");
                    showToast(message: "Successfully signed out");
                  },
                )
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! GetLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                          title: titleController.text,
                          date: dateController.text,
                          time: timeController.text);
                    }
                  } else {
                    scaffoldKey.currentState
                        ?.showBottomSheet(
                            elevation: 15,
                            (context) => Container(
                                  padding: const EdgeInsets.all(20),
                                  color: Colors.grey[250],
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        defaultFormField(
                                            controller: titleController,
                                            type: TextInputType.text,
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return 'Title must not be empty';
                                              }
                                              return null;
                                            },
                                            label: 'Title Task',
                                            prefIcon: Icons.title),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        defaultFormField(
                                            controller: timeController,
                                            type: TextInputType.datetime,
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return 'Time must not be empty';
                                              }
                                              return null;
                                            },
                                            onTapFunction: () {
                                              showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now())
                                                  .then((value) {
                                                timeController.text = value!
                                                    .format(context)
                                                    .toString();
                                              });
                                            },
                                            label: 'Time Task',
                                            prefIcon: Icons.watch_later),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        defaultFormField(
                                            controller: dateController,
                                            type: TextInputType.datetime,
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return 'date must not be empty';
                                              }
                                              return null;
                                            },
                                            onTapFunction: () {
                                              showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(2022),
                                                      lastDate: DateTime(2025))
                                                  .then((value) {
                                                // print(DateFormat.yMMMd().format(value));
                                                dateController.text =
                                                    DateFormat.yMMMd()
                                                        .format(value!);
                                              });
                                            },
                                            label: 'Date Task',
                                            prefIcon: Icons.watch_later),
                                      ],
                                    ),
                                  ),
                                ))
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetShown(
                          isShow: false, icon: Icons.edit);
                    });
                    cubit.changeBottomSheetShown(isShow: true, icon: Icons.add);
                  }
                },
                child: fabIcon),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                cubit.changeIndex(index);
                // setState(() {
                //   currentIndex = index;
                // });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: "Archived",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
