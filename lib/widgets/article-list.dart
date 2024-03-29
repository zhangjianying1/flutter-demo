import 'package:flutter/material.dart';
import 'package:flutter_app/services/colors.dart';
import 'package:flutter_app/services/newsServices.dart';
import 'package:flutter_app/view/article.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//产品列表
class ArticleList extends StatefulWidget {
  final int documentClassSerial; //列表类型
  final int curDocumentClassSerial;
  @override
  ArticleList({Key key, this.documentClassSerial, this.curDocumentClassSerial}) : super(key: key);
  _ArticleListState createState() => new _ArticleListState();
}

class _ArticleListState extends State<ArticleList>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; // 保持底部切换状态不变
  List<dynamic> tabList = [];
  List articleList = [];
  int documentClassSerial; // 当前的id
  int loadState=0; // 0 不显示  1加载中  2 没有了
  int pageNum = 0;

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
      'cityCode': 110000,
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
  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return NotificationListener<ScrollEndNotification>( // or  OverscrollNotification
              onNotification: (ScrollEndNotification  scroll){
                if(scroll.metrics.pixels==scroll.metrics.maxScrollExtent){ // Scrol
                  if (documentClassSerial == widget.curDocumentClassSerial)
                  _getMoreEvent();
                }
              },
              child: CustomScrollView(
//                key: PageStorageKey<String>(),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  new SliverStaggeredGrid.countBuilder(
                    itemCount: articleList.length,
                    crossAxisCount: 4,
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0,
                    itemBuilder: (context, index) => new GoodItem(context, articleList[index]),
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
}
class GoodItem extends StatelessWidget {
  const GoodItem(this.context, this.data);
  final Map data;
  final BuildContext context;
  Widget _widget_item_card() {
    return new Card(
      child: GestureDetector(
        onTap: (){
          print(data['id']);
          Navigator.of(context).push(new MaterialPageRoute(builder:(context){
            return new ArticlePage(id: data['id']);
          }));
        },
        child: new Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                data['image'].isNotEmpty ? Image.network(data['image']) : Text('')
                ,data['type'] == 2 ? Image.asset('images/playvideo.png', width: 36, height: 36,) : Text('')
              ],
            ),
            new Padding(
              padding: const EdgeInsets.all(5),
              child: new Column(
                children: <Widget>[
                  new Text(
                      data['title'],
                      maxLines: 2, // 元固定数据为2行 index%3+1 是为了做瀑布流高低错落效果
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(color: MyColors.gray, fontSize: 16)),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        child: _widget_item_card(),
        onTap: () {}
    );
  }
}

