require 'yaml'
require 'mail'
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

      def send_mail(subject, body, attachemnt = nil)
        mail_config = YAML.load_file(File.expand_path("mail_config.yml", File.dirname(__FILE__)))
        smtp = mail_config["smtp"]
        mail_head = mail_config["mail"]
        Mail.defaults do
          delivery_method :smtp, {
          :address              => smtp["address"],
          :port                 => smtp["port"],
          # :domain               =smtp
          :user_name            => smtp["user_name"],
          :password             => smtp["password"],
          :authentication       => smtp["authentication"],
          :enable_starttls_auto => smtp["enable_starttls_auto"] 
          }
        end

        mail = Mail.new do
          from    mail_head["from"]
          to      mail_head["to"]
          subject subject
          body    body
          add_file :filename => File.basename(attachemnt), :content => File.read(attachemnt)
        end

        mail.deliver
      end  
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end