# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Doctor.create([
                { name: "Dr. Hynes",
                  address: "fghjkl;;",
                  image_url: "image1.png",
                  fees: 0.56789e5,
                  busy_slots: ['07:30 1'],
                  start_time: '06:30',
                  end_time: '10:30'
                },
                {
                  name: "Dr. Yamma",
                  address: "dfhjkl;",
                  image_url: "image1.png",
                  fees: 0.23e2
                },
                {
                  name: "Dr. Octopus",
                  address: "fghjtyiuovbnm.,",
                  image_url: "image1.png",
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
                email: 'abc@email.com',
                role: 'admin'
              },
            ])