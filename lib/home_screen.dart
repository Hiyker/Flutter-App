import 'package:flutter/material.dart';
import 'details_screen.dart';
import 'search_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key); // Constructor adjustment

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _movies = [];

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  _fetchMovies() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      setState(() {
        _movies = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: _movies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index]['show'];
          return ListTile(
            leading: Image.network(movie['image'] != null ? movie['image']['medium'] : ''),
            title: Text(movie['name']),
            subtitle: Text(movie['summary'].replaceAll(RegExp(r'<[^>]*>'), '')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(movie: movie),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
