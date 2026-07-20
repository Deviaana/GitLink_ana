///|
test "bfs finds shortest hop path" {
  let graph = Graph::new(5)
  graph.add_undirected_edge(0, 1, 1)
  graph.add_undirected_edge(1, 2, 1)
  graph.add_undirected_edge(0, 3, 1)
  graph.add_undirected_edge(3, 4, 1)
  graph.add_undirected_edge(4, 2, 1)

  let result = graph.bfs(0, 2)
  inspect(result.found, content="true")
  inspect(result.cost, content="2")
  inspect(result.path.length(), content="3")
}

///|
test "graph has_path detects reachable node" {
  let graph = Graph::new(4)
  graph.add_edge(0, 1, 1)
  graph.add_edge(1, 2, 1)

  inspect(graph.has_path(0, 2), content="true")
}

///|
test "graph has_path detects unreachable node" {
  let graph = Graph::new(4)
  graph.add_edge(0, 1, 1)

  inspect(graph.has_path(0, 3), content="false")
}

///|
test "graph reachable_count counts reachable nodes" {
  let graph = Graph::new(5)
  graph.add_edge(0, 1, 1)
  graph.add_edge(1, 2, 1)
  graph.add_edge(3, 4, 1)

  inspect(graph.reachable_count(0), content="3")
}

///|
test "graph reachable_count rejects invalid start" {
  let graph = Graph::new(3)

  inspect(graph.reachable_count(9), content="0")
}

///|
test "dijkstra prefers cheaper weighted path" {
  let graph = Graph::new(4)
  graph.add_edge(0, 1, 10)
  graph.add_edge(0, 2, 1)
  graph.add_edge(2, 1, 1)
  graph.add_edge(1, 3, 1)
  graph.add_edge(2, 3, 10)

  let result = graph.dijkstra(0, 3)
  inspect(result.found, content="true")
  inspect(result.cost, content="3")
  inspect(result.path.length(), content="4")
}

///|
test "graph astar reopens nodes for inconsistent heuristic" {
  let graph = Graph::new(4)
  graph.add_edge(0, 1, 5)
  graph.add_edge(0, 2, 4)
  graph.add_edge(2, 1, 0)
  graph.add_edge(1, 3, 10)

  fn heuristic(node : Int, _goal : Int) -> Int {
    if node == 2 {
      10
    } else {
      0
    }
  }

  let result = graph.astar(0, 3, heuristic)
  inspect(result.found, content="true")
  inspect(result.cost, content="14")
  inspect(result.path.length(), content="4")
}

///|
test "graph astar returns single-node path when start equals goal" {
  let graph = Graph::new(3)

  fn zero(_node : Int, _goal : Int) -> Int {
    0
  }

  let result = graph.astar(1, 1, zero)
  inspect(result.found, content="true")
  inspect(result.cost, content="0")
  inspect(result.path.length(), content="1")
}

///|
test "graph astar rejects invalid endpoints" {
  let graph = Graph::new(3)

  fn zero(_node : Int, _goal : Int) -> Int {
    0
  }

  let invalid_start = graph.astar(-1, 2, zero)
  inspect(invalid_start.found, content="false")
  inspect(invalid_start.visited, content="0")

  let invalid_goal = graph.astar(0, 9, zero)
  inspect(invalid_goal.found, content="false")
  inspect(invalid_goal.visited, content="0")
}

///|
test "grid astar avoids blocked cells" {
  let grid = Grid::new(5, 5)
  grid.set_blocked(Point::{ x: 1, y: 0 }, true)
  grid.set_blocked(Point::{ x: 1, y: 1 }, true)
  grid.set_blocked(Point::{ x: 1, y: 2 }, true)

  let result = grid.astar(Point::{ x: 0, y: 0 }, Point::{ x: 4, y: 0 })
  inspect(result.found, content="true")
  inspect(result.cost, content="10")
}

///|
test "grid bfs finds shortest unweighted path" {
  let grid = Grid::new(5, 5)
  grid.set_blocked(Point::{ x: 1, y: 0 }, true)
  grid.set_blocked(Point::{ x: 1, y: 1 }, true)
  grid.set_blocked(Point::{ x: 1, y: 2 }, true)

  let result = grid.bfs(Point::{ x: 0, y: 0 }, Point::{ x: 4, y: 0 })
  inspect(result.found, content="true")
  inspect(result.cost, content="10")
}

///|
test "grid bidirectional bfs finds shortest unweighted path" {
  let grid = Grid::new(5, 5)
  grid.set_blocked(Point::{ x: 1, y: 0 }, true)
  grid.set_blocked(Point::{ x: 1, y: 1 }, true)
  grid.set_blocked(Point::{ x: 1, y: 2 }, true)

  let result = grid.bidirectional_bfs(Point::{ x: 0, y: 0 }, Point::{
    x: 4,
    y: 0,
  })
  inspect(result.found, content="true")
  inspect(result.cost, content="10")
}

///|
test "grid dijkstra avoids blocked cells" {
  let grid = Grid::new(5, 5)
  grid.set_blocked(Point::{ x: 1, y: 0 }, true)
  grid.set_blocked(Point::{ x: 1, y: 1 }, true)
  grid.set_blocked(Point::{ x: 1, y: 2 }, true)

  let result = grid.dijkstra(Point::{ x: 0, y: 0 }, Point::{ x: 4, y: 0 })
  inspect(result.found, content="true")
  inspect(result.cost, content="10")
}

///|
test "grid dijkstra avoids expensive terrain" {
  let grid = Grid::new(3, 3)
  grid.set_cost(Point::{ x: 1, y: 0 }, 10)

  let result = grid.dijkstra(Point::{ x: 0, y: 0 }, Point::{ x: 2, y: 0 })
  inspect(result.found, content="true")
  inspect(result.cost, content="4")
  inspect(result.path.length(), content="5")
}

///|
test "grid astar avoids expensive terrain" {
  let grid = Grid::new(3, 3)
  grid.set_cost(Point::{ x: 1, y: 0 }, 10)

  let result = grid.astar(Point::{ x: 0, y: 0 }, Point::{ x: 2, y: 0 })
  inspect(result.found, content="true")
  inspect(result.cost, content="4")
  inspect(result.path.length(), content="5")
}
