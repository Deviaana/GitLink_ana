# PathForge

PathForge is a lightweight MoonBit graph search and grid pathfinding toolkit. It packages reusable data structures and algorithms for route planning, game AI, algorithm teaching, and WebAssembly demos.

## Features

- Directed weighted graph based on adjacency lists
- BFS for shortest paths by hop count
- Dijkstra for minimum-cost paths with non-negative edge costs
- A* with custom heuristics and node reopening for admissible inconsistent heuristics
- Grid adapter with blocked cells and terrain movement costs
- Unified `PathReport` result type with found status, cost, visited count, and path data
- Unit tests, coverage-ready CI, and a command-line demo

## Project Layout

```text
.
|-- graph.mbt              # Graph, BFS, Dijkstra, A*
|-- grid.mbt               # Grid pathfinding adapter
|-- priority_queue.mbt     # Min-priority queue
|-- path_report.mbt        # Search result type
|-- pathforge_test.mbt     # Unit tests
|-- cmd/main/main.mbt      # Demo entry point
|-- docs/api.md            # Public API reference
|-- docs/application.md    # Project application notes
|-- moon.mod               # MoonBit module metadata
`-- moon.pkg               # Root package config
```

## Quick Start

Install MoonBit, then run:

```bash
moon check
moon test
moon run cmd/main
```

Expected demo output:

```text
PathForge demo
found: true
cost: 15
visited: 29
path length: 16
```

## Example

```moonbit
let grid = @pathforge.Grid::new(8, 5)
grid.set_blocked(@pathforge.Point::{ x: 2, y: 0 }, true)
grid.set_blocked(@pathforge.Point::{ x: 2, y: 1 }, true)

let result = grid.astar(
  @pathforge.Point::{ x: 0, y: 0 },
  @pathforge.Point::{ x: 7, y: 4 },
)
println("found: \{result.found}")
println("cost: \{result.cost}")
```

## API Documentation

See [docs/api.md](docs/api.md) for the public API reference.

## Publishing

The module metadata in `moon.mod` includes mooncakes.io fields: `license`, `keywords`, `repository`, `description`, and `homepage`.

Before publishing:

```bash
moon check --deny-warn
moon test
moon coverage analyze -- -f summary
moon package
moon publish
```

## License

MIT. See [LICENSE](LICENSE).
