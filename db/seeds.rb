# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)




if Doorkeeper::Application.count.zero?
	application = Doorkeeper::Application.create({
						name: "iOS client",
						scopes: "read write",
						confidential: false,
						redirect_uri: "urn:ietf:wg:oauth:2.0:oob"
					})
	
	# Doorkeeper::Application.create(name: "iOS client", redirect_uri: "", scopes: "")
	# Doorkeeper::Application.create(name: "Android client", redirect_uri: "", scopes: "")
	# Doorkeeper::Application.create(name: "React", redirect_uri: "", scopes: "")

	# get apps credientials
	# client_id of the application
	p Doorkeeper::Application.find_by(name: "iOS client").uid

	# client_secret of the application
	p Doorkeeper::Application.find_by(name: "iOS client").secret

end


# User.create({
# 	email: "jai@tecorb.co",
# 	password: "123456",
# 	fname: "Jai",
# 	lname: "Rajput",
# 	country_code: "+91",
# 	mobile_number: "7834821711",
# 	govt_id: "122123"
# })