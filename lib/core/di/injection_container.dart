import 'package:flutter_todo_app/features/todo/data/datasources/app_database.dart';
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
  ));

}