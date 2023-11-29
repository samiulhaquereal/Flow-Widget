import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  IconData lastIconClicked = Icons.notifications;

  final List<IconData> menuItem = <IconData>[
    //Icons.menu,
    Icons.home,
    Icons.add_alert,
    Icons.search,
    Icons.satellite_alt,
    Icons.menu
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Flow(
          delegate: FlowMenuDelegate(menuAnimation: controller),
          children: menuItem
              .map<Widget>((IconData icon) => Padding(
                    padding: EdgeInsets.all(5),
                    child: FloatingActionButton(
                      foregroundColor: Colors.white,
                      elevation: 0,
                      backgroundColor:
                          lastIconClicked == icon ? Colors.green : Colors.grey,
                      splashColor: Colors.green,
                      onPressed: () {
                        if (icon != Icons.satellite_alt) {
                          setState(() {
                            lastIconClicked = icon;
                          });
                          controller.status == AnimationStatus.completed
                              ? controller.reverse()
                              : controller.forward();
                        }
                      },
                      child: Icon(icon),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({required this.menuAnimation})
      : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    //---------------Top Show----------------
    double dx = 0.0;
    /*for (int i = 0; i < context.childCount; i++) {
      dx = context.getChildSize(i)!.width * i;
      context.paintChild(i, transform: Matrix4.translationValues(dx * menuAnimation.value, 0, 0)); // Main Line of icon position
    }*/

    //--------------Bottom show --------------

    /*final size = context.size;
    final xStart = size.width - 80;
    final yStart = size.height - 80;
    for (int i = context.childCount - 1; i >=0; i--) {
      dx = context.getChildSize(i)!.width * i;
      //final x = xStart - dx * 0.9 * menuAnimation.value; // Digonal
      //final y = yStart - dx * 0.9 * menuAnimation.value;  // Digonal
      final x = xStart;  // Horizontal ( - dx )
      final y = yStart - dx * menuAnimation.value;  // Vertical ( - dx )
      context.paintChild(i, transform: Matrix4.translationValues(x, y, 0)); // Main Line of icon position
    }*/


    //-------------Rounded Show ------------------

    final size = context.size;
    final xStart = size.width - 80;
    final yStart = size.height - 80;
    final n = context.childCount;
    for(int i = 0 ; i<n ; i++){

      final isLastItem = i == context.childCount - 1 ;
      final setValue = (value) => isLastItem ? 0.0 : value;

      final radius = 180 * menuAnimation.value;

      final theta = i * pi * 0.5 / (n-2);
      final x = xStart - setValue(radius * cos(theta));
      final y = yStart - setValue(radius * sin(theta));

      context.paintChild(
          i,
          transform: Matrix4.identity()
            ..translate(x,y,0)
            ..translate(80 / 2,80 / 2)
            ..rotateZ(isLastItem ? 0.0 : 180 * (1-menuAnimation.value) * pi / 180)
            ..scale(isLastItem ? 1.0 : max(menuAnimation.value,0.5))
            ..translate(-80/2,-80/2)

      );

    }


  }
}
