
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

  @override
  List<Object?> get props => [id, title, description, isDone, createdAt];
}