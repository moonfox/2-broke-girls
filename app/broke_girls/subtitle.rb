module SubtitleExtract
  module BrokeGirls
    class Subtitle
      PREFIX = "broke_girls"
      ORIGINAL_PATH = File.expand_path("../../../tmp/original/#{PREFIX}" ,__FILE__)
      SUBTITLE_PATH = File.expand_path("../../../tmp/subtitle/#{PREFIX}" ,__FILE__)

      def generate
        new_file = "#{ORIGINAL_PATH}/*.txt"
        old_file = "#{SUBTITLE_PATH}/*.txt"

        new_set(new_file, old_file).each do |file_name|
          create_file file_name    
        end
      end

      def create_file(file_name)
        body_start = false
        ext_enc = not_utf8?("#{ORIGINAL_PATH}/#{file_name}") ? "gb2312" : "utf-8"

        f_subtitle = File.open("#{SUBTITLE_PATH}/#{file_name}", "w") 
        File.open("#{ORIGINAL_PATH}/#{file_name}", "r:#{ext_enc}:utf-8") do |f|
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
      end

      def new_set(new_file, old_file)       
        Dir.glob(new_file).map{|f|File.basename(f)} - Dir.glob(old_file).map{|f|File.basename(f)} 
      end

      def line_void?(line)
        !line.include?(' --> ')
      end

      def format_line(line)
        line.gsub(/\{.+\}/,'')
      end

      def body_start?(line)
        line.strip =~ /^19$/   
      end

      def not_utf8?(file)
        f = File.open(file, "r")
        f.gets
        f.gets
        byte = f.getbyte.to_s(2)
        f.close
        byte !~ /^0|^110|^1110|^11110|^111110|^1111110/
      end
    end 
  end    
end

SubtitleExtract::BrokeGirls::Subtitle.new.generate
