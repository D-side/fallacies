#!/usr/bin/env ruby
# This is a helper script that converts Android values into Markdown

require "nokogiri"

if ARGV.length != 1
  STDERR.puts "Specify a file to process, like `./generator.rb strings.xml`"
  exit(1)
end

strings = Nokogiri::XML(File.read("strings.xml")).css("string").map do |str|
            [str[:name], str.children.to_s]
          end.to_h

strings.select { |(k, _)| k.start_with?("section_") }.keys.each do |section|
  puts "---\n\n## #{strings[section]}\n\n"

  number = section.match(/\d+$/).to_s
  section_titles = strings.select { |(k, _)| k.start_with?("fallacies_titles_#{number}_") }.keys

  section_titles.each do |section_title|
    number = section_title.match(/\d+_\d+$/).to_s

    puts "### #{strings["fallacies_titles_#{number}"]}\n\n"
    puts "#{strings["fallacies_descs_#{number}"]}\n\n"
    puts "> #{strings["fallacies_examples_#{number}"]}\n\n"
  end
end
