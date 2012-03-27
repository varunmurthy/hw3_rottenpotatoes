# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  #assert false, "Unimplmemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  # puts e1,e2
  # puts page.body
  page.body.scan(Regexp.new("#{e1}.*#{e2}", Regexp::MULTILINE)).size > 0
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(', ')
  ratings.each do |rating|
    step %Q{I #{uncheck}check "ratings[#{rating}]"}
  end   
end

Then /^I should see all of the movies$/ do
  rows = page.all('table#movies tbody tr').size
  assert rows == Movie.count, 'Check Count'
end

Then /^I should see movies sorted by "(.*)"$/ do |sortable|
  movie_list = Movie.order(sortable)
  movie_list[0..movie_list.length-2].zip(movie_list[1..movie_list.length-1]).each do |x, y|
    step %Q{I should see "#{x[:title]}" before "#{y[:title]}"}
  end
end
  
