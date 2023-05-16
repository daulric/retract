You can build, destroy or update elements with ReTractUI. 

Just know how to make the element. 😂

## Mount

### Api
```lua
ReTract.mount(element, tree) -> element
```

### Example
```lua
local handle = ReTract.mount(element, game.Players.LocalPlayer.PlayerGui)
```
Element param derived from the [Element Page](./Element.md)

## Unmount

### Api
This disconnect the tree from the Hub and destroy the instance with it.

```lua
ReTractUI.unmount(tree: element) -> Instance
```
This will return the parent that was in the tree.

### Example
```lua
ReTract.unmount(handle)
```
Handle derived from [here](./Build.md#example)

## Update
All this does is unmount the current tree and mount the new tree.

### Api
```
ReTractUI.update(currentTree, newTree) -> element
```

### Example
```lua
handle = ReTractUI.update(handle, newTree)
```

The handle param derived from [here](./Build.md#example).

The newTree param derived from [here](./Element.md#example-when-using-element).

!!! note

    The `update` method uses the `mount` and `unmount` method.