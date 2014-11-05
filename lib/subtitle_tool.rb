module SubtitleExtract
  module SubtileTool
    module ClassMethods
      
    end
    
    module InstanceMethods
      def not_utf8?(file)
        f = File.open(file, "r")
        f.gets
        f.gets
        byte = f.getbyte.to_s(2)
        f.close
        byte !~ /^0|^110|^1110|^11110|^111110|^1111110/
      end

      def new_set(new_file, old_file)       
        Dir.glob(new_file).map{|f|File.basename(f)} - Dir.glob(old_file).map{|f|File.basename(f)} 
      end   
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end