require "open-uri"
require "zlib"

headers = {
  "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36",
  "Referer" => "https://www.google.com/search?q=surecritic",
  "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
  "Accept-Language" => "en-US,en;q=0.9"
}

base_domain = "https://www.surecritic.com"
robots_url = "#{base_domain}/robots.txt"
sitemap_url = nil

def get_sitemap(robots_url, headers)
  puts "1: Fetching robots.txt from #{robots_url}"
  begin
    robots_content = URI.open(robots_url, headers).read
    if match = robots_content.match(/^Sitemap:\s*(.+)$/i)
      sitemap_url = match[1].strip
      puts "\tFound sitemap URL: #{sitemap_url}"
    end
  rescue => e
    puts "\tError: #{e.message}"
  else
    if sitemap_url
      puts "Sitemap Located!"
    else
      puts "No Sitemap located on the robots.txt page :("
    end
  end
  return sitemap_url
end
# I should automate the look up and download of the sitemap
# so that way this program doesnt require a manual download
# of the file to run, and so it can run smaller subsequent
# scans after the first major one.
# 
# Define a variable for the sitmap URL

sitemap_filename = "sitemap.xml"
puts "Downloading sitemap..."
begin
  URI.open(sitemap_url, headers) do |compressed_file|
    gz = Zlib::GzipReader.new(compressed_file)
    File.open(sitemap_filename, "w") { |f| f.write(gz.read) }
    gz.close
  end
  puts "\tSuccessfully downloaded and decompressed to #{sitemap_filename}"
  rescue => e
    puts "\tError: #{e.message}"
end
# Navigate to the sitemap with the url

