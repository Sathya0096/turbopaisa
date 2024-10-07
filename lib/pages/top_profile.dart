import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offersapp/api/model/UserData.dart';
import 'package:offersapp/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopProfileAppBarWidget extends StatefulWidget {
  const TopProfileAppBarWidget({Key? key}) : super(key: key);

  @override
  State<TopProfileAppBarWidget> createState() => _TopProfileAppBarWidgetState();
}

class _TopProfileAppBarWidgetState extends State<TopProfileAppBarWidget> {
  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryColor1.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      height: 80,
      child: Row(
        children: [
          CircleAvatar(
            child: Icon(
              Icons.person,
              color: Colors.blue,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hello,"),
              Text(userData?.name?.toUpperCase() ?? ""),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                border: Border.fromBorderSide(
                  BorderSide(width: 1, color: Colors.green.withOpacity(0.5)),
                ),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Icon(
                  Icons.currency_rupee,
                  size: 18,
                  color: Colors.green,
                ),
                Text(
                  "500",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  UserData? userData;

  Future<void> loadProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      UserData data = UserData.fromJson(jsonDecode(user!));
      setState(() {
        userData = data;
      });
    } catch (e) {
      print(e);
    }
  }
}
