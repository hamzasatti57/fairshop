# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Hamza


arr = ["Furniture", "Interior Designer", "Architects", "Upholstery & Repair",
       "Paints", "Tiles", "Sanitary", "Appliances", "Product Designer" ]
for i in arr do
  Category.create(title: i)
end

Country.create(title: 'Pakistan')
City.create(title: 'Lahore', country_id: 1)
User.create(email:'superadmin@furnishia.com', password: 'superadmin', role: 0, first_name: 'Super',
            last_name: 'Admin', username: 'superadmin', contact_details: 'Admin', category_id: 1, city_id: 1)










# @vender = Vender.create(name: 'Tahir',email: 'vender@example.com')
# @store1 = Store.create(store_name: 'Tahir home Furniture',store_address: 'H block DHA LHR',store_city: 'lahore',store_country: 'pakistan',store_state: 'islambad',store_area: 'DHA',stroe_active: true,vender_id: @vender.id)
# # @store1.pictures.create(Pathname.new(Rails.root.join("assets/images/mcdonalds_logo.png")).open
#
# @store2 = Store.create(store_name: 'Tahir offic Furniture',store_address: 'EE block DHA LHR',store_city: 'lahore',store_country: 'pakistan',store_state: 'islambad',store_area: 'DHA',stroe_active: true,vender_id: @vender.id)
#
#
#
# Product.create(product_name: 'Sofa',product_category: 'wooden',product_brand:'uniform',product_model: '1235',product_warranty: '1 month',product_color: 'brown',product_isview: true,product_sale_status: true, product_purchase_price: 30000, product_sale_price: 50000, product_material: 'wood',product_quantity: 50,store_id: @store1.id)
# Product.create(product_name: 'chair',product_category: 'wooden',product_brand:'uniform',product_model: '235',product_warranty: '1 month',product_color: 'brown',product_isview: true,product_sale_status: true, product_purchase_price: 40000, product_sale_price: 60000, product_material: 'wood',product_quantity: 50,store_id: @store1.id)
# Product.create(product_name: 'bed',product_category: 'wooden',product_brand:'uniform',product_model: '235',product_warranty: '1 month',product_color: 'brown',product_isview: true,product_sale_status: true, product_purchase_price: 50000, product_sale_price: 70000, product_material: 'wood',product_quantity: 50,store_id: @store1.id)
# Product.create(product_name: 'table',product_category: 'wooden',product_brand:'uniform',product_model: '23454',product_warranty: '2 month',product_color: 'white',product_isview: true,product_sale_status: true, product_purchase_price: 30000, product_sale_price: 50000, product_material: 'wood',product_quantity: 50,store_id: @store1.id)
# Product.create(product_name: 'clasic sofa',product_category: 'steel',product_brand:'uniform',product_model: '456',product_warranty: '2 month',product_color: 'white',product_isview: true,product_sale_status: true, product_purchase_price: 40000, product_sale_price: 60000, product_material: 'wood',product_quantity: 50,store_id: @store1.id)
# Product.create(product_name: 'gallant sofa',product_category: 'steel',product_brand:'uniform',product_model: '565',product_warranty: '2 month',product_color: 'balck',product_isview: true,product_sale_status: true, product_purchase_price: 50000, product_sale_price: 70000, product_material: 'wood',product_quantity: 50,store_id: @store1.id)
# Product.create(product_name: 'paragon sofa',product_category: 'steel',product_brand:'uniform',product_model: '467',product_warranty: '3 month',product_color: 'balck',product_isview: true,product_sale_status: true, product_purchase_price: 30000, product_sale_price: 50000, product_material: 'wood',product_quantity: 50,store_id: @store1.id)
# Product.create(product_name: 'home chair',product_category: 'steel',product_brand:'uniform',product_model: '754',product_warranty: '3 month',product_color: 'balck',product_isview: true,product_sale_status: true, product_purchase_price: 40000, product_sale_price: 60000, product_material: 'wood',product_quantity: 50,store_id: @store1.id)
# Product.create(product_name: 'offic chair',product_category: 'plastic',product_brand:'uniform',product_model: '45',product_warranty: '3 month',product_color: 'gray',product_isview: true,product_sale_status: true, product_purchase_price: 50000, product_sale_price: 70000, product_material: 'wood',product_quantity: 50,store_id: @store1.id)
# Product.create(product_name: 'duplex chair',product_category: 'plastic',product_brand:'uniform',product_model: '444',product_warranty: '3 month',product_color: 'gray',product_isview: true,product_sale_status: true, product_purchase_price: 30000, product_sale_price: 50000, product_material: 'wood',product_quantity: 50,store_id: @store1.id)
#
# Product.create(product_name: 'Sofa',product_category: 'wooden',product_brand:'uniform',product_model: '1235',product_warranty: '1 month',product_color: 'brown',product_isview: true,product_sale_status: true, product_purchase_price: 30000, product_sale_price: 50000, product_material: 'wood',product_quantity: 50,store_id: @store2.id)
# Product.create(product_name: 'chair',product_category: 'wooden',product_brand:'uniform',product_model: '235',product_warranty: '1 month',product_color: 'brown',product_isview: true,product_sale_status: true, product_purchase_price: 40000, product_sale_price: 60000, product_material: 'wood',product_quantity: 50,store_id: @store2.id)
# Product.create(product_name: 'bed',product_category: 'wooden',product_brand:'uniform',product_model: '235',product_warranty: '1 month',product_color: 'brown',product_isview: true,product_sale_status: true, product_purchase_price: 50000, product_sale_price: 70000, product_material: 'wood',product_quantity: 50,store_id: @store2.id)
# Product.create(product_name: 'table',product_category: 'wooden',product_brand:'uniform',product_model: '23454',product_warranty: '2 month',product_color: 'white',product_isview: true,product_sale_status: true, product_purchase_price: 30000, product_sale_price: 50000, product_material: 'wood',product_quantity: 50,store_id: @store2.id)
# Product.create(product_name: 'clasic sofa',product_category: 'steel',product_brand:'uniform',product_model: '456',product_warranty: '2 month',product_color: 'white',product_isview: true,product_sale_status: true, product_purchase_price: 40000, product_sale_price: 60000, product_material: 'wood',product_quantity: 50,store_id: @store2.id)
# Product.create(product_name: 'gallant sofa',product_category: 'steel',product_brand:'uniform',product_model: '565',product_warranty: '2 month',product_color: 'balck',product_isview: true,product_sale_status: true, product_purchase_price: 50000, product_sale_price: 70000, product_material: 'wood',product_quantity: 50,store_id: @store2.id)
# Product.create(product_name: 'paragon sofa',product_category: 'steel',product_brand:'uniform',product_model: '467',product_warranty: '3 month',product_color: 'balck',product_isview: true,product_sale_status: true, product_purchase_price: 30000, product_sale_price: 50000, product_material: 'wood',product_quantity: 50,store_id: @store2.id)
# Product.create(product_name: 'home chair',product_category: 'steel',product_brand:'uniform',product_model: '754',product_warranty: '3 month',product_color: 'balck',product_isview: true,product_sale_status: true, product_purchase_price: 40000, product_sale_price: 60000, product_material: 'wood',product_quantity: 50,store_id: @store2.id)
# Product.create(product_name: 'offic chair',product_category: 'plastic',product_brand:'uniform',product_model: '45',product_warranty: '3 month',product_color: 'gray',product_isview: true,product_sale_status: true, product_purchase_price: 50000, product_sale_price: 70000, product_material: 'wood',product_quantity: 50,store_id: @store2.id)
# Product.create(product_name: 'duplex chair',product_category: 'plastic',product_brand:'uniform',product_model: '444',product_warranty: '3 month',product_color: 'gray',product_isview: true,product_sale_status: true, product_purchase_price: 30000, product_sale_price: 50000, product_material: 'wood',product_quantity: 50,store_id: @store2.id)
