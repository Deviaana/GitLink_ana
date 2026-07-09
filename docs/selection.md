# 选题建议：PathForge - MoonBit 寻路算法工具库

## 推荐选题

我建议做 `PathForge`，一个面向 MoonBit 生态的寻路算法工具库。

它不是单纯算法练习，而是一个可复用基础库：开发者可以把它用于游戏 AI、
WebAssembly 地图导航、物流路线模拟、确定性仿真、教学可视化等场景。

## 为什么适合这个赛题

1. 贴合推荐方向：赛题明确提到 Graph 相关算法库和 Pathfinding 工具库。
2. 边界清晰：核心功能容易讲清楚，评审理解成本低。
3. 可扩展性强：从 1 个基础库可以自然扩展出 benchmark、可视化、WASM demo。
4. MoonBit 价值明显：强类型、低资源消耗、适合编译到 WebAssembly。
5. 避免撞车：比 Markdown 渲染器、日志库这类常见项目更容易做出差异化。

## 作品定位

PathForge = 图与网格场景下的轻量级寻路工具箱。

首版功能：

- 图结构 `Graph`
- 广度优先搜索 `bfs`
- Dijkstra 最短路 `dijkstra`
- A* 搜索 `astar`
- 网格地图 `Grid`
- 路径结果 `PathReport`
- 命令行示例和测试

后续增强：

- ASCII 地图解析器
- JSON 导出，供前端可视化
- benchmark 工具
- 双向 A*
- WASM 交互式演示页面

## 参赛标题备选

- PathForge: MoonBit Graph Pathfinding Toolkit
- PathForge: 面向 MoonBit 生态的图搜索与网格寻路库
- MoonPath: 用 MoonBit 构建可复用寻路算法工具箱

