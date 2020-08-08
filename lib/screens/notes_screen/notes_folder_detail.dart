import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:iMomentum/app/common_widgets/device.dart';
import 'package:iMomentum/app/models/note.dart';

/// Note Card details UI
class NoteFolderDetail extends StatefulWidget {
  final Note note;

  NoteFolderDetail({this.note});

  @override
  _NoteFolderDetailState createState() => _NoteFolderDetailState();
}

class _NoteFolderDetailState extends State<NoteFolderDetail> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  Device device;

  @override
  void initState() {
    super.initState();
//    SchedulerBinding.instance.addPostFrameCallback((_) {
//      if (homeBloc.notesBloc.note != null) {
//        descriptionController.text = homeBloc.notesBloc.note.description;
//        titleController.text = homeBloc.notesBloc.note.title;
//      }
//      setState(() {});
//    });
  }

  Note get note => widget.note;

  @override
  Widget build(BuildContext context) {
    device = Device(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    return Container(
      height: device.deviceHeight,
      width: device.deviceWidth,
      color: Color(note.color),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBar(
                backgroundColor: Color(note.color),
                elevation: 0,
                actions: [
                  note.id != null
                      ? IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        )
                      : Container(),
                  IconButton(
                    onPressed: () => colorPicker(),
                    icon: Icon(
                      Icons.color_lens,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  device.isMobile
                      ? IconButton(
                          onPressed: () {
//                              manageNote();
                          },
                          icon: Icon(
                            Icons.clear,
                            size: 30,
                            color: Colors.white,
                          ),
                        )
                      : Container(),
                ],
              ),
              SingleChildScrollView(
                child: Container(
                  width: device.deviceWidth,
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: Colors.white30,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Title",
                            hintStyle: TextStyle(
                              fontSize: 25,
                              color: Colors.white60,
                              fontWeight: FontWeight.bold,
                            ),
                            contentPadding: EdgeInsets.all(8.0)),
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        controller: titleController,
                        maxLines: 1,
                      ),
                      Container(
                        color: Colors.white30,
                        height: 1,
                      ),
                      Container(
                        child: TextFormField(
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          showCursor: true,
                          cursorColor: Colors.white30,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter note",
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.white60),
                            contentPadding:
                                EdgeInsets.only(left: 8.0, right: 8.0),
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          controller: descriptionController,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Change selected color from color picker box
  void changeColor(Color color) => setState(() {
        note.color = color.value;
      });

  /// Opens color picker box
  void colorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: Color(note.color),
              onColorChanged: changeColor,
            ),
          ),
        );
      },
    );
  }

  /// add or update or delete a note
}
