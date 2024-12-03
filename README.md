# Checkable properties behave differently based on where they are edited

The term "checkable properties" refers to properties exposed to the editor through `_get_property_list` with the flag `PROPERTY_USAGE_CHECKABLE`. 

Assume there is a custom resource class named `MyResource` with such a property, and a file `my_resource.tres` storing a specific instance of that class. If the user clicks on that file and edits it that way in the inspector, toggling on and off the property will behave as expected (or at least, the way I expected it to) - more specifically, toggling off the property sets it to `null` while toggling it on sets it to an appropriate default value based on its type.

Now assume there is a custom node `MyNode` with an exported member of type `MyResource` set to `my_resource.tres`. Editing it through the node's inspector does not yield the same behavior as in last paragraph; toggling the property on and off does nothing. This effectively makes the check button useless; even if manually set to the default value and unchecked, the value will be saved as the default one instead of `null`.

The purpose of this small repository is to highlight this inconsistency, which I can only assume is due to a bug whatever the intended behavior is.

## Structure of the repository

- `my_resource.gd` defines `MyResource` with its checkable property `my_property`. Whenever `my_property` is set, a message is printed on the console.
- `my_resource.tres`is an instance of `MyResource` stored outside of any scene so that we can compare the two situations
- `my_node.tscn`and `my_node.gd` define `MyNode` with two exported members, `first` (set to `my_resource`) and `second` whose instance is stored internally.

## How to reproduce the bug

First double-click on `my_resource.tres` in the file explorer.
- Toggling on `my_property` will set its value to `0`. In the console, you should see `my_property <- 0`.
- Toggling it off will set its value to `null`. In the console, you should see `my_property <- <null>`. Whatever its previous value was, the inspector should now display `0`.

Then open `my_node.tscn`. In the inspector, click on its member `first` to start editing `my_resource.tres` *through* the node.
- Toggling on `my_property` does nothing. In particular, no message is printed to the console, suggesting the setter is not even called.
- Toggling it off similarly does nothing.  The value is not set to `null` or even `0`.

Internally stored resources can only be edited through their scene, and so they always fall in the second case.

## Workaround

Store all resources with checkable properties externally.