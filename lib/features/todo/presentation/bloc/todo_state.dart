
import 'package:equatable/equatable.dart';
import 'package:flutter_todo_app/features/todo/presentation/bloc/todo_event.dart';

import '../../domain/entities/todo.dart';

abstract class TodoState extends Equatable {

  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodosLoaded extends TodoState {
  final List<Todo> todos;
  final TodoFilter currentFilter;


  const TodosLoaded({
    required this.todos,
    this.currentFilter = TodoFilter.all
  });

  List<Todo> get filteredTodos{
    switch(currentFilter){
      case TodoFilter.pending:
        return todos.where((todo) => !todo.isDone).toList();
      case TodoFilter.completed:
        return todos.where((todo) => todo.isDone).toList();
      default:
        return todos;
    }
  }

  int get totalCount => todos.length;
  int get completedCount => todos.where((todo) => todo.isDone).length;
  int get pendingCount => todos.where((todo) => !todo.isDone).length;

  @override
  List<Object?> get props => [todos, currentFilter];

  TodosLoaded copyWith({
    List<Todo>? todos,
    TodoFilter? currentFilter
  }){
    return TodosLoaded(
      todos: todos ?? this.todos,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}

class TodoLoaded extends TodoState {
  final Todo todos;

  const TodoLoaded(this.todos);
  @override
  List<Object?> get props => [todos];
}

class TodoOperationSuccess extends TodoState {
  final String message;

  const TodoOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object?> get props => [message];
}