import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import './utils/request.dart';
class CustomScrollPage extends StatefulWidget{
  @override
  _CustomScrollPateState createState () => new _CustomScrollPateState();
}
class _CustomScrollPateState extends State<CustomScrollPage>{
  ScrollController myScrollController = new ScrollController();
  bool isScroll = false;
  List<Widget> tabList = [];
  @override
  void initState() {
    super.initState();
    getDocuemtnClassList().then((res){
      print(res);
      List<Widget> _tempList = [];
      setState(() {
        res.forEach((val){
          print(val);
          tabList.add(Container(
            child: new Text(val['documentClassName']),
          ));
        });
      });
    });
    myScrollController.addListener((){
      print(myScrollController.offset);
      setState(() {
        if (myScrollController.offset > 400) {
          isScroll = false;
        } else {
          isScroll = true;
        }
        print(isScroll);
      });
    });
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
    return Material(
      child: SafeArea(
        child: CustomScrollView(
        controller: myScrollController,
        slivers: <Widget>[
          //AppBar，包含一个导航栏
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            forceElevated: true,
            flexibleSpace: Container(
              child: Image.asset(
                "./images/4.jpg", fit: BoxFit.cover,),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: new SliverGrid( //Grid
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //Grid按两列显示
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 4.0,
              ),
              delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  //创建子widget
                  return new Container(
                    alignment: Alignment.center,
                    color: Colors.cyan[100 * (index % 9)],
                    child: tabList.isEmpty ? null : tabList[index],
                  );
                },
                childCount: tabList.length,
              ),
            ),
          ),
          //List
          SliverToBoxAdapter(
            child: RaisedButton(
                child: isScroll ? Text('top') : Text('fdflkj'),
                onPressed: (){
                  myScrollController.animateTo(0.0, duration: Duration(milliseconds: 1000), curve: Curves.ease);
            })
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
                child: PreferredSize(
                  preferredSize: Size.fromHeight(40.0),
                  child: Container(
                    height: 40.0,
                    color: Colors.deepOrange,
                    child:  ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: tabList.length,
                      itemBuilder: (context, index){
                        return tabList[index];
                      }
                    )
                  ),
                )
            ),
          ),
          new SliverStaggeredGrid.countBuilder(
            itemCount: 50,
            crossAxisCount: 4,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            itemBuilder: (context, index) => Container(child: Text('fdlfjdkfjklj'),),
            staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
          ),
        ],
      ),
    )
    );
  }
  Future<dynamic> getDocuemtnClassList() async {
    dynamic response;
    try {
      response = await new Request().get(context, "https://app.joyshebao.com/cons/document/getDocumenClassList");
    } catch (e) {
      print(e);
    }
    return response;
  }
}

class _ListView extends StatelessWidget{
  List<Widget> child = [];
  bool isScroll;
  _ListView(this.child, this.isScroll);
  @override
  Widget build(BuildContext context) {
    return isScroll ? ListView(
      scrollDirection: Axis.horizontal,
      children: child,
    ) :
    ListView(
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      children: child,
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