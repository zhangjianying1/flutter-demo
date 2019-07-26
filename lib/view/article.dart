
import 'package:auto_orientation/auto_orientation.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/services/MySize.dart';
import 'package:flutter_app/services/colors.dart';
import 'package:flutter_app/services/newsServices.dart';
import 'package:flutter_app/widgets/video.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:video_player/video_player.dart';
class ArticlePage extends StatefulWidget{
  final int id;
  ArticlePage({Key, key, this.id}) : super(key:key);
  @override
  State<StatefulWidget> createState() => _ArticlePageState();

}
class _ArticlePageState extends State<ArticlePage>{
  Map document = new Map();
  static VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  bool isPlayed = false;
  @override
  void initState() {
    super.initState();
    NewsServices.of(context).getDocumentContent(widget.id.toString()).then((res){
      document = res;
      print(res);
      if (res['type'] == 2) {
        _initVideoController(res);
      }
      setState(() {});
    });
  }
  _initVideoController(Map res){
    videoPlayerController = VideoPlayerController.network(res['videoUrl']);
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
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
  }
  @override
  void dispose() {
    super.dispose();
    if (videoPlayerController != null) {
      videoPlayerController.dispose();
      videoPlayerController.dispose();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        document.isNotEmpty ? Scaffold( appBar: PreferredSize(
          child: document['type'] == 2 ?
          SafeArea( bottom: false, child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              chewieController != null ? Chewie(controller: chewieController) : Text(''),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.symmetric(vertical: MySize.s_8, horizontal: MySize.s_8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage(document['image']), fit: BoxFit.fill)
                    ),
                  ),
                  Expanded(
                    child: Text(document['title'], overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: MySize.s_16, color: MyColors.gray)),
                  )
                ],
              ),
              Divider(height: 0.1,)
            ],
          ))
          : AppBar(
            backgroundColor: MyColors.white,
            title: Text(document['title'], style: TextStyle(color: MyColors.gray),),
          ),
          preferredSize: Size.fromHeight(document['type'] == 2 ? MediaQuery.of(context).size.width * 16/9 : 44)
        ),
        body: Scrollbar(child:
          NotificationListener(child:
              SingleChildScrollView(
                child:  Container(
                    padding: EdgeInsets.symmetric(horizontal: MySize.s_14),
                    child: Html(data:document['content'], defaultTextStyle: TextStyle(fontSize: MySize.s_18, color: MyColors.gray, height: 1.3))
                ),
              )
          )
        ))
        : Image.asset('images/default.gif', fit: BoxFit.cover,)
      ],
    );
  }
  void resetPlay() {
    chewieController.play();
  }
}