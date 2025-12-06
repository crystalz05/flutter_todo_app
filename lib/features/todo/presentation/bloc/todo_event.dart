
import 'package:equatable/equatable.dart';
import 'package:flutter_todo_app/features/todo/domain/entities/todo.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodosEvent extends TodoEvent {}

class LoadTodoByIdEvent extends TodoEvent {
  final String id;

  const LoadTodoByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateTodoEvent extends TodoEvent {
  final String title;
  final String? description;

  const CreateTodoEvent({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];

}

class UpdateTodoEvent extends TodoEvent {
  final Todo todo;

  const UpdateTodoEvent(this.todo);

  @override
  // TODO: implement props
  List<Object?> get props => [todo];
}

class ToggleTodoStatusEvent extends TodoEvent {
  final String id;

  const ToggleTodoStatusEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class DeleteTodoEvent extends TodoEvent {
  final String id;

  const DeleteTodoEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterTodosEvent extends TodoEvent {
  final TodoFilter todoFilter;

  const FilterTodosEvent(this.todoFilter);

  @override
  List<Object?> get props => [todoFilter];
}


enum TodoFilter { all, pending, completed }
