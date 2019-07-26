import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/MySize.dart';
import 'package:flutter_app/services/colors.dart';
import 'package:flutter_app/utils/request.dart';
import 'package:flutter_app/widgets/news-list.dart';
import 'package:video_player/video_player.dart';
class NewsPage extends StatefulWidget{
  @override
  _NewsPageState createState () => new _NewsPageState();
}
class _NewsPageState extends State<NewsPage> with TickerProviderStateMixin{
  TabController _tabController;
  List _tabs = [];
  static VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: _tabs.length, vsync: this);
    getDocuemtnClassList().then((res){
      print(res);
      if (res.isEmpty) return;
      setState(() {
        _tabs = res;
        _tabController = new TabController(length: _tabs.length, vsync: this);
        _tabController.addListener(()=>_tabChanged());
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    if (videoPlayerController != null) {
      videoPlayerController.dispose();
      videoPlayerController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    //因为本路由没有使用Scaffold，为了让子级Widget(如Text)使用
    //Material Design 默认的样式风格,我们使用Material作为本路由的根。
    return Material(
      child:  Scaffold(
        appBar: _appBar(),
        body: TabBarView(
              controller: _tabController,
              children: _tabs.isEmpty ? [] : _tabs.map((res){
                return SafeArea(
                  top: false,
                  bottom: false,
                  child: Builder(
                    builder: (BuildContext context) {
                      return NewsList(documentClassSerial: res['documentClassSerial'], videoPlayerController: videoPlayerController, chewieController: chewieController,);
                    }
                  ),
                );
              }).toList()
        )
      )
    );
  }
  _appBar(){
    return AppBar(
        elevation: 0,
        title: Container(
          color: MyColors.primary,
          child: Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('北京', style: TextStyle(fontSize: MySize.s_16, color: MyColors.white),),
                  Icon(Icons.arrow_drop_down, size: MySize.s_16, color: MyColors.white,),
                ],
              ),
              Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: const BorderRadius.all(const Radius.circular(6.0)),
                    ),
                    child: FlatButton.icon(
                        onPressed: null,
                        icon: Icon(Icons.search, size: MySize.s_20,),
                        label: Text('请输入要搜索的内容')
                    ),
                  )
              )
            ],
          ),
        ),
        bottom: PreferredSize(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyColors.white,
                border: Border(bottom: BorderSide(color: MyColors.gray80))
              ),
              child:Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: _tabs.isEmpty ? null : TabBar(
                        labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        isScrollable: true,
                        controller: _tabController,
                        tabs: _tabs.map((res){
                          return Tab(
                            text: res['documentClassName'],
                          );
                        }).toList()
                      ),
                    ),
                  ),
                  Container(
                    width: 46,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: MyColors.gray80))
                    ),
                    child: GestureDetector(
                      onTap: (){
                        print('fdf');
                      },
                      child: Icon(Icons.list)
                    )
                  )
                ],
              )
            ), 
            preferredSize: Size.fromHeight(34)
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
  _tabChanged(){
    if (videoPlayerController != null) {
      videoPlayerController.dispose();
      videoPlayerController.dispose();
    }
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