module Journalist
  module Generators

    class InstallGenerator < Rails::Generator::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "This generator install journalist configurations and ActiveRecord Model for rails"
      argument :journal_account_klass, type: :string, default: "JournalAccount", banner: "Name of your journal account active record model"
      argument :journal_account_belongs_to, type: :string, default: "journal", banner: "Name of belong to association your journal account active_record model"

      def generate_conf_file
        erb = File.read("#{Journalist.root}/lib/generators/journalist/install/templates/journalist.rb.erb")
        res = ERB.new(erb).result(binding)
        File.open("config/journalist.rb", 'w+') {|f| f.write(res)}
      end
    end
  end
end
