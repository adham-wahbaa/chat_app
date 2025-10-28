import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class AppBrain {
  ValueNotifier<List<UserModel>> users = ValueNotifier([]);
  //ValueNotifier<List<MessageModel>> messages = ValueNotifier([]);
}

final appBrain = AppBrain();
