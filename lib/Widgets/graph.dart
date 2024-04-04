

import 'dart:convert';
import 'dart:html';
import 'dart:js_util';
import 'dart:math';
import 'dart:typed_data';

import 'package:convex_hull/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'kps.dart';
import 'jm.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Custom_Point.dart';





class Graph extends StatefulWidget {
  const Graph({super.key});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  int seconds = 0;


  List<Custom_Point> data = [
    // Outline
    Custom_Point(50, 20), // Top of the head
    Custom_Point(30, 35), // Upper left forehead
    Custom_Point(70, 35), // Upper right forehead
    Custom_Point(20, 50), // Left temple
    Custom_Point(80, 50), // Right temple
    Custom_Point(15, 65), // Left cheekbone
    Custom_Point(85, 65), // Right cheekbone
    Custom_Point(20, 80), // Left jaw
    Custom_Point(80, 80), // Right jaw
    Custom_Point(40, 100), // Bottom left chin
    Custom_Point(60, 100), // Bottom right chin
    Custom_Point(50, 90), // Bottom of the chin
    Custom_Point(30, 75), // Mid left jaw
    Custom_Point(70, 75), // Mid right jaw

    // Eyes
    Custom_Point(40, 45), // Left eye left corner
    Custom_Point(45, 42), // Left eye top
    Custom_Point(50, 45), // Left eye right corner
    Custom_Point(45, 48), // Left eye bottom
    Custom_Point(60, 45), // Right eye left corner
    Custom_Point(65, 42), // Right eye top
    Custom_Point(70, 45), // Right eye right corner
    Custom_Point(65, 48), // Right eye bottom

    // Nose
    Custom_Point(50, 55), // Nose top
    Custom_Point(47, 65), // Nose left
    Custom_Point(53, 65), // Nose right
    Custom_Point(50, 75), // Nose bottom

    // Mouth
    Custom_Point(45, 85), // Mouth left corner
    Custom_Point(50, 82), // Mouth top mid
    Custom_Point(55, 85), // Mouth right corner
    Custom_Point(50, 88), // Mouth bottom mid

    // Ears
    Custom_Point(10, 55), // Left ear top
    Custom_Point(5, 70), // Left ear middle
    Custom_Point(10, 85), // Left ear bottom
    Custom_Point(90, 55), // Right ear top
    Custom_Point(95, 70), // Right ear middle
    Custom_Point(90, 85), // Right ear bottom
  ];
  List<Custom_Point> final_convex_hull = [];
  List<List<Custom_Point>> upperBridgePoints = [];
  List<List<Custom_Point>> lowerBridgePoints = [];
  List<Custom_Point> quadrilateral = [];
  List<List<Custom_Point>> removedPoints = [];
  List<List<List<Custom_Point>>> Ordered = [];
  bool maxkps = false;
  bool maxjm = false;
  int splice = 0;
  Custom_Point p = Custom_Point(0, 0);
  Custom_Point q = Custom_Point(0, 0);
  List<Custom_Point> currline = [Custom_Point(0, 0), Custom_Point(0, 0)];
  double maxx = 110;
  double maxy = 110;
  String kpstime = "";
  String jmtime = "";

  List<List<Custom_Point>> updates = [];
  List<Custom_Point> hull = [];
  List<List<Custom_Point>> removedP = [];
  List<Custom_Point> temp = [];

  double speed = 1;

  double pointx = 0;
  double pointy = 0;

  int numberOfPoints = 10; // Default number of points



  void setNumberOfPoints(String value) {
    setState(() {
      numberOfPoints = int.tryParse(value) ?? 10; // Default to 10 if invalid input
    });
    }
  void generateRandomPoints() {
    clearPoints();
    setState(() {
      data = List.generate(
        numberOfPoints,
            (index) => Custom_Point(
          Random().nextDouble()*100.toDouble(), // Random X value between 0 and 100
          Random().nextDouble()*100.toDouble(), // Random Y value between 0 and 100
        ),
      );
    });
    print("sadf");
    print(data);
  }

  void addPointx(String point) {
    setState(() {
      pointx = double.parse(point);

    });
  }

  void addPointy(String point) {
    setState(() {
      pointy = double.parse(point);
    });
  }

  void addPoint() {
    setState(() {
      data.add(Custom_Point(pointx, pointy));
      maxx = data.map((e) => e.x).reduce(max)*1.932;
      maxy = data.map((e) => e.y).reduce(max)*1.2;
    });
  }

  void startTimer()async{

  }

  void runAlgo() async {
    resetwithoutclearkps();
    DateTime currtime = DateTime.now();
    animatedPoints ap = findkps(data);
    DateTime endtime = DateTime.now();
    setState(() {
      if(endtime.difference(currtime).inMicroseconds >=10000){
        kpstime = "${endtime.difference(currtime).inMilliseconds} milli seconds";
      }
      else{
        kpstime = "${endtime.difference(currtime).inMicroseconds} micro seconds";
      }
      Ordered = ap.Ordered;
    });
    setState(() {
      print(data.length);
      print(upperBridgePoints.length);
      upperBridgePoints = [];
      lowerBridgePoints = [];
      quadrilateral = [];
      removedPoints = [];
    });
    for (int i = 0; i < Ordered.length; i++) {
      setState(() {
        print(upperBridgePoints.length);
        upperBridgePoints.add(Ordered[i][0]);
      });

      await Future.delayed(Duration(milliseconds: 1000~/speed));
      setState(() {
        quadrilateral = Ordered[i][1];
      });
      if(Ordered[i][1].isEmpty) {
        continue;
      }

      await Future.delayed(Duration(milliseconds: 1000~/speed));
      setState(() {
        removedPoints.add(Ordered[i][2]);
      });

      await Future.delayed(Duration(milliseconds: 1000~/speed));
    }
    await Future.delayed(Duration(milliseconds: 1000~/speed));
    setState(() {
      final_convex_hull = ap.final_convex_hull;
      upperBridgePoints = [];
      lowerBridgePoints = [];
      quadrilateral = [];
      removedPoints = [];
      Ordered = [];
      splice = 0;
    });
  }

  void runAlgojm() async {
    resetwithoutclearjm();
    DateTime currtime = DateTime.now();
    animatedPointsjm jm = findjm(data);
    DateTime endtime = DateTime.now();
    setState(() {
      if(endtime.difference(currtime).inMicroseconds >=10000){
        jmtime = "${endtime.difference(currtime).inMilliseconds} milli seconds";
      }
      else{
        jmtime = "${endtime.difference(currtime).inMicroseconds} micro seconds";
      }
      updates = jm.updates;
      removedP = jm.removedP;
      hull.add(updates[0][0]);
    });

    for (int i = 0; i < updates.length; i++) {
      setState(() {
        if (i >= 3) {
          temp += removedP[i - 3];
        }
        p = updates[i][0];
        currline[0] = p;
      });

      for (int j = 1; j < updates[i].length; j++) {
        setState(() {
          q = updates[i][j];
          currline[1] = q;
        });
        await Future.delayed(Duration(milliseconds: 1000~/speed));
      }

      await Future.delayed(Duration(milliseconds: 1000~/speed));
      setState(() {
        hull.add(updates[i][updates[i].length - 1]);
      });
    }
    setState(() {
      hull.add(hull[0]);
      p = q;
    });
  }

  void clearPoints() {
    setState(() {
      maxx = 110;
      maxy = 110;
      data = [];
      final_convex_hull = [];
      upperBridgePoints = [];
      lowerBridgePoints = [];
      quadrilateral = [];
      removedPoints = [];
      Ordered = [];
      splice = 0;
      p = Custom_Point(0, 0);
      q = Custom_Point(0, 0);
      currline = [Custom_Point(0, 0), Custom_Point(0, 0)];
      updates = [];
      hull = [];
      removedP = [];
      temp = [];
    });
  }

  void resetwithoutclearkps(){
    setState(() {
      final_convex_hull = [];
      upperBridgePoints = [];
      lowerBridgePoints = [];
      quadrilateral = [];
      removedPoints = [];
      Ordered = [];
      splice = 0;
    });
  }
  void resetwithoutclearjm(){
    setState(() {
      p = Custom_Point(0, 0);
      q = Custom_Point(0, 0);
      currline = [Custom_Point(0, 0), Custom_Point(0, 0)];
      updates = [];
      hull = [];
      removedP = [];
      temp = [];
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Padding(padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                 !maxjm?Stack(
                   children: [
                     Container(
                        height: maxkps? MediaQuery.of(context).size.height/1.2 : null,
                       child: SfCartesianChart(
                         title: ChartTitle(text: 'Kirk Patrick Seidel Algorithm'),
                        plotAreaBackgroundColor: kColorPlotBack,
                        backgroundColor: kColorSecondary,
                        margin: EdgeInsets.all(20),
                        primaryXAxis:  NumericAxis(
                            minimum: -10,
                            maximum: maxx,
                            title: AxisTitle(text: 'X'),
                            crossesAt: 0,
                            placeLabelsNearAxisLine: false),
                        primaryYAxis:  NumericAxis(
                            minimum: -10,
                            maximum: maxy,
                            title: AxisTitle(text: 'Y'),
                            crossesAt: 0,
                            placeLabelsNearAxisLine: false),
                        series: <CartesianSeries>[
                          ScatterSeries<Custom_Point, double>(
                            animationDuration: 0,
                            color: kColorPoints,
                            dataSource: data,
                            xValueMapper: (Custom_Point data, _) => data.x as double?,
                            yValueMapper: (Custom_Point data, _) => data.y,
                          ),
                          ...upperBridgePoints.map((List<Custom_Point> points) {
                            return LineSeries<Custom_Point, double>(
                                animationDuration: 0,
                                dataSource: points,
                                xValueMapper: (Custom_Point data, _) => data.x as double?,
                                yValueMapper: (Custom_Point data, _) => data.y,
                                color: kColorGreen,
                                width: 2);
                          }),
                          LineSeries<Custom_Point, double>(
                            animationDuration: 0,
                            dataSource: quadrilateral,
                            xValueMapper: (Custom_Point data, _) => data.x as double?,
                            yValueMapper: (Custom_Point data, _) => data.y,
                            color: kColorRed,
                          ),
                          ...removedPoints.map((List<Custom_Point> points) {
                            return ScatterSeries<Custom_Point, double>(
                              animationDuration: 0,

                              dataSource: points,
                              xValueMapper: (Custom_Point data, _) => data.x as double?,
                              yValueMapper: (Custom_Point data, _) => data.y,
                              color: kColorRed,
                              // pointColorMapper: (Custom_Point data, _) => Colors.blue,
                              // pointBorderColorMapper: (Custom_Point data, _) => Colors.blue,
                              // borderWidth: 2
                            );
                          }),

                          LineSeries<Custom_Point, double>(
                              animationDuration: 0,
                              dataSource: final_convex_hull,
                              xValueMapper: (Custom_Point data, _) => data.x as double?,
                              yValueMapper: (Custom_Point data, _) => data.y,
                              color: kColorConvexHull,
                              width: 4),

                        ],),
                     ),
                     Positioned(child: GestureDetector(
                        onTap: (){
                          setState(() {
                           maxkps = !maxkps;
                          });},
                         child: !maxkps? Icon(Icons.expand_circle_down):Icon(Icons.arrow_circle_up) ),bottom: 10,right: 10,),
                     Positioned(child: Text(
                       kpstime,
                       style: TextStyle(fontSize:14),
                     ),
                       top:10,
                       right: 10,
                     )
                   ],
                 ):Container(),
                 SizedBox(height: 20,),
                 !maxkps? Stack(
                   children: [
                     Container(
                       height: maxjm? MediaQuery.of(context).size.height/1.2 : null,
                       child: SfCartesianChart(
                         title: ChartTitle(text: 'Jarvis March Algorithm'),
                        plotAreaBackgroundColor: kColorPlotBack,
                        backgroundColor: kColorSecondary,
                        margin: EdgeInsets.all(20),
                        primaryXAxis:  NumericAxis(
                            minimum: -10,
                            maximum: maxx,
                            title: AxisTitle(text: 'X'),
                            crossesAt: 0,
                            placeLabelsNearAxisLine: false),
                        primaryYAxis:  NumericAxis(
                            minimum: -10,
                            maximum: maxy,
                            title: AxisTitle(text: 'Y'),
                            crossesAt: 0,
                            placeLabelsNearAxisLine: false),
                        series: <CartesianSeries>[
                          ScatterSeries<Custom_Point, double>(
                            animationDuration: 0,
                            color: kColorPoints,
                            dataSource: data,
                            xValueMapper: (Custom_Point data, _) => data.x as double?,
                            yValueMapper: (Custom_Point data, _) => data.y,
                          ),
                          LineSeries<Custom_Point, double>(
                              animationDuration: 100,
                              dataSource: hull,
                              xValueMapper: (Custom_Point data, _) => data.x as double?,
                              yValueMapper: (Custom_Point data, _) => data.y,
                              color: kColorGreen,
                              width: 2),
                          LineSeries<Custom_Point, double>(
                              animationDuration: 0,
                              dataSource: [p, q],
                              xValueMapper: (Custom_Point data, _) => data.x as double?,
                              yValueMapper: (Custom_Point data, _) => data.y,
                              color: kColorRed,
                              width: 2),
                          ScatterSeries<Custom_Point, double>(
                            animationDuration: 0,
                            dataSource: temp,
                            xValueMapper: (Custom_Point data, _) => data.x as double?,
                            yValueMapper: (Custom_Point data, _) => data.y,
                            color: kColorRed,
                          ),
                        ],
                                       ),
                     ),
                     Positioned(child: GestureDetector(
                         onTap: (){
                           setState(() {
                             maxjm = !maxjm;
                           });},
                         child: !maxjm? Icon(Icons.expand_circle_down):Icon(Icons.arrow_circle_up) ),bottom: 10,right: 10,),
                     Positioned(child: Text(
                       jmtime,
                       style: TextStyle(fontSize: 14),
                     ),
                       top:10,
                       right: 10,
                     )
                   ],
                 ): Container(),],
            ),
          ),
          SizedBox(width: 40),
          !maxkps || !maxjm? Column(children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 30,
                child: TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    hintText: 'X',
                  ),
                  onChanged: (String value) {
                    addPointx(value);
                  },
                ),
              ),
              SizedBox(width: 8,),
              Container(
                width: 100,
                height: 30,
                child: TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    hintText: 'Y',
                  ),
                  onChanged: (String value) {
                    addPointy(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8,),
              ElevatedButton(
                onPressed: addPoint,
                child: const Text('Add Custom Point'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['txt'],
                  );
                  if (result != null) {
                    clearPoints();
                    List<Custom_Point> pointsfromfile= [];
                    Uint8List bytes = result.files.single.bytes!;
                    String file = utf8.decode(bytes);
                    List<String> lines = file.split('\n');
                    for (String line in lines){
                      if(line.isNotEmpty){
                        String x = line.substring(1, line.indexOf(','));
                        String y = line.substring(line.indexOf(',') + 1, line.length-1);
                        Custom_Point point = Custom_Point(double.parse(x), double.parse(y));
                        pointsfromfile.add(point);
                      }
                    }
                    setState(() {
                      maxx = pointsfromfile.map((e) => e.x).reduce(max)*1.932;
                      maxy = pointsfromfile.map((e) => e.y).reduce(max)*1.2;
                      data = pointsfromfile;
                    });
                  } else {
                    // User canceled the picker
                  }
                },
                child: const Text('Add points from file'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: clearPoints,
                child: const Text('Clear Points'),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 50,
                child: TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(),
                    hintText: 'Number of points (default 10)',
                  ),
                  onChanged: (String value) {
                    setNumberOfPoints(value);
                  },
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(kColorPrimary),
                ),
                onPressed: generateRandomPoints,
                child: const Text('Generate', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(kColorPrimary),
                ),
                onPressed: runAlgo,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: const Text('Run Kirk Patrick Seidel Algorithm', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(kColorPrimary),
                ),
                onPressed: runAlgojm,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: const Text('Run Jarvis March Algorithm', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(kColorPrimary),
              ),
              onPressed: (){
                runAlgo();
                runAlgojm();
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: const Text('Run simultaneously', style: TextStyle(color: Colors.white)),
              ),
            ),
          SizedBox(height: 20),
          Container(width: 400, child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Speed: '),
              Slider(value: speed,
                  min: 1,
                  max: 20,
                  onChanged: (value) {
                setState(() {
                  speed = value;
                });
              }),
            ],
          )),]):Container()
        ],
      )),
    );
  }
}
