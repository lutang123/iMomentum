// import 'package:flutter/material.dart';
// import 'package:iMomentum/app/common_widgets/my_round_button.dart';
//
// class TimerButtonRow extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 60,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             RoundTextButton(
//               text: 'Cancel',
//               textColor: Colors.white70,
//               onPressed: _end,
//               circleColor: Colors.white70,
//               fillColor: Colors.black12,
//             ),
//             _stopwatch.isRunning
//                 ? RoundTextButton(
//                     text: 'Pause',
//                     textColor: Colors.white,
//                     onPressed: _pause,
//                     circleColor: Colors.white,
//                     fillColor: Colors.deepOrange.withOpacity(0.3),
//                   )
//                 : RoundTextButton(
//                     text: 'Resume',
//                     textColor: Colors.white,
//                     onPressed: _resume,
//                     circleColor: Colors.white,
//                     fillColor: Colors.lightGreenAccent.withOpacity(0.3),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
