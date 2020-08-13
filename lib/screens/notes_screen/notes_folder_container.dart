import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/models/folder.dart';

/// Note Card UI in List
///
class NotesFolderContainer extends StatelessWidget {
  final Folder folder;
  final Function onTap;

  NotesFolderContainer({this.folder, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 180,
        width: 180,
        margin: EdgeInsets.only(left: 8.0, right: 8),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.book, size: 40),
              SizedBox(height: 8),
              InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    folder.title ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'OpenSans'),
                  ),
                ),
              ),
//        Center(
//          child: Container(
//            height: 200,
//            width: 160,
//            decoration: BoxDecoration(
//              image: DecorationImage(
//                image: AssetImage(
//                  'assets/images/images_notes/ic_${folder.colorCode}.png',
//                ),
//                fit: BoxFit.cover,
//                colorFilter: ColorFilter.mode(
//                    Colors.transparent.withOpacity(0.5), BlendMode.dstATop),
//              ),
//            ),
//            child: Center(
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  folder.title ?? '',
//                  maxLines: 3,
//                  style: TextStyle(
//                      fontSize: 22,
//                      color: Colors.white,
//                      fontFamily: 'OpenSans'),
//                ),
//              ),
//            ),
//          ),
//        )
            ],
          ),
        ),
      ),
    );
  }
}

///
//class NotesFolderContainer extends StatelessWidget {
//  final Folder folder;
//  final Function onTap;
//
//  NotesFolderContainer({this.folder, this.onTap});
//
//  @override
//  Widget build(BuildContext context) {
//    return Stack(
//      children: [
//        Center(
//          child: InkWell(
//            onTap: onTap,
//            child: Container(
//              height: 180,
//              width: 140,
//              decoration: BoxDecoration(
//                image: DecorationImage(
//                  image: AssetImage(
//                    'assets/images/images_notes/ic_${folder.colorCode}.png',
//                  ),
//                  fit: BoxFit.cover,
////                  colorFilter: ColorFilter.mode(
////                      Colors.transparent.withOpacity(0.3), BlendMode.softLight),
//                ),
//              ),
////      constraints: BoxConstraints.expand(),
//              child: Center(
//                child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Text(
//                    folder.title ?? '',
//                    maxLines: 3,
//                    style: TextStyle(
//                        fontSize: 22,
//                        color: Colors.white,
//                        fontFamily: 'OpenSans'),
//                  ),
//                ),
//              ),
//            ),
//          ),
//        ),
////        Center(
////          child: Container(
////            height: 200,
////            width: 160,
////            decoration: BoxDecoration(
////              image: DecorationImage(
////                image: AssetImage(
////                  'assets/images/images_notes/ic_${folder.colorCode}.png',
////                ),
////                fit: BoxFit.cover,
////                colorFilter: ColorFilter.mode(
////                    Colors.transparent.withOpacity(0.5), BlendMode.dstATop),
////              ),
////            ),
////            child: Center(
////              child: Padding(
////                padding: const EdgeInsets.all(8.0),
////                child: Text(
////                  folder.title ?? '',
////                  maxLines: 3,
////                  style: TextStyle(
////                      fontSize: 22,
////                      color: Colors.white,
////                      fontFamily: 'OpenSans'),
////                ),
////              ),
////            ),
////          ),
////        )
//      ],
//    );
//  }
//}

/// Note Card UI in List
class NotesFolderContainerButton extends StatelessWidget {
  final Function onTap;

  NotesFolderContainerButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 200,
          width: 160,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/images_notes/ic_4288585374.png',
              ),
              fit: BoxFit.cover,
//          colorFilter: ColorFilter.mode(
//              Colors.transparent.withOpacity(0.8), BlendMode.dstATop),
            ),
          ),
//      constraints: BoxConstraints.expand(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.add),
                  SizedBox(width: 3),
                  Text(
                    'Add Folder',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontFamily: 'OpenSans'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
