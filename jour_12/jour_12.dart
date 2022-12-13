import "dart:io";
import "dart:math" ;
import 'package:collection/collection.dart';

/* Repris de mykdavies */

void main() {
  List<String> lignes = File("./jour_12/input.txt").readAsLinesSync();
  print("Partie 1 : ${part1(lignes)} noeuds visités");
  print("Partie 2 : ${part2(lignes)} noeuds visités");
}

extension IntegerRangeExtension on int {
  List<int> to(int end) => List.generate(end - this, (i) => i + this);
}

class Node {
  Point id;
  int height;
  Node(this.id, this.height);
}

class Edge {
  Point from, to;
  int weight;
  Edge(this.from, this.to, this.weight);
}

class Graph {
  var nodes = <Point, Node>{};
  var edges = <String, Edge>{};
  var connected = <Point, Set<Point>>{};
  Graph();

  Node ensure(Node n) => nodes.putIfAbsent(n.id, () => n);

  void addEdge(Point from, Point to, int weight) {
    edges["$from/$to"] = Edge(from, to, weight);
    connected.putIfAbsent(from, () => {}).add(to);
  }

  List<Point> neighboursOf(Point node) => connected[node]!.toList();
  Edge? edgeBetween(Point node1, Point node2) => edges["$node1/$node2"];
}


var cameFrom = <Point, Point>{};
Map<Point, int> dijkstra(Graph graph, Point start, Point end) {
  cameFrom = {start: Point(-1, -1)};
  var costSoFar = {start: 0};
  var frontier = PriorityQueue<Point>(
          (a, b) => (costSoFar[a]!).compareTo((costSoFar[b]!)));
  frontier.add(start);
  while (frontier.isNotEmpty) {
    var current = frontier.removeFirst();
    if (current == end) break;
    for (var next in graph.neighboursOf(current)) {
      var newCost =
          costSoFar[current]! + graph.edgeBetween(current, next)!.weight;
      if (!costSoFar.containsKey(next) || newCost < costSoFar[next]!) {
        costSoFar[next] = newCost;
        frontier.add(next);
        cameFrom[next] = current;
      }
    }
  }
  return costSoFar;
}

late int width, height;
Graph buildGraph(List<String> lines) {
  var g = Graph();
  width = lines.first.length;
  height = lines.length;
  var points = [
    for (var y in 0.to(lines.length))
      for (var x in 0.to(lines.first.length)) Point(x, y)
  ];
  for (var p in points) {
    var c = lines[p.y].substring(p.x, p.x + 1);
    if (c == 'S') {
      start = p;
      c = 'a';
    } else if (c == 'E') {
      end = p;
      c = 'z';
    }
    var h = c.codeUnitAt(0) - 'a'.codeUnitAt(0);
    g.ensure(Node(p, h));
  }
  return g;
}

typedef HeightTest = bool Function(int x, int y);
var dirs = [Point(0, 1), Point(0, -1), Point(1, 0), Point(-1, 0)];

void buildEdges(Graph g, HeightTest edgeTest) {
  for (var h in g.nodes.keys) {
    var hh = g.nodes[h]!.height;
    dirs
        .map((d) => h + d)
        .where((n) => g.nodes.containsKey(n))
        .where((n) => edgeTest(g.nodes[n]!.height, hh))
        .forEach((n) => g.addEdge(h, n, 1));
  }
}

late Point start, end;
part1(List<String> lines) {
  Graph g = buildGraph(lines);
  buildEdges(g, (hh, hn) => hh - hn <= 1);
  Map<Point, int> path = dijkstra(g, start, end);
  return path[end];
}

part2(List<String> lines) {
  Graph g = buildGraph(lines);
  buildEdges(g, (hh, hn) => hn - hh <= 1);
  Map<Point, int> path = dijkstra(g, end, start);
  return path.entries
      .where((e) => g.nodes[e.key]!.height == 0)
      .map((e) => e.value)
      .min;
}
