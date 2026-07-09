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

test "grid astar avoids blocked cells" {
  let grid = Grid::new(5, 5)
  grid.set_blocked(Point::{ x: 1, y: 0 }, true)
  grid.set_blocked(Point::{ x: 1, y: 1 }, true)
  grid.set_blocked(Point::{ x: 1, y: 2 }, true)

  let result = grid.astar(Point::{ x: 0, y: 0 }, Point::{ x: 4, y: 0 })
  inspect(result.found, content="true")
  inspect(result.cost, content="10")
}
