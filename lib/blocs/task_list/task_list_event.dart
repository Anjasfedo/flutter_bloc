part of 'task_list_bloc.dart';

@immutable
abstract class TaskListEvent {}

class AddTask extends TaskListEvent {
  final Task task;
  AddTask({required this.task});
}

class DeleteTask extends TaskListEvent {
  final Task task;
  DeleteTask({required this.task});
}

class UpdateTask extends TaskListEvent {
  final Task task;
  UpdateTask({required this.task});
}