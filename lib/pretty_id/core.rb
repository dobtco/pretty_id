module PrettyId
  module Core
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_pretty_id(options = {})
        default_options = {
          column: :pretty_id,
          length: 8
        }

        options = default_options.merge(options)

        define_method(:"generate_#{options[:column]}") do
          new_pretty_id = loop do
            random_pretty_id = rand(36**options[:length]).to_s(36)
            exists_hash = {}
            exists_hash[options[:column]] = random_pretty_id
            break random_pretty_id unless self.class.exists?(exists_hash)
          end

          self.send "#{options[:column]}=", new_pretty_id
        end

        before_create :"generate_#{options[:column]}"
      end
    end
  end
end
