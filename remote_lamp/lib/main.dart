import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(RemoteLamp());
}

class RemoteLamp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Lamp',
      home: LampConnection(),
      debugShowCheckedModeBanner: false
    );
  }
}

class LampConnection extends StatefulWidget {
  @override
  _LampConnectionState createState() => _LampConnectionState();
}

class _LampConnectionState extends State<LampConnection> {
  var isOff = false;
  var isConnected = false;

  @override
  void initState() {
    _updateStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildStatus(),
    );
  }

  Widget _buildStatus() {
    print(isConnected);
    print(isOff);
    if (!isConnected) {
      return Center(
        child: Column(children: <Widget>[
          IconButton(
            icon: Icon(Icons.error_outline),
            iconSize: 240.0,
            onPressed: _updateStatus,
          ),
          Text('Disconnected')
        ]),
      );
    }

    return Center(
        child: IconButton(
      icon: Icon(isOff ? Icons.lightbulb_outline : Icons.lightbulb,
          color: isOff ? null : Colors.amber),
      iconSize: 240.0,
      onPressed: () {
        _switch(isOff);
      },
    ));
  }

  Future<bool> _send(String path) async {
    try {
      final data = (await http.get('http://192.168.201.38:5000/$path')).body;
      Map<String, dynamic> js = jsonDecode(data);
      isConnected = true;
      print(jsonEncode(js));
      return js['status'];
    } on Exception {
      isConnected = false;
      return false;
    }
  }

  void _updateStatus() {
    _send('status').then((bool status) {
      setState(() {
        this.isOff = status;
      });
    });
  }

  void _switch(bool on) {
    if (on) {
      _send('on').then((bool status) {
        setState(() {
          this.isOff = status;
        });
      });
    } else {
      _send('off').then((bool status) {
        setState(() {
          this.isOff = status;
        });
      });
    }
  }
}
