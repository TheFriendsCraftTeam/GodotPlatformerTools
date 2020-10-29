extends Object
class_name HandyFunctions
# A class to store some functions that might be useful in some cases.

static func abs_vec(vector):# Return a vector with no negative values
	if vector is Vector2:
		vector.x = abs(vector.x)
		vector.y = abs(vector.y)
	elif vector is Vector3:
		vector.x = abs(vector.x)
		vector.y = abs(vector.y)
		vector.z = abs(vector.z)


static func sign_vec(vector):# Return a vector with only 0, -1 or 1
	if vector is Vector2:
		vector.x = sign(vector.x)
		vector.y = sign(vector.y)
	elif vector is Vector3:
		vector.x = sign(vector.x)
		vector.y = sign(vector.y)
		vector.z = sign(vector.z)


static func snake_case(string: String) -> String:# Formats a String with snake_case
	return string.to_lower().replace(" ", "_")
