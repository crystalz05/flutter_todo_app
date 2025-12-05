
import 'package:dartz/dartz.dart';
import 'package:flutter_todo_app/core/error/failures.dart';
import 'package:flutter_todo_app/core/usecases/usecase.dart';
import 'package:flutter_todo_app/features/todo/domain/entities/todo.dart';
import 'package:flutter_todo_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';

class GetAllTodos extends UseCase<List<Todo>, NoParams>{

  final TodoRepository repository;

  GetAllTodos(this.repository);

  @override
  Future<Either<Failure, List<Todo>>> call(NoParams param) {
    return repository.getAllTodos();
  }
}

class GetTodoById extends UseCase<Todo, IdParams>{
  final TodoRepository repository;

  GetTodoById(this.repository);

  @override
  Future<Either<Failure, Todo>> call(IdParams param) {
    return repository.getTodoById(param.id);
  }
}

class CreateTodo extends UseCase<Todo, TodoParams>{
  
  final TodoRepository repository;
  final _uuid = const Uuid();

  CreateTodo(this.repository);

  @override
  Future<Either<Failure, Todo>> call(TodoParams param) {

    final id = _uuid.v4();

    final todo = Todo(
      id: id,
      title: param.title ?? "",
      description: param.description ?? "",
      isDone: param.isDone,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    return repository.createTodo(todo);
  }
}

class UpdateTodo extends UseCase<void, IdParams>{
  final TodoRepository repository;

  UpdateTodo(this.repository);

  @override
  Future<Either<Failure, void>> call(IdParams param) {
    return repository.toggleTodoStatus(param.id);
  }
}