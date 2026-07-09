fn main {
  let grid = @pathforge.Grid::new(8, 5)
  grid.set_blocked(@pathforge.Point::{ x: 2, y: 0 }, true)
  grid.set_blocked(@pathforge.Point::{ x: 2, y: 1 }, true)
  grid.set_blocked(@pathforge.Point::{ x: 2, y: 2 }, true)
  grid.set_blocked(@pathforge.Point::{ x: 5, y: 2 }, true)
  grid.set_blocked(@pathforge.Point::{ x: 5, y: 3 }, true)
  grid.set_blocked(@pathforge.Point::{ x: 5, y: 4 }, true)

  let result = grid.astar(
    @pathforge.Point::{ x: 0, y: 0 },
    @pathforge.Point::{ x: 7, y: 4 },
  )
  println("PathForge demo")
  println("found: \{result.found}")
  println("cost: \{result.cost}")
  println("visited: \{result.visited}")
  println("path length: \{result.path.length()}")
}
