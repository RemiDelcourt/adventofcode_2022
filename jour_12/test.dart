import 'package:graphs/graphs.dart';


void main(){
  Map<String, List<String>> graph = <String, List<String>>{
    '1': ['2', '5'],
    '2': ['3'],
    '3': ['4', '5'],
    '4': ['1'],
    '5': ['8'],
    '6': ['7'],
  };

  shortestPath<X>(
    X(from),
    X(to),
    getXValues,
    equals: xEquals,
    hashCode: xHashCode,
  )?.map((x) => x.value);
}