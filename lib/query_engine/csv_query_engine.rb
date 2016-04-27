require "csv"
require "query_engine/default_query_engine"

class CsvQueryEngine < DefaultQueryEngine
  def connect;  end

  def close;  end

  # should return an enumerator
  def execute(query, _)
    col_sep = case query["col_sep"]
    when "tab"
      "\t"
    when nil
      ","
    else
      query["col_sep"]
    end

    cursor = if query["headers"].is_a?(TrueClass)
      CSV.read(query["path"], col_sep: col_sep, headers: true).map(&:to_hash)
    elsif query["headers"].is_a?(Array)
      CSV.read(query["path"], col_sep: col_sep).map { |row| Hash[query["headers"].zip(row)] }
    else
      raise "wrong headers"
    end

    if query["types"].is_a?(Hash)
      cursor.map! do  |row|
        query["types"].each do |key, type|
          row[key] = convert_type(row[key], type)
        end
        row
      end
    end

    if query["rename"]
      query["rename"].each do |key, value|
        cursor.each do |row|
          row[value] = row.delete(key)
        end
      end
    end
    cursor
  end

  def decorate(query, filters = {}, query_params = {})
    @filters = filters
    JSON.parse(query)
  end

  private

  def apply_filters(query, filters = {})
  end

  def convert_type(value, type)
    return nil if value.nil? || value == ""
    case type.downcase
    when "int", "integer"
      return value.to_i
    when "double", "float"
      return value.to_f
    when "bool", "boolean"
      return true if value =~ /(true|t|1)$/i
      return false if value =~ /(false|f|0)$/i
      raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
    else
      return value
    end
  end
end
