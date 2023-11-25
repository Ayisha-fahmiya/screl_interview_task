import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screl_interview_task/models/user_model.dart';
import 'package:screl_interview_task/provider/user_provider.dart';
import 'package:screl_interview_task/responsive/responsive.dart';

class SearchInput extends ConsumerStatefulWidget {
  final List<UserModel> users;
  const SearchInput({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  ConsumerState<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends ConsumerState<SearchInput> {
  List<UserModel> filteredUsers = [];
  @override
  void initState() {
    super.initState();
  }

  void filterOrders(String searchText) {
    setState(() {
      filteredUsers = widget.users
          .where((user) =>
              user.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController =
        ref.watch(searchControllerProvider);
    return Column(
      children: [
        TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          onChanged: (value) {
            filterOrders(value);
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            filled: true,
            fillColor: Colors.transparent,
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.all(20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
        ),
        searchController.text.isEmpty
            ? const SizedBox()
            : SizedBox(
                height: R.sh(filteredUsers.length * 80, context),
                child: ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text(user.email),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
