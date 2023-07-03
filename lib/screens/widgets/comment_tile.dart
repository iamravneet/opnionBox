import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/comment_bloc.dart';
import '../comment.dart';


class CommentTile extends StatelessWidget {
  final Comment comment;
  final FocusNode node;
  bool showReply;
  int commentId;



  CommentTile({
    Key? key,
    required this.comment,
    required this.node,
    this.showReply = false,

  }) : commentId = comment.id ?? 0, super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentBloc = BlocProvider.of<CommentBloc>(context);
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              foregroundImage: AssetImage('assets/profile_image.jpeg'),
              radius: 25,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment.user ?? ''),
                          Text(comment.text ?? '')
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz),
                        onPressed: () {
                          _showReplyDialog(context, commentBloc);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                    onTap: (){
                      commentId = comment.id ?? 0;
                      FocusScope.of(context).requestFocus(node);
                    },
                    child: const Text('Reply')),
                if (comment.replies != null && comment.replies!.isNotEmpty)
                  Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(left: 50),
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: comment.replies!
                          .map(
                            (reply) => Text(reply.text ?? ''),
                      )
                          .toList(),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }




  void _showReplyDialog(BuildContext context, CommentBloc commentBloc) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close)),
              Center(
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    commentBloc.deleteComment(comment);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}