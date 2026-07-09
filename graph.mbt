pub(all) struct Edge {
  to : Int
  cost : Int
}

pub(all) struct Graph {
  mut adj : Array[Array[Edge]]
}

pub fn Graph::new(size : Int) -> Graph {
  let adj : Array[Array[Edge]] = []
  for _ in 0..<size {
    adj.push([])
  }
  Graph::{ adj }
}

pub fn Graph::node_count(self : Graph) -> Int {
  self.adj.length()
}

pub fn Graph::add_node(self : Graph) -> Int {
  let id = self.adj.length()
  self.adj.push([])
  id
}

pub fn Graph::add_edge(self : Graph, from : Int, to : Int, cost : Int) -> Unit {
  guard self.in_bounds(from) && self.in_bounds(to) && cost >= 0 else {
    return
  }
  self.adj[from].push(Edge::{ to, cost })
}

pub fn Graph::add_undirected_edge(self : Graph, a : Int, b : Int, cost : Int) -> Unit {
  self.add_edge(a, b, cost)
  self.add_edge(b, a, cost)
}

pub fn Graph::neighbors(self : Graph, node : Int) -> Array[Edge] {
  if self.in_bounds(node) {
    self.adj[node]
  } else {
    []
  }
}

pub fn Graph::in_bounds(self : Graph, node : Int) -> Bool {
  node >= 0 && node < self.adj.length()
}

pub fn Graph::bfs(self : Graph, start : Int, goal : Int) -> PathReport {
  guard self.in_bounds(start) && self.in_bounds(goal) else {
    return PathReport::not_found(0)
  }
  if start == goal {
    return PathReport::single(start)
  }

  let n = self.node_count()
  let queue = [start]
  let mut head = 0
  let seen = Array::make(n, false)
  let parent = Array::make(n, -1)
  let mut visited = 0
  seen[start] = true

  while head < queue.length() {
    let current = queue[head]
    head = head + 1
    visited = visited + 1

    for edge in self.neighbors(current) {
      let next = edge.to
      if !seen[next] {
        seen[next] = true
        parent[next] = current
        if next == goal {
          return PathReport::success(steps(parent, start, goal), visited, rebuild(parent, start, goal))
        }
        queue.push(next)
      }
    }
  }

  PathReport::not_found(visited)
}

pub fn Graph::dijkstra(self : Graph, start : Int, goal : Int) -> PathReport {
  guard self.in_bounds(start) && self.in_bounds(goal) else {
    return PathReport::not_found(0)
  }
  if start == goal {
    return PathReport::single(start)
  }

  let n = self.node_count()
  let inf = 1_000_000_000
  let dist = Array::make(n, inf)
  let parent = Array::make(n, -1)
  let visited = Array::make(n, false)
  let mut count = 0
  let pq = PriorityQueue::new()
  dist[start] = 0
  pq.push(start, 0)

  while !pq.is_empty() {
    let item = pq.pop().unwrap()
    let current = item.node
    if visited[current] {
      continue
    }
    visited[current] = true
    count = count + 1
    if current == goal {
      return PathReport::success(dist[goal], count, rebuild(parent, start, goal))
    }

    for edge in self.neighbors(current) {
      let next = edge.to
      let next_cost = dist[current] + edge.cost
      if next_cost < dist[next] {
        dist[next] = next_cost
        parent[next] = current
        pq.push(next, next_cost)
      }
    }
  }

  PathReport::not_found(count)
}

pub fn Graph::astar(
  self : Graph,
  start : Int,
  goal : Int,
  heuristic : (Int, Int) -> Int
) -> PathReport {
  guard self.in_bounds(start) && self.in_bounds(goal) else {
    return PathReport::not_found(0)
  }
  if start == goal {
    return PathReport::single(start)
  }

  let n = self.node_count()
  let inf = 1_000_000_000
  let g_score = Array::make(n, inf)
  let parent = Array::make(n, -1)
  let closed = Array::make(n, false)
  let mut count = 0
  let open = PriorityQueue::new()
  g_score[start] = 0
  open.push(start, heuristic(start, goal))

  while !open.is_empty() {
    let item = open.pop().unwrap()
    let current = item.node
    if closed[current] {
      continue
    }
    closed[current] = true
    count = count + 1

    if current == goal {
      return PathReport::success(g_score[goal], count, rebuild(parent, start, goal))
    }

    for edge in self.neighbors(current) {
      let next = edge.to
      let tentative = g_score[current] + edge.cost
      if tentative < g_score[next] {
        g_score[next] = tentative
        parent[next] = current
        open.push(next, tentative + heuristic(next, goal))
      }
    }
  }

  PathReport::not_found(count)
}

fn rebuild(parent : Array[Int], start : Int, goal : Int) -> Array[Int] {
  let path : Array[Int] = []
  let mut current = goal
  while current != -1 {
    path.push(current)
    if current == start {
      break
    }
    current = parent[current]
  }
  reverse(path)
}

fn reverse(items : Array[Int]) -> Array[Int] {
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

fn steps(parent : Array[Int], start : Int, goal : Int) -> Int {
  let mut count = 0
  let mut current = goal
  while current != start && current != -1 {
    count = count + 1
    current = parent[current]
  }
  count
}
