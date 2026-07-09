pub(all) struct Point {
  x : Int
  y : Int
}

pub(all) struct Grid {
  width : Int
  height : Int
  mut blocked : Array[Bool]
}

pub fn Grid::new(width : Int, height : Int) -> Grid {
  Grid::{ width, height, blocked: Array::make(width * height, false) }
}

pub fn Grid::inside(self : Grid, p : Point) -> Bool {
  p.x >= 0 && p.x < self.width && p.y >= 0 && p.y < self.height
}

pub fn Grid::index(self : Grid, p : Point) -> Int {
  p.y * self.width + p.x
}

pub fn Grid::point(self : Grid, index : Int) -> Point {
  Point::{ x: index % self.width, y: index / self.width }
}

pub fn Grid::set_blocked(self : Grid, p : Point, value : Bool) -> Unit {
  if self.inside(p) {
    self.blocked[self.index(p)] = value
  }
}

pub fn Grid::is_blocked(self : Grid, p : Point) -> Bool {
  !self.inside(p) || self.blocked[self.index(p)]
}

pub fn Grid::to_graph(self : Grid) -> Graph {
  let graph = Graph::new(self.width * self.height)
  for y in 0..<self.height {
    for x in 0..<self.width {
      let p = Point::{ x, y }
      if !self.is_blocked(p) {
        self.connect_if_open(graph, p, Point::{ x: x + 1, y })
        self.connect_if_open(graph, p, Point::{ x: x - 1, y })
        self.connect_if_open(graph, p, Point::{ x, y: y + 1 })
        self.connect_if_open(graph, p, Point::{ x, y: y - 1 })
      }
    }
  }
  graph
}

pub fn Grid::astar(self : Grid, start : Point, goal : Point) -> PathReport {
  guard self.inside(start) && self.inside(goal) else {
    return PathReport::not_found(0)
  }
  guard !self.is_blocked(start) && !self.is_blocked(goal) else {
    return PathReport::not_found(0)
  }
  let graph = self.to_graph()
  graph.astar(self.index(start), self.index(goal), fn(a, b) {
    let pa = self.point(a)
    let pb = self.point(b)
    abs(pa.x - pb.x) + abs(pa.y - pb.y)
  })
}

pub fn Grid::dijkstra(self : Grid, start : Point, goal : Point) -> PathReport {
  guard self.inside(start) && self.inside(goal) else {
    return PathReport::not_found(0)
  }
  let graph = self.to_graph()
  graph.dijkstra(self.index(start), self.index(goal))
}

fn Grid::connect_if_open(self : Grid, graph : Graph, from : Point, to : Point) -> Unit {
  if self.inside(to) && !self.is_blocked(to) {
    graph.add_edge(self.index(from), self.index(to), 1)
  }
}

fn abs(value : Int) -> Int {
  if value < 0 {
    -value
  } else {
    value
  }
}
