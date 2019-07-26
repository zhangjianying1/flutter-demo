import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/MySize.dart';
import 'package:flutter_app/services/colors.dart';
import 'package:flutter_app/services/newsServices.dart';
import 'package:flutter_app/widgets/video.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_player/video_player.dart';
//产品列表
class NewsList extends StatefulWidget {
  final int documentClassSerial; //列表类型
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  @override
  NewsList({Key key, this.documentClassSerial, this.videoPlayerController, this.chewieController}) : super(key: key);
  _NewsListState createState() => new _NewsListState();
}

class _NewsListState extends State<NewsList>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; // 保持底部切换状态不变
  List articleList = [];
  int documentClassSerial; // 当前的id
  int loadState=0; // 0 不显示  1加载中  2 没有了
  int pageNum = 0;
  bool played = false;
  @override
  void initState() {
    super.initState();
    documentClassSerial=widget.documentClassSerial;
    _getMoreEvent();
  }
  _getMoreEvent(){
    if (loadState == 0) {
      setState(() {loadState= 1; });
      _getMore();
    }
  }
  //HTTP请求的函数返回值为异步控件Future
  _getMore() async {
    if (!mounted) return;
    pageNum ++;
    Map<String, dynamic> sendData = {
      'documentClassSerial': documentClassSerial,
      'cityCode': '110000',
      'pageNum': pageNum,
      'pageSize': 10,
    };
    NewsServices.of(context).getFollowDocumentList(sendData).then((res){
      if (res.isEmpty) {
        loadState = 3;
      } else if (res['pagination']['totalItems'] <= pageNum * 10) {
        loadState = 2;
        setState(() {});
        return;
      } else {
        articleList.addAll(res['list']);
        loadState = 0;
        setState(() {});
      }
    });
  }

  Widget _widget_more(){
    List<Widget> list= new List();
    if(loadState==1){
      list.add( new Container(margin:EdgeInsets.only(right: 16),width:20,height: 20,
          child:new CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.black26),)));
      list.add(new Text("加载中..."));
    }
    if(loadState==2){
      list.add(new Text("暂时没有更多了。。。"));
    }
    //网络错误
    if(loadState==3){
      list.add(GestureDetector(
        child: new Text('加载失败，请点击重试'),
        onTap: (){
          setState(() {
            loadState = 0;
          });
          _getMoreEvent();
        },
      ));
    }
    return new SliverToBoxAdapter(
        child: new Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(bottom: 20, top: 20),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,mainAxisSize: MainAxisSize.min,
            children:list,
          ),
        )
    );
  }
  _playVideo(String url){
    widget.videoPlayerController = VideoPlayerController.network(url);
    played = true;
    widget.chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 16/9,
        overlay: Text('重复播放'),
        autoPlay: true,
        looping: false,
        routePageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondAnimation, provider) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget child) {
              return VideoScaffold(
                child: Scaffold(
                  resizeToAvoidBottomPadding: false,
                  body: Container(
                    alignment: Alignment.center,
                    color: Colors.black,
                    child: provider,
                  ),
                ),
              );
            },
          );
        }
    );
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return NotificationListener<ScrollEndNotification>( // or  OverscrollNotification
              onNotification: (ScrollEndNotification  scroll){
                if(scroll.metrics.pixels==scroll.metrics.maxScrollExtent){ // Scroll End
                  print("我监听到我滑到底部了${documentClassSerial}");
                  _getMoreEvent();
                }
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  new SliverStaggeredGrid.countBuilder(
                    itemCount: articleList.length,
                    crossAxisCount: 2,
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0,
                    itemBuilder: (context, index) => goodItem(articleList[index]),
                    staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
                  ),
                  _widget_more(),
                ],
              )
          );
        },
      ),
    );
  }
  goodItem(Map data) {
    return new Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: new Column(
        children: <Widget>[
          new GestureDetector(
              onTap: () {
                print(data);
              },
              child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    data['type'] == 2 ? played ? Chewie(controller: widget.chewieController) : Image.network(data['image']): Text('图片加载失败'),
                    !played && data['type'] == 2 ? RaisedButton.icon(onPressed: _playVideo(data['videoUrl']), label: Text(''), icon: Image.asset(
                      'images/playvideo.png', width: 50, height: 50,)) : Text('')
                  ],
                ),
          ),
          new Container(
            height: 40,
            width: double.infinity,
            padding: EdgeInsets.only(right: MySize.s_14),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: MySize.s_8),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(data['authorHeadPath']),
                  ),
                ),
                Expanded(
                  child: new Text(
                      data['title'],
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                          color: MyColors.gray, fontSize: MySize.s_14)
                  ),
                ),
                Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Icon(Icons.message, color: MyColors.gray40,),
                    Positioned(
                      top: -4,
                      left: 20,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        color: Colors.redAccent,
                        child: Text('4', style: TextStyle(
                            fontSize: MySize.s_10, color: MyColors.white),),
                      ),
                    )
                  ],
                ),
                SizedBox(width: MySize.s_14,),
                Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Icon(Icons.landscape, color: MyColors.gray40,),
                    Positioned(
                      top: -4,
                      right: -10,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        color: Colors.redAccent,
                        child: Text('12', style: TextStyle(
                            fontSize: MySize.s_10, color: MyColors.white),),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  _videoWidget(data){

  }
}

