import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opinion_box/screens/comment_section.dart';
import 'package:opinion_box/screens/comment.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'bloc/comment_bloc.dart';


void main() {
  sqfliteFfiInit();
  runApp( const MyApp());
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: BlocProvider<CommentBloc>(
      create: (context) => CommentBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Comment Section'),
        ),
        body: CommentSection(),
      ),
    ),
  );
}
}
