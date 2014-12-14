require File.expand_path("subtitle_tool", File.dirname(__FILE__))
module SubtitleExtract
  class Subtitle
    attr_reader :original_path, :subtitle_path, :prefix
    include SubtileTool
    
    def initialize
      @prefix = ARGV[0]
      @original_path = File.expand_path("../../tmp/original/#{prefix}" ,__FILE__)
      @subtitle_path = File.expand_path("../../tmp/subtitle/#{prefix}" ,__FILE__)
    end

    def generate
      new_file = "#{original_path}/*.txt"
      old_file = "#{subtitle_path}/*.txt"

      new_set(new_file, old_file).each do |file_name|
        create_file file_name
      end
    end

    def create_file(file_name)
      body_start = false
      ext_enc = not_utf8?("#{original_path}/#{file_name}") ? "gb2312" : "utf-8"

      f_subtitle = File.open("#{subtitle_path}/#{file_name}", "w") 
      File.open("#{original_path}/#{file_name}", "r:#{ext_enc}:utf-8") do |f|
        f.each_line do |line|
          unless body_start
            body_start = body_start?(line)
            f_subtitle.puts line if body_start
            next
          end       
          f_subtitle.puts format_line(line) if line_void?(line)     
        end
      end 
      f_subtitle.close
      puts "geterate: #{f_subtitle.path}"
      send_mail(prefix, "", f_subtitle.path)
      puts "mail: #{f_subtitle.path}"
    end

    def line_void?(line)
      !line.include?(' --> ')
    end

    def format_line(line)
      line.gsub(/\{.+\}/,'')
    end

    def body_start?(line)
      line.strip =~ /^#{ARGV[1]}$/   
    end
  end     
end

SubtitleExtract::Subtitle.new.generate
