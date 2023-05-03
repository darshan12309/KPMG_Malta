def get_value_from_nested_object(nested_object, key):
    keys = key.split("/")
    value = nested_object
    for k in keys:
        value = value.get(k)
        if not value:
            return None
    return value

object_1 = {"a": {"b": {"c": "d"}}}
key_1 = "a/b/c"
value_1 = get_value_from_nested_object(object_1, key_1)
print(value_1) 

object_2 = {"x": {"y": {"z": "a"}}}
key_2 = "x/y/z"
value_2 = get_value_from_nested_object(object_2, key_2)
print(value_2) 
