# PathForge

PathForge is a MoonBit pathfinding toolkit for graph search and grid maps.

This project is designed for the MoonBit ecosystem contest. It focuses on a
clear reusable library surface rather than a one-off demo:

- weighted directed graph
- BFS shortest hop search
- Dijkstra shortest path
- A* search with pluggable heuristic
- grid map adapter for games, simulation and navigation demos
- path report utilities for debugging and visualization

## Why This Topic

Recommended contest topic: basic data structures and algorithms, especially
graph algorithms and pathfinding tools.

Pathfinding is a good fit because it has real usage scenarios:

- WebAssembly browser games
- campus indoor navigation demos
- warehouse route planning simulation
- deterministic AI movement tests
- teaching graph algorithms with MoonBit examples

It is also easy to expand to 4k-10k MoonBit lines by adding benchmark cases,
more algorithms, grid compression, map parsers, and WebAssembly visualization.

## Suggested Roadmap

1. Add more algorithms: Bellman-Ford, Floyd-Warshall, bidirectional A*.
2. Add map formats: ASCII map parser, JSON map parser, tiled map importer.
3. Add benchmark command: compare BFS / Dijkstra / A* on generated maps.
4. Add visualization: export searched nodes and final path as JSON.
5. Add WebAssembly demo: interactive grid editor in browser.

## Run

After installing MoonBit:

```bash
moon check
moon test
moon run cmd/main
```
