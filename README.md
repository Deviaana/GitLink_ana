# PathForge

PathForge 是一个使用 MoonBit 编写的图搜索与网格寻路工具库。它把常见寻路算法封装成可复用的基础库，而不是只提供一个一次性的演示程序。

本项目面向 MoonBit 开源生态建设赛题，选题聚焦于推荐方向中的 **图算法库** 与 **Pathfinding 工具库**。

## 功能特性

- 基于邻接表的带权有向图结构
- BFS 广度优先搜索，用于无权图中的最少步数路径
- Dijkstra 算法，用于带权图中的最低代价路径
- A* 搜索，支持自定义启发函数
- 网格地图适配器，适合导航、游戏地图和仿真场景
- 路径结果结构，包含是否找到路径、总代价、访问节点数和路径数据
- 命令行演示程序与单元测试

## 为什么选择寻路工具库

寻路算法既是基础算法问题，也有非常明确的真实使用场景：

- WebAssembly 浏览器游戏
- 校园导航演示
- 仓储与物流路线规划模拟
- 确定性移动行为测试
- 图算法教学与可视化

MoonBit 适合这个方向，因为同一套核心库后续可以用于命令行工具、测试程序，也可以继续扩展为 WebAssembly 可视化演示。

## 项目结构

```text
.
|-- graph.mbt              # 图结构、BFS、Dijkstra 和 A*
|-- grid.mbt               # 基于 Graph 的网格地图适配层
|-- priority_queue.mbt     # Dijkstra 和 A* 使用的最小优先队列
|-- path_report.mbt        # 路径搜索结果结构
|-- pathforge_test.mbt     # 单元测试
|-- cmd/main/main.mbt      # 命令行演示入口
|-- docs/selection.md      # 赛题选题说明
|-- moon.mod.json          # MoonBit 模块配置
`-- moon.pkg.json          # 根包配置
```

## 快速开始

安装 MoonBit 后，在项目根目录运行：

```bash
moon check
moon test
moon run cmd/main
```

演示程序的预期输出：

```text
PathForge demo
found: true
cost: 15
visited: 29
path length: 16
```

## 使用示例

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

## 核心设计

`Graph` 使用邻接表保存节点和带权边。`bfs` 适合所有边代价相同的场景，用于寻找最少步数路径。`dijkstra` 适合边代价不同的场景，用于寻找总代价最低的路径。`astar` 在 Dijkstra 的基础上加入启发函数，让搜索过程更倾向于目标方向。

`Grid` 是更高层的网格地图适配器。它把二维网格转换为图结构，将被阻塞的格子视为障碍物，并提供基于 `Point` 坐标的寻路接口，使用者不需要直接处理底层节点编号。

## 后续规划

1. 增加 ASCII 地图解析器，方便快速编写地图。
2. 增加 JSON 导出能力，用于前端路径可视化。
3. 增加更多寻路算法，例如双向 A*。
4. 增加不同地图规模下的 benchmark。
5. 增加 WebAssembly 可视化演示页面。

## GitHub 仓库描述

推荐中文描述：

```text
使用 MoonBit 实现的图搜索与网格寻路工具库，支持 BFS、Dijkstra 和 A* 算法。
```

推荐英文描述：

```text
A MoonBit graph search and grid pathfinding toolkit with BFS, Dijkstra and A*.
```

推荐初始提交信息：

```text
feat: implement PathForge graph and grid pathfinding toolkit
```
