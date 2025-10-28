import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/view_model/app_brain.dart';
import 'package:chat_app/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/views/private_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    ChatService.fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsPadding: const EdgeInsets.all(12),
        actions: const [Icon(Icons.search), Icon(Icons.more_vert)],
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: ValueListenableBuilder(
          valueListenable: appBrain.users,
          builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("chaty-app", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 10),
                Text(
                  "${appBrain.users.value.length} users are available",
                  style: TextStyle(color: Colors.grey.shade300, fontSize: 14),
                ),
              ],
            );
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: appBrain.users,
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: appBrain.users.value.length,
            itemBuilder: (context, index) {
              final user = appBrain.users.value[index];
              return GestureDetector(
                onTap: () async {
                  final chatId = ChatService.createChatId(user.id);
                  final doesChatExist = await ChatService.checkIfChatExists(
                    chatId,
                  );
                  if (!doesChatExist) {
                    await ChatService.createChat(chatId);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivateChatScreen(
                        chatId: chatId,
                        userModel: user,
                      ),
                    ),
                  );
                },
                child: UserCard(model: user),
              );
            },
          );
        },
      ),
    );
  }
}
