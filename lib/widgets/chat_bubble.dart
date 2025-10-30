import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants/app_colors.dart';

class ChatBubble extends StatefulWidget {
  ChatBubble({super.key, required this.model, required this.chatId});

  final MessageModel model;

  final String chatId;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _animation;
  late final bool isMe;

  @override
  void initState() {
    isMe = FirebaseAuth.instance.currentUser!.uid == widget.model.senderId;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation =
        Tween(
          begin: Offset(isMe ? 0.5 : -0.5, 0.0),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutQuart,
          ),
        );
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppColors.chatBubbleBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                "Message Info",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sent by: ${widget.model.senderName}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sent at: ${widget.model.timeStamp.toLocal()}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(color: AppColors.brightGreen),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await ChatService.deletemessage(
                      widget.chatId,
                      widget.model.id,
                      context,
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text("delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      child: SlideTransition(
        position: _animation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                child: Column(
                  crossAxisAlignment: isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isMe
                            ? AppColors.brightGreen
                            : AppColors.chatBubbleBackground,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: isMe
                              ? const Radius.circular(18)
                              : const Radius.circular(4),
                          bottomRight: isMe
                              ? const Radius.circular(4)
                              : const Radius.circular(18),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                widget.model.senderName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: AppColors.brightGreen,
                                ),
                              ),
                            ),
                          Text(
                            widget.model.message,
                            style: TextStyle(
                              color: isMe ? AppColors.background : Colors.white,
                              fontSize: 16,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                timeago.format(widget.model.timeStamp),
                                style: TextStyle(
                                  color: isMe
                                      ? AppColors.background.withOpacity(0.8)
                                      : Colors.grey.shade400,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (isMe)
                                Icon(
                                  Icons.done_all,
                                  size: 14,
                                  color: AppColors.background,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
