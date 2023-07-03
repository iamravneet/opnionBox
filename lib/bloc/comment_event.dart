abstract class CommentEvent {}

class AddCommentEvent extends CommentEvent {
  final String user;
  final String text;

  AddCommentEvent(this.user, this.text,);
}

