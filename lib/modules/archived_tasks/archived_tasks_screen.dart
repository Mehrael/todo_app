import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class archivedTasks extends StatelessWidget {
  const archivedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit,appStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = appCubit.get(context).archived_tasks;

        return taskBuilder(tasks: tasks);
      },
    );
  }
}
