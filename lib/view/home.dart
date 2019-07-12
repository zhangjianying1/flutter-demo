import 'package:flutter/material.dart';
import 'package:flutter_app/services/MySize.dart';
import 'package:flutter_app/services/colors.dart';
import 'package:flutter_app/utils/request.dart';
import 'package:flutter_app/widgets/article-list.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomPageState();
  }
}
class _HomPageState extends State<HomePage> with TickerProviderStateMixin{
  int _tabIndex = 0;
  List _tabs = [];
  TabController _tabController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.gray80,
        appBar: AppBar(
          title: _homeNavigation(),
          backgroundColor: MyColors.primary,
          elevation: 1.0,
        ),
        body: new NestedScrollView(
            headerSliverBuilder: (BuildContext context,bool innerBoxIsScrolled){
              return <Widget>[
                SliverToBoxAdapter(
                    child: Column(
                        children: <Widget>[
                          _entry(),
                          _swiperView(),
                          _mulitpleEntry(),
                        ]
                    )
                ),
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  child: SliverAppBar(
                    primary: false,
                    backgroundColor: MyColors.white,
                    pinned: true,
                    title: _tabs.isEmpty ? null : _pageTab()
                  )
                )
              ];
            },
            body: TabBarView(
                controller: _tabController,
                children: _tabs.isEmpty ? [] : _tabs.map((res){
                  return ArticleList(documentClassSerial: res['documentClassSerial'].toString());
                }).toList()
            )
        ),
      );
  }
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: _tabs.length, vsync: this);
    getDocuemtnClassList().then((res){
      _tabs = res;
      _tabController = new TabController(length: _tabs.length, vsync: this);
      setState(() {

      });
      _tabController.addListener(() => _onTabChanged());
    });
  }
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  Widget _homeNavigation(){
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: MySize.s_10),
          child: Row(
            children: <Widget>[
              Text('北京', style: TextStyle(color: MyColors.white)),
              Icon(Icons.keyboard_arrow_down, color: MyColors.white,),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: MySize.s_36,
            padding: EdgeInsets.only(left: MySize.s_12, right: MySize.s_12),
            decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.all(Radius.circular(MySize.s_4))
            ),
            child: Row(children: <Widget>[
              Icon(
                Icons.search,
                color: Colors.white,
                size: MySize.s_20,
              ),
              Container(
                child: Text(
                  "搜索",
                  style: TextStyle(color: Colors.black26, fontSize: MySize.s_14),
                ),
                margin: EdgeInsets.only(left: MySize.s_8),
              )
            ]),
          ),
        )
      ],
    );
  }
  Widget _entry(){
    List _data = [{'name': '社保查询', 'icon': Icons.save_alt},{'name': '社保咨询', 'icon': Icons.face},
      {'name': '险种分析', 'icon': Icons.announcement},{'name': '公积金查询', 'icon': Icons.map}];
    return Container(
        color: MyColors.primary,
        padding: EdgeInsets.only(top: MySize.s_30, bottom: MySize.s_20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _data.map((res){
            return  GestureDetector(
              child: Column(
                children: <Widget>[
                  Icon(res['icon'], color: MyColors.white, size: MySize.s_40),
                  Text(res['name'], style: TextStyle(color: Colors.white, fontSize: MySize.s_14, height: 1.6), )
                ],
              ),
              onTap: (){
                print(0);
              },
            );
          }).toList()
        )
    );
  }
  Widget _swiperView() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      color: MyColors.white,
      child: Swiper(
        itemCount: 2,
//          layout: SwiperLayout.STACK,
//          customLayoutOption: new CustomLayoutOption(
//              startIndex: -1,
//              stateCount: 3
//          ).addRotate([
//            -45.0/180,
//            0.0,
//            45.0/180
//          ]).addTranslate([
//            new Offset(-370.0, -40.0),
//            new Offset(0.0, 0.0),
//            new Offset(370.0, -40.0)
//          ]),
        itemHeight: 200.0,
//        viewportFraction: 0.8,
        scale: 0.9,
        itemBuilder: _swiperBuilder,
        pagination: SwiperPagination(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.fromLTRB(0, 0, 20, 10),
            builder: DotSwiperPaginationBuilder(
                color: Colors.black54,
                activeColor: Colors.white
            )
        ),
        controller: SwiperController(),
        scrollDirection: Axis.horizontal,
//        autoplay: true,
//        scale: 0.4,
        onTap: (index) => print('点击了第$index'),
      ),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return Transform(
        transform: Matrix4.translationValues(-30, 0, 0),
        child: Image.asset(
          'images/4.jpg',
          fit: BoxFit.fill,
        )
    );
  }
  Widget _mulitpleEntry(){
    List _data = [{'name': '社保服务', 'icon': Icons.save_alt},{'name': '商业保险', 'icon': Icons.face},
      {'name': '保险赠送', 'icon': Icons.announcement},{'name': '工资计算', 'icon': Icons.map}];
    return Container(
      margin: EdgeInsets.only(top: MySize.s_10, bottom: MySize.s_10),
      color: MyColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _data.map((res){
          return  Container(
            padding: EdgeInsets.only(top: MySize.s_10, bottom: MySize.s_10),
            child: Column(
              children: <Widget>[
                Icon(Icons.announcement, color: MyColors.primary, size: MySize.s_28),
                Text(res['name'], style: TextStyle(fontSize: MySize.s_12, color: MyColors.gray),)
              ],
            ),
          );
        }).toList()
      ),
    );
  }
  Widget _pageTab(){
    int _num = 0;
    List<Widget> _tabsList = [];
    for (; _num < _tabs.length; _num ++) {
      Map res = _tabs[_num];
      _tabsList.add(
        new Tab( child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
          Container(
          height: MySize.s_4,
          width: 40,
          color: _tabIndex == _num ? MyColors.primary : MyColors.transparent,
          ),
        Text(res['documentClassName'], style:
        TextStyle(color: _tabIndex == _num ? MyColors.gray : MyColors.gray,
            fontSize: _tabIndex == _num ? MySize.s_16 : MySize.s_14, height: .5)),
        ],
      ))
      );
    }
    return Container(
      color: MyColors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorPadding: EdgeInsets.only(bottom: 130),
        indicatorWeight: 2.1,
        unselectedLabelColor: MyColors.gray,
        labelColor: MyColors.primary,
        labelPadding: EdgeInsets.symmetric(horizontal: 20.0),
        unselectedLabelStyle: TextStyle(fontSize: 20),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: _tabsList,
      ),
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
  _onTabChanged() {
      if (this.mounted) {
        _tabIndex = _tabController.index;
        setState(() {
        });
      }
  }
}