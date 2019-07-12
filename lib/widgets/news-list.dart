import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NewsList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _NewsListState();
}
class _NewsListState extends State<NewsList> with
    AutomaticKeepAliveClientMixin {
  List list = [1,2,333,3,4,5,6,6,7,7,5,44,3,3,223,343,29,23,545,00];

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        new SliverStaggeredGrid.countBuilder(
        itemCount: list.length,
          crossAxisCount: 2,
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
          itemBuilder: (context, index) => Text(list[index].toString(), style: TextStyle(fontSize: 40),),
          staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
        )
      ],
    );
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
