import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:offersapp/pages/wallet_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/app_route.dart';
import '../api/api_services/wallet_service.dart';
import '../api/model/UserData.dart';
import '../api/model/WalletResponse.dart';
import '../utils/app_colors.dart';

class NewSpin extends ConsumerStatefulWidget {
  const NewSpin({Key? key}) : super(key: key);

  @override
  _NewSpinState createState() => _NewSpinState();
}

class _NewSpinState extends ConsumerState<NewSpin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();
  double _currentAngle = 0;
  final int _numSections = 8; // Number of sections on the spinner
  bool _isSpinning = false;
  bool _isButtonEnabled = false; // Manage button state
  bool isLoading = false;
  int start = 1;
  var walletProvider = ChangeNotifierProvider((ref) => WalletProvider());
  WalletResponse? walletResponse;

  @override
  void initState() {
    super.initState();
    addSpinStatus();
    loadWallet();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
    _controller.addListener(() {
      setState(() {
        _currentAngle = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int? winningPoints;

  void addSpinPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString("user");
    UserData data = UserData.fromJson(jsonDecode(user!));
    final url = Uri.parse(
        'https://dev.turbopaisa.com/services/spin/insertClaimedSpinAmount');

    final headers = {
      'Content-Type': 'application/json',
      'auth-key': 'earncashRestApi',
    };

    final body = jsonEncode({
      "user_id": data.userId.toString(),
      "earned_amount": winningPoints,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void addSpinStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString("user");
    UserData data = UserData.fromJson(jsonDecode(user!));
    final url = Uri.parse(
        'https://dev.turbopaisa.com/services/spin/getUserSpinsStatus');

    final headers = {
      'Content-Type': 'application/json',
      'auth-key': 'earncashRestApi',
    };

    final body = jsonEncode({
      "user_id": data.userId.toString(),
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // "spin_available": true
      var res = jsonDecode(response.body);
      _isButtonEnabled =
          res['spin_available'].toString() == 'true' ? true : false;
      setState(() {});
      print('Response data: ${response.body}');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void _spin() {
    if (!_isButtonEnabled || _isSpinning)
      return; // Prevent multiple spins simultaneously

    setState(() {
      _isSpinning = true;
      _isButtonEnabled = false; // Disable button while spinning
    });

// Randomize spin duration and the number of full rotations
    int randomDuration =
        _random.nextInt(2000) + 2000; // Duration between 2 and 4 seconds
    double randomSpins = (_random.nextInt(5) + 5)
        .toDouble(); // Random full spins between 5 and 10
    double endAngle = _currentAngle +
        (randomSpins * 2 * pi) +
        _random.nextDouble() * 2 * pi; // Add some extra randomness

    _animation = Tween<double>(begin: _currentAngle, end: endAngle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.decelerate),
    );

    _controller
      ..duration = Duration(milliseconds: randomDuration)
      ..reset() // Ensure the controller is reset before starting
      ..forward().then((_) {
        setState(() {
          _isSpinning = false; // Allow new spins after completion
          _currentAngle = endAngle % (2 * pi);
// Show popup here
        });
        _showPopup();
      });
  }

  void _showPopup() {
    double anglePerSection = (2 * pi) / _numSections;
    int winningIndex = ((_currentAngle % (2 * pi)) / anglePerSection).floor();
    winningIndex = winningIndex % _numSections; // Ensure index is within bounds

// Define points associated with each prize
    List<int> pointsList = [20, 10, 80, 70, 60, 50, 40, 30];

    winningPoints = pointsList[winningIndex];
    setState(() {});
// Debugging
    print('Angle per Section: $anglePerSection');
    print(
        'Winning Index Calculation: ${_currentAngle % (2 * pi)} / $anglePerSection');
    print('Winning Index: $winningIndex');
    print('Winning Points: $winningPoints');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  child: Image.asset('assets/images/spinwallet.png'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'You Have Won',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  '$winningPoints TP POINTS',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    addSpinPoints();
                    Navigator.of(context).pop();
// Re-enable the button after the task is completed
                  },
                  child: Container(
                    height: 40,
                    width: 175,
                    decoration: BoxDecoration(
                        color: const Color(0xffED3E55),
                        borderRadius: BorderRadius.circular(6.67)),
                    child: const Center(
                      child: Text(
                        'Collect',
                        style: TextStyle(color: Colors.white, fontSize: 13.33),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor:
            const Color(0xff3D3FB5), // AppBar color matching the image
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 24,
                    decoration: const BoxDecoration(
                      borderRadius:  BorderRadius.all(Radius.circular(25)),
                      // margin: EdgeInsets.all(5),2
                      // color: AppColors.primaryDarkColor.withOpacity(0.5),
                      color: Color(0xff3D3FB5)
                    ),
                    // padding: EdgeInsets.all(20),
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const WalletBalacePage()));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7),
                                  bottomLeft: Radius.circular(7)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Image.asset(
                                color: Colors.black,
                                'assets/images/wallet_icon.png',
                                fit: BoxFit.contain,
                                width: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Row(
                            children: [
                              SizedBox(
                                height: 14,
                                width: 14,
                                child: Image.asset('assets/images/tp_coin.png'),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${walletResponse?.wallet?.toStringAsFixed(0) ?? "0.0"}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  // fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  height: 1.84,
                                ),
                              ),
                            ],
                          ),
                          //          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                      'Spin & Win',
                      style: TextStyle(
                        fontSize: 28, // Increase the font size
                        fontWeight: FontWeight.w900, // Already the maximum boldness
                        color: Color(0xFF3E3DB2), // Text color matching the image
                        shadows: [
                          Shadow(
                            offset: Offset(1.5, 1.5),
                            blurRadius: 3.0,
                            color: Color.fromARGB(100, 0, 0, 0), // Subtle shadow for added depth
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: _animation.value,
                      child: Image.asset(
                        'assets/images/newspin.png',
                        fit: BoxFit.cover,
                        width: 242,
                        height: 242,
                      ),
                    ),
                    Positioned(
                      right: -17,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/spinarrow.png')),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Stand a chance to win bag full of ',
              style: TextStyle(fontSize: 12, color: Color(0xff3D3FB5)),
            ),
            const Text(
              'Turbo Paisa points',
              style: TextStyle(fontSize: 12, color: Color(0xff3F41B6)),
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: _isButtonEnabled ? _spin : null,
              // Enable/disable button based on state
              child: Container(
                height: 40,
                width: 250,
                decoration: BoxDecoration(
                    color: _isButtonEnabled
                        ? const Color(0xffED3E55)
                        : const Color(0xffED3E55).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6.67)),
                child: const Center(
                  child: Text(
                    'Click Here to Spin',
                    style: TextStyle(color: Colors.white, fontSize: 13.33),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.taskListPage);
              },
              child: Container(
                height: 40,
                width: 250,
                decoration: BoxDecoration(
                    color: const Color(0xffED3E55),
                    borderRadius: BorderRadius.circular(6.67)),
                child: const Center(
                  child: Text(
                    'Complete One task to unlock',
                    style: TextStyle(color: Colors.white, fontSize: 13.33),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You have to complete one task to unlock spin!',
              style: TextStyle(
                  fontSize: 10,
                  color: Color(0xff3D3FB5),
                  fontWeight: FontWeight.bold),
            ),
        // Add your reward widgets here
          ],
        ),
      ),
    );
  }

  Future<void> loadWallet() async {
    try {
      setState(() {
        isLoading = true;
      });
      // final client = await RestClient.getRestClient();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      UserData data = UserData.fromJson(jsonDecode(user!));

      print(start);
      // WalletResponse scratchCardResponse =
      //     await client.getTransactions(data.userId ?? "", start, PAGE_SIZE);
      var res = await ref.read(walletProvider).transactions(
            context: context,
            ref: ref,
            count: '10',
            pagenumber: start.toString(),
            user_id: data.userId,
          );
      if (res == true) {
        var data = ref.watch(walletProvider).data.first;
        setState(() {
          if (start == 1) {
            walletResponse = data;
          } else {
            walletResponse?.transactions?.addAll(data.transactions ?? []);
          }
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }
}
