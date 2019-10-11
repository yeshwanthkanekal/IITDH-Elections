import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/scheduler.dart' show timeDilation;
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent)
  {
    return new SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
class Photo extends StatelessWidget {
  Photo({ Key key, this.photo, this.color, this.onTap }) : super(key: key);

  final String photo;
  final Color color;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return Material(
      // Slightly opaque color appears where the image has transparency.
      color: Theme.of(context).primaryColor.withOpacity(0.25),
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints size) {
            return Image.network(
              photo,
              fit: BoxFit.contain,
            );
          },
        ),
      ),
    );
  }
}

class RadialExpansion extends StatelessWidget {
  RadialExpansion({
    Key key,
    this.maxRadius,
    this.child,
  }) : clipRectSize = 2.0 * (maxRadius / math.sqrt2),
        super(key: key);

  final double maxRadius;
  final clipRectSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Center(
        child: SizedBox(
          width: clipRectSize,
          height: clipRectSize,
          child: ClipRect(
            child: child,
          ),
        ),
      ),
    );
  }
}
class CollapsingList extends StatefulWidget {
  final List<String> listarray;
  const CollapsingList({Key key, this.listarray}) : super(key: key);

  @override
  State createState() => new CollapsingListState();
}
class CollapsingListState extends State<CollapsingList> {
  static const double kMinRadius = 22.0;
  static const double kMaxRadius = 68.0;
  static const opacityCurve = const Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);
  static const double randint = 68.0;
  int deci = 0;
  ScrollController _controller;
  //String _result;
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  static RectTween _createRectTween(Rect begin, Rect end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  static Widget _buildPage(BuildContext context, String imageName, String description, String tag1) {
    //globals.commonman++;
    //var rng = randint;
    return Container(
      color: Theme.of(context).canvasColor,
      child: Center(
        child: Card(
          elevation: 8.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: kMaxRadius * 2.0,
                height: kMaxRadius * 2.0,
                child: Hero(
                  createRectTween: _createRectTween,
                  tag: tag1,
                  child: RadialExpansion(
                    maxRadius: kMaxRadius,
                    child: Photo(
                      photo: imageName,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ),
              new Expanded(
                flex: 1,
                child: new SingleChildScrollView(
                  child: Image.network('http://10.250.1.243/'+description+"_manifesto.jpg"),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, String imageName, String description) {
    timeDilation = 2.0;
    globals.commonman++;
    String saveus = globals.commonman.toString();
    return Container(
      width: kMinRadius * 3.0,
      height: kMinRadius * 3.0,
      child: Hero(
        createRectTween: _createRectTween,
        tag: saveus,
        child: RadialExpansion(
          maxRadius: kMaxRadius,
          child: Photo(
            photo: imageName,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder<void>(
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return AnimatedBuilder(
                        animation: animation,
                        builder: (BuildContext context, Widget child) {
                          return Opacity(
                            opacity: opacityCurve.transform(animation.value),
                            child: _buildPage(context, imageName, description, saveus),
                          );
                        }
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 200.0,
        child: Container(
            color: Colors.lightBlue, child: Center(child:
        Text(headerText))),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    Future<Null> _showToast(String messag) async {
      Fluttertoast.showToast(
        msg: messag,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
      );
    }
    Future<Null> _sendallvotes(String votesmessage) async{
      http.get(
          'http://10.196.6.112:8012/elections-iitdh/try.php?username=${globals.myController1.text}&password=${globals.myController2.text}&sendvotes=$votesmessage');
    }

    List<Widget> ListMyWidgets(List<String> listarray1) {
      String didnotvote;
      if(globals.allcontestants == null) {
        globals.allcontestants = new List(int.parse(listarray1[1]));
        globals.allposts = new List(int.parse(listarray1[1]));
      }
      List<Widget> list = new List();
      //List<String> Strlist = new List();
      List<String> saveme = new List();
      int count = 2;
      int childcount1;
      print(widget.listarray);

      list.add(SliverAppBar(
        automaticallyImplyLeading: false,
        pinned: true,
        title: Center(
          child: new GestureDetector(
              onTap: () {
                _controller.animateTo(0.0, duration: new Duration(seconds: 1),
                    curve: Curves.ease);
              },
              child: SizedBox(width: MediaQuery
                  .of(context)
                  .size
                  .width,
                  child: Container(
                      color: Color.fromRGBO(162, 146, 199, 0.8).withOpacity(
                          1.0),
                      child: Center(child: Text('IIT Dharwad Elections'))))),
        ),
        backgroundColor: Color.fromRGBO(162, 146, 199, 0.8),
        expandedHeight: 200.0,
        flexibleSpace: FlexibleSpaceBar(
          background: Image.network(
            'http://10.250.1.243/logo.png', fit: BoxFit.cover,),
        ),
      ));

        count = 2;
      var count2 = 2;
      var mychildcount2;
      double mywidth = 200.0;


        for (int i = 0; i < int.parse(listarray1[1]); i++) {
          print("widthhhhhhhhhhhhhh"+mywidth.toString());
          List<String> myvar2 = new List();
          globals.allposts[i] = listarray1[count2];
          list.add(SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false,
            title: Center(
              child: new GestureDetector(
                  onTap: () {
                    _controller.animateTo(
                        200.0+(600.0*i), duration: new Duration(seconds: 1),
                        curve: Curves.ease);
                  },
                  child: SizedBox(width: MediaQuery
                      .of(context)
                      .size
                      .width,
                      child: Container(
                          color: Color.fromRGBO(162, 146, 199, 0.8).withOpacity(
                              1.0), child: Center(child: Text(listarray1[count2]))))),
            ),
            backgroundColor: Color.fromRGBO(162, 146, 199, 0.8),
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'http://10.250.1.243/'+listarray1[count2]+'.jpg', fit: BoxFit.cover,)

            ),
          ));
          count++;
          count2++;

          print("yeshwwwwwwwwwwww"+listarray1[count2]);

          mychildcount2 = int.parse(listarray1[count2]);
          //mywidth = mywidth + 100.0;
          count2++;
          print("yeshwwwwwwwwwwww"+listarray1[count2+1]);
          //myvar2.clear();
          for(int mn=0;mn < (2*mychildcount2);mn++){
            myvar2.add(listarray1[count2+mn]);
          }
          //myvar2 = listarray1[count2];
          //childcount1 = int.parse(listarray1[count]);
          print("count" + count.toString());
          print(childcount1);
          count++;
          saveme.clear();


          //print(widget.listarray[count + 2]);
          list.add(SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return index == 0 ? Container(height: 150.0) :
                index == 1 ? Container(child: Center(child: Text('Contestants',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0,fontStyle: FontStyle.italic,color: Colors.blue))),height: 150.0) :
                    index == 2 ? Container(height: 150.0) :
                Container(
                  //alignment: Alignment.center,
                  //color: Colors.teal[100 * (index % 9)],
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildHero(context,
                            "http://10.250.1.243/" +
                                myvar2[2*(index-3)] + ".jpg",
                            myvar2[(2*(index-3))]),
                        //Text(myvar2[index],style: TextStyle(
                         //   fontStyle: FontStyle.italic,
                          //  color: Colors.blue),),
                        new Text(myvar2[(2*(index-3))+1]),
                        new RaisedButton(
                          padding: const EdgeInsets.all(2.0),
                          //textColor: Colors.white,
                          color: globals.allcontestants.contains(myvar2[2*(index-3)]) ? Colors.green : Color.fromRGBO(162, 146, 199, 0.8).withOpacity(
                              1.0) ,
                          disabledColor: globals.allcontestants.contains(myvar2[2*(index-3)]) ? Colors.green : Color.fromRGBO(162, 146, 199, 0.8)
                              .withOpacity(1.0),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: (){

                                globals.allcontestants[i] = myvar2[2*(index-3)];

                                //_showToast("Your vote is recorded");
                                print(globals.allposts);
                              print(globals.allcontestants);
                              setState(() {

                              });
                          },
                          child: new Text("Vote",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: mychildcount2+3,
            ),
          ));
          //count = count + childcount1;
          count2 = count2 + (2*mychildcount2);
        }
      list.add(SliverAppBar(
        automaticallyImplyLeading: false,
        pinned: false,
        title: Center(
          child: RaisedButton(
            padding: const EdgeInsets.all(2.0),
            //textColor: Colors.white,
            color: Colors.green,
            disabledColor: Color.fromRGBO(162, 146, 199, 0.8)
                .withOpacity(1.0),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            onPressed: (){
              String allvotes = "";
              for(int mx = 0; mx < globals.allposts.length; mx++){
                //if(globals.allcontestants[mx] == null){

                 if(globals.allcontestants[mx] == null){
                   allvotes = allvotes + globals.allposts[mx] + ", ";

                 }
                 //print(globals.allcontestants);
                  //_showToast("You didn't vote for "+globals.allcontestants[mx]);
                  //print("yesssssssssss pressssssssssssssss"+globals.allposts[mx]);
                  //print(globals.allposts);
                  //didnotvote = didnotvote + globals.allposts[mx] + ",";
                  //print(didnotvote);

                //}
              }
              if(allvotes.isEmpty){
                String allcontestants5 = "";
                for(int mx = 0; mx < globals.allposts.length-1; mx++){
                  allcontestants5 = allcontestants5 + globals.allcontestants[mx] + ",";
                }
                allcontestants5 = allcontestants5 + globals.allcontestants[globals.allposts.length-1];
                print("allconteeeeeeeeeeeeeeeeeeee"+allcontestants5);
                _sendallvotes(allcontestants5);
      Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> r) => false);
                _showToast("We received your votes");
              }
              else {
                _showToast("You didn't vote for " + allvotes);
              }
              //globals.allcontestants[i] = myvar2[index-3];

             // _showToast("You disn't vote for "+didnotvote);
              //print(globals.allposts);
              //print(globals.allcontestants);
            },
            child: new Text("Submit your votes",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white),),
          ),
        ),
        backgroundColor: Color.fromRGBO(162, 146, 199, 0.8),
        expandedHeight: 200.0,

      ));
      return list;
    }

    return CustomScrollView(
      controller: _controller,
      slivers: ListMyWidgets(widget.listarray),
    );
  }

}