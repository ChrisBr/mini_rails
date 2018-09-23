require 'sqlite3'
require 'rulers/core_extensions/string'

DB = SQLite3::Database.new "db/test.db"

module Rulers
  module Model
    class SQLite
      def initialize(data)
        @data = data
      end

      def self.all
        sql = "SELECT * FROM #{table}"
        rows = DB.execute(sql)
        result = []
        rows.each do |row|
          result << new(Hash[schema.keys.zip(row)])
        end
        result
      end

      def self.create(data)
        data.delete('id')
        keys = data.keys.join(',')
        values = data.values.map { |v| to_sql(v) }.join(',')
        sql = "INSERT INTO #{table} (#{keys}) VALUES (#{values});"
        DB.execute(sql)
        id = DB.execute("SELECT last_insert_rowid();")[0][0]
        data['id'] = id
        new(data)
      end

      def self.find(id)
        result = DB.execute("SELECT * from #{table} WHERE id = #{id}")[0]
        return nil unless result

        new(Hash[schema.keys.zip(result)])
      end

      def self.count
        DB.execute(<<-SQL
          SELECT COUNT(*) FROM #{table}
        SQL
        )[0][0]
      end

      def save!
        unless @data['id']
          result = self.class.create(@data)
          self.data = result.data
          return true
        end

        fields = @data.compact.map do |k, v|
          next unless v
          "#{k}=#{self.class.to_sql(v)}"
        end.join ","

        DB.execute <<-SQL
          UPDATE #{self.class.table}
          SET #{fields}
          WHERE id = #{@data["id"]}
        SQL

        true
      end

      def save
        save! rescue false
      end

      def respond_to?(m, *args, &block)
        method_name = m.to_s.chomp("=")
        return true if @data.key?(method_name)
        super
      end 

      def method_missing(m, *args, &block)
        method_name = m.to_s.chomp("=")
        super unless @data.key?(method_name)

        self.class.send(:define_method, method_name) {
          @data[method_name]
        }

        self.class.send(:define_method, "#{method_name}=") do |argument|
          @data[method_name] = argument
        end

        args.empty? ? send(m) : send(m, args.first)
      end

      protected

      attr_accessor :data

      private

      def self.to_sql(val)
        case val
        when Numeric
          val.to_s
        when String
          "'#{val}'"
        else
          raise "Can't convert #{val} to SQL."
        end
      end

      def self.table
        name.underscore
      end

      def self.schema
        return @schema if @schema
        @schema = {}

        DB.table_info(table) do |row|
          @schema[row['name']] = row['type']
        end

        @schema
      end
    end
  end
end
