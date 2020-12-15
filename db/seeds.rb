# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

# before running "rake db: seed", do the following:
# - put the "rails-engine-development-pgdump" file in the db/data/
# - put the "items.csv" file in db/data

cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d rails-engine_development db/data/rails-engine-development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

# TO DO
# - Import the CSV data into the Items tables

filename = "db/data/items.csv"

csv = CSV.foreach(Rails.root.join(filename), :headers => true) do |row|
  row["unit_price"] = (row["unit_price"].to_f)/100.round(2)
  Item.create(row.to_hash)
end

# - Add code to reset primary key sequences on all 6 tables (merchants, items, customers, invoices, invoice_items, transactions)
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end
