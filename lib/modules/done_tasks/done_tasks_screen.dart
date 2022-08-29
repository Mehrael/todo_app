import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../shared/components/components.dart';

class doneTasks extends StatelessWidget {
  const doneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit,appStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = appCubit.get(context).done_tasks;

        return taskBuilder(tasks: tasks);
      },
    );
  }
}
