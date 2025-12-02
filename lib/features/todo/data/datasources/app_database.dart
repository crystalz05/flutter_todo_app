
import 'package:floor/floor.dart';
import 'package:flutter_todo_app/features/todo/data/datasources/todo_dao.dart';


import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/todo_model.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [TodoModel])
abstract class AppDatabase extends FloorDatabase{
  TodoDao get todoDao;
}