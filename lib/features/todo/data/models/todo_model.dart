
import 'package:floor/floor.dart';
import 'package:flutter_todo_app/features/todo/domain/entities/todo.dart';

@entity
class TodoModel{

  @primaryKey
  final String id;
  final String title;
  final String description;
  final bool isDone;
  final int createdAt;

  const TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
    required this.createdAt,
  });

  // const TodoModel({
  //
  //   required super.id,
  //   required super.title,
  //   required super.description,
  //   required super.isDone,
  //   required super.createdAt
  // });

  // const TodoModel({
  //   required this.id,
  //   required this.title,
  //   required this.description,
  //   required this.isDone,
  //   required this.createdAt,
  // }) : super(
  //     id: id,
  //     title: title,
  //     description: description,
  //     isDone: isDone,
  //     createdAt: createdAt);

  //convert from entity to data model
  factory TodoModel.fromEntity(Todo todo){
    return TodoModel(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isDone: todo.isDone,
        createdAt: todo.createdAt);
  }

  //Convert to domain entity
  Todo toEntity(){
    return Todo(
        id: id,
        title: title,
        description: description,
        isDone: isDone,
        createdAt: createdAt
    );
  }

  //create a copy with modifications
  TodoModel copyWith({

    String? id,
    String? title,
    String? description,
    bool? isDone,
    int? createdAt,
  }){
    return TodoModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isDone: isDone ?? this.isDone,
        createdAt: createdAt ?? this.createdAt
    );
  }
}

