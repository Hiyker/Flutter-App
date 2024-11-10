import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Map movie;

  DetailsScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            movie['image'] != null
                ? Image.network(movie['image']['original'])
                : Container(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                movie['summary'].replaceAll(RegExp(r'<[^>]*>'), ''),
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
