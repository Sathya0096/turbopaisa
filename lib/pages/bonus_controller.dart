import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../api/model/UserData.dart';

class BonusController extends GetxController {
  var streakDays = 0.obs;
  var tasksCompleted = 0.obs;
  var dailyCollected = false.obs;
  var lastCollected = DateTime.now().obs;
  var timeLeft = "00:00:00".obs;
  var dailyProgress = 0.0.obs;
  var streakProgress = 0.0.obs;
  var taskProgress = 0.0.obs;

  final countdownSeconds = 86400.obs; // Change this to 86400 for 24 hours

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    _loadData();
    _startTimer();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    streakDays.value = prefs.getInt('streakDays') ?? 0;
    tasksCompleted.value = prefs.getInt('tasksCompleted') ?? 0;
    dailyCollected.value = prefs.getBool('dailyCollected') ?? false;
    String? lastCollectedString = prefs.getString('lastCollected');
    if (lastCollectedString != null) {
      lastCollected.value = DateTime.parse(lastCollectedString);
      _checkReset();
    }
  }

  _checkReset() {
    if (lastCollected.value == null) return;

    final now = DateTime.now();
    if (now.difference(lastCollected.value).inSeconds >=
        countdownSeconds.value) {
      dailyCollected.value = false;
      timer?.cancel(); // Stop the timer if countdown is over
    }

    if (now.difference(lastCollected.value).inDays > 1) {
      streakDays.value = 0; // Reset streak if missed a day
    }

    _updateProgress();
  }

  _updateProgress() {
    final now = DateTime.now();
    final timeSinceLastCollect = now.difference(lastCollected.value);

    // Daily Progress
    dailyProgress.value =
        timeSinceLastCollect.inSeconds / countdownSeconds.value;
    if (dailyProgress.value > 1) dailyProgress.value = 1.0;

    // Streak Progress
    streakProgress.value = streakDays.value / 10;
    if (streakProgress.value > 1) streakProgress.value = 1.0;

    // Task Progress
    taskProgress.value = tasksCompleted.value / 5;
    if (taskProgress.value > 1) taskProgress.value = 1.0;
  }

  _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (lastCollected.value != null) {
        final difference = lastCollected.value
            .add(Duration(seconds: countdownSeconds.value))
            .difference(now);

        if (difference.isNegative || difference.inSeconds == 0) {
          timeLeft.value = "00:00:00";
          dailyCollected.value = false; // Enable collect button
          timer.cancel(); // Stop the timer
        } else {
          timeLeft.value = _formatDuration(difference);
          _updateProgress();
        }
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  collectTenDaysBonus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (streakDays.value > 10)
      streakDays.value = 0;
    else
      streakDays.value += 1;
    prefs.setInt('streakDays', streakDays.value);

    _updateProgress();
  }

  void collectDailyBonus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (streakDays.value > 10)
    //   streakDays.value = 0;
    // else
    // streakDays.value += 1;
    await
    checkUserStatus();
    dailyCollected.value = true;
    lastCollected.value = DateTime.now();
    prefs.setInt('streakDays', streakDays.value);
    prefs.setBool('dailyCollected', dailyCollected.value);
    prefs.setString('lastCollected', lastCollected.value.toString());

    _updateProgress();
    _startTimer(); // Restart the timer for the next period
  }

  void collectTaskBonus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tasksCompleted.value = 0; // assuming 5 tasks completed
    prefs.setInt('tasksCompleted', tasksCompleted.value);

    checkUserStatusTwo();
    _updateProgress();
  }

  UserData? dataUser;

  Future<void> loadReferalCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = await prefs.getString("user");
    UserData data = UserData.fromJson(jsonDecode(user!));

    dataUser = data;
  }

  Future<void> checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await loadReferalCode();
    final url = 'https://dev.turbopaisa.com/services/users/check_user_status';

    final body = jsonEncode({'user_id': dataUser?.userId});

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'auth-key': 'earncashRestApi'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final dailyLogin = data['daily_login'];
        final status = dailyLogin['status'];
        final message = dailyLogin['message'];

        // Convert streak_count to integer
        final streakCount = int.tryParse(dailyLogin['streak_count']) ?? 0;

        // Ensure task_count is also correctly handled
        final taskCount = dailyLogin['task_count'] is int
            ? dailyLogin['task_count']
            : int.tryParse(dailyLogin['task_count'].toString()) ?? 0;

        tasksCompleted.value = taskCount;
        streakDays.value = streakCount;

        // Store streakDays in SharedPreferences
        prefs.setInt('streakDays', streakDays.value);

        print('Status: $status');
        print('Message: $message');
        print('Streak Count: $streakCount');
        print('Task Count: $taskCount');
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> checkUserStatusTwo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await loadReferalCode();
    final url = 'https://dev.turbopaisa.com/services/users/claim_task_bonus';

    final body = jsonEncode({'user_id': dataUser?.userId});

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'auth-key': 'earncashRestApi'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final dailyLogin = data['task_completion'];
        final status = dailyLogin['status'];
        final message = dailyLogin['message'];

        // Convert streak_count to integer
        final streakCount = int.tryParse(dailyLogin['streak_count']) ?? 0;

        // Ensure task_count is also correctly handled
        final taskCount = dailyLogin['status'] is int
            ? dailyLogin['status']
            : int.tryParse(dailyLogin['status'].toString()) ?? 0;

        tasksCompleted.value = taskCount;
        streakDays.value = streakCount;

        // Store streakDays in SharedPreferences
        prefs.setInt('streakDays', streakDays.value);

        print('Status: $status');
        print('Message: $message');

      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Future<void> checkUserStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   await loadReferalCode();
  //   final url = 'https://dev.turbopaisa.com/services/users/check_user_status';
  //
  //   final body = jsonEncode({'user_id': dataUser?.userId});
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {'Content-Type': 'application/json','auth-key':'earncashRestApi'},
  //       body: body,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //
  //       final dailyLogin = data['daily_login'];
  //       final status = dailyLogin['status'];
  //       final message = dailyLogin['message'];
  //       final streakCount = dailyLogin['streak_count'];
  //       final taskCount = dailyLogin['task_count'];
  //       tasksCompleted.value = taskCount;
  //       streakDays.value = streakCount;
  //       prefs.setInt('streakDays', streakDays.value);
  //       print('Status: $status');
  //       print('Message: $message');
  //       print('Streak Count: $streakCount');
  //       print('Task Count: $taskCount');
  //     } else {
  //       print('Failed to load data. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

}
