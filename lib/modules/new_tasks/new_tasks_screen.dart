
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../shared/components/components.dart';

class newTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = appCubit.get(context).new_tasks;

        return taskBuilder(tasks: tasks);
      },
    );
  }
}
