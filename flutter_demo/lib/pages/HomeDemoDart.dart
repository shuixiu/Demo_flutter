import 'package:flutter/material.dart';
import 'package:flutter_demo/banner/banner_entity.dart';
import 'package:flutter_demo/banner/banner_widget.dart';
import 'package:flutter_demo/model/product_list.dart';

class SimpleEntity extends Object with BannerEntity {
  final String obj;
  final String url;
  final String title;

  SimpleEntity({this.obj, this.url, this.title});

  @override
  get bannerUrl => url;

  @override
  get bannerTitle => title;
}

class NestedScrollViewDemo extends StatefulWidget {
  _NestedScrollViewDemoState createState() => _NestedScrollViewDemoState();
}

class _NestedScrollViewDemoState extends State<NestedScrollViewDemo>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollViewController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);


  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final GlobalKey<BannerState> globalKey = new GlobalKey<BannerState>();

    final List<SimpleEntity> entity = [
      new SimpleEntity(
          url:
          'http://p1.img.cctvpic.com/photoworkspace/2018/05/18/2018051814594647287.jpg',
          title: '治愈系小可爱和你说晚安~',
          obj:
          'http://live.ipanda.com/2018/05/18/VIDEKRkGRBOtjr33LfKamvlM180518.shtml'),
      new SimpleEntity(
          url:
          'http://p1.img.cctvpic.com/photoworkspace/2018/05/18/2018051814220084352.jpg',
          title: '“太妃糖”：麻麻，我走啦！',
          obj:
          'http://live.ipanda.com/2018/05/18/VIDEhZDFWlTidfugBlZa8qDl180518.shtml'),
      new SimpleEntity(
          url:
          'http://p1.img.cctvpic.com/photoworkspace/2018/05/18/2018051814245872100.jpg',
          title: '冷静冷静，这也太有爱了吧~',
          obj:
          'http://live.ipanda.com/2018/05/18/VIDERxEzGP40e4zIsKvZO0no180518.shtml'),
      new SimpleEntity(
          url:
          'http://p1.img.cctvpic.com/photoworkspace/2018/05/18/2018051814175817985.jpg',
          title: '“福豹”：跟我一起嗨~',
          obj:
          'http://live.ipanda.com/2018/05/18/VIDEIUt6LWRTnP5rBSqjqZRe180518.shtml'),
    ];

    final List<SimpleEntity> localEntity = [
      new SimpleEntity(
          url: 'lib/image/banner1.jpg', title: '本地资源第一张', obj: 'message'),
      new SimpleEntity(
          url: 'lib/image/banner2.jpg', title: '本地资源第二张', obj: 'message'),
      new SimpleEntity(
          url: 'lib/image/banner3.png', title: '本地资源第三张', obj: 'message'),
      new SimpleEntity(
          url: 'lib/image/banner4.jpg', title: '本地资源第四张', obj: 'message'),
    ];

    return Container(
      height: 700.0,
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text('Tab Controller'),
                pinned: true,
                floating: true,
                forceElevated: boxIsScrolled,
                expandedHeight: 200.0,
                flexibleSpace: Container(
                  child: Image.asset(
                    'images/food01.jpeg',
                    width: double.infinity,
                    repeat: ImageRepeat.repeat,
                    height: double.infinity,
                  ),
//                  child: BannerWidget(
//                    entity: entity,
//                    key: globalKey,
//                    delayTime: 500,
//                    duration: 500,
//                  ),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      text: "Home",
                      icon: Icon(Icons.home),
                    ),
                    Tab(
                      text: "Help",
                      icon: Icon(Icons.help),
                    ),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              PageOne(),
              PageTwo(),
            ],
            controller: _tabController,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.control_point),
          onPressed: () {
            _tabController.animateTo(1,
                curve: Curves.bounceInOut,
                duration: Duration(milliseconds: 10));
            _scrollViewController
                .jumpTo(_scrollViewController.position.maxScrollExtent);
          },
        ),
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(
              'assets/images/food06.jpeg',
              width: 300.0,
              fit: BoxFit.contain,
            ),
            Image.asset(
              'assets/images/food02.jpeg',
              width: 300.0,
              fit: BoxFit.contain,
            ),
          ],
        ));
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 250.0,
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.all(10.0),
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(5.0),
          color: index % 2 == 0 ? Colors.cyan : Colors.deepOrange,
          child: Center(
            child: Text(index.toString()),
          ),
        ),
      ),
    );
  }
}

class CustomScrollViewDemo extends StatelessWidget {
  final GlobalKey<BannerState> globalKey = new GlobalKey<BannerState>();

  final List<SimpleEntity> entity = [
    new SimpleEntity(
        url:
            'http://p1.img.cctvpic.com/photoworkspace/2018/05/18/2018051814594647287.jpg',
        title: '治愈系小可爱和你说晚安~',
        obj:
            'http://live.ipanda.com/2018/05/18/VIDEKRkGRBOtjr33LfKamvlM180518.shtml'),
    new SimpleEntity(
        url:
            'http://p1.img.cctvpic.com/photoworkspace/2018/05/18/2018051814220084352.jpg',
        title: '“太妃糖”：麻麻，我走啦！',
        obj:
            'http://live.ipanda.com/2018/05/18/VIDEhZDFWlTidfugBlZa8qDl180518.shtml'),
    new SimpleEntity(
        url:
            'http://p1.img.cctvpic.com/photoworkspace/2018/05/18/2018051814245872100.jpg',
        title: '冷静冷静，这也太有爱了吧~',
        obj:
            'http://live.ipanda.com/2018/05/18/VIDERxEzGP40e4zIsKvZO0no180518.shtml'),
    new SimpleEntity(
        url:
            'http://p1.img.cctvpic.com/photoworkspace/2018/05/18/2018051814175817985.jpg',
        title: '“福豹”：跟我一起嗨~',
        obj:
            'http://live.ipanda.com/2018/05/18/VIDEIUt6LWRTnP5rBSqjqZRe180518.shtml'),
  ];

  final List<SimpleEntity> localEntity = [
    new SimpleEntity(
        url: 'lib/image/banner1.jpg', title: '本地资源第一张', obj: 'message'),
    new SimpleEntity(
        url: 'lib/image/banner2.jpg', title: '本地资源第二张', obj: 'message'),
    new SimpleEntity(
        url: 'lib/image/banner3.png', title: '本地资源第三张', obj: 'message'),
    new SimpleEntity(
        url: 'lib/image/banner4.jpg', title: '本地资源第四张', obj: 'message'),
  ];

  Widget _buildItem(BuildContext context, ProductItem product) {
    return Container(
      height: 100.0,
      margin: const EdgeInsets.only(bottom: 5.0),
      padding: const EdgeInsets.only(left: 10.0),
      color: Colors.blueGrey,
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          Positioned(
              right: 40.0,
              child: Card(
                child: Center(
                  child: Text(
                    product.name,
                    style: Theme.of(context).textTheme.title,
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
          ClipRRect(
            child: SizedBox(
              width: 70.0,
              height: 70.0,
              child: Image.asset(
                product.asset,
                fit: BoxFit.cover,
              ),
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: /*new SingleChildScrollView(*/
//        child: Column(
//          children: <Widget>[
//            BannerWidget(
//              entity: entity,
//              key: globalKey,
//              delayTime: 500,
//              duration: 500,
//            ),
          new Container(
        child: new CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: <Widget>[
                // _buildAction(),
              ],
              title: Text('首页'),
              backgroundColor: Theme.of(context).primaryColor,
              expandedHeight: 160.0,
//              flexibleSpace: FlexibleSpaceBar(
//                background:
//                    Image.asset('images/food01.jpeg', fit: BoxFit.cover),
//              ),
              flexibleSpace: Container(

                child: BannerWidget(entity: entity,
                key: globalKey,
                delayTime: 500,
                duration: 500,
                ),
                
              ),
              pinned: false, //固定导航
            ),
            SliverFixedExtentList(
              delegate: SliverChildListDelegate(products.map((product) {
                return _buildItem(context, product);
              }).toList()),
              itemExtent: 120.0,
            )
          ],
        ),
//            ),
//          ],
      ),
//      ),
    );
  }
}
