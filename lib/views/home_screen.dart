import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/view_model/app_brain.dart';
import 'package:chat_app/views/sign_in_screen.dart';
import 'package:chat_app/widgets/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appBarBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsPadding: const EdgeInsets.only(right: 8.0),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          PopupMenuButton<String>(
            color: AppColors.chatBubbleBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'signOut') {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                    (route) => false);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'signOut',
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
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
            final availableUsers = value
                .where((user) => user.id != FirebaseAuth.instance.currentUser!.uid)
                .length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Chaty",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  "$availableUsers users are available",
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
          final users = value
              .where((user) => user.id != FirebaseAuth.instance.currentUser!.uid)
              .toList();
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return InkWell(
                borderRadius: BorderRadius.circular(12),
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
