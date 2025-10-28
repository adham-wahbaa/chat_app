import 'package:chat_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class AppBrain {
  ValueNotifier<List<UserModel>> users = ValueNotifier([]);
}

final appBrain = AppBrain();
