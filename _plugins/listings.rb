module Jekyll
    class DirectoryListingGenerator < Generator
      safe true
      priority :high
  
      def generate(site)
        listings_path = File.join(site.source, '_data', 'listings.json')
        listings_data = JSON.parse(File.read(listings_path))
        site.data['listings'] = listings_data
      end
    end
  end
  