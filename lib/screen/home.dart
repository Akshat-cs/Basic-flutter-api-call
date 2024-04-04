import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> repositories = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRepositories();
  }

  Future<void> fetchRepositories() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http
          .get(Uri.parse('https://api.github.com/users/freeCodeCamp/repos'));
      if (response.statusCode == 200) {
        setState(() {
          repositories = json.decode(response.body);
          isLoading = false;
        });
        await fetchLastCommits();
      } else {
        throw Exception('Failed to load repositories');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchLastCommits() async {
    for (var repo in repositories) {
      try {
        final response = await http.get(Uri.parse(
            'https://api.github.com/repos/freeCodeCamp/${repo['name']}/commits'));
        if (response.statusCode == 200) {
          var commits = json.decode(response.body);
          setState(() {
            repo['lastCommit'] = commits.isNotEmpty
                ? commits[0]['commit']['message']
                : 'No commits';
          });
        } else {
          throw Exception('Failed to load last commit');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Repositories'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(repositories[index]['name']),
                  subtitle: Text(repositories[index]['lastCommit'] ??
                      'Loading last commit...'),
                );
              },
            ),
    );
  }
}
