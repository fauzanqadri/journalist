#require 'rails/generators/active_record'

#module ActiveRecord
  #module Generators
    #class JournalistGenerator < ActiveRecord::Generators::Base
      #argument :attributes, type: :array, default: [], banner: "field:type field:type"

      #include Journalist::Generators::OrmHelpers
      #source_root File.expand_path("../templates", __FILE__)

      #def copy_journalist_migrations
        #if (behavior == :invoke && model_exist?) || (behavior == :revoke && migration_exist?(table_name))
          #migration_template "migration_existing.rb", "db/migrate/add_journalist_to_#{table_name}.rb"
        #else
          #migration_template "migration.rb", "db/migrate/journalist_create#{table_name}.rb"
        #end
      #end


    #end
  #end
#end
