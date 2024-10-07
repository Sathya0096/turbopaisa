import 'package:flutter/material.dart';
// import '../components/Style.dart';

class NetworkError extends StatefulWidget {
  const NetworkError({Key? key}) : super(key: key);

  @override
  _NetworkErrorState createState() => _NetworkErrorState();
}

class _NetworkErrorState extends State<NetworkError> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Network Error',),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Image.asset('assets/images/network_error.jpg'),
            ],
          ),
          SizedBox(height: 20,),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     MyButtons(text: 'Try Again.', borderRadius: 2, color: primaryColor,)
          //   ],
          // ),
        ],
      ),
    );
  }
}
