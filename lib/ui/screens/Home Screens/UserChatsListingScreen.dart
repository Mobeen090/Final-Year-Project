import 'package:flutter/material.dart';

class UserChatListingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PeopleList(),
    );
  }
}

class PeopleList extends StatelessWidget {
  final List<String> people = [
    'John Doe',
    'Jane Doe',
    'Alice',
    'Bob',
    'Charlie',
    'David',
    'Eva',
    'Frank',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: people.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: CircleAvatar(
            // You can replace this with actual user images
            child: Text(people[index][0]),
          ),
          title: Text(people[index]),
          subtitle: Text('Last message or status here'),
          onTap: () {
            // Handle tap on a person in the list
            print('Tapped on ${people[index]}');
            // Add your navigation or other logic here
          },
        );
      },
    );
  }
}
