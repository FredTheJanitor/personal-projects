require "open-uri"
require "zlib"

headers = {
  "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
  "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
  "Accept-Language" => "en-US,en;q=0.9",
  "Referer" => "https://www.surecritic.com/",
  "Connection" => "keep-alive"
}
site_name = "surecritic"
base_domain = "https://www.#{site_name}.com"
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


def download_file(sitemap_url, headers)
  if sitemap_url
    puts "2: Downloading Sitemap..."

    File.open("sitemap.xml.gz", "wb") do |file|
      file.write(URI.open(sitemap_url, headers).read)
    end

    puts "\tDownload complete! Saved as 'sitemap.xml.gz"
  end
end

def unzip_the_file
  puts "3: Unzipping the sitemap..."
  Zlib::GzipReader.open("sitemap.xml.gz") do |gz|
    sitemap_xml = gz.read
    puts "\tSuccess! Here is a sneak peek of the data:"
    puts "------------------------------------------"
    puts sitemap_xml[0..100] 
    puts "------------------------------------------"
    return sitemap_xml
  end
end

# sitemap_url = get_sitemap(robots_url, headers)
# download_file(sitemap_url, headers)
sitemap_string = unzip_the_file
puts sitemap_string