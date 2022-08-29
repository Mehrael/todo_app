import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget myTextFormField({
  required TextEditingController controller,
  TextInputType? ttype,
  String? label,
  required IconData prefix,
  IconData? suffix,
  GestureTapCallback? onTap,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  FormFieldValidator<String>? validate,
  bool isPassword = false,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: ttype,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: IconTheme(
          data: IconThemeData(
            color: Colors.blueGrey,
          ),
          child: Icon(prefix),
        ),
        suffixIcon: suffix != null ? Icon(suffix) : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blueGrey,)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff000000)),
            borderRadius: BorderRadius.circular(30)),
      ),
      cursorColor: Color(0xff000000),
      onTap: onTap,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validate,
      obscureText: isPassword,
    );

Widget taskItem({required Map model, context}) {
  // IconData check = Icons.circle_outlined;
  // bool checked = false;

  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 1.5,
              color: Colors.grey,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: CircleAvatar(
                radius: 40,
                child: Text(
                  model['time'],
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor:      Color(0xff1ca7ec),
              ),
            ),

            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    model['title'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    model['date'],
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 1.50),
              child: Row(
                children: [
                  Visibility(
                    child: FloatingActionButton(
                      onPressed: () {
                        appCubit
                            .get(context)
                            .updateData(status: 'done', id: model['id']);
                      },
                      child: Icon(
                        Icons.done_outline_sharp,
                        size: 20,
                      ),
                      mini: true,
                      backgroundColor: Color(0xff1ca7ec),
                      elevation: 4,
                    ),
                    visible: model['status'] == 'done' ? false : true,
                  ),
                  Visibility(
                    child: FloatingActionButton(
                      onPressed: () {
                        appCubit
                            .get(context)
                            .updateData(status: 'archive', id: model['id']);
                      },
                      child: Icon(
                        Icons.archive,
                        size: 20,
                      ),
                      mini: true,
                      backgroundColor: Color(0xff1ca7ec),
                      elevation: 4,
                    ),
                    visible: model['status'] == 'archive' ? false : true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    onDismissed: (direction) {
      appCubit.get(context).deleteData(id: model['id']);
    },
  );
}

Widget taskBuilder({
  required List<Map> tasks,
}) {
  if (tasks.isNotEmpty) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff1f2f98),
            // Color(0xff787ff6),
            Color(0xff1ca7ec),
            Colors.white,
          ],
        ),
      ),
      child: ListView.builder(
          itemBuilder: (context, index) =>
              taskItem(model: tasks[index], context: context),
          itemCount: tasks.length),
    );
  } else {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff1f2f98),
            Color(0xff1ca7ec),
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100,
              color: Colors.black45,
            ),
            Text(
              'No Tasks Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
