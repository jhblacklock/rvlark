# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.first_or_create(first_name: 'Jackson', last_name: 'Blacklock',
                            email: 'jhblacklock@gmail.com', password: 'l10nh@wk')

user.reload

vehicle = user.vehicles.first_or_create(listing_name: 'New Listing', summary: 'New Listing',
                                        vehicle_type: '1', accommodates: 1)

amenities = Amenity.first_or_create([{ name: 'Electric Generator', amenity_type: 'Tech' },
                                     { name: 'Fire Extinguisher', amenity_type: 'Safety' },
                                     { name: 'Kitchen Sink', amenity_type: 'Kitchen' },
                                     { name: 'Roof Air Conditioning', amenity_type: 'Utilities' },
                                     { name: 'TV', amenity_type: 'Tech' },
                                     { name: 'Microwave', amenity_type: 'Kitchen' },
                                     { name: 'Slide Out', amenity_type: 'Extras' },
                                     { name: 'DVD Player', amenity_type: 'Tech' },
                                     { name: 'CD Player', amenity_type: 'Tech' },
                                     { name: 'Hot & Cold Water Supply', amenity_type: 'Utilities' },
                                     { name: 'Shower', amenity_type: 'Bathroom' },
                                     { name: 'Radio', amenity_type: 'Tech' },
                                     { name: 'Refrigerator', amenity_type: 'Kitchen' },
                                     { name: 'Seatbelts', amenity_type: 'Safety' },
                                     { name: 'Stove', amenity_type: 'Kitchen' },
                                     { name: 'Rear Vision Camera', amenity_type: 'Tech' },
                                     { name: 'Bathroom Sink', amenity_type: 'Bathroom' },
                                     { name: 'In Dash Air Conditioning', amenity_type: 'Utilities' },
                                     { name: 'iPod Docking Station', amenity_type: 'Tech' },
                                     { name: 'Navigation', amenity_type: 'Tech' },
                                     { name: 'Smoking Allowed', amenity_type: 'Extras' },
                                     { name: 'Automatic Transmission', amenity_type: 'Features' },
                                     { name: 'Cruise Control', amenity_type: 'Features' },
                                     { name: 'Power Steering', amenity_type: 'Features' },
                                     { name: 'Fresh Water Tank', amenity_type: 'Features', extended_int: true },
                                     { name: 'Minimum Age', amenity_type: 'Features', extended_int: true },
                                     { name: 'Fuel Capacity', amenity_type: 'Features', extended_int: true },
                                     { name: 'MPG', amenity_type: 'Features', extended_int: true },
                                     { name: 'Pet Friendly', amenity_type: 'Extras' }])

vehicle.amenities << amenities
