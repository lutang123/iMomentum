import 'package:flutter/material.dart';

import 'empty_content.dart';

//typedef means we define a new type
typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key key,
    //snapshot is from StreamBuilder
    @required this.snapshot,
    @required this.itemBuilder,
  }) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        //this is ListView we want to return
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return Column(
        children: <Widget>[
          Text(snapshot.error.toString()),
          EmptyContent(
            title: 'Something went wrong',
            message: 'Can\'t load items right now',
          ),
        ],
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    //similar with ListView.builder
    return ListView.separated(
      //this is to make sure to add separator at the beginning as well as the end
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        //or index == 0 or index == the last, we return an empty container
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
