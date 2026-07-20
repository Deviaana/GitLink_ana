# PathForge API

PathForge provides graph search and grid pathfinding primitives for MoonBit.

## Graph

`Graph` is a directed weighted graph backed by adjacency lists.

- `Graph::new(size : Int) -> Graph`: create a graph with `size` nodes.
- `Graph::node_count(self : Graph) -> Int`: return the number of nodes.
- `Graph::add_node(self : Graph) -> Int`: append a node and return its id.
- `Graph::add_edge(self : Graph, from : Int, to : Int, cost : Int) -> Unit`: add a non-negative directed edge. Invalid nodes and negative costs are ignored.
- `Graph::add_undirected_edge(self : Graph, a : Int, b : Int, cost : Int) -> Unit`: add edges in both directions.
- `Graph::neighbors(self : Graph, node : Int) -> Array[Edge]`: return outgoing edges, or an empty array for an invalid node.
- `Graph::in_bounds(self : Graph, node : Int) -> Bool`: check whether a node id exists.
- `Graph::has_path(self : Graph, start : Int, goal : Int) -> Bool`: test reachability.
- `Graph::reachable_count(self : Graph, start : Int) -> Int`: count nodes reachable from `start`.
- `Graph::bfs(self : Graph, start : Int, goal : Int) -> PathReport`: find a shortest path by hop count.
- `Graph::dijkstra(self : Graph, start : Int, goal : Int) -> PathReport`: find a minimum-cost path for non-negative edge costs.
- `Graph::astar(self : Graph, start : Int, goal : Int, heuristic : (Int, Int) -> Int) -> PathReport`: find a minimum-cost path with A*. The implementation reopens nodes when a better path is found, so admissible but inconsistent heuristics are handled correctly.

## Grid

`Grid` adapts a two-dimensional map to graph search.

- `Grid::new(width : Int, height : Int) -> Grid`: create an open grid with movement cost `1`.
- `Grid::inside(self : Grid, p : Point) -> Bool`: check bounds.
- `Grid::index(self : Grid, p : Point) -> Int`: convert a point to a graph node id.
- `Grid::point(self : Grid, index : Int) -> Point`: convert a graph node id back to a point.
- `Grid::set_blocked(self : Grid, p : Point, value : Bool) -> Unit`: mark or unmark an obstacle.
- `Grid::is_blocked(self : Grid, p : Point) -> Bool`: return true for blocked or out-of-bounds points.
- `Grid::set_cost(self : Grid, p : Point, cost : Int) -> Unit`: set the movement cost of entering a cell. Costs below `1` are ignored.
- `Grid::cost_at(self : Grid, p : Point) -> Int`: return the cell cost.
- `Grid::to_graph(self : Grid) -> Graph`: convert the grid to a directed graph.
- `Grid::astar(self : Grid, start : Point, goal : Point) -> PathReport`: run A* using Manhattan distance.
- `Grid::bfs(self : Grid, start : Point, goal : Point) -> PathReport`: run unweighted BFS.
- `Grid::bidirectional_bfs(self : Grid, start : Point, goal : Point) -> PathReport`: run bidirectional BFS.
- `Grid::dijkstra(self : Grid, start : Point, goal : Point) -> PathReport`: run weighted Dijkstra search.

## PathReport

Every search returns `PathReport`.

- `found : Bool`: whether a path was found.
- `cost : Int`: total path cost, or `0` when not found.
- `visited : Int`: number of expanded nodes.
- `path : Array[Int]`: node ids from start to goal.
- `PathReport::length(self : PathReport) -> Int`: path length.
- `PathReport::is_empty(self : PathReport) -> Bool`: whether `path` is empty.
- `PathReport::first(self : PathReport) -> Option[Int]`: first node in the path.
- `PathReport::last(self : PathReport) -> Option[Int]`: last node in the path.

## Example

```moonbit
let graph = Graph::new(4)
graph.add_edge(0, 1, 5)
graph.add_edge(0, 2, 1)
graph.add_edge(2, 1, 1)
graph.add_edge(1, 3, 1)

fn zero(_node : Int, _goal : Int) -> Int {
  0
}

let result = graph.astar(0, 3, zero)
println(result.cost)
```
