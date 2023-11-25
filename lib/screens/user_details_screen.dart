import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  final String id;
  final String userName;
  final String userEmail;
  final DateTime createdAt;
  const UserDetailsScreen({
    super.key,
    required this.id,
    required this.userName,
    required this.userEmail,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Table(
            children: [
              TableRow(
                children: [
                  Text("Name"),
                  Text(userName),
                ],
              ),
              TableRow(
                children: [
                  Text("Email"),
                  Text(userEmail),
                ],
              ),
              TableRow(
                children: [
                  Text("Created at"),
                  Text(
                      "${createdAt.day} / ${createdAt.month} / ${createdAt.year}, ${createdAt.hour} : ${createdAt.minute}"),
                ],
              ),
              TableRow(
                children: [
                  Text("Id"),
                  Text(id),
                ],
              ),
            ],
          ),
          // SingleChildScrollView(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(userName),
          //       Text(userEmail),
          //       Text(
          //           "${createdAt.day} / ${createdAt.month} / ${createdAt.year}"),
          //       Text("${createdAt.hour} : ${createdAt.minute}"),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
