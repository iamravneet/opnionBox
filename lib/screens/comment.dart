import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Step 2: Create the BLoC Classes

class Comment {
  final int? id;
  final String? user;
  final String? text;
  final List<Comment>? replies;

  Comment({this.id, this.user, this.text, this.replies});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'text': text,
    };
  }
}















