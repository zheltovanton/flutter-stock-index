library stockview;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../component/empty.dart';
import '../includes/strings.dart' as s;
import '../includes/globals.dart' as g;
import 'package:async_loader/async_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../component/rest.dart';
import 'dart:convert';
import '../component/tools.dart';
import '../modal/stock.dart';

class ExitButton extends StatelessWidget {
  const ExitButton();

  @override
  Widget build(BuildContext context) {
    return new CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Tooltip(
        message: 'Back',
        child: const Text('Exit'),
        excludeFromSemantics: true,
      ),
      onPressed: () {
        // The demo is on the root navigator.
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
  }
}


Widget StockViewWidget (BuildContext context, List<StockModal> StockView)
{
  ScrollController _scrollController = new ScrollController();

  if (StockView != null) {
    if (StockView.length > 0) {
      return new SingleChildScrollView(
          reverse: true,
          //key: _scaffoldKey,
          child:new Container(
            padding: const EdgeInsets.all(4.0),
            child: new Column(
              children: <Widget>[
              ]
                ..addAll(buildTab(context, StockView)),
            ),
          )
      );
    } else {
      return new UIElementEmpty();
    }
  } else {
    return new UIElementEmpty();
  }
}

class StockView extends StatefulWidget {
  StockView({  this.context });

  BuildContext context;
  String number;

  @override
  createState() =>
      new _StockViewState( context: context);
}

class _StockViewState extends State<StockView> with WidgetsBindingObserver {
  _StockViewState({  this.context });
  BuildContext context;

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
  new GlobalKey<AsyncLoaderState>();
  AppLifecycleState _lastLifecycleState;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      print("new _lastLifecycleState " +_lastLifecycleState.toString());
      _lastLifecycleState = state;
      _handleRefresh;
    });
  }


  Future<Null> _handleRefresh() async {
    _asyncLoaderState.currentState.reloadState();
    return null;
  }

  _getStock(BuildContext context) async{
    List<StockModal> _data;
    var restHelper = new RestHelperGET();
    String lResp = await restHelper.post(g.URL_SERVER+g.URL_API, null, context);

    print(lResp);

    var ret = json.decode(lResp);

    //print(ret["data"].toString());
    if (ret!=null) {
      _data = new List<StockModal>();
      for (var i in ret) {
        print(i.toString());
        _data.add(new StockModal.fromFields(i));
      }
    }

    return _data;
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        key: _asyncLoaderState,
        initState: () async => await _getStock(context),
        renderLoad: () => new UIElementLoading(),
        renderError: ([error]) =>  new Text(s.txtErrorLoading),
        renderSuccess: ({data}) =>  StockViewWidget(context, data)

    );

    return _asyncLoader;
  }
}

List<Widget> buildTab(BuildContext context,
    List<StockModal> StockView) {
  List<Widget> _data;

  _data = new List<Widget>();

  for (var i in StockView) {

    _data.add(StockViewItem(context:context, i:i));
  }
  return _data;
}

class StockViewItem extends StatelessWidget {
  StockViewItem({this.context, this.i});
  BuildContext context;
  StockModal i;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final List<Widget> columnChildren = new List<Widget>();
    columnChildren.add(new Text(i.val+"-" +i.last));
    columnChildren.add(new Text(i.name, style: themeData.textTheme.caption));

    final List<Widget> rowChildren = <Widget>[
      new Expanded(
          child: new Container(
              width: 300.0,
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: new Column(
                  children: columnChildren
              )
          )
      )
    ];

    return new MergeSemantics(
      child: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren
          )
      ),
    );
  }
}
