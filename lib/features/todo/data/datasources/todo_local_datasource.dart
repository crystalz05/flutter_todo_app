import 'package:flutter_todo_app/features/todo/data/datasources/todo_dao.dart';
import 'package:flutter_todo_app/features/todo/data/models/todo_model.dart';
import 'package:uuid/uuid.dart';

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
      final uuid = Uuid();
      final id = todo.id.isEmpty ? uuid.v4() : todo.id;

      final todoWithId = todo.copyWith(id: id);
      await todoDao.createTodo(todoWithId);
    }catch(e){
      throw DatabaseException("Failed to create Todo: $e");
    }
  }

  @override
  Future<void> deleteTodo(TodoModel todo) async {
    try{
      await todoDao.deleteTodo(todo);
    }catch(e){
      throw DatabaseException("Failed to delete todo $e");
    }
  }

  @override
  Future<void> deleteTodoById(String id) async {
    try {
      await todoDao.deleteTodoById(id);
    }catch(e){
      throw DatabaseException("Failed to delete todo $e");
    }
  }

  @override
  Future<List<TodoModel>> getAllTodos() async {
    try{
      return await todoDao.getAllTodos();
    }catch(e){
      throw DatabaseException("Failed to get all todos $e");
    }

  }

  @override
  Future<List<TodoModel>> getCompletedTodo() async {

    try{
      return await todoDao.getCompletedTodo();
    }catch(e){
      throw DatabaseException("Failed to get completed todos $e");
    }

  }

  @override
  Future<List<TodoModel>> getPendingTodos() async {

    try{
      return await todoDao.getPendingTodos();
    }catch(e){
      throw DatabaseException("Failed to get pending todos $e");
    }
  }

  @override
  Future<TodoModel?> getTodoById(String id) async {

    try{
      final todo = await todoDao.getTodoById(id);
      if(todo == null){
        throw DatabaseException("Todo with id $id not found");
      }
      return todo;
    }catch(e){
      throw DatabaseException("Failed to get todo $e");
    }

  }

  @override
  Future<void> toggleTodoStatus(String id) async {

    try{
      await todoDao.toggleTodoStatus(id);
    }catch(e){
      throw DatabaseException("Failed to toggle todo status $e");
    }
    
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    
    try{
      await todoDao.updateTodo(todo);
    }catch(e){
      throw DatabaseException("Failed to update todo: $e");
    }
  }
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}
