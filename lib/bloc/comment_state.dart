import '../screens/comment.dart';

abstract class CommentState {}

class CommentsLoadingState extends CommentState {}

class CommentsLoadedState extends CommentState {
  final List<Comment> comments;

  CommentsLoadedState(this.comments);
}

class CommentsErrorState extends CommentState {
  final String errorMessage;

  CommentsErrorState(this.errorMessage);
}