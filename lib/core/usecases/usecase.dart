
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todo_app/core/error/failures.dart';
import 'package:uuid/uuid.dart';

import '../../features/todo/domain/entities/todo.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params param);
}

//use case for operations with no parameters
class NoParams extends Equatable{
  @override
  List<Object?> get props => [];
}

//use case for operations needing ID
class IdParams extends Equatable{

  final String id;

  const IdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

//Use case for creating and updating todos
class TodoParams extends Equatable{

  final String? id;
  final String? title;
  final String? description;
  final bool? isDone;
  final int? createdAt;


  const TodoParams({
    this.id,
    required this.title,
    this.description,
    this.isDone,
    this.createdAt,
  });

  factory TodoParams.fromTodo(Todo todo) {
    return TodoParams(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isDone: todo.isDone,
      createdAt: todo.createdAt,
    );
  }

  Todo toTodo() {
    return Todo(
      id: id ?? Uuid().v4(),
      title: title ?? "",
      description: description ?? "",
      isDone: isDone ?? false,
      createdAt: createdAt  ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  List<Object?> get props => [id, title, description];
}