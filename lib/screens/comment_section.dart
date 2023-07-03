import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opinion_box/screens/widgets/comment_tile.dart';
import '../bloc/comment_bloc.dart';
import '../bloc/comment_event.dart';
import '../bloc/comment_state.dart';
import 'comment.dart';

class CommentSection extends StatelessWidget {
  final TextEditingController commentController = TextEditingController();
  final commentFocusNode = FocusNode();
  bool showReply = false;
  int commentId = 0;

  CommentSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentBloc = BlocProvider.of<CommentBloc>(context);
    commentBloc.fetchComments();
    return SingleChildScrollView(
      child: Column(
        children: [
          if(commentId != 0)
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey.shade200,
              width: MediaQuery.of(context).size.width,
              child: const Text('Reply to User'),
            ),
          Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 70,
                  child: TextField(
                    controller: commentController,
                    focusNode: commentFocusNode,
                    onSubmitted: (_){
                      showReply = false;
                    },
                    decoration: const InputDecoration(hintText: 'Enter your comment'),
                  ),
                ),
                IconButton(
                    onPressed: (){
                      final String commentText = commentController.text;
                      if (commentId == 0) {
                        commentBloc.add(AddCommentEvent('User', commentText));
                        commentController.clear();
                      } else {
                        if (commentText.isNotEmpty) {
                         // commentBloc.add(ReplyToCommentEvent(commentId, 'User', commentText));
                          //commentController.clear();
                        }
                      }
                    },
                    icon: const Icon(Icons.send)),
              ],
            ),
          ),
          BlocConsumer<CommentBloc, CommentState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is CommentsLoadingState) {
                return const CircularProgressIndicator();
              } else if (state is CommentsLoadedState) {
                final List<Comment> comments = state.comments;
                return SingleChildScrollView(
                  child: Column(
                    children: comments.map((comment) {
                      return CommentTile(comment: comment, node: commentFocusNode, showReply: showReply,);
                    }).toList(),
                  ),
                );
              } else if (state is CommentsErrorState) {
                return const CircularProgressIndicator();
              }

              return const SizedBox.shrink();
            },

          ),

        ],
      ),
    );
  }
}