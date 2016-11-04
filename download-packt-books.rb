require 'logger'
require 'mechanize'
require 'yaml'

# read the config
config = YAML.load(File.read(File.expand_path("config.yml")))

# read the tracking file
downloaded_books = YAML::load_file("books.yml")

# setup the agent
agent = Mechanize.new
agent.user_agent_alias = 'Linux Firefox'
agent.ignore_bad_chunking = true
agent.follow_meta_refresh = true

# login
page = agent.get("https://www.packtpub.com/")
login_page = page.form_with(:dom_id => "packt-user-login-form") do |form|
  form.email         = config["email"]
  form.password      = config["password"]
  form.form_build_id = "form-8a2d79f004148340e7e18826418beec1"
  form.form_id       = "packt_user_login_form"
end.submit

# go to the account page
account_page = agent.click(login_page.link_with(:text => /My Account/))

# go the my books page
my_books_page = agent.click(account_page.link_with(:text => /My eBooks/))

book_map = Hash.new
download_links = ['ebook_download','code_download']
download_base = config["downloadpath"]

book_titles = my_books_page.search(".//div[@class='title']")
book_titles.each do |b|
  title = b.children.text.lstrip.rstrip
  book_block = my_books_page.search(".//div[contains(@title, \"#{title}\") and @class='product-line unseen']")
  # map book downloads to title
  book_block.each do |bk|
   book_map[bk.attributes['nid'].value] = title.sub(" [eBook]", "")
  end
  # map code downloads to title (nid differs)
  download_block = book_block.search(".//div[@class='product-buttons-line toggle']")
  download_nids = download_block.search(".//div[@nid]")
  download_nids.each do |d|
    book_map[d.attributes['nid'].value] = title.sub(" [eBook]", "")
  end
end

# build the download links
download_links = ['ebook_download','code_download']
my_books_page.links.each do |link|
  if download_links.any? {|s| link.href.to_s.include? s}
    full_link = "https://www.packtpub.com#{link.href}"
    if link.href.to_s.include? "code"
      file_name = book_map[link.href.split("/").last] + "_code.zip"
    else
      file_name = book_map[link.href.split("/")[2]] + "." + link.href.split("/").last
    end
    file_name = file_name.gsub(" ","_")
    file_name = file_name.gsub("/","-")
    begin
      unless downloaded_books["list"].include?("#{file_name}")
        puts "[DOWNLOADING] #{file_name}"
        agent.download(full_link, download_base + file_name)
        downloaded_books["list"] << "#{file_name}" unless downloaded_books["list"].include?("#{file_name}")
      end
      File.open("books.yml", 'w') {|f| f.write downloaded_books.to_yaml }
    rescue Mechanize::ResponseReadError => e
      e.force_parse
      puts "  => " + file_name + " retrying"
      agent.download(full_link, download_base + file_name)
    rescue Mechanize::ResponseCodeError => e
      puts "  => " + file_name + " failed => #{e}; #{e.message}"
    end

  end
end
