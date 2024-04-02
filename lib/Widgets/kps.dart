import 'dart:math';
import 'Custom_Point.dart';

class Line {
  Custom_Point p1;
  Custom_Point p2;

  Line(this.p1, this.p2);

  double slope() {
    if (p1.x == p2.x) {
      return double.infinity;
    }
    return (p2.y - p1.y) / (p2.x - p1.x);
  }

  @override
  String toString() => 'Line from $p1 to $p2';
}

List <List<Custom_Point>> upperBridgePoints = [];
List <List<Custom_Point>> lowerBridgePoints = [];
List <List<Custom_Point>> quadrilateral = [];
List <List<Custom_Point>> removedPoints = [];
List <Custom_Point> cvhull = [];
List <List<List<Custom_Point>>> Ordered = [];
animatedPoints fin = animatedPoints(upperBridgePoints,lowerBridgePoints,quadrilateral,removedPoints,cvhull,Ordered);

bool pointInPolygon(Custom_Point point, List<Custom_Point> polygon) {
  int numVertices = polygon.length;
  double x = point.x, y = point.y;
  bool inside = false;
  Custom_Point p1 = polygon[0], p2;
  for (int i = 1; i <= numVertices; i++) {
    p2 = polygon[i % numVertices];
    if (y > min(p1.y, p2.y)) {
      if (y <= max(p1.y, p2.y)) {
        if (x <= max(p1.x, p2.x)) {
          double xIntersection =
              (y - p1.y) * (p2.x - p1.x) / (p2.y - p1.y) + p1.x;
          if (p1.x == p2.x || x <= xIntersection) {
            inside = !inside;
          }
        }
      }
    }
    p1 = p2;
  }
  return inside;
}

List<Custom_Point> removeConsecutiveDuplicates(List<Custom_Point> points) {
  return points
      .asMap()
      .entries
      .where((entry) => 
        entry.key == 0 || points[entry.key] != points[entry.key - 1])
      .map((entry) => entry.value)
      .toList();
}

double medianOfMedians(List<double> list, int i) {
  if (list.length <= 5) {
    list.sort();
    return list[i % list.length]; 
  }

  List<List<double>> groups = [];
  for (int j = 0; j < list.length; j += 5) {
    List<double> group = list.sublist(j, min(j + 5, list.length));
    group.sort();
    groups.add(group);
  }

  List<double> medians = groups.map((group) => group[group.length ~/ 2]).toList();

  double pivot = medianOfMedians(medians, medians.length ~/ 2);

  List<double> less = [];
  List<double> equal = [];
  List<double> greater = [];
  for (double num in list) {
    if (num < pivot) {
      less.add(num);
    } else if (num > pivot) {
      greater.add(num);
    } else {
      equal.add(num);
    }
  }


  if (i < less.length) {
    return medianOfMedians(less, i);  
  } else if (i < less.length + equal.length) {
    return pivot;  
  } else {
    return medianOfMedians(greater, i - less.length - equal.length);  
  }
}


Custom_Point findPumin(List<Custom_Point> points) {
  Custom_Point pumin = points[0];
  for (Custom_Point p in points) {
    if (p.x < pumin.x || (p.x == pumin.x && p.y > pumin.y)) {
      pumin = p;
    }
  }
  return pumin;
}

Custom_Point findPumax(List<Custom_Point> points) {
  Custom_Point pumax = points[0];
  for (Custom_Point p in points) {
    if (p.x > pumax.x || (p.x == pumax.x && p.y > pumax.y)) {
      pumax = p;
    }
  }
  return pumax;
}

Custom_Point findPlmin(List<Custom_Point> points) {
  Custom_Point plmin = points[0];
  for (Custom_Point p in points) {
    if (p.x < plmin.x || (p.x == plmin.x && p.y < plmin.y)) {
      plmin = p;
    }
  }
  return plmin;
}

Custom_Point findPlmax(List<Custom_Point> points) {
  Custom_Point plmax = points[0];
  for (Custom_Point p in points) {
    if (p.x > plmax.x || (p.x == plmax.x && p.y < plmax.y)) {
      plmax = p;
    }
  }
  return plmax;
}

Line findMedianLine(List<Custom_Point> points) {
  List<double> xCoordinates = points.map((point) => point.x).toList();
  double medianX = medianOfMedians(xCoordinates, xCoordinates.length ~/ 2);
  Custom_Point medianPoint1 = Custom_Point(medianX, double.negativeInfinity);
  Custom_Point medianPoint2 = Custom_Point(medianX, double.infinity);
  return Line(medianPoint1, medianPoint2);
}

void splitPoints(List<Custom_Point> points, Line medianLine, List<Custom_Point> tLeft, List<Custom_Point> tRight) {
  double medianX = medianLine.p1.x; 

  for (Custom_Point point in points) {
    if (point.x < medianX) {
      tLeft.add(point);
    } else if (point.x > medianX) {
      tRight.add(point);
    } else {
      tLeft.add(point);
    }
  }
}

Line findUpperBridge(List<Custom_Point> points, Line medianLine) {
  if (points.length == 2) {
    return Line(points[0], points[1]);
  }

  List<Line> pairs = [];
  List<Custom_Point> candidates = [];
  for (int i = 0; i < points.length - 1; i += 2) {
    pairs.add(Line(points[i], points[i + 1]));
  }
  if (points.length % 2 != 0) {
    candidates.add(points.last);
  }

   List<double> slopes = [];
  List<Line> noninfslopes = [];
  
  List<Line> smallSlopePairs = [];
  List<Line> equalSlopePairs = [];
  List<Line> largeSlopePairs = [];

  for(Line pair in pairs) {
    if(pair.p1.x == pair.p2.x) {
      if(pair.p1.y > pair.p2.y) {
        candidates.add(pair.p1);
      }
      else {
        candidates.add(pair.p2);
      }
    }
    else {
      double pairSlope = pair.slope();
      slopes.add(pairSlope);
      noninfslopes.add(pair);
    }
  }
  double medianSlope = medianOfMedians(slopes, slopes.length ~/ 2);

  for(Line pair in noninfslopes) {
      double pairSlope = pair.slope();
      if (pairSlope < medianSlope) {
        smallSlopePairs.add(pair);
      } 
      else if (pairSlope == medianSlope) {
        equalSlopePairs.add(pair);
      } 
      else { 
        largeSlopePairs.add(pair);
      }
    }
  

  double maxYIntercept = -double.infinity;
  Custom_Point? temp;
  Custom_Point pk = Custom_Point(double.infinity, 0);
  Custom_Point pm = Custom_Point(-double.infinity, 0);

  for(Custom_Point point in points)
  {
    double yIntercept = point.y - medianSlope * point.x;
    if (yIntercept > maxYIntercept) {
      maxYIntercept=yIntercept;
    }
  }

  for(Custom_Point point in points)
  {
    double yIntercept = point.y - medianSlope * point.x;
    if (yIntercept == maxYIntercept) {
      if(point.x<pk.x)
      {
        pk=point;
      }
      if(point.x>pm.x)
      {
        pm=point;
      }
    }
  }

  if (pk == null || pm == null) {
    throw Exception('No supporting line found.');
  }
  
  double a = medianLine.p1.x;
  if (pk.x <= a && pm.x > a) {
    return Line(pk, pm);
  } else {
    if (pm.x <= a) { 
      candidates.addAll(largeSlopePairs.map((pair) => pair.p2));
      candidates.addAll(equalSlopePairs.map((pair) => pair.p2));
      candidates.addAll(smallSlopePairs.expand((pair) => [pair.p1, pair.p2]));
    } 
    else if(pk.x > a) {
      candidates.addAll(smallSlopePairs.map((pair) => pair.p1));
      candidates.addAll(equalSlopePairs.map((pair) => pair.p1));
      candidates.addAll(largeSlopePairs.expand((pair) => [pair.p1, pair.p2]));
    }
  }
  candidates.sort((a, b) => a.x.compareTo(b.x));
  return findUpperBridge(candidates, medianLine);  
}

Line findLowerBridge(List <Custom_Point> points, Line medianLine) {
  
  if(points.length == 2){
    return Line(points[0], points[1]);
  }
    
  List<Line> pairs = [];
  List<Custom_Point> candidates = [];
  for (int i = 0; i < points.length - 1; i += 2) {
    pairs.add(Line(points[i], points[i + 1]));
  }
  if (points.length % 2 != 0) {
    candidates.add(points.last);
  }

  List<double> slopes = [];
  List<Line> noninfslopes = [];
  
  List<Line> smallSlopePairs = [];
  List<Line> equalSlopePairs = [];
  List<Line> largeSlopePairs = [];

  for(Line pair in pairs) {
    if(pair.p1.x == pair.p2.x) {
      if(pair.p1.y < pair.p2.y) {
        candidates.add(pair.p1);
      }
      else {
        candidates.add(pair.p2);
      }
    }
    else {
      double pairSlope = pair.slope();
      slopes.add(pairSlope);
      noninfslopes.add(pair);
    }
  }
  double medianSlope = medianOfMedians(slopes, slopes.length ~/ 2);

  for(Line pair in noninfslopes) {
      double pairSlope = pair.slope();
      if (pairSlope < medianSlope) {
        smallSlopePairs.add(pair);
      } 
      else if (pairSlope == medianSlope) {
        equalSlopePairs.add(pair);
      } 
      else { 
        largeSlopePairs.add(pair);
      }
    }
  

  double minYIntercept = double.infinity;
  Custom_Point pk = Custom_Point(double.infinity, 0);
  Custom_Point pm = Custom_Point(-double.infinity, 0);

  for (Custom_Point point in points) {
    double yIntercept = point.y - medianSlope * point.x;
    if (yIntercept < minYIntercept) {
      minYIntercept = yIntercept;
    }
  }

  for (Custom_Point point in points) {
    double yIntercept = point.y - medianSlope * point.x;
    if (yIntercept == minYIntercept) {
      if(point.x<pk.x)
      {
        pk=point;
      }
      if(point.x>pm.x)
      {
        pm=point;
      }
    }
  }

  if (pk == null || pm == null) {
    throw Exception('No supporting line found.');
  }
  
  double a = medianLine.p1.x;
  if (pk.x <= a && pm.x > a) {
    return Line(pk, pm);
  }
  else {
    if (pm.x <=a) {  
      candidates.addAll(smallSlopePairs.map((pair) => pair.p2));
      candidates.addAll(equalSlopePairs.map((pair) => pair.p2));
      candidates.addAll(largeSlopePairs.expand((pair) => [pair.p1, pair.p2]));
    } 
    else if(pm.x > a) {
      candidates.addAll(largeSlopePairs.map((pair) => pair.p1));
      candidates.addAll(equalSlopePairs.map((pair) => pair.p1));
      candidates.addAll(smallSlopePairs.expand((pair) => [pair.p1, pair.p2]));
    }
  }
  candidates.sort((a, b) => a.x.compareTo(b.x));
  return findLowerBridge(candidates, medianLine);
}

List<Custom_Point> upperHull(Custom_Point pUmin, Custom_Point pUmax, List <Custom_Point> points) {
  if(points.length <= 2){
    upperBridgePoints.add(points);
    Ordered.add([points,[],[]]);
    return points;
  }
  List<Custom_Point> pointsCopy = List.from(points);
  Line medianLine = findMedianLine(points);
  Line ubridge = findUpperBridge(pointsCopy,medianLine);
  List<Custom_Point> temp = [];
  temp.add(pUmin);

  temp.add(ubridge.p1);
  temp.add(ubridge.p2);

  temp.add(pUmax);
  fin.upperBridgePoints.add(temp);
  List<Custom_Point> pointsToRemove = [];
  List<Custom_Point> uBridgePoints = [];
  uBridgePoints.add(pUmin);
  uBridgePoints.add(ubridge.p1);
  uBridgePoints.add(ubridge.p2);
  uBridgePoints.add(pUmax);
  uBridgePoints.add(pUmin);

  fin.quadrilateral.add(uBridgePoints);
  for (int i = 0; i < pointsCopy.length; i++) {
        if (pointInPolygon(pointsCopy[i], uBridgePoints) && !uBridgePoints.contains(pointsCopy[i])) {
          pointsToRemove.add(pointsCopy[i]);
        }
  }
  fin.removedPoints.add(pointsToRemove);
  for (int i = 0; i < pointsToRemove.length; i++) {
        pointsCopy.remove(pointsToRemove[i]);
  }
  List<Custom_Point> tLeft = [];
  List<Custom_Point> tRight = [];
  double slopeULeft = (uBridgePoints[1].y - pUmin.y)/(uBridgePoints[1].x - pUmin.x);
  double yInterceptULeft = uBridgePoints[1].y - (slopeULeft * uBridgePoints[1].x);
  for(int i = 0; i < pointsCopy.length; i++) {
    double yIntercept = pointsCopy[i].y - (pointsCopy[i].x * slopeULeft);
    if(yIntercept > yInterceptULeft) {
      tLeft.add(pointsCopy[i]);
    }
  }
  tLeft.add(uBridgePoints[1]);
  double slopeURight = (pUmax.y - uBridgePoints[2].y)/(pUmax.x - uBridgePoints[2].x);
  double yInterceptURight = uBridgePoints[2].y - (slopeURight * uBridgePoints[2].x);
  for(int i = 0; i < pointsCopy.length; i++) {
    double yIntercept = pointsCopy[i].y - (pointsCopy[i].x * slopeURight);
    if(yIntercept > yInterceptURight) {
      tRight.add(pointsCopy[i]);
    }
  }
  tRight.add(uBridgePoints[2]);
  List<Custom_Point> upperHullLeft = upperHull(pUmin,uBridgePoints[1],tLeft);
  List<Custom_Point> upperHullRight = upperHull(uBridgePoints[2],pUmax,tRight);
  List<Custom_Point> upperHullFinal = [];
  upperHullFinal.addAll(uBridgePoints);
  upperHullFinal.addAll(upperHullLeft);
  upperHullFinal.addAll(upperHullRight);
  Ordered.add([temp,uBridgePoints,pointsToRemove]);
  return upperHullFinal;
}

List<Custom_Point> lowerHull(Custom_Point pLmin, Custom_Point pLmax, List <Custom_Point> points) {
  if(points.length <= 2){
    lowerBridgePoints.add(points);
    Ordered.add([points,[],[]]);
    return points;
  }
  List<Custom_Point> pointsCopy = List.from(points);
  Line medianLine = findMedianLine(points);
  Line lbridge = findLowerBridge(pointsCopy,medianLine);
  List<Custom_Point> temp = [];
  temp.add(pLmin);
  temp.add(lbridge.p1);
  temp.add(lbridge.p2);
  temp.add(pLmax);
  fin.lowerBridgePoints.add(temp);
  List<Custom_Point> pointsToRemove = [];
  List<Custom_Point> lBridgePoints = [];
  lBridgePoints.add(pLmin);
  lBridgePoints.add(lbridge.p1);
  lBridgePoints.add(lbridge.p2);
  lBridgePoints.add(pLmax);
  lBridgePoints.add(pLmin);
  fin.quadrilateral.add(lBridgePoints);
  for (int i = 0; i < pointsCopy.length; i++) {
        if (pointInPolygon(pointsCopy[i], lBridgePoints) && !lBridgePoints.contains(pointsCopy[i])) {
          pointsToRemove.add(pointsCopy[i]);
        }
  }
  fin.removedPoints.add(pointsToRemove);
  Ordered.add([temp,lBridgePoints,pointsToRemove]);
  for (int i = 0; i < pointsToRemove.length; i++) {
        pointsCopy.remove(pointsToRemove[i]);
  }
  List<Custom_Point> tLeft = [];
  List<Custom_Point> tRight = [];
  double slopeLLeft = (lBridgePoints[1].y - pLmin.y)/(lBridgePoints[1].x - pLmin.x);
  double yInterceptLLeft = lBridgePoints[1].y - (slopeLLeft * lBridgePoints[1].x);
  for(int i = 0; i < pointsCopy.length; i++) {
    double yIntercept = pointsCopy[i].y - (pointsCopy[i].x * slopeLLeft);
    if(yIntercept < yInterceptLLeft) {
      tLeft.add(pointsCopy[i]);
    }
  }
  tLeft.add(lBridgePoints[1]);
  double slopeLRight = (pLmax.y - lBridgePoints[2].y)/(pLmax.x - lBridgePoints[2].x);
  double yInterceptLRight = lBridgePoints[2].y - (slopeLRight * lBridgePoints[2].x);
  for(int i = 0; i < pointsCopy.length; i++) {
    double yIntercept = pointsCopy[i].y - (pointsCopy[i].x * slopeLRight);
    if(yIntercept < yInterceptLRight) {
      tRight.add(pointsCopy[i]);
    }
  }
  tRight.add(lBridgePoints[2]);
  List<Custom_Point> lowerHullLeft = lowerHull(pLmax,lBridgePoints[2],tRight);
  List<Custom_Point> lowerHullRight = lowerHull(lBridgePoints[1],pLmin,tLeft);
  List<Custom_Point> lowerHullFinal = [];
  lowerHullFinal.addAll(lBridgePoints);
  lowerHullFinal.addAll(lowerHullLeft);
  lowerHullFinal.addAll(lowerHullRight);
  
  return lowerHullFinal;
}

animatedPoints kirkPatrick(List<Custom_Point> points) {

  points.sort((a, b) => a.x.compareTo(b.x));
  Custom_Point pumin = findPumin(points);
  Custom_Point pumax = findPumax(points);
  Custom_Point plmin = findPlmin(points);
  Custom_Point plmax = findPlmax(points);
  print(pumin);
  print(pumax);
  print(plmin);
  print(plmax);
  Line medianLine = findMedianLine(points);

  List<Custom_Point> upperHullP = upperHull(pumin, pumax, points);
  // print("Upper Hull Points Final: ");
  // print(upperHullP);

  List<Custom_Point> lowerHullP = lowerHull(plmin, plmax, points);
  // print("Lower Hull Points Final: ");
  // print(lowerHullP);

  upperHullP.sort((a, b) => a.x.compareTo(b.x));
  lowerHullP.sort((a, b) => b.x.compareTo(a.x));
  lowerHullP = lowerHullP.toSet().toList();
  upperHullP = upperHullP.toSet().toList();
  lowerHullP = removeConsecutiveDuplicates(lowerHullP);
  upperHullP = removeConsecutiveDuplicates(upperHullP);
  List <Custom_Point> convexHull = [];
  convexHull.addAll(upperHullP);
  convexHull.addAll(lowerHullP);
  convexHull.add(upperHullP[0]);
  // for(int i = 0; i < convexHull.length; i++) {
  //   fin.convexHull.add(convexHull[i]);
  // }
  
  // print("Convex Hull Points: ");
  // print(convexHull);
  fin.final_convex_hull = convexHull;
  return(fin);
}

// void main() { 
//   List<Point> points = [
//   Point(30, 70), Point(53, 32), Point(74, 66), Point(40, 80), Point(17, 25),
//   Point(80, 45), Point(10, 90), Point(60, 10), Point(90, 20), Point(45, 55),
//   Point(85, 85), Point(25, 35), Point(15, 60), Point(70, 5), Point(5, 10),
//   Point(50, 75), Point(95, 50), Point(20, 30), Point(35, 65), Point(75, 15),
//   Point(55, 80), Point(65, 40), Point(45, 20), Point(10, 40), Point(80, 75),
//   Point(30, 50), Point(55, 5), Point(85, 30), Point(25, 75), Point(60, 90),
//   Point(40, 10), Point(90, 60), Point(70, 35), Point(50, 30), Point(15, 5),
//   Point(20, 45), Point(75, 80), Point(5, 85), Point(35, 15), Point(95, 10),
//   Point(10, 65), Point(45, 50), Point(60, 25), Point(25, 10), Point(50, 60),
//   Point(80, 20), Point(30, 95), Point(55, 70), Point(85, 40), Point(70, 85),
//   Point(40, 55), Point(15, 20), Point(5, 50), Point(45, 5), Point(90, 90),
//   Point(20, 80), Point(75, 25), Point(35, 45), Point(95, 75), Point(10, 15),
//   Point(65, 80), Point(25, 60), Point(60, 35), Point(50, 10), Point(80, 65),
//   Point(30, 25), Point(55, 90), Point(85, 15), Point(70, 50), Point(40, 40),
//   Point(15, 75), Point(5, 20), Point(45, 95), Point(90, 30), Point(20, 5),
//   Point(75, 60), Point(35, 80), Point(95, 20), Point(10, 50), Point(65, 15),
//   Point(25, 90), Point(60, 55), Point(50, 35), Point(85, 70), Point(70, 95),
//   Point(40, 25), Point(15, 10), Point(5, 65), Point(45, 30), Point(90, 5),
//   Point(20, 50), Point(75, 85), Point(35, 10), Point(95, 45), Point(10, 80),
//   Point(65, 25), Point(25, 5), Point(60, 70), Point(50, 45), Point(85, 10),
//   Point(70, 40), Point(40, 95), Point(15, 50), Point(5, 85), Point(45, 15),
//   Point(90, 60), Point(20, 35), Point(75, 10), Point(35, 60), Point(95, 30)
// ];
//   // List<Custom_Point> convexHull = kirkPatrick(points);
//   print(fin);
//   print("Convex Hull Points: ");
//   // print(convexHull);
// }
