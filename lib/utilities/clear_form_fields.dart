import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screl_interview_task/provider/user_provider.dart';

void clearFormFields(WidgetRef ref) {
  ref.watch(nameControllerProvider).clear();
  ref.watch(emailControllerProvider).clear();
}
