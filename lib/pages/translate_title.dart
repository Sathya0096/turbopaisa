// import 'package:flutter/material.dart';
// import 'package:offersapp/pages/translator_provider.dart';
// import 'package:provider/provider.dart';
//
// class TranslateTitle extends StatelessWidget {
//   // const TranslateTitle({super.key});
//   final String title;
//
//   const TranslateTitle({super.key, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<UserInfo>(
//         builder: (context, counter, child) {
//           return FutureBuilder<String>(
//             future: counter.translateText(title), // Replace with your input and target language code
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               } else if (snapshot.hasError) {
//                 return Text('');
//               } else {
//                 return Text(snapshot.data ?? '',
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     height: 1.38,
//                   ),); // Display translated title
//               }
//             },
//           );
//         }
//     ),;
//   }
// }
