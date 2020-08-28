import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:iMomentum/app/models/folder.dart';

/// Note Card UI in List
///
class NotesFolderContainer extends StatelessWidget {
  final Folder folder;
  final Function onTap;
  final int notesNumber;

  NotesFolderContainer({this.folder, this.onTap, this.notesNumber});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 180,
        width: 180,
        margin: EdgeInsets.only(left: 8.0, right: 8),
        decoration: BoxDecoration(
          color: darkThemeNoteFolder,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Spacer(),
                      Icon(EvaIcons.bookOutline, size: 50),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AutoSizeText(
                          folder.title ?? '',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          minFontSize: 18,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'OpenSans'),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${notesNumber.toString()}',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
//                    Icon(Icons.chevron_right)
                  ],
                )
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
      ),
    );
  }
}

/// Note Card UI in List
//class NotesFolderContainerButton extends StatelessWidget {
//  final Function onTap;
//
//  NotesFolderContainerButton({this.onTap});
//
//  @override
//  Widget build(BuildContext context) {
//    return Center(
//      child: InkWell(
//        onTap: onTap,
//        child: Container(
//          height: 200,
//          width: 160,
//          decoration: BoxDecoration(
//            image: DecorationImage(
//              image: AssetImage(
//                'assets/images/images_notes/ic_4288585374.png',
//              ),
//              fit: BoxFit.cover,
////          colorFilter: ColorFilter.mode(
////              Colors.transparent.withOpacity(0.8), BlendMode.dstATop),
//            ),
//          ),
////      constraints: BoxConstraints.expand(),
//          child: Center(
//            child: Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Row(
//                children: <Widget>[
//                  Icon(Icons.add),
//                  SizedBox(width: 3),
//                  Text(
//                    'Add Folder',
//                    style: TextStyle(
//                        fontSize: 22,
//                        color: Colors.white,
//                        fontFamily: 'OpenSans'),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
