Minimalistic URL shortener service

# Setup

MySQL database server required

    bundle
    ruby bin/setup_database.rb

# Run

    rackup -p 3000

Test it

    ab -n 2000 -c 20 -d -S -p test_payload.json http://127.0.0.1:3000/