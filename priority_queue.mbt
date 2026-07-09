pub(all) struct QueueItem {
  node : Int
  priority : Int
}

pub(all) struct PriorityQueue {
  mut data : Array[QueueItem]
}

pub fn PriorityQueue::new() -> PriorityQueue {
  PriorityQueue::{ data: [] }
}

pub fn PriorityQueue::is_empty(self : PriorityQueue) -> Bool {
  self.data.length() == 0
}

pub fn PriorityQueue::length(self : PriorityQueue) -> Int {
  self.data.length()
}

pub fn PriorityQueue::push(self : PriorityQueue, node : Int, priority : Int) -> Unit {
  self.data.push(QueueItem::{ node, priority })
  self.bubble_up(self.data.length() - 1)
}

pub fn PriorityQueue::pop(self : PriorityQueue) -> Option[QueueItem] {
  let len = self.data.length()
  if len == 0 {
    None
  } else if len == 1 {
    Some(self.data.pop().unwrap())
  } else {
    let top : QueueItem = self.data[0]
    let last = self.data.pop().unwrap()
    self.data[0] = last
    self.bubble_down(0)
    Some(top)
  }
}

fn PriorityQueue::bubble_up(self : PriorityQueue, index : Int) -> Unit {
  let mut cursor = index
  while cursor > 0 {
    let parent = (cursor - 1) / 2
    if self.data[parent].priority <= self.data[cursor].priority {
      break
    }
    self.swap(parent, cursor)
    cursor = parent
  }
}

fn PriorityQueue::bubble_down(self : PriorityQueue, index : Int) -> Unit {
  let mut cursor = index
  let len = self.data.length()
  while true {
    let left = cursor * 2 + 1
    let right = left + 1
    let mut best = cursor

    if left < len && self.data[left].priority < self.data[best].priority {
      best = left
    }
    if right < len && self.data[right].priority < self.data[best].priority {
      best = right
    }
    if best == cursor {
      break
    }
    self.swap(cursor, best)
    cursor = best
  }
}

fn PriorityQueue::swap(self : PriorityQueue, a : Int, b : Int) -> Unit {
  let tmp = self.data[a]
  self.data[a] = self.data[b]
  self.data[b] = tmp
}
