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

  let start_id = self.index(start)
  let goal_id = self.index(goal)
  if start_id == goal_id {
    return PathReport::single(start_id)
  }

  let total = self.width * self.height
  let inf = 1_000_000_000
  let g_score = Array::make(total, inf)
  let parent = Array::make(total, -1)
  let closed = Array::make(total, false)
  let open = PriorityQueue::new()
  let mut visited = 0

  g_score[start_id] = 0
  open.push(start_id, manhattan(start, goal))

  while !open.is_empty() {
    let item = open.pop().unwrap()
    let current = item.node
    if closed[current] {
      continue
    }
    closed[current] = true
    visited = visited + 1

    if current == goal_id {
      return PathReport::success(
        g_score[goal_id],
        visited,
        grid_rebuild(parent, start_id, goal_id),
      )
    }

    let p = self.point(current)
    self.relax_grid_neighbor(open, g_score, parent, current, Point::{ x: p.x + 1, y: p.y }, goal)
    self.relax_grid_neighbor(open, g_score, parent, current, Point::{ x: p.x - 1, y: p.y }, goal)
    self.relax_grid_neighbor(open, g_score, parent, current, Point::{ x: p.x, y: p.y + 1 }, goal)
    self.relax_grid_neighbor(open, g_score, parent, current, Point::{ x: p.x, y: p.y - 1 }, goal)
  }

  PathReport::not_found(visited)
}

pub fn Grid::bfs(self : Grid, start : Point, goal : Point) -> PathReport {
  guard self.inside(start) && self.inside(goal) else {
    return PathReport::not_found(0)
  }
  guard !self.is_blocked(start) && !self.is_blocked(goal) else {
    return PathReport::not_found(0)
  }

  let start_id = self.index(start)
  let goal_id = self.index(goal)
  if start_id == goal_id {
    return PathReport::single(start_id)
  }

  let total = self.width * self.height
  let queue = [start_id]
  let seen = Array::make(total, false)
  let parent = Array::make(total, -1)
  let mut head = 0
  let mut visited = 0

  seen[start_id] = true

  while head < queue.length() {
    let current = queue[head]
    head = head + 1
    visited = visited + 1

    let p = self.point(current)
    if self.enqueue_grid_neighbor(queue, seen, parent, current, Point::{ x: p.x + 1, y: p.y }, goal_id) {
      return PathReport::success(grid_steps(parent, start_id, goal_id), visited, grid_rebuild(parent, start_id, goal_id))
    }
    if self.enqueue_grid_neighbor(queue, seen, parent, current, Point::{ x: p.x - 1, y: p.y }, goal_id) {
      return PathReport::success(grid_steps(parent, start_id, goal_id), visited, grid_rebuild(parent, start_id, goal_id))
    }
    if self.enqueue_grid_neighbor(queue, seen, parent, current, Point::{ x: p.x, y: p.y + 1 }, goal_id) {
      return PathReport::success(grid_steps(parent, start_id, goal_id), visited, grid_rebuild(parent, start_id, goal_id))
    }
    if self.enqueue_grid_neighbor(queue, seen, parent, current, Point::{ x: p.x, y: p.y - 1 }, goal_id) {
      return PathReport::success(grid_steps(parent, start_id, goal_id), visited, grid_rebuild(parent, start_id, goal_id))
    }
  }

  PathReport::not_found(visited)
}

pub fn Grid::dijkstra(self : Grid, start : Point, goal : Point) -> PathReport {
  guard self.inside(start) && self.inside(goal) else {
    return PathReport::not_found(0)
  }
  guard !self.is_blocked(start) && !self.is_blocked(goal) else {
    return PathReport::not_found(0)
  }

  let start_id = self.index(start)
  let goal_id = self.index(goal)
  if start_id == goal_id {
    return PathReport::single(start_id)
  }

  let total = self.width * self.height
  let inf = 1_000_000_000
  let dist = Array::make(total, inf)
  let parent = Array::make(total, -1)
  let visited_nodes = Array::make(total, false)
  let open = PriorityQueue::new()
  let mut visited = 0

  dist[start_id] = 0
  open.push(start_id, 0)

  while !open.is_empty() {
    let item = open.pop().unwrap()
    let current = item.node
    if visited_nodes[current] {
      continue
    }
    visited_nodes[current] = true
    visited = visited + 1

    if current == goal_id {
      return PathReport::success(
        dist[goal_id],
        visited,
        grid_rebuild(parent, start_id, goal_id),
      )
    }

    let p = self.point(current)
    self.relax_grid_neighbor_by_cost(open, dist, parent, current, Point::{ x: p.x + 1, y: p.y })
    self.relax_grid_neighbor_by_cost(open, dist, parent, current, Point::{ x: p.x - 1, y: p.y })
    self.relax_grid_neighbor_by_cost(open, dist, parent, current, Point::{ x: p.x, y: p.y + 1 })
    self.relax_grid_neighbor_by_cost(open, dist, parent, current, Point::{ x: p.x, y: p.y - 1 })
  }

  PathReport::not_found(visited)
}

fn Grid::connect_if_open(self : Grid, graph : Graph, from : Point, to : Point) -> Unit {
  if self.inside(to) && !self.is_blocked(to) {
    graph.add_edge(self.index(from), self.index(to), 1)
  }
}

fn Grid::enqueue_grid_neighbor(
  self : Grid,
  queue : Array[Int],
  seen : Array[Bool],
  parent : Array[Int],
  current : Int,
  next_point : Point,
  goal : Int
) -> Bool {
  if self.is_blocked(next_point) {
    return false
  }
  let next = self.index(next_point)
  if seen[next] {
    return false
  }
  seen[next] = true
  parent[next] = current
  if next == goal {
    return true
  }
  queue.push(next)
  false
}

fn Grid::relax_grid_neighbor(
  self : Grid,
  open : PriorityQueue,
  g_score : Array[Int],
  parent : Array[Int],
  current : Int,
  next_point : Point,
  goal : Point
) -> Unit {
  if self.is_blocked(next_point) {
    return
  }
  let next = self.index(next_point)
  let tentative = g_score[current] + 1
  if tentative < g_score[next] {
    g_score[next] = tentative
    parent[next] = current
    open.push(next, tentative + manhattan(next_point, goal))
  }
}

fn Grid::relax_grid_neighbor_by_cost(
  self : Grid,
  open : PriorityQueue,
  dist : Array[Int],
  parent : Array[Int],
  current : Int,
  next_point : Point
) -> Unit {
  if self.is_blocked(next_point) {
    return
  }
  let next = self.index(next_point)
  let tentative = dist[current] + 1
  if tentative < dist[next] {
    dist[next] = tentative
    parent[next] = current
    open.push(next, tentative)
  }
}

fn grid_rebuild(parent : Array[Int], start : Int, goal : Int) -> Array[Int] {
  let path : Array[Int] = []
  let mut current = goal
  while current != -1 {
    path.push(current)
    if current == start {
      break
    }
    current = parent[current]
  }
  grid_reverse(path)
}

fn grid_reverse(items : Array[Int]) -> Array[Int] {
  let result : Array[Int] = []
  let mut i = items.length() - 1
  while i >= 0 {
    result.push(items[i])
    if i == 0 {
      break
    }
    i = i - 1
  }
  result
}

fn grid_steps(parent : Array[Int], start : Int, goal : Int) -> Int {
  let mut count = 0
  let mut current = goal
  while current != start && current != -1 {
    count = count + 1
    current = parent[current]
  }
  count
}

fn manhattan(a : Point, b : Point) -> Int {
  abs(a.x - b.x) + abs(a.y - b.y)
}

fn abs(value : Int) -> Int {
  if value < 0 {
    -value
  } else {
    value
  }
}
