# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

WORK_FILE = Rails.root.join('db', 'works-seeds.csv')
puts "Loading raw works data from #{WORK_FILE}"

work_failures = []
CSV.foreach(WORK_FILE, :headers => true) do |row|
  work = Work.new
  work.title = row['title']
  work.category = row['category']
  work.creator = row['creator']
  work.description = row['description']
  work.publication_year = row['publication_year']
  successful = work.save
  if !successful
    work_failures << work
    puts "failed to save work: #{work.inspect}"
  else
    puts "created work: #{work.inspect}"
  end
end

puts "Added #{Work.count} work records"
puts "#{work_failures.length} works failed to save"