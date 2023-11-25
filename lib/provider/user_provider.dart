import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screl_interview_task/models/user_model.dart';
import 'package:uuid/uuid.dart';

class UserControllerNotifier extends StateNotifier<List<UserModel>> {
  UserControllerNotifier()
      : super([
          UserModel(
            id: const Uuid().v4().substring(0, 5),
            name: "Ayisha",
            email: "ayisha@gmail.com",
            createdAt: DateTime.now(),
          ),
          UserModel(
            id: const Uuid().v4().substring(0, 5),
            name: "Fahmiya",
            email: "fahmiya@gmail.com",
            createdAt: DateTime.now(),
          ),
        ]);

  addUser(UserModel newUser) {
    return state = [...state, newUser];
  }

  // editUserDate(int index, UserModel updatedUser) {
  //   state = List.from(state);
  //   state[index] = updatedUser;
  // }

  removeUser(int index) {
    state = List.from(state);
    state.removeAt(index);
  }
}

final usersProvider =
    StateNotifierProvider<UserControllerNotifier, List<UserModel>>(
  (ref) => UserControllerNotifier(),
);

final nameControllerProvider = StateProvider((ref) => TextEditingController());
final emailControllerProvider = StateProvider((ref) => TextEditingController());
final searchControllerProvider =
    StateProvider((ref) => TextEditingController());
