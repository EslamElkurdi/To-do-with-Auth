import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/features/user_auth/presentation/to-do/Shared/bloc/cubit.dart';
import 'package:flutter_firebase/features/user_auth/presentation/to-do/Shared/bloc/states.dart';
import 'package:flutter_firebase/features/user_auth/presentation/to-do/Shared/components/component.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = ToDoAppCubit.get(context).newTasks;
        return taskBuilder(tasks: tasks);
      },
    );
  }
}
