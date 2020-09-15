import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///https://stackoverflow.com/questions/58584334/understand-how-listen-false-works-when-used-with-providersometype-ofcontext
///
///https://medium.com/flutter-community/making-sense-all-of-those-flutter-providers-e842e18f45dd

void main() => runApp(MyApp());

class Counter with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

///
//The following ProviderNotFoundException was thrown building MyHomePage(dirty):
// Error: Could not find the correct Provider<Counter> above this MyHomePage Widget
//
//This likely happens because you used a `BuildContext` that does not include the provider
// of your choice.
//
//  Make sure that MyHomePage is under your MultiProvider/Provider<Counter>.
//   This usually happen when you are creating a provider and trying to read it immediately.
//
//   For example, instead of:
//
//   ```
//   Widget build(BuildContext context) {
//     return Provider<Example>(
//       create: (_) => Example(),
//       // Will throw a ProviderNotFoundError, because `context` is associated
//       // to the widget that is the parent of `Provider<Example>`
//       child: Text(context.watch<Example>()),
//     ),
//   }
//   ```
//
//   consider using `builder` like so:
//
//   ```
//   Widget build(BuildContext context) {
//     return Provider<Example>(
//       create: (_) => Example(),
//       // we use `builder` to obtain a new `BuildContext` that has access to the provider
//       builder: (context) {
//         // No longer throws
//         return Text(context.watch<Example>()),
//       }
//     ),
//   }
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            Counter();
          },
        ),
      ],

      /// must wrap with a builder, otherwise got the above error
      /// we use `builder` to obtain a new `BuildContext` that has access to the provider

      ///still getting errors, why?
      child: Builder(builder: (context) {
        return MaterialApp(
          //wrap this with a builder?
          title: 'Provider Demo',
          theme: ThemeData(
            primarySwatch: Colors.amber,
          ),
          home: MyHomePage(title: 'Provider Demo Home Page'),
        );
      }),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    Counter counter = Provider.of<Counter>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ExampleProviderWidget(),
            ExampleConsumerWidget(),
            ExampleNoListenWidget()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.increment(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class ExampleProviderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Counter counter = Provider.of<Counter>(context);

    return Container(
      color: Colors.green,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Provider.of<Counter>(context):',
            ),
            Text(
              '${counter.count}',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleConsumerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, _) {
        return Container(
          color: Colors.blue,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Consumer<Counter>(context):',
                ),
                Text(
                  '${counter.count}',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ExampleNoListenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Counter counter = Provider.of<Counter>(context, listen: false);

    return Container(
      color: Colors.red,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Provider.of<Counter>(context, listen: false):',
            ),
            Text(
              '${counter.count}',
              style: Theme.of(context).textTheme.display1,
            ),
            RaisedButton(
              child: Text("Increment"),
              onPressed: () => counter.increment(),
            )
          ],
        ),
      ),
    );
  }
}
