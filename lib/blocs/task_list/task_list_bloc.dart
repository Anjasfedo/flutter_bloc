import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/task.dart';
part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  TaskListBloc() : super(TaskListInitial(tasks: [])) {
    on<AddTask>(_addTask);
    on<DeleteTask>(_deleteTask);
    on<UpdateTask>(_updateTask);
  }

  void _addTask(AddTask event, Emitter<TaskListState> emit) {
    state.tasks.add(event.task);
    emit(TaskListUpdated(tasks: state.tasks));
  }

  void _deleteTask(DeleteTask event, Emitter<TaskListState> emit) {
    state.tasks.remove(event.task);
    emit(TaskListUpdated(tasks: state.tasks));
  }

  void _updateTask(UpdateTask event, Emitter<TaskListState> emit) {
    for (int i = 0; i < state.tasks.length; i++) {
      if (event.task.id == state.tasks[i].id) {
        state.tasks[i] = event.task;
      }
    }
    emit(TaskListUpdated(tasks: state.tasks));
  }
}
