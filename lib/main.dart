import 'package:flutter/material.dart';
import 'package:local_notifications/notification_service.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
                onPressed: () async {
                  if (Platform.isIOS) {
                    var value =
                        await NotificationService.instance.requestPermissions(alert: true, badge: true, sound: true);
                    print('Notification permission on iOS  : ' + value.toString());
                  }
                  var now = tz.TZDateTime.now(tz.local);
                  var scheduleDate = tz.TZDateTime.local(now.year, now.month, now.day, now.hour, now.minute, now.second + 5);
                  //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
                  //var scheduleDate = tz.TZDateTime.local(2021, 9, 13, 15, 5);
                  await NotificationService.instance.zonedScheduleNotification(
                      title: "Event incoming", body: "Super event", scheduledDate: scheduleDate);
                },
                child: Text('Notifications in 5 seconds'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
