@tool
class_name MyResource
extends Resource

# I first tried using a "my_property" member directly (of type Variant),
# but for some reason I would always stay unchecked this way.
const KEY := "my_property"
var internal_data := {}

func _get_property_list() -> Array[Dictionary]:
	var usage := PROPERTY_USAGE_DEFAULT + PROPERTY_USAGE_CHECKABLE
	if internal_data.has(KEY):
		usage += PROPERTY_USAGE_CHECKED
	return [{
		"name": KEY,
		"type": TYPE_INT,
		"usage": usage
	}]

func _get(property: StringName) -> Variant:
	if property == KEY:
		return internal_data.get(KEY)
	else:
		return null

func _set(property: StringName, value: Variant) -> bool:
	if property == KEY:
		prints(KEY, "<-", value)
		if value == null:
			internal_data.erase(KEY)
		else:
			internal_data[KEY] = value
		return true
	else:
		return false
