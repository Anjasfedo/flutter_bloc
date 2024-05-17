part of 'task_list_bloc.dart';

abstract class TaskListState {
  List<Task> tasks;
  TaskListState({required this.tasks});
}

class TaskListInitial extends TaskListState {
  TaskListInitial({required List<Task> tasks}) : super(tasks: tasks);
}

class TaskListUpdated extends TaskListState {
  TaskListUpdated({required List<Task> tasks}) : super(tasks: tasks);
}
