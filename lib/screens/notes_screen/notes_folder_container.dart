import 'package:flutter/material.dart';
import 'package:iMomentum/app/models/note.dart';
import 'package:shape_of_view/shape_of_view.dart';

/// Note Card UI in List
class NotesFolderContainer extends StatelessWidget {
  final Note note;

  NotesFolderContainer(this.note);

//  @override
//  _ItemWidgetState createState() => _ItemWidgetState();
//}
//
//class _ItemWidgetState extends State<ItemWidget> {
//  final Image background;
//
//  @override
//  void initState() {
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      height: 150,
//      width: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/images_notes/ic_4278228616.png',
          ),
//            fit: BoxFit.cover,
//            colorFilter: ColorFilter.mode(
//                Colors.white.withOpacity(0.8), BlendMode.dstATop),
        ),
      ),
//      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              note.title ?? '',
              maxLines: 1,
              style: TextStyle(
                  fontSize: 22, color: Colors.white, fontFamily: 'OpenSans'),
            ),
          ),
          Container(
            color: Colors.white30,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              note.description ?? '',
              style: TextStyle(
                  fontSize: 18,
                  height: 1,
                  color: Colors.white,
                  fontFamily: 'OpenSans'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
