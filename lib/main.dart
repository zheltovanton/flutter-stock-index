import 'package:flutter/material.dart';
import 'login/login.dart';
import 'login/auth.dart';
import 'chat/chat_sender.dart';
import 'chat/chat.dart';
import 'stock/stockview.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'includes/strings.dart' as s;
import 'includes/globals.dart' as g;
import 'component/rest.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'component/tools.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

AuthService appAuth = new AuthService();

void main() async{
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Widget MainBuilder(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (new Scaffold(
      // Appbar
      //key: _scaffoldKey,
//        drawer: _buildDrawer(context),
      //      appBar: buildAppBar(context),
        body:  StockView(context)
    )

    );
  }

  ThemeData get theme {
    return new ThemeData(
        brightness: Brightness.light,
        primarySwatch: g.clMatBack
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tasks',
      theme: theme,
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => MainBuilder(context),
        '/home': (BuildContext context) => MainBuilder(context),
//        '/login': (BuildContext context) => LoginPage(context),
//        '/settings': (BuildContext context) => null,
      },
//      onGenerateRoute: (RouteSettings settings) =>_getRoute(context, settings),
//      onUnknownRoute: (RouteSettings settings) =>_getRoute(context, settings),
    );
  }
}
