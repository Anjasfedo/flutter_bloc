import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/task_list/task_list_bloc.dart';
import 'package:flutter_app/models/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TaskListBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
          // This is deprecated, consider using primarySwatch instead
          // primarySwatch: Colors.deepPurple,
          // useMaterial3: true, // This line is not necessary and can cause issues
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final taskListBloc = BlocProvider.of<TaskListBloc>(context);
          final state = taskListBloc.state;
          final id = state.tasks.length + 1;

          showBottomSheet(
            context: context,
            id: id,
            title: '', // Provide a default empty title
            content: '', // Provide a default empty content
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TaskListBloc, TaskListState>(
        builder: (context, state) {
          if (state is TaskListUpdated && state.tasks.isNotEmpty) {
            final tasks = state.tasks;

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return buildTaskTile(context, task);
              },
            );
          } else {
            return const Center(
              child: Text("No task"),
            );
          }
        },
      ),
    );
  }
}

Widget buildTaskTile(BuildContext context, Task task) {
  final taskListBloc = BlocProvider.of<TaskListBloc>(context);

  return ListTile(
    title: Text(task.title),
    subtitle: Text(task.content),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            taskListBloc.add(DeleteTask(task: task));
          },
          icon: const Icon(
            Icons.delete,
            size: 30,
            color: Colors.red,
          ),
        ),
IconButton(
          onPressed: () {
            showBottomSheet(
              context: context,
              id: task.id,
              title: task.title, // Pass the task title
              content: task.content, // Pass the task content
              isEdit: true,
            );
          },
          icon: const Icon(
            Icons.edit,
            size: 30,
            color: Colors.green,
          ),
        ),

      ],
    ),
  );
}

void showBottomSheet({
  required BuildContext context,
  bool isEdit = false,
  required int id,
   required String title, // Define title parameter
  required String content, // Define content parameter
}) {
  final TextEditingController titleController =
      TextEditingController(text: title);
  final TextEditingController contentController =
      TextEditingController(text: content);

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final taskListBloc = BlocProvider.of<TaskListBloc>(context);

      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Enter title')),
            TextField(
                controller: contentController,
                decoration: InputDecoration(hintText: 'Enter content')),
            ElevatedButton(
              onPressed: () {
                final task = Task(
                    id: id,
                    title: titleController.text,
                    content: contentController.text);
                if (isEdit) {
                  taskListBloc.add(UpdateTask(task: task));
                } else {
                  taskListBloc.add(AddTask(task: task));
                }
                Navigator.pop(context);
              },
              child: Text(isEdit ? "Update" : "Add"),
            ),
          ],
        ),
      );
    },
  );
}
