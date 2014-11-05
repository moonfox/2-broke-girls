class FormatSubtitle
  PREFIX = "broke_girls"
  ORIGINAL_PATH = File.expand_path("../../tmp/original/#{PREFIX}/#{PREFIX}_" ,__FILE__)
  SUBTITLE_PATH = File.expand_path("../../tmp/subtitle/#{PREFIX}/#{PREFIX}_" ,__FILE__)

  class << self
    def txt_format

    end

    def generate_subtitle
      # item = ARGV[0]
      item = ARGV[0] || "s01e11.txt"
      ext_enc = ARGV[1] || "utf-8"
      body_start = false
      old_file = "#{ORIGINAL_PATH}#{item}"
      new_file = "#{SUBTITLE_PATH}#{item}"

      f_subtitle = File.new(new_file,"w")
      File.open(old_file, "r:#{ext_enc}:utf-8") do |f|
        f.each_line do |line|
          unless body_start
            body_start = body_start?(line)
            f_subtitle.puts line if body_start
            next
          end
          
          f_subtitle.puts format_line(line) if line_void?(line)     
        end
      end
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
  end  
end

FormatSubtitle.generate_subtitle
