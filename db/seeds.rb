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
                  fees: 0.56789e5,
                  busy_slots: ['07:30 1'],
                  start_time: '06:30',
                  end_time: '10:30'
                },
                {
                  name: "Dr. Yamma",
                  address: "Celebrium, Human Brain",
                  image_url: "doctor2_image.png",
                  fees: 0.23e2
                },
                {
                  name: "Dr. Octopus",
                  address: "Water Colony, Red Sea",
                  image_url: "doctor3_image.png",
                  fees: 0.345e3,
                },
                {
                  name: "Dr. Yatharth",
                  address: "Ghumnam Sahar, Malabar Island",
                  image_url: "doctor4_image.png",
                  fees: 0.345e3,
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