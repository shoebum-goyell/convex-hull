import 'kps.dart';
import 'jm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Custom_Point.dart';

class Graph extends StatefulWidget {
  const Graph({super.key});
  

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {

    List<Point> data = [];
    List<Custom_Point> final_convex_hull = [];

    double pointx = 0;
    double pointy = 0;

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
        data.add(Point(pointx, pointy));
      });
    }

    void runAlgo() {
      setState(() {
        final_convex_hull = kirkPatrick(data);
      });
    }
    void runAlgojm() {
      setState(() {
        final_convex_hull = kirkPatrick(data);
      });
    }


  @override
  Widget build(BuildContext context) {
    return 
    
    SingleChildScrollView(
      child: Column(
        children: [SfCartesianChart(
          
          enableAxisAnimation: true,
          primaryXAxis: const NumericAxis(
            title: AxisTitle(text: 'X'),
            crossesAt: 0,
            placeLabelsNearAxisLine: false
            
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Y'),
            crossesAt: 0,
            placeLabelsNearAxisLine: false
            
          ),
          series: <CartesianSeries>[
            ScatterSeries<Point,double>(
              dataSource: data,
              xValueMapper: (Point data, _) => data.x as double?,
              yValueMapper: (Point data, _) => data.y,
            ),
            LineSeries<Custom_Point,double>(
              dataSource: final_convex_hull,
              xValueMapper: (Custom_Point data, _) => data.x as double?,
              yValueMapper: (Custom_Point data, _) => data.y,
              color: Colors.red,
              width: 2
            )
          ],
        ),
              Container(
                padding: const EdgeInsets.fromLTRB(500,50,500,10),
                child: TextField(  
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'X',
                  ),
                  onChanged: (String value) {
                    addPointx(value);
                      
                  },
                  
                ),
              ),
              Container(
                 padding: const EdgeInsets.fromLTRB(500,10,500,20),
                child: TextField(  
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Y',
                    
                  ),
                  
                  onChanged: (String value) {
                    addPointy(value);
                  },
                  
                  
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: addPoint,
                child: const Text('AddPoint'),
              ),
              ElevatedButton(
                onPressed: runAlgo,
                child: const Text('Run kps'),
              ),
              ElevatedButton(
                onPressed: runAlgojm,
                child: const Text('Run jm'),
              ),
           
      
        ],
      ),
    );
    
  }
  
}