///|
pub(all) struct PathReport {
  found : Bool
  cost : Int
  visited : Int
  path : Array[Int]
}

///|
pub fn PathReport::not_found(visited : Int) -> PathReport {
  PathReport::{ found: false, cost: 0, visited, path: [] }
}

///|
pub fn PathReport::single(node : Int) -> PathReport {
  PathReport::{ found: true, cost: 0, visited: 1, path: [node] }
}

///|
pub fn PathReport::success(
  cost : Int,
  visited : Int,
  path : Array[Int],
) -> PathReport {
  PathReport::{ found: true, cost, visited, path }
}

///|
pub fn PathReport::length(self : PathReport) -> Int {
  self.path.length()
}

///|
pub fn PathReport::is_empty(self : PathReport) -> Bool {
  self.path.length() == 0
}

///|
pub fn PathReport::first(self : PathReport) -> Int? {
  if self.path.length() == 0 {
    None
  } else {
    Some(self.path[0])
  }
}

///|
pub fn PathReport::last(self : PathReport) -> Int? {
  let len = self.path.length()
  if len == 0 {
    None
  } else {
    Some(self.path[len - 1])
  }
}
