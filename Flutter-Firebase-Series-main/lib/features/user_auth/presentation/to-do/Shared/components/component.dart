import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/features/user_auth/presentation/to-do/Shared/bloc/cubit.dart';

Widget defaultFormField(
        {required TextEditingController controller,
        required TextInputType type,
        required String? Function(String?) validate,
        required String label,
        required IconData prefIcon,
        Function? onTapFunction()?,
        IconData? sufx,
        Function? onChange(String? value)?,
        bool secureText = false,
        Function? onTapSuff()?,
        String? Function(String?)? onSubmit}) =>
    TextFormField(
      validator: validate,
      keyboardType: type,
      controller: controller,
      onTap: onTapFunction,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      obscureText: secureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(
          prefIcon,
        ),
        labelText: label,
        suffixIcon: sufx != null
            ? IconButton(
                icon: Icon(sufx),
                onPressed: onTapSuff,
              )
            : null,
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        ToDoAppCubit.get(context).deleteDB(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text("${model['time']}"),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${model['title']}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "${model['date']}",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  ToDoAppCubit.get(context)
                      .UpdateDB(status: 'done', id: model['id']);
                },
                icon: const Icon(
                  Icons.done_all,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  ToDoAppCubit.get(context)
                      .UpdateDB(status: 'archive', id: model['id']);
                },
                icon: const Icon(
                  Icons.archive,
                  color: Colors.black26,
                ))
          ],
        ),
      ),
    );

// Widget tasksBuilder({required List<Map> tasks}) => ConditionalBuilder(
//     condition: tasks.length > 0,
//     builder: (context) {
//       return ListView.separated(
//           itemBuilder: (context, index) =>
//               buildTaskItem(tasks, context)
//
//           separatorBuilder: (context, index) => myDivider(),
//           itemCount: tasks.length
//       );
//     },
//     fallback: (context) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Icon(
//               Icons.menu,
//               size: 100.0,
//               color: Colors.grey,
//             ),
//             Text(
//               "No Tasks Yet",
//               style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 17.0,
//                   fontWeight: FontWeight.bold),
//             )
//           ],
//         ),
//       );
//     });

Widget taskBuilder({required List<Map> tasks}) => ConditionalBuilder(
    condition: tasks.length > 0,
    builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 20,
              ),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
        itemCount: tasks.length),
    fallback: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.menu,
                size: 100,
                color: Colors.grey,
              ),
              Text(
                "No Tasks Yet, Please Add som Tasks",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              )
            ],
          ),
        ));

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );
