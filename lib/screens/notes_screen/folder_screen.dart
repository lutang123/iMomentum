import 'dart:async';
import 'package:animations/animations.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iMomentum/app/common_widgets/build_photo_view.dart';
import 'package:iMomentum/app/common_widgets/container_linear_gradient.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/models/folder.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/notes_screen/notes_in_folder_screen.dart';
import 'package:provider/provider.dart';
import 'add_note_screen.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'notes_folder_container.dart';
import 'package:iMomentum/app/utils/cap_string.dart';

class FolderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FolderScreenState();
  }
}

const double _fabDimension = 56.0;

class FolderScreenState extends State<FolderScreen> {
  bool _addButtonVisible = true;
  ScrollController _hideButtonController;

//  // for folder
//  bool isMobile = true;
//  Device device;

  @override
  void initState() {
    super.initState();
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_addButtonVisible == true) {
          setState(() {
            _addButtonVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_addButtonVisible == false) {
            setState(() {
              _addButtonVisible = true;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _hideButtonController.removeListener(() {});
    _hideButtonController.dispose(); //what's the difference?
    super.dispose();
  }

  int counter = 0;

  void _onDoubleTap() {
    setState(() {
      ImageUrl.randomImageUrl =
          'https://source.unsplash.com/random?nature/$counter';
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    final randomNotifier = Provider.of<RandomNotifier>(context);
    bool _randomOn = (randomNotifier.getRandom() == true);

    final imageNotifier = Provider.of<ImageNotifier>(context);

    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

//    double deviceHeight = MediaQuery.of(context).size.height;
//    double deviceWidth = MediaQuery.of(context).size.width;
//    isMobile = deviceWidth > deviceHeight ? false : true;
//
//    device = Device(
//        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BuildPhotoView(
          imageUrl:
              _randomOn ? ImageUrl.randomImageUrl : imageNotifier.getImage(),
        ),
        ContainerLinearGradient(),
        GestureDetector(
          onDoubleTap: _onDoubleTap,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              top: false,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      //this is to make top bar color cover all
                      SizedBox(
                        height: 30,
                        child: Container(
                          color: _darkTheme ? darkAppBar : lightSurface,
                        ),
                      ),
                      Container(
                        height: 50,
                        color: _darkTheme ? darkAppBar : lightSurface,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: Text('Folders',
                                    style:
                                        Theme.of(context).textTheme.headline4),
                              ),
                              FlatButton(
                                  onPressed: () => null,
//                                    Navigator.push(
//                                    context,
//                                    MaterialPageRoute(
//                                        builder: (_) => HomeScreenKeep())),
                                  child: Text('Edit'))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder<List<Folder>>(
                    stream: database.foldersStream(),
                    // print(database.todosStream());//Instance of '_MapStream<QuerySnapshot, List<TodoModel>>'
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<Folder> folders = snapshot.data;
                        if (folders.isNotEmpty) {
                          final List<Folder> defaultFolders = [
                            Folder(id: 0.toString(), title: 'All Notes'),
                            Folder(id: 1.toString(), title: 'Notes'),
                          ];
                          final List<Folder> finalFolders = defaultFolders
                            ..addAll(folders);

                          return Expanded(
                            child: CustomScrollView(
                              shrinkWrap: true,
                              controller: _hideButtonController,
                              // put AppBar in NestedScrollView to have it sliver off on scrolling
                              slivers: <Widget>[
//                                _buildSearchAppBar(),
                                _buildBoxAdaptor(),
                                _buildFolderGrid(database, finalFolders),
                                //filter null views
                              ],
                            ),
                          );
//                            Expanded(
//                            child: Padding(
//                              padding:
//                                  const EdgeInsets.only(left: 8.0, right: 8),
//                              child: getFolderList(database, folders),
//                            ),
//                          );
                        } else {
                          return Expanded(
                            child: CustomScrollView(
                              shrinkWrap: true,
                              controller: _hideButtonController,
                              // put AppBar in NestedScrollView to have it sliver off on scrolling
                              slivers: <Widget>[
//                                _buildSearchAppBar(),
                                _buildBoxAdaptor(),
                                _buildEmptyFolderGrid(database),
                              ],
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Expanded(
                          child: CustomScrollView(
                            shrinkWrap: true,
                            controller: _hideButtonController,
                            // put AppBar in NestedScrollView to have it sliver off on scrolling
                            slivers: <Widget>[
//                              _buildSearchAppBar(),
                              _buildBoxAdaptor(),
                              _buildEmptyFolderGrid(database),
                              //filter null views
                            ],
                          ),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  Visibility(
                    visible: _addButtonVisible,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _darkTheme ? Colors.black38 : lightSurface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: FlatButton.icon(
                              icon: Icon(
                                FontAwesomeIcons.folder,
                                size: 25,
                              ),
                              label: Text(
                                'Add Folder',
                                style: TextStyle(fontSize: 18),
//                                  style: Theme.of(context).textTheme.headline6,
                              ),
                              onPressed: () =>
                                  _showAddDialog(context, database),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: OpenContainer(
                              useRootNavigator: true,
                              transitionType: _transitionType,
                              openBuilder:
                                  (BuildContext context, VoidCallback _) {
                                return AddNoteScreen(database: database);
                              },
                              closedElevation: 6.0,
                              closedColor: Colors.transparent,
                              openColor: Colors.transparent,
                              closedShape: const RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(_fabDimension / 2),
                                ),
                              ),
                              closedBuilder: (BuildContext context,
                                  VoidCallback openContainer) {
                                return SizedBox(
                                    height: _fabDimension,
                                    width: _fabDimension,
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
//        Visibility(
//          visible: _isVisible,
//          child: Stack(
//            overflow: Overflow.visible,
//            alignment: FractionalOffset(0.97, .87),
//            children: [
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//                  FlatButton.icon(
//                    icon: Icon(FontAwesomeIcons.folder),
//                    label: Text('Add Folder'),
//                    onPressed: () => _showEditDialog(context),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(right: 12.0),
//                    child: OpenContainer(
//                      transitionType: _transitionType,
//                      openBuilder: (BuildContext context, VoidCallback _) {
//                        return AddNoteScreen(database: database);
//                      },
//                      closedElevation: 6.0,
//                      closedColor: Colors.transparent,
//                      openColor: Colors.transparent,
////                  shape: CircleBorder(side: BorderSide(color: Colors.white, width: 2.0)),
//                      closedShape: const RoundedRectangleBorder(
//                        side: BorderSide(color: Colors.white, width: 2.0),
//                        borderRadius: BorderRadius.all(
//                          Radius.circular(_fabDimension / 2),
//                        ),
//                      ),
//                      closedBuilder:
//                          (BuildContext context, VoidCallback openContainer) {
//                        return SizedBox(
//                            height: _fabDimension,
//                            width: _fabDimension,
//                            child:
////                      _rotationAnimation == null
////                          ?
//                                Center(
//                              child: Icon(
//                                Icons.add,
//                                size: 30,
//                                color: Colors.white,
//                              ),
//                            ));
//                      },
//                    ),
//                  ),
//                ],
//              ),
//            ],
//          ),
//        ),
      ],
    );
  }

  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  /// spent a lot of time on Sliver App Bar but the space is too big or too small,
  /// later learnt that I should use SliverToBoxAdapter
//  Widget _buildSearchAppBar() {
//    final themeNotifier = Provider.of<ThemeNotifier>(context);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
//    return SliverPadding(
//      padding: const EdgeInsets.only(top: 0.0),
//      sliver: SliverAppBar(
//        backgroundColor: Colors.transparent,
////        backgroundColor: _darkTheme ? Colors.black38 : lightSurface,
//        titleSpacing: 0,
//        elevation: 0,
//        centerTitle: true,
//        snap: true,
//        toolbarHeight: 100,
//        automaticallyImplyLeading: false,
//        stretch: false,
//        floating: true,
////        bottom: PreferredSize(
////          // Add this code
////          preferredSize: Size.fromHeight(0.0), // Add this code
////          child: Text(''), // Add this code
////        ), // Add this code
////          flexibleSpace: /title
//        title: Column(
//          children: [
////              Container(
//////                height: 80,
////                child: Row(
////                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
////                  children: <Widget>[
////                    Padding(
////                      padding: const EdgeInsets.only(left: 25.0),
////                      child: Text('Folders',
////                          style: Theme.of(context).textTheme.headline4),
////                    ),
////                    FlatButton(
////                        onPressed: () => _showEditDialog(context),
////                        child: Text('Edit'))
////                  ],
////                ),
////              ),
//            Padding(
//              padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 0),
//              child: Container(
//                  decoration: BoxDecoration(
//                      color: _darkTheme ? Colors.black38 : lightSurface,
//                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                  child: Row(
//                    children: <Widget>[
//                      FlatButton.icon(
//                          onPressed: null,
//                          icon: Icon(
//                            Icons.search,
//                            color: Colors.white70,
//                          ),
//                          label: Text(
//                            'Search your notes',
//                            style: TextStyle(color: Colors.white70),
//                          ))
//                    ],
//                  )),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

  Widget _buildBoxAdaptor() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 40.0, right: 40, top: 20, bottom: 10),
        child: Container(
            decoration: BoxDecoration(
                color: _darkTheme ? Colors.black38 : lightSurface,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton.icon(

                    ///Todo: implement search
                    onPressed: null,
                    icon: Icon(
                      Icons.search,
                      color: Colors.white70,
                    ),
                    label: Text(
                      'Search your notes',
                      style: TextStyle(color: Colors.white70),
                    )),
//                  IconButton(
//                    icon: Icon(
//                      axisCount == 2 ? EvaIcons.list : EvaIcons.gridOutline,
//                      //dehaze
////                                                    ? Icons.list
////                                                    : Icons.grid_on,
//                      color: _darkTheme ? Colors.white : lightButton,
//                    ),
//                    onPressed: () {
//                      setState(() {
//                        axisCount = axisCount == 2 ? 4 : 2;
//                      });
//                    },
//                  ),
              ],
            )),
      ),
    );
  }

//https://medium.com/@lets4r/flutorial-create-a-staggered-gridview-9c881a9b0b98
  int axisCount = 2;

  Widget _buildFolderGrid(Database database, List<Folder> folders) {
//    List defaultFolders = [
//      Folder(id: 0.toString(), title: 'All Notes'),
//      Folder(id: 1.toString(), title: 'Notes'),
//    ];
//
//    List finalFolderList = defaultFolders..addAll(folders);
//    int columnCount = orientation == Orientation.portrait ? 2 : 3;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      sliver: SliverStaggeredGrid.countBuilder(
        // set column count
        crossAxisCount: 4,
        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
//        staggeredTileBuilder: (int index) =>
//            _buildStaggeredTile(finalFolderList[index], 2),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 10.0,
        //set 2 if using StaggeredTile.extent(1, aspectRatio * columnWidth);
        itemCount: folders.length,
        // set itemBuilder
        itemBuilder: (BuildContext context, int index) {
          final folder = folders[index];
          return Slidable(
            key: UniqueKey(),
            closeOnScroll: true,
            actionPane: SlidableDrawerActionPane(),
//            dismissal: SlidableDismissal(
//              child: SlidableDrawerDismissal(),
//              onDismissed: (actionType) {
//                _delete(context, folder);
//              },
//            ),
            actionExtentRatio: 0.25,
            child: OpenContainer(
//              useRootNavigator: true,
              transitionType: _transitionType,
              closedElevation: 0,
              closedColor: Colors.transparent,
              closedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0))),
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return NotesFolderContainer(
                  folder: folder,
//                onTap: () => _gotoNotesInFolder(database,
//                    folder),
                );
              },
              openElevation: 0,
              openColor: Colors.transparent,
              openBuilder: (BuildContext context, VoidCallback _) {
                return NotesInFolderScreen(
                    database: database, folder: folder, folders: folders);
              },
            ),

//            NotesFolderContainer(
//                folder: folder,
//                onTap: () => _gotoNotesInFolder(database,
//                    folder)), //on tap: NoteFolderDetail(note: folder);
            actions: <Widget>[
              IconSlideAction(
//                caption: 'Edit',
                color: Colors.transparent,
                iconWidget: FaIcon(
                  FontAwesomeIcons.edit,
                  color: Colors.lightBlue,
                ),
//                icon: Icons.delete,
                onTap: () => _showEditDialog(context, database, folder),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
//                caption: 'Delete',
                color: Colors.transparent,
                iconWidget: FaIcon(
                  FontAwesomeIcons.trashAlt,
                  color: Colors.red,
                ),
//                icon: Icons.delete,
                ///add a flush bar and prevent edit on default one
                onTap: () => _showFlushBar(context, folder),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyFolderGrid(Database database) {
    List defaultFolders = [
      Folder(id: 0.toString(), title: 'All Notes'),
      Folder(id: 1.toString(), title: 'Notes'),
    ];

    //no slidable for empty one

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
      sliver: SliverStaggeredGrid.countBuilder(
        // set column count
        crossAxisCount: 4,
        //set 2 if using StaggeredTile.extent(1, aspectRatio * columnWidth);
        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
        //default is 2
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 10.0,
        itemCount: defaultFolders.length,
        // set itemBuilder
        itemBuilder: (BuildContext context, int index) {
          final folder = defaultFolders[index];
          return OpenContainer(
//            useRootNavigator: true,
            transitionType: _transitionType,
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return NotesFolderContainer(
                folder: folder,
//                onTap: () => _gotoNotesInFolder(database,
//                    folder),
              );
            },
            closedElevation: 0,
            openElevation: 0,
            closedColor: Colors.transparent,
            closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            openColor: Colors.transparent,
            openBuilder: (BuildContext context, VoidCallback _) {
              return NotesInFolderScreen(database: database, folder: folder);
            },
          );
        },
        //the vertical space
      ),
    );
  }

  void _showFlushBar(BuildContext context, Folder folder) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);

    ///Todo: edit design:
    Flushbar(
      mainButton: Row(
        children: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style:
                  TextStyle(color: _darkTheme ? Colors.white : Colors.black87),
            ),
          ),
          FlatButton(
            onPressed: () {
              _delete(context, folder);
            },
            child: Text(
              "Delete Folder",
              style:
                  TextStyle(color: _darkTheme ? Colors.white : Colors.black87),
            ),
          ),
        ],
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(10),
      borderRadius: 10,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundGradient: _darkTheme
          ? LinearGradient(
              colors: [Color(0xF0888888).withOpacity(0.85), darkBkgdColor])
          : LinearGradient(
              colors: [Color(0xF0888888).withOpacity(0.85), lightSurface]),
      duration: Duration(seconds: 10),
      titleText: Text(
        'All Notes in this folder will be deleted.',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            color: _darkTheme ? Colors.white : Colors.black87,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: Text(
        '',
        style: TextStyle(
            fontSize: 12.0,
            color: _darkTheme ? Colors.white : Colors.black87,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
    )..show(context);
  }

  ///delete
  Future<void> _delete(BuildContext context, Folder folder) async {
    final database = Provider.of<Database>(context, listen: false);

    try {
      await database.deleteFolder(folder);
      Navigator.pop(context);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  String _newFolderName = '';
  bool _isFolderNameEmpty = true;

  final _formKey = GlobalKey<FormState>();

  //because in add button, we can't access notes unless we move steamBuilder up,
  // so I make add and edit separate, lots of repeated code
  //https://stackoverflow.com/questions/50964365/alert-dialog-with-rounded-corners-in-flutter/50966702#50966702
  void _showAddDialog(BuildContext context, Database database) async {
//    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 10.0),
            backgroundColor: Color(0xf01b262c),
            // //
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Column(
              children: <Widget>[
                Text(
                  "New Folder",
//            style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 15),
                Text(
                  'Enter a name for this folder.',
                  style: Theme.of(context).textTheme.subtitle2,
                )
              ],
            ),
            content: Container(
//              color: Colors.purpleAccent,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
//                      color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                value.length == 0
                                    ? _isFolderNameEmpty = true
                                    : _isFolderNameEmpty = false;
                              });
                            },
                            maxLength: 30,
                            maxLines: 1,
                            //limit only one line
                            initialValue: _newFolderName,
                            validator: (value) => (value.isNotEmpty)
                                ? null
                                : 'Folder name can not be empty',
                            onSaved: (value) => _newFolderName = value,
                            style: TextStyle(fontSize: 20.0),
                            autofocus: true,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ),
                      ),
                      Container(
//                      color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ///Todo: change color when typing
                              FlatButton(
                                  child: Text('Cancel',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  shape: _isFolderNameEmpty
                                      ? RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(68.0),
                                          side: BorderSide(
                                              color: Colors.white70,
                                              width: 2.0))
                                      : null,
                                  onPressed: () => Navigator.of(context).pop()),
//                          SizedBox(
//                            width: 2,
//                            child: Container(color: Colors.white70),
//                          ),
                              FlatButton(
                                  child: Text('Save',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  shape: _isFolderNameEmpty
                                      ? null
                                      : RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(68.0),
                                          side: BorderSide(
                                              color: Colors.white70,
                                              width: 2.0)),
                                  onPressed: () =>
                                      _addFolder(context, database)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
//            actions: <Widget>[],
          );
        });
      },
    );
  }

  /// only allow unique name for folder, and can not be notes or all notes
  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    //validate
    if (form.validate()) {
      //save
      form.save();
      return true;
    }
    return false;
  }

  //when we don't have BuildContext context, we used a wrong context and it popped to home screen
  void _addFolder(BuildContext context, Database database) async {
    if (_validateAndSaveForm()) {
      try {
        final folders = await database.foldersStream().first;
        final allNames =
            folders.map((folder) => folder.title.toLowerCase()).toList();
//        print('allNames: $allNames');
        //and this is to make sure when we edit job, we can keep the name
//        if (folder != null) {
//          allNames.remove(widget.job.name);
//        }
        //this is to make sure when we create job, we do not write the same name
        if (allNames.contains(_newFolderName.toLowerCase())) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please choose a different folder name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          ///first we find this specific Todo item that we want to update
          final newFolder = Folder(
            id: documentIdFromCurrentDate(),
            title: _newFolderName.firstCaps,

            ///TODO
          );
          //add newTodo to database
          await database.setFolder(newFolder);

          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  //The reason not to put the add and edit together is because in add button, no access to folder.
  void _showEditDialog(
      BuildContext context, Database database, Folder folder) async {
//    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
//    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(top: 10.0),
            backgroundColor: Color(0xf01b262c),
            // //
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Column(
              children: <Widget>[
                Text(
                  "Rename Folder",
//            style: Theme.of(context).textTheme.headline6,
                ),
//                SizedBox(height: 15),
//                Text(
//                  'Enter a name for this folder.',
//                  style: Theme.of(context).textTheme.subtitle2,
//                )
              ],
            ),
            content: Container(
//              color: Colors.purpleAccent,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
//                      color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                value.length == 0
                                    ? _isFolderNameEmpty = true
                                    : _isFolderNameEmpty = false;
                              });
                            },
                            maxLines: 1,
                            maxLength: 30,
                            initialValue: folder.title,
                            validator: (value) => (value.isNotEmpty)
                                ? null
                                : 'Folder name can not be empty',
                            onSaved: (value) => _newFolderName = value,
                            style: TextStyle(fontSize: 20.0),
                            autofocus: true,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ),
                      ),
                      Container(
//                      color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ///Todo: change color when typing
                              FlatButton(
                                  child: Text('Cancel',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  shape: _isFolderNameEmpty
                                      ? RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(68.0),
                                          side: BorderSide(
                                              color: Colors.white70,
                                              width: 2.0))
                                      : null,
                                  onPressed: () => Navigator.of(context).pop()),
//                          SizedBox(
//                            width: 2,
//                            child: Container(color: Colors.white70),
//                          ),
                              FlatButton(
                                  child: Text('Save',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  shape: _isFolderNameEmpty
                                      ? null
                                      : RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(68.0),
                                          side: BorderSide(
                                              color: Colors.white70,
                                              width: 2.0)),
                                  onPressed: () =>
                                      _editFolder(context, database, folder)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
//            actions: <Widget>[],
          );
        });
      },
    );
  }

  void _editFolder(
      BuildContext context, Database database, Folder folder) async {
    if (_validateAndSaveForm()) {
      try {
        final folders = await database.foldersStream().first;
        final allNames =
            folders.map((folder) => folder.title.toLowerCase()).toList();
        //and this is to make sure when we edit job, we can keep the name
        if (folder != null) {
          allNames.remove(folder.title);
        }
        //this is to make sure when we create job, we do not write the same name
        if (allNames.contains(_newFolderName.toLowerCase())) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please choose a different folder name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          ///first we find this specific Todo item that we want to update
          final id = folder?.id ?? documentIdFromCurrentDate();
          final newFolder = Folder(
            id: id,
            title: _newFolderName.firstCaps,
          );
          await database.setFolder(newFolder);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }
}

//  Widget getDefaultFolderList(Database database) {
//    List defaultFolders = [
//      Folder(id: 0.toString(), title: 'All Notes', colorCode: '4278238420'),
//      Folder(id: 1.toString(), title: 'Notes', colorCode: '4278228616'),
//    ];
//
//    return StaggeredGridView.countBuilder(
//        controller: _hideButtonController,
//        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
//        mainAxisSpacing: 8.0,
//        crossAxisSpacing: 8.0,
//        physics: BouncingScrollPhysics(),
//        crossAxisCount: 4,
//        itemCount: defaultFolders.length,
//        shrinkWrap: true,
//        itemBuilder: (BuildContext context, int index) {
//          final folder = defaultFolders[index];
//          return Slidable(
////            controller: slidableController,
//            key: UniqueKey(),
//            closeOnScroll: true,
//            actionPane: SlidableDrawerActionPane(),
//            dismissal: SlidableDismissal(
//              child: SlidableDrawerDismissal(),
//              onDismissed: (actionType) {
//                _delete(context, folder);
//              },
//            ),
//            actionExtentRatio: 0.25,
//            child: OpenContainer(
//              useRootNavigator: true,
//              transitionType: _transitionType,
//              closedBuilder: (BuildContext _, VoidCallback openContainer) {
//                return Stack(
//                  alignment: Alignment.topRight,
//                  children: <Widget>[
//                    NotesFolderContainer(
//                      folder: folder,
////                onTap: () => _gotoNotesInFolder(database,
////                    folder),
//                    ),
//                    IconButton(
//                      icon: FaIcon(
//                        FontAwesomeIcons.trashAlt,
//                        size: 20,
//                        color: Colors.white,
//                      ),
//                      onPressed: () => _delete(context, folder),
//                    )
//                  ],
//                );
//              },
//              closedElevation: 0,
//              openElevation: 0,
//              closedColor: Colors.transparent,
//              closedShape: const RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(0))),
//              openColor: Colors.transparent,
//              openBuilder: (BuildContext context, VoidCallback _) {
//                return NotesInFolder(database: database, folder: folder);
//              },
//            ),
//
////            NotesFolderContainer(
////                folder: folder,
////                onTap: () => _gotoNotesInFolder(database,
////                    folder)), //on tap: NoteFolderDetail(note: folder);
//            actions: <Widget>[],
//            secondaryActions: <Widget>[
//              IconSlideAction(
//                caption: 'Delete',
//                color: Colors.black12,
//                iconWidget: FaIcon(
//                  FontAwesomeIcons.trashAlt,
//                  color: Colors.white,
//                ),
////                icon: Icons.delete,
//                onTap: () => _delete(context, folder),
//              ),
//            ],
//          );
//        });
//  }

//  Widget getFolderList(Database database, List<Folder> folders) {
//    List defaultFolders = [
//      Folder(id: 0.toString(), title: 'All Notes', colorCode: '4278238420'),
//      Folder(id: 1.toString(), title: 'Notes', colorCode: '4278228616'),
//    ];
//
//    List finalFolderList = defaultFolders..addAll(folders);
//
//    return StaggeredGridView.countBuilder(
//        controller: _hideButtonController,
//        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
//        mainAxisSpacing: 15.0,
//        crossAxisSpacing: 15.0,
//        physics: BouncingScrollPhysics(),
//        crossAxisCount: 4,
//        itemCount: finalFolderList.length,
//        shrinkWrap: true,
//        itemBuilder: (BuildContext context, int index) {
//          final folder = finalFolderList[index];
//          return Slidable(
////            controller: slidableController,
//            key: UniqueKey(),
//            closeOnScroll: true,
//            actionPane: SlidableDrawerActionPane(),
//            dismissal: SlidableDismissal(
//              child: SlidableDrawerDismissal(),
//              onDismissed: (actionType) {
//                _delete(context, folder);
//              },
//            ),
//            actionExtentRatio: 0.25,
//            child: OpenContainer(
//              useRootNavigator: true,
//              transitionType: _transitionType,
//              closedBuilder: (BuildContext _, VoidCallback openContainer) {
//                return NotesFolderContainer(
//                  folder: folder,
////                onTap: () => _gotoNotesInFolder(database,
////                    folder),
//                );
//              },
//              closedElevation: 0,
//              openElevation: 0,
//              closedColor: Colors.transparent,
//              closedShape: const RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(0))),
//              openColor: Colors.transparent,
//              openBuilder: (BuildContext context, VoidCallback _) {
//                return NotesInFolder(database: database, folder: folder);
//              },
//            ), //on tap: NoteFolderDetail(note: folder);
//            actions: <Widget>[
//              IconSlideAction(
//                caption: 'Edit folder name',
//                color: Colors.black12,
//                iconWidget: FaIcon(
//                  FontAwesomeIcons.trashAlt,
//                  color: Colors.white,
//                ),
////                icon: Icons.delete,
//                onTap: () => _showAddDialog(context),
//              ),
//            ],
//            secondaryActions: <Widget>[
//              IconSlideAction(
//                caption: 'Delete',
//                color: Colors.black12,
//                iconWidget: FaIcon(
//                  FontAwesomeIcons.trashAlt,
//                  color: Colors.white,
//                ),
////                icon: Icons.delete,
//                onTap: () => _delete(context, folder),
//              ),
//            ],
//          );
//        });
//  }

//this is just to make UI look consistent
//  Widget getButtonFolderContainer(Database database) {
//    List defaultFolders = [
//      NotesFolderContainerButton(onTap: () => _showAddDialog(context)),
//    ];
//
//    return StaggeredGridView.countBuilder(
////        controller: _hideButtonController,
//        staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
//        mainAxisSpacing: 8.0,
//        crossAxisSpacing: 8.0,
//        physics: BouncingScrollPhysics(),
//        crossAxisCount: 4,
//        itemCount: defaultFolders.length,
//        shrinkWrap: true,
//        itemBuilder: (BuildContext context, int index) {
////          final folder = defaultFolders[index];
//          return NotesFolderContainerButton(
//              onTap: () => _showAddDialog(context));
//        });
//  }
