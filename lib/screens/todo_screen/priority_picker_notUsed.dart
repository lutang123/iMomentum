// import 'package:flutter/material.dart';
//
// class PriorityPicker extends StatefulWidget {
//   final Function(int) onTap;
//   final int selectedIndex;
//   PriorityPicker({this.onTap, this.selectedIndex});
//   @override
//   _PriorityPickerState createState() => _PriorityPickerState();
// }
//
// class _PriorityPickerState extends State<PriorityPicker> {
//   int selectedIndex;
//   List<String> priorityText = ['Low', 'High', 'Very High'];
//   List<Color> priorityColor = [Colors.green, Colors.lightGreen, Colors.red];
//   @override
//   Widget build(BuildContext context) {
//     if (selectedIndex == null) {
//       selectedIndex = widget.selectedIndex;
//     }
//     double width = MediaQuery.of(context).size.width;
//     return SizedBox(
//       width: width,
//       height: 60,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 3,
//         itemBuilder: (BuildContext context, int index) {
//           return InkWell(
//             onTap: () {
//               setState(() {
//                 selectedIndex = index;
//               });
//               widget.onTap(index);
//             },
//             child: Container(
//               padding: EdgeInsets.all(8.0),
//               width: width / 3,
//               height: 70,
//               child: Container(
//                 child: Center(
//                   child: Text(priorityText[index],
//                       style: TextStyle(
//                           color: selectedIndex == index
//                               ? Colors.white
//                               : Colors.black,
//                           fontWeight: FontWeight.bold)),
//                 ),
//                 decoration: BoxDecoration(
//                     color: selectedIndex == index
//                         ? priorityColor[index]
//                         : Colors.transparent,
//                     borderRadius: BorderRadius.circular(8.0),
//                     border: selectedIndex == index
//                         ? Border.all(width: 2, color: Colors.black)
//                         : Border.all(width: 0, color: Colors.transparent)),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// //Row(
// //                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                  children: <Widget>[
// //                    Expanded(
// //                      child: Padding(
// //                        padding: const EdgeInsets.all(8.0),
// //                        child: Text(
// //                          this.noteList[index].title,
// //                          style: Theme.of(context).textTheme.body1,
// //                        ),
// //                      ),
// //                    ),
// //                    Text(
// //                      getPriorityText(this.noteList[index].priority),
// //                      style: TextStyle(
// //                          color:
// //                              getPriorityColor(this.noteList[index].priority)),
// //                    ),
// //                  ],
// //                ),
//
// // Returns the priority color
// Color getPriorityColor(int priority) {
//   switch (priority) {
//     case 1:
//       return Colors.red;
//       break;
//     case 2:
//       return Colors.yellow;
//       break;
//     case 3:
//       return Colors.green;
//       break;
//
//     default:
//       return Colors.yellow;
//   }
// }
//
// // Returns the priority icon
// String getPriorityText(int priority) {
//   switch (priority) {
//     case 1:
//       return '!!!';
//       break;
//     case 2:
//       return '!!';
//       break;
//     case 3:
//       return '!';
//       break;
//
//     default:
//       return '!';
//   }
// }
