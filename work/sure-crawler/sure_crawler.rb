require "open-uri"

headers = {
  "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0",
  "Referer" => "https://www.google.com/search?q=surecritic",
  "Accept-Language" => "en-US,en;q=0.9"
}

remote_base_url = "https://www.surecritic.com/reviews/"

# I should automate the look up and download of the sitemap
# so that way this program doesnt require a manual download
# of the file to run, and so it can run smaller subsequent
# scans after the first major one.

