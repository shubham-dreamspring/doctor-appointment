# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Doctor.create([
                { name: "Dr. Hynes",
                  address: "Stanford University",
                  image_url: "doctor1_image.png",
                  city: 'New York',
                  fees: 0.56789e5,
                },
                {
                  name: "Dr. Yamma",
                  address: "Celebrium",
                  image_url: "doctor2_image.png",
                  city: 'Human Brain',
                  fees: 0.23e2
                },
                {
                  name: "Dr. Octopus",
                  address: "Water Colony",
                  image_url: "doctor3_image.png",
                  city: 'Red Sea',
                  fees: 0.345e3,
                },
                {
                  name: "Dr. Yatharth",
                  address: "Ghumnam Sahar",
                  image_url: "doctor4_image.png",
                  fees: 0.345e3,
                  city: 'Malabar Island',
                  available: false
                }
              ]
)

User.create([
              {
                name: 'Shubham',
                email: 'abc@email.com'
              },
              {
                name: 'Shubham Jain',
                email: 'abc2@email.com',
                role: 'admin'
              },
            ])