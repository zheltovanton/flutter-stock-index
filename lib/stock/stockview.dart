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

Widget StockView (BuildContext context){

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
  new GlobalKey<AsyncLoaderState>();
  AppLifecycleState _lastLifecycleState;

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


  var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await _getStock(context),
      renderLoad: () => new UIElementLoading(),
      renderError: ([error]) =>  new Text(s.txtErrorLoading),
      renderSuccess: ({data}) =>  buildTab(context, data)

  );

  return _asyncLoader;

}

Widget buildTab(BuildContext context,
    List<StockModal> StockView) {
  List<Widget> _data;

  _data = new List<Widget>();

  for (var i in StockView) {

    _data.add(StockViewItem(context:context, i:i));
  }
  return new Padding(
      padding: const EdgeInsets.only(top: 1.0),
      child: new GridView.extent(
        maxCrossAxisExtent: 150.0,
        children: _data,
        mainAxisSpacing: 2.0,
        crossAxisSpacing:2.0,
        padding: const EdgeInsets.all(1.0),
      )
  );
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
