
import 'package:floor/floor.dart';
import 'package:flutter_todo_app/features/todo/data/models/todo_model.dart';

@dao
abstract class TodoDao {
  @Query('SELECT * FROM TodoModel')
  Future<List<TodoModel>> getAllTodos();

  @Query('SELECT * FROM TodoModel WHERE id = :id')
  Future<TodoModel?> getTodoById(String id);

  @insert
  Future<void> createTodo(TodoModel todo);

  @update
  Future<void> updateTodo(TodoModel todo);

  @Query('UPDATE TodoModel SET isDone = CASE WHEN isDone = 1 THEN 0 ELSE 1 END WHERE id = :id')
  Future<void> toggleTodoStatus(String id);

  @delete
  Future<void> deleteTodo(TodoModel todo);

  @Query('DELETE FROM TodoModel WHERE id = :id')
  Future<void> deleteTodoById(String id);

  @Query('SELECT * FROM TodoModel WHERE isDone = 1')
  Future<List<TodoModel>> getCompletedTodo();

  @Query('SELECT * FROM TodoModel WHERE isDone = 0')
  Future<List<TodoModel>> getPendingTodos();
}
