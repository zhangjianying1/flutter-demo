import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/news-list.dart';
class CustomScrollPage extends StatefulWidget{
  @override
  _CustomScrollPateState createState () => new _CustomScrollPateState();
}
class _CustomScrollPateState extends State<CustomScrollPage> {
  ScrollController myScrollController = new ScrollController();
  bool isScroll = false;
  List tabList = [1, 2];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    myScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //因为本路由没有使用Scaffold，为了让子级Widget(如Text)使用
    //Material Design 默认的样式风格,我们使用Material作为本路由的根。
    return DefaultTabController(
      length: tabList.length,
      child: Material(
          child: SafeArea(
              child: TabBarView(
                  children: tabList.map((res) {
                    return NewsList();
                  }).toList()
              )
          )
      )
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSize child;

  _SliverAppBarDelegate({ this.child });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return child;
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => child.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }

}