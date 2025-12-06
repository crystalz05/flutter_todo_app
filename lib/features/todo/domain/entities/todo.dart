
import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isDone;
  final int createdAt;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
    required this.createdAt
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
    int? createdAt,
  }) {

    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, description, isDone, createdAt];
}