///|
fn rebuild_path(parent : Array[Int], start : Int, goal : Int) -> Array[Int] {
  let path : Array[Int] = []
  let mut current = goal
  while current != -1 {
    path.push(current)
    if current == start {
      break
    }
    current = parent[current]
  }
  reverse_ints(path)
}

///|
fn rebuild_bidirectional_path(
  parent_start : Array[Int],
  parent_goal : Array[Int],
  start : Int,
  meet : Int,
) -> Array[Int] {
  let path = rebuild_path(parent_start, start, meet)
  let mut current = parent_goal[meet]
  while current != -1 {
    path.push(current)
    current = parent_goal[current]
  }
  path
}

///|
fn reverse_ints(items : Array[Int]) -> Array[Int] {
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

///|
fn path_steps(parent : Array[Int], start : Int, goal : Int) -> Int {
  let mut count = 0
  let mut current = goal
  while current != start && current != -1 {
    count = count + 1
    current = parent[current]
  }
  count
}
