import 'package:flutter/material.dart';
import 'details_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key); // Constructor adjustment

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List _searchResults = [];
  TextEditingController _searchController = TextEditingController();

  _searchMovies(String query) async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
    if (response.statusCode == 200) {
      setState(() {
        _searchResults = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
          ),
          onSubmitted: (query) {
            _searchMovies(query);
          },
        ),
      ),
      body: _searchResults.isEmpty
          ? const Center(child: Text('Search for a movie'))
          : ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final movie = _searchResults[index]['show'];
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
