require 'json'
require 'fileutils'
require 'yaml' # Add this line to include the YAML module

# Load Jekyll configuration to get the directory to list
config = YAML.load_file('_config.yml')
directory_to_list = config['directory_to_list']

# Use an environment variable or default to the directory from the config
directory_to_list = ENV['WIKI_DIR'] || directory_to_list

# Ensure the directory exists
unless Dir.exist?(directory_to_list)
  puts "Directory does not exist: #{directory_to_list}"
  exit 1
end

# Function to generate listings recursively
def generate_listings(dir, base_path = '')
  listings = {
    folders: [],
    files: [],
    path: base_path
  }

  Dir.foreach(dir) do |item|
    next if item == '.' || item == '..'

    item_path = File.join(dir, item)
    relative_path = File.join(base_path, item)

    if File.directory?(item_path)
      # Recursively generate listings for subfolders
      sub_listings = generate_listings(item_path, relative_path)
      listings[:folders] << {
        name: item,
        path: relative_path,
        listings: sub_listings
      }
    else
      listings[:files] << {
        name: item,
        path: relative_path
      }
    end
  end

  listings
end

# Ensure the _data directory exists
data_dir = '_data'
FileUtils.mkdir_p(data_dir)

# Generate listings for the specified directory
output = generate_listings(directory_to_list)

# Write output to listings.json using Liquid
File.open(File.join(data_dir, 'listings.json'), 'w') do |f|
  f.write(JSON.pretty_generate(output))
end