import 'package:flutter_todo_app/features/todo/data/datasources/app_database.dart';
import 'package:flutter_todo_app/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:flutter_todo_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:flutter_todo_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_todo_app/features/todo/domain/usecases/usecase.dart';
import 'package:flutter_todo_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:get_it/get_it.dart';


final sl = GetIt.instance;

Future<void> init() async{

  final database = await $FloorAppDatabase
      .databaseBuilder("app_database.db")
      .build();


  sl.registerSingleton<AppDatabase>(database);
  sl.registerSingleton(database.todoDao);

  sl.registerFactory(()=> TodoBloc(
    getAllTodos: sl(),
    getTodoById: sl(),
    createTodo: sl(),
    updateTodo: sl(),
    toggleTodoStatus: sl(),
    deleteTodo: sl(),
    getCompletedTodos: sl(),
    getPendingTodos: sl(),
  ));

  sl.registerLazySingleton(()=> GetAllTodos(sl()));
  sl.registerLazySingleton(()=> GetTodoById(sl()));
  sl.registerLazySingleton(()=> CreateTodo(sl()));
  sl.registerLazySingleton(()=> UpdateTodo(sl()));
  sl.registerLazySingleton(()=> ToggleTodoStatus(sl()));
  sl.registerLazySingleton(()=> DeleteTodo(sl()));
  sl.registerLazySingleton(()=> GetCompletedTodos(sl()));
  sl.registerLazySingleton(()=> GetPendingTodos(sl()));

  sl.registerLazySingleton<TodoRepository>(
      ()=> TodoRepositoryImpl(localDatasource: sl()),
  );

  sl.registerLazySingleton<TodoLocalDatasource>(
      ()=> TodoLocalDataSourceImpl(todoDao: sl()),
  );
}