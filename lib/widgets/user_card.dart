import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key,required this.model});

  final UserModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.brightGreen,width: 2),
                  shape: BoxShape.circle
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541"),
                  child: Text(model.username[0].toUpperCase(),style: TextStyle(color: Colors.green.shade900),),
                
                ),
              ),
              Positioned(
                bottom: 0,
                right: 5,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(shape: BoxShape.circle,color: AppColors.brightGreen),
                ),
              )
            ],
          ),
          const SizedBox(width: 10,),
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.username,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Row(
                children: [
                  Icon(Icons.mail_outline,color: Colors.grey.shade600,size: 15,),
                  const SizedBox(width: 5,),
                  Text(model.email,style: TextStyle(color: Colors.grey.shade600),)
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.brightGreen
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Text("Available to chat")
                ],
              )
            ],
          ),
          Spacer(),
          Column(
            children: [
              Text("now"),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.brightGreen
                ),
                child: Icon(Icons.chat_bubble,color: Colors.white,size: 15,),
              )
            ],
          )
        ],
      ),
    );
  }
}