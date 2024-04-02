import 'dart:math';
import 'Custom_Point.dart';



List<List<Custom_Point>> updates = [];
List<List<Custom_Point>> removedP = [];


findjm(points){
  updates = [];
  removedP = [];
  convexHull(points);
  print(updates.length);
  print(removedP.length);
  animatedPointsjm jmfin = animatedPointsjm(updates,removedP);
  return jmfin;
}

int orientation(Custom_Point p, Custom_Point q, Custom_Point r) {
  double val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y);

  if (val == 0) return 0;
  return (val > 0) ? 1 : 2;
}

double distanceSquared(Custom_Point p, Custom_Point q) {
  return (p.x - q.x) * (p.x - q.x) + (p.y - q.y) * (p.y - q.y);
}

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

List<Custom_Point> convexHull(List<Custom_Point> points) {
  int n = points.length;
  if (n < 3) return [];

  List<Custom_Point> hull = [];

  int l = 0;
  for (int i = 1; i < n; i++) {
    if (points[i].x < points[l].x) {
      l = i;
    } else if (points[i].x == points[l].x && points[i].y < points[l].y) {
      l = i;
    }
  }

  int p = l, q;
  List<Custom_Point> temp1=[];
  do {
    hull.add(points[p]);
    q = (p + 1) % points.length;
    List<Custom_Point> temp=[];
    temp.add(points[q]);
    for (int i = 0; i < points.length; i++) {
      if (orientation(points[p], points[i], points[q]) == 2 ) {
        q = i;
        temp.add(points[q]);
      }
    }
    for (int i = 0; i < hull.length; i++) {
      if (orientation(points[p], hull[i], points[q]) == 0 && 
          distanceSquared(points[q], hull[i]) >= distanceSquared(points[p], hull[i]) 
          && points[p] != hull[i] 
          && points[q] != hull[i]) 
      {
        hull.remove(points[p]);
      }
    }
    temp.insert(0,points[p]);
    updates.add(temp);
    print(updates.length);
    p = q;
    List<Custom_Point> pointsToRemove = [];
    List<Custom_Point> pointsCopy = List.from(points);
    if (hull.length >= 3) {
      for (int i = 0; i < pointsCopy.length; i++) {
        if (pointInPolygon(pointsCopy[i], hull)) {
          pointsToRemove.add(pointsCopy[i]);
        }
      }
      for(int i = 0; i < hull.length; i++) {
        pointsToRemove.add(hull[i]);
      }
      removedP.add(pointsToRemove);
      for (int i = 0; i < pointsToRemove.length; i++) {
        pointsCopy.remove(pointsToRemove[i]);
      }
    }
  } while (p != l);
  hull.add(hull[0]);
  
  for (int i = 0; i < hull.length; i++) {
    print(hull[i]);
  }
  return hull;
}















