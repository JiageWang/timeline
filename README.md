# Timeline
* A flutter project for present items in timeline.
* Support scroll and zoom.

![Simulator Screen Recording - iPhone 14 - 2023-07-26 at 21.58.30.gif](..%2F..%2FDesktop%2FSimulator%20Screen%20Recording%20-%20iPhone%2014%20-%202023-07-26%20at%2021.58.30.gif)
## Demo code
```dart

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Timeline(items: [
        TimelineItem(dateTime: DateTime(2010, 1, 6), child: InkWell(child: Container(height: 50, color: Colors.blue,), onTap: (){print("test");},)),
        TimelineItem(dateTime: DateTime(2010, 1, 5), child: Container(height: 50, color: Colors.yellow,)),
        TimelineItem(dateTime: DateTime(2010, 1, 8), child: Container(height: 50, color: Colors.green,)),
        TimelineItem(dateTime: DateTime(2010, 1, 19), child: Container(height: 50, color: Colors.red,)),
      ]),
    );
  }
}
```
