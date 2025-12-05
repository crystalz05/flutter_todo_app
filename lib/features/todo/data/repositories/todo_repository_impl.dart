
import 'package:dartz/dartz.dart';
import 'package:flutter_todo_app/core/error/failures.dart';
import 'package:flutter_todo_app/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:flutter_todo_app/features/todo/data/models/todo_model.dart';
import 'package:flutter_todo_app/features/todo/domain/entities/todo.dart';
import 'package:flutter_todo_app/features/todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {

  final TodoLocalDatasource localDatasource;

  TodoRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, Todo>> createTodo(Todo todo) async {

    try{
      final todoModel = TodoModel.fromEntity(todo);
      await localDatasource.createTodo(todoModel);
      return Right(todo);
    } on DatabaseFailure catch(e){
      return Left(DatabaseFailure(e.message));
    } catch(e){
      return Left(DatabaseFailure("Unexpected error"));
    }

  }

  @override
  Future<Either<Failure, void>> deleteTodo(String id) async {

    try{
      final selectedTodo = await localDatasource.getTodoById(id);

      if(selectedTodo != null){
        await localDatasource.deleteTodo(selectedTodo);
        return Right(null);
      }else{
        return Left(NotFoundFailure("Todo not found"));
      }
    }catch(e){
      return Left(DatabaseFailure("Failed to delete todo"));
    }

  }

  @override
  Future<Either<Failure, List<Todo>>> getAllTodos() async {
    try{
      final todoModels = await localDatasource.getAllTodos();
      final todos = todoModels.map((models) => models.toEntity()).toList();
      return Right(todos);
    }on DatabaseException catch(e){
      return Left(DatabaseFailure(e.message));
    }catch(e){
      return Left(DatabaseFailure("Unexpected error $e"));
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> getCompletedTodos() async {

    try{
      final todoModels = await localDatasource.getCompletedTodo();
      final todos = todoModels.map((models) => models.toEntity()).toList();
      return Right(todos);
    }on DatabaseException catch (e){
      return Left(DatabaseFailure(e.message));
    }catch(e){
      return Left(DatabaseFailure("Unexpected error $e"));
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> getPendingTodos() async {
    try{
      final todoModels = await localDatasource.getPendingTodos();
      final todos = todoModels.map((models) => models.toEntity()).toList();
      return Right(todos);
    }on DatabaseException catch (e){
      return Left(DatabaseFailure(e.message));
    }catch(e){
      return Left(DatabaseFailure("Unexpected error $e"));
    }
  }

  @override
  Future<Either<Failure, Todo>> getTodoById(String id) async {

    try{
      final todoModel = await localDatasource.getTodoById(id);
      if(todoModel != null){
        return Right(todoModel.toEntity());
      }else{
        return Left(NotFoundFailure("Todo not found"));
      }
    }on DatabaseException catch(e){
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleTodoStatus(String id) async {

    try{
      await localDatasource.toggleTodoStatus(id);
      return Right(null);
    } on DatabaseFailure catch (e){
      return Left(DatabaseFailure(e.message));
    }catch(e){
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTodo(Todo todo) async {

    try{
      final todoModel = TodoModel.fromEntity(todo);
      await localDatasource.updateTodo(todoModel);
      return Right(null);
    }on DatabaseFailure catch (e){
      return Left(DatabaseFailure(e.message));
    }catch(e){
      return Left(DatabaseFailure("Unexpected error: $e"));
    }
  }

}