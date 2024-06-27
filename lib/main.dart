import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Post.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'List View',
      home: PostListScreen(),
    );
  }
}

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Post> fetchedPosts = data
            .map((json) => Post(
          userId: json['userId'],
          id: json['id'],
          title: json['title'],
          body: json['body'],
        ))
            .toList();

        setState(() {
          posts = fetchedPosts;
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      debugPrint('Error fetching posts: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
            child: Text(
              'List View',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            )),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  post.body,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 5),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}