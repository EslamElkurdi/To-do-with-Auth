import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Shared/bloc/cubit.dart';
import '../Shared/bloc/states.dart';
import '../Shared/components/component.dart';
class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoAppCubit, ToDoAppStates>(
      listener: (context, state){},
      builder: (context, state)
      {
        var tasks = ToDoAppCubit.get(context).doneTasks;
        return taskBuilder(tasks: tasks);
      },
    );
  }
}