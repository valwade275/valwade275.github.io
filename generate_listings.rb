require 'json'
require 'fileutils'
require 'yaml'

def generate_listings(dir, base_path = '')
  listings = {
    folders: [],
    files: [],
    path: base_path
  }

  Dir.foreach(dir) do |item|
    next if item == '.' or item == '..'

    item_path = File.join(dir, item)
    relative_path = File.join(base_path, item)
    if File.directory?(item_path)
      folder = {
        name: item,
        path: relative_path,
        folders: [],  # Add an empty folders array
        files: []     # Add an empty files array
      }
      folder[:listings] = generate_listings(item_path, relative_path)  # Recursively generate listings for subfolders
      listings[:folders] << folder
    else
      listings[:files] << {
        name: item,
        path: relative_path
      }
    end
  end

  listings
end

# Load configuration
config = YAML.load_file('_config.yml')
directory_to_list = config['directory_to_list']

# Ensure the _data directory exists
data_dir = '_data'
FileUtils.mkdir_p(data_dir)

# Generate listings for the specified directory
output = generate_listings(directory_to_list)
File.open(File.join(data_dir, 'listings.json'), 'w') do |f|
  f.write(JSON.pretty_generate(output))
end
