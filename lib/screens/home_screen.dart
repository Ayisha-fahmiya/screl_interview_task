import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/adapters.dart';
// import 'package:hive_flutter/adapters.dart';
import 'package:screl_interview_task/models/user_model.dart';
import 'package:screl_interview_task/provider/user_provider.dart';
import 'package:screl_interview_task/responsive/responsive.dart';
import 'package:screl_interview_task/screens/user_details_screen.dart';
import 'package:screl_interview_task/utilities/clear_form_fields.dart';
import 'package:screl_interview_task/widgets/search_input.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<UserModel> users = ref.watch(usersProvider);
    TextEditingController nameController = ref.watch(nameControllerProvider);
    TextEditingController emailController = ref.watch(emailControllerProvider);
    final nameKey = GlobalKey<FormState>();
    final emailKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchInput(users: users),
              SizedBox(height: R.sh(20, context)),
              usersList(users, context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[50],
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add new user"),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: nameKey,
                        child: TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Form(
                        key: emailKey,
                        child: TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            }
                            if (!RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      clearFormFields(ref);
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (nameKey.currentState!.validate() &&
                          emailKey.currentState!.validate()) {
                        var box = await Hive.openBox('userBox');

                        final fullUuid = const Uuid().v4();
                        final truncatedUuid = fullUuid.substring(0, 5);
                        // final newUser = UserModel(
                        //   id: truncatedUuid,
                        //   name: nameController.text,
                        //   email: emailController.text,
                        //   createdAt: DateTime.now(),
                        // );
                        final newUserMap = {
                          'id': truncatedUuid,
                          'name': nameController.text,
                          'email': emailController.text,
                          'createdAt': DateTime.now().toString(),
                        };
                        box.put(newUserMap['id'], newUserMap);
                        final newUser = UserModel.fromMap(newUserMap);

                        ref.read(usersProvider.notifier).addUser(newUser);
                        Navigator.pop(context);
                        clearFormFields(ref);
                      }
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: const Text("Add"),
      ),
    );
  }

  SizedBox usersList(List<UserModel> users, BuildContext context) {
    return SizedBox(
      height: users.length * R.sh(80, context),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: Colors.amber[50],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailsScreen(
                    id: users[index].id,
                    userName: users[index].name,
                    userEmail: users[index].email,
                    createdAt: users[index].createdAt,
                  ),
                ),
              );
            },
            title: Text(users[index].name),
            subtitle: Text(users[index].email),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Are you sure?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(usersProvider.notifier)
                                  .removeUser(index);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.delete),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Gap(R.sh(12, context));
        },
        itemCount: users.length,
      ),
    );
  }
}
