# PathForge 维护与发布检查清单

## 维护目标
P3 阶段关注长期可维护性：统一实现风格、保持搜索核心和适配层边界清晰，并沉淀稳定的发布前检查流程。

## 实现风格
- 图搜索相关入口保持在 `graph.mbt`
- 网格建模和网格邻居扩展保持在 `grid.mbt`
- 搜索结果结构保持在 `path_report.mbt`
- 优先队列实现保持在 `priority_queue.mbt`
- 路径回溯、反转、步数统计等共享工具保持在 `path_utils.mbt`
- 新增公共 API 时同步更新 `docs/api.md`、`README.md` 和单元测试

## 搜索核心与适配层边界
- `Graph` 负责通用有向加权图搜索
- `Grid` 负责二维坐标、障碍物、地形代价和邻居生成
- `PathReport` 只表达搜索结果，不承载搜索过程状态
- 公共搜索接口返回稳定语义：非法输入不展开节点，失败路径为空
- 只需要判断可达性时优先使用 `has_path`，避免不必要的路径回溯

## 发布前检查流程
发布前建议依次执行：

```bash
moon check --deny-warn
moon test
moon coverage analyze -- -f summary
moon run cmd/main
moon package
```

检查通过后再执行：

```bash
moon publish
```

## 发布前人工核对
- `moon.mod` 中的 `version`、`repository`、`description`、`homepage` 是否准确
- `README.md` 的示例是否仍可运行
- `docs/api.md` 是否覆盖新增或变更的公共 API
- `docs/application.md` 中的维护清单是否反映当前进度
- 新增行为是否有单元测试覆盖
- 失败语义是否仍满足：`found == false`、`cost == 0`、`path` 为空

## 后续演进建议
- 如果搜索算法继续增加，优先抽象内部工作队列和邻居访问模式
- 如果网格能力扩展到斜向移动或动态障碍，应先补充成本语义文档
- 如果性能成为瓶颈，再引入可复用搜索工作区，避免提前扩大 API 面
