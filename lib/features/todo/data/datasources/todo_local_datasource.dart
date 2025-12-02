
import 'package:flutter_todo_app/core/error/failures.dart';
import 'package:flutter_todo_app/features/todo/data/datasources/todo_dao.dart';
import 'package:flutter_todo_app/features/todo/data/models/todo_model.dart';

abstract class TodoLocalDatasource {

  Future<List<TodoModel>> getAllTodos();
  Future<TodoModel?> getTodoById(String id);
  Future<void> createTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
  Future<void> toggleTodoStatus(String id);
  Future<void> deleteTodo(TodoModel todo);
  Future<void> deleteTodoById(String id);
  Future<List<TodoModel>> getCompletedTodo();
  Future<List<TodoModel>> getPendingTodos();

}

class TodoLocalDataSourceImpl implements TodoLocalDatasource {

  final TodoDao todoDao;

  TodoLocalDataSourceImpl({required this.todoDao});

  @override
  Future<void> createTodo(TodoModel todo) async {
    try{
      final id = todo.id.isEmpty
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : todo.id;

      final todoWithId = todo.copyWith(id: id);
      await todoDao.createTodo(todoWithId);
    }catch(e){
      throw DatabaseFailure("Failed to create Todo: $e");
    }
  }

  @override
  Future<void> deleteTodo(TodoModel todo) async {

    try{
      return await todoDao.deleteTodo(todo);
    }catch(e){
      throw DatabaseFailure("Failed to delete todo");
    }
  }

  @override
  Future<void> deleteTodoById(String id) {
    // TODO: implement deleteTodoById
    throw UnimplementedError();
  }

  @override
  Future<List<TodoModel>> getAllTodos() {
    // TODO: implement getAllTodos
    throw UnimplementedError();
  }

  @override
  Future<List<TodoModel>> getCompletedTodo() {
    // TODO: implement getCompletedTodo
    throw UnimplementedError();
  }

  @override
  Future<List<TodoModel>> getPendingTodos() {
    // TODO: implement getPendingTodos
    throw UnimplementedError();
  }

  @override
  Future<TodoModel?> getTodoById(String id) {
    // TODO: implement getTodoById
    throw UnimplementedError();
  }

  @override
  Future<void> toggleTodoStatus(String id) {
    // TODO: implement toggleTodoStatus
    throw UnimplementedError();
  }

  @override
  Future<void> updateTodo(TodoModel todo) {
    // TODO: implement updateTodo
    throw UnimplementedError();
  }
  
}
