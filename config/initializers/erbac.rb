Erbac.configure do |config|
	# For the time being, maybe in the long term, it only support ActiveRecord...

	# Uncomment the item to override the default

	# if this is set to true, bizrule should return true restrictly
	# else bizrule will pass if they don't return false
	# NB in ruby 0 != false and 1 != true
	# config.strict_check_mode = true

	# check these roles first
	# config.default_roles = []

	# models and database tables
	config.user_class = "Account"

	# config.auth_item = "auth_item"
	# config.auth_item_class = "AuthItem"
	# config.auth_item_table = "auth_items"

	# config.auth_item_child = "auth_item_child"
	# config.auth_item_child_table = "auth_item_children"

	# config.auth_assignment = "auth_assignment"
	# config.auth_assignment = "AuthAssignment"
	# config.auth_assignment_table = "auth_assignments"
end