module PrettyId
  module Core
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_pretty_id(options = {})
        default_options = {
          column: :pretty_id,
          method: :pretty,
          uniq: true
        }

        options = default_options.merge(options)

        case options[:method]
        when :pretty
          options[:length] ||= 8
          options[:generate_proc] = -> {
            chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
            Array.new(options[:length]) { chars[rand(chars.length)] }.join
          }
        when :urlsafe_base64
          options[:length] ||= 21
          options[:generate_proc] = -> {
            SecureRandom.urlsafe_base64(options[:length] / 1.333)
          }
        else
          fail 'Unknown :method passed to has_pretty_id'
        end

        define_method(:"generate_#{options[:column]}") do
          new_pretty_id = loop do
            random_pretty_id = options[:generate_proc].call
            break random_pretty_id if !options[:uniq]
            exists_hash = {}
            exists_hash[options[:column]] = random_pretty_id
            break random_pretty_id unless self.class.exists?(exists_hash)
          end

          self.send "#{options[:column]}=", new_pretty_id
        end

        define_method(:"regenerate_#{options[:column]}") do
          self.send("generate_#{options[:column]}")
        end

        define_method(:"regenerate_#{options[:column]}!") do
          self.send("generate_#{options[:column]}")
          self.save
        end

        before_create :"generate_#{options[:column]}"
      end
    end
  end
end
