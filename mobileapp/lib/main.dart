import 'package:flutter/material.dart' hide Router;
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/navigation/router.dart';
import 'package:hls/services/_http_service.dart';
import 'package:hls/services/auth_service.dart';
import 'package:hls/services/settings_service.dart';
import 'package:hls/theme/theme_data.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() => initServices().then((_) => runApp(HLS()));

Future initServices() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting(null, null);
  await Get.put(SettingsService()).init();
  await Get.put(HttpService()).init();
}

class HLS extends StatelessWidget {
  @override
  Widget build(context) => RefreshConfiguration(
      headerBuilder: () => ClassicHeader(
          spacing: 0,
          idleText: idleRefreshText,
          releaseText: releaseRefreshText,
          refreshingText: activeRefreshText,
          completeText: completedRefreshText),
      child: Obx(() => GraphQLProvider( // rebuild when token changes
          client: ValueNotifier(GraphQLClient(
              cache: InMemoryCache(),
              link: HttpLink(uri: apiUri, headers: {
                'Client-Token': apiTokenValue,
                'Content-Type': 'application/json',
                if (!SettingsService.i.token.isNullOrEmpty)
                  'Auth-Token': SettingsService.i.token
              }))),
          child: GetBuilder<AuthService>(
              init: AuthService()..init(),
              builder: (_) => GetMaterialApp(
                  theme: theme(context),
                  defaultTransition: Transition.rightToLeftWithFade,
                  getPages: Router.routes,
                  initialRoute: Router.initial,
                  home: Router.home())))));
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // prepare link
    final HttpLink httpLink = HttpLink(
        uri: 'https://hls-backend-stage.herokuapp.com/graphql',
        headers: {
          'Client-Token': 'WcbKFUnrAteA3YyajbK8c68839j7TXXq',
          'Content-Type': 'application/json'
        });

    final query = '''
      query currentUser {
        currentUser {
          id,
          name
        }
      }
      ''';

    // init client
    return GraphQLProvider(
        client: ValueNotifier(
            GraphQLClient(cache: InMemoryCache(), link: httpLink)),
        child: MaterialApp(
            title: 'Flutter Demo',
            home: Scaffold(
                body: Center(
                    child: Query(
                        options: QueryOptions(
                          documentNode: gql(
                              query), // this is the query string you just created
                          fetchPolicy: FetchPolicy.networkOnly,
                          errorPolicy: ErrorPolicy.all,
                          //variables: {},
                          //pollInterval: 10,
                        ),
                        builder: (QueryResult result,
                            {VoidCallback refetch, FetchMore fetchMore}) {
                          if (result.hasException) {
                            return Text(result.exception.toString());
                          }

                          if (result.loading) {
                            return Text('Loading');
                          }

                          if (result.data['currentUser'] == null)
                            return Text('need to login');

                          // it can be either Map or List
                          print('Query.builder ${result.data}');

                          return Container();
                        })))));
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
