class DownloadSublitle
  class << self
    def download_rar
      path = File.expand_path("html.txt", __FILE__)
      urls = File.readlines(path)

      # urls.each_with_index do |uri, index|
      #   %x[ wget -O #{index}.rar #{uri}] 
      # end
      %x[mv *.rar #{File.expand_path("../download", __FILE__)}]
    end

    def parse_html
      path = File.expand_path("html.txt", __FILE__)
      if File.exist?(path)
        return "File already exist"
      end
      # url = 'http://www.yyets.com/search/index?keyword=%E6%89%93%E5%B7%A5%E5%A7%90%E5%A6%B9%E8%8A%B1+%E7%AC%AC%E4%B8%80%E5%AD%A3&type='
      # url = "http://www.yyets.com/search/index?keyword=%E6%89%93%E5%B7%A5%E5%A7%90%E5%A6%B9%E8%8A%B1+%E7%AC%AC%E4%BA%8C%E5%AD%A3&type="
      url = "http://www.yyets.com/search/index?keyword=%E6%89%93%E5%B7%A5%E5%A7%90%E5%A6%B9%E8%8A%B1+%E7%AC%AC%E4%B8%89%E5%AD%A3&type=subtitle" #3
      response = %x[ curl #{url} ].to_s
      p1 = response.scan(/http:\/\/www\.yyets\.com\/subtitle\/\d*/)
      p p1.uniq
      p p1.size
      new_file = File.open("html.txt","w")
      new_file.puts p1.uniq   
    end


    def session_url
      path = File.expand_path("../new_file/download_url.txt", __FILE__)
      urls = File.readlines(path)
      session_url = []
      urls.each do |line|
        response = %x[ curl #{line} ].to_s.scan(/www\.yyets\.com\/subtitle\/index\/download\?id\=\d+/)
        session_url << response.first
      end
      new_file = File.open(File.expand_path("../new_file/session_url.txt", __FILE__),"w")
      new_file.puts session_url
    end
  end  
end
DownloadSublitle.parse_html