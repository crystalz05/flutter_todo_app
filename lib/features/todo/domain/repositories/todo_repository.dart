
import 'package:dartz/dartz.dart';
import 'package:flutter_todo_app/core/error/failures.dart';
import 'package:flutter_todo_app/features/todo/domain/entities/todo.dart';

abstract class TodoRepository {

  //Get all todos
  Future<Either<Failure, List<Todo>>> getAllTodos();

  //Get a specific todo by id
  Future<Either<Failure, Todo>> getTodoById(String id);

  //Create a new todo
  Future<Either<Failure, Todo>> createTodo(Todo todo);

  //Update a todo
  Future<Either<Failure, Todo>> updateTodo(Todo todo);

  //Toggle todo to done or not
  Future<Either<Failure, Todo>> toggleTodoStatus(String id);

  //Delete a todo
  Future<Either<Failure, void>> deleteTodo(String id);

  //Get only completed todos
  Future<Either<Failure, List<Todo>>> getCompletedTodos();

  //Get only pending todos
  Future<Either<Failure, List<Todo>>> getPendingTodos();

}