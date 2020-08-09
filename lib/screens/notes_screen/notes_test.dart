import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:provider/provider.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import '../../app/constants/constants.dart';

class NotesTest extends StatefulWidget {
  @override
  _NotesTestState createState() => _NotesTestState();
}

class _NotesTestState extends State<NotesTest> {
  @override
  Widget build(BuildContext context) {
    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);
    final imageNotifier = Provider.of<ImageNotifier>(context);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BuildPhotoView(
          imageUrl:
              _randomOn ? ImageUrl.randomImageUrl : imageNotifier.getImage(),
        ),
        ContainerLinearGradient(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.clear, size: 30),
              color: Colors.white,
            ),
          ),
          body: getNotesList(),
        ),
      ],
    );
  }

  final List folder = [
    'Journal',
    'Reminder',
    'Important',
    'Personal',
    'Others'
//    'Work'
  ];

  Widget getNotesList() {
    final database = Provider.of<Database>(context, listen: false);
    return StaggeredGridView.countBuilder(
//        controller: _scrollController,
//        controller: _hideButtonController,
        staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        physics: BouncingScrollPhysics(),
        crossAxisCount: 4,
//        itemCount: folder.length,
        itemCount: 6,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
//          final note = notes[index];
          return Center(
            child: Container(
                height: 200,
                width: 170,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/images_notes/ic_4278228616.png',
                    ),
                    fit: BoxFit.cover,
//            colorFilter: ColorFilter.mode(
//                Colors.white.withOpacity(0.8), BlendMode.dstATop),
                  ),
                ),
//                constraints: BoxConstraints.,
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Reminder', style: KNoteTitle),
//SizedBox(height: 20),
//                    note.title == null || note.title == ''
//                        ? Container()
//                        :
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text('dvwbhgvyfcyvgjbhjhkjgvhcfgxdcfhg',
                                    style: KNoteTitle,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
//                            note.description,
                                  'hbjvcfhgvjbhjkgjvfcdxcfvgbhkjvgcfhgdxcfvgb',
                                  style: KNoteDescription,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                              //visible: _showAll,
                            ],
                          ),
                        ],
                      ),
                    ),
//                    note.description == null || note.description == ''
//                        ? Container()
//                        :

//                    Text(note)
                  ],
                )),
          );
        });
  }
}
