---
title: "Mutex"
weight: 100
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# The `Mutex` class 

## Constructor of `Mutex`

The `Mutex` constructor creates a new mutex object with no parameters.

```lua
mutex = Mutex.new()
```

## `Mutex` Methods

### `lock`

The `lock` method acquires a lock on the `Mutex` object. It blocks other threads
until the lock is available. This method does not accept any parameters and does
not return anything.

```lua
mutex = Mutex.new()
mutex:lock()
-- critical section
mutex:unlock()
```

### `unlock`

The `unlock` method releases the lock on the `Mutex` object. This method does not
accept any parameters and does not return anything.

```lua
mutex = Mutex.new()
mutex:lock()
-- critical section
mutex:unlock()
```
