require 'sequel'

DB = Sequel.connect(ENV['DATABASE_URL'])

unless DB.tables.include?(:categories)
  DB.create_table :categories do
    primary_key :id
    String :name, null: false
    Integer :priority, default: 0
  end
end

unless DB.tables.include?(:photos)
  DB.create_table :photos do
    primary_key :id
    Integer :category_id, null: false
    Integer :priority, default: 0
    String :file
  end
end

unless DB.tables.include?(:settings)
  DB.create_table :settings do
    primary_key :id
    String :title, null: false
    String :description_title, null: false
    String :description, null: false
    String :telegram_link
    String :instagram_link
    String :vk_link
  end
end

Dir["./model/*.rb"].each {|file| require file }
