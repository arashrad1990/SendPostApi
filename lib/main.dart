// ignore_for_file: camel_case_types

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Send Post"),
        ),
        body: const page_text(),
      ),
    );
  }
}

class page_text extends StatefulWidget {
  const page_text({super.key});

  @override
  State<page_text> createState() => _page_textState();
}

class _page_textState extends State<page_text> {
  Future<posts>? posttext;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();
// ignore: unused_element
  void _clear() {
    _content.clear();
    _title.clear();
  }

  // ignore: unused_element
  FutureBuilder<posts> _builder() {
    return FutureBuilder(
      future: posttext,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Text("Data Send");
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextField(
            controller: _title,
          ),
          TextField(
            controller: _content,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                posttext = sendpost(_title.text, _content.text);
              });
              _clear();
            },
            child: const Text("Send Post"),
          ),
          Center(
            child: posttext == null ? const Text("") : _builder(),
          ),
        ],
      ),
    );
  }
}

class posts {
  final String? title;
  final String? content;
  // ignore: non_constant_identifier_names
  posts({
    this.content,
    this.title,
  });

  factory posts.fromJson(Map<String, dynamic> json) {
    return posts(
      title: json['title'],
      content: json['content'],
    );
  }
}

Future<posts> sendpost(String title, String content) async {
  String basicauth = 'Basic YWRtaW46YTg2NjA1NzYwNTA0QEE=';
  var responsee = await http.post(
    Uri.https("stokecom.ir", "wp-json/wp/v2/posts/"),
    headers: {
      'Authorization': basicauth,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'content': content,
      'status': 'publish',
    }),
  );

  if (responsee.statusCode == 201) {
    return posts.fromJson(jsonDecode(responsee.body));
  } else {
    throw Exception(responsee.statusCode.toString());
  }
}
