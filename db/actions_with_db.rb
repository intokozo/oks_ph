require 'sequel'

DB = Sequel.connect('sqlite://db/database.sqlite')

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
    Integer :category_id
    Integer :priority, default: 0
    String :link
  end
end

def photos_by_category_id(id)
  DB['select * from photos where category_id = ?', id]
end

def set_priority(table:, priority:, id:)
  return if [table, priority, id].any?(&:nil?)

  DB["update #{table} set priority = #{priority} where #{table}.id = #{id}"]
end
