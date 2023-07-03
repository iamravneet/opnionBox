import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../screens/comment.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  late Database _database;

  CommentBloc() : super(CommentsLoadedState([])) {
    _initDatabase();
    on<AddCommentEvent>((event, emit) async {
      try {
        Comment comment = Comment(user: event.user, text: event.text, replies: []);
        await _insertComment(comment);
        emit(CommentsLoadedState(await _getComments()));
      } catch (error) {
        emit(CommentsErrorState('Failed to add comment.'));
      }
    });

  }

  Future<void> fetchComments() async {
    emit(CommentsLoadingState());
    try {
      final comments = await _getComments();
      emit(CommentsLoadedState(comments));
    } catch (error) {
      emit(CommentsErrorState('Failed to fetch comments.'));
    }
  }


  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'comments_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE comments(id INTEGER PRIMARY KEY AUTOINCREMENT, user TEXT, text TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> _insertComment(Comment comment) async {
    await _database.insert(
      'comments',
      comment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



  Future<List<Comment>> _getComments() async {
    final List<Map<String, dynamic>> maps = await _database.query('comments');
    return List.generate(maps.length, (index) {
      return Comment(
        id: maps[index]['id'] as int?,
        user: maps[index]['user'] as String?,
        text: maps[index]['text'] as String?,
      );
    });
  }

  Future<void> deleteComment(Comment comment) async {
    await _database.delete(
      'comments',
      where: 'id = ?',
      whereArgs: [comment.id],
    );
    emit(CommentsLoadedState(await _getComments()));
  }

  @override
  Future<void> close() {
    _database.close();
    return super.close();
  }

}