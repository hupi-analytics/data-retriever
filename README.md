# hupi data retriever #

## Usage
this project use swagger Documentation
go to : [http://petstore.swagger.io/](http://petstore.swagger.io/)

paste : `http://api.dataretriever.hupi.io/swagger_doc`

### Header Params
* Content-Type: "application/json"
* Accept-Version: "v1"

### Endpoints

#### POST `http://api.dataretriever.hupi.io/(:module_name)/(:method_name)`
* <u>module_name:</u> (String)
* <u>method_name:</u> (String)
* <u>body:</u>
  ```json
  {
    "client": client_name,
    "render_type": render_type,
    "filters": {
      filter_name1: { "operator": operator, "value": value},
      filter_name2: value
    }
  }
  ```
  * <u>client:</u> (String) client name
  * <u>render_type:</u> (String) depends of the configuration of the hdr_endpoint
  * <u>filters:</u> (JSON) two acceptable way
```json
{
  "filter_name": {
    "operator": "<",
    "value": "42"
  },
  "filter_name": "42"
  }
}
```

#### POST `http://api.dataretriever.hupi.io/estimate/(:subject)`
* <u>subject:</u> (String)
* <u>body: </u>
  ```json
  {
    "client": client_name,
    subject: { subject_features }
  }
  ```
  * <u>client:</u> (String)
  * <u>(subject):</u> (JSON)

#### Admin
admin endpoints follows REST convention.
* index: GET `http://api.dataretriever.hupi.io/admin/(:model_name)`
* create: POST `http://api.dataretriever.hupi.io/admin/(:model_name)`
* read: GET `http://api.dataretriever.hupi.io/admin/(:model_name)/(:id)`
* update: PUT `http://api.dataretriever.hupi.io/admin/(:model_name)/(:id)`
* delete: DELETE `http://api.dataretriever.hupi.io/admin/(:model)/(:id)`

```
.
                                     +----------------+
                                     |hdr_query_engine|
                                     +----------------+
                                     |*name(String)   |
                                     |*desc(String)   |
                                     |*engine(String) |
                                     |*settings(JSON) |
                                     +----------------+
                                             ^
                                             |(1,n)
                                             |
                                             |
                                             |(1,1)
                                             |
+--------------------+ (1,n)   (1,1) +-------+--------+ (1,n)   (1,n) +--------------------+
|    hdr_endpoint    |-------------->|hdr_query_object|-------------->|   hdr_export_type  |
+--------------------+               +----------------+               +--------------------+
|*module_name(String)|               |*name(String)   |               |*name(String)       |
|*method_name(String)|               |*desc(String)   |               |*desc(String)       |
+--------------------+               |*query(JSON)    |               |*render_types(Array)|
                                     +-------+--------+               +--------------------+
                                             |
                                             |(1,n)
                                             |
                                             |
                                             |(1,1)
                                             V
                                +-------------------------+
                                |      hdr_filters        |
                                +-------------------------+
                                |*pattern(String)         |
                                |*value_type(String)      |
                                |*field (String)          |
                                |*default_operator(String)|
                                +-------------------------+


```
you can create or update hdr_endpoint with nested attributes using the [rails way](http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html). If you add "id" key this will update the corresponding object.
```json
{
  "hdr_endpoint": {
    "module_name": "my_module",
    "method_name": "my_name",
    "hdr_query_objects_attributes": {
      "1449582731413": {
        "hdr_query_engine_id": "1",
        "hdr_export_type_ids": ["3", "4", "5"],
        "query": "my query",
        "hdr_filters_attributes": {
          "1449582746742": {
            "id": "42",
            "pattern": "my_pattern",
            "value_type": "my_type",
            "field": "my_field",
            "default_operator": "my_operator",
            "name": "my_filter_name"
          },
          "1449582746792": {
            "pattern": "my_pattern",
            "value_type": "my_type",
            "field": "my_field",
            "default_operator": "my_operator",
            "name": "my_filter_name"
          }
        }
      }
    }
  }
}
```
## Query

in order to have a result formated for Highchart, query should rename field according to the desired render_type. Below we list the different renaming convention and the associated render type.

If you want to better understand what each field does take a look in `lib/export/`

#### Add filter
To add filter in your query simply insert a pattern `#_your_pattern_#` at the desired place in the query, and add the corresponding hdr_filter. the pattern will be replaced by the filter given when you call the hdr_endpoint or if there is no filter given it will be replaced by an empty string.

### SQL Query
write a valid sql query, you can use every function that your query_engine recognize.
#### Filter Pattern
filter recognize specific pattern:
* `#_and_[something_else]_#`: Add `AND` at the beginning and `AND` between each filter that match the pattern
* `#_where_[something_else]_#`: Add `WHERE` at the beginning and `AND` between each filter that match the pattern

### MongoDb Query
since MongoDB only provide api to query their database, we use a JSON query that we match with their api.
```json
{
  "collection": "colleciton_name",
  "query": [ operator ]
}
```

#### operator

* aggregate: `db.my_colleciton.aggregate(mongo_aggregate_query, mongo_options)`
  ```json
  {
    "operator": "aggregate",
    "pipeline": mongo_aggregate_query,
    "opts": mongo_options
  }
  ```
* find: `db.my_collection.find(mongo_find_query, mongo_options)`
  ```json
  {
    "operator": "find",
    "find": mongo_find_query,
    "opts": mongo_options
  }
  ```
* map_reduce: `db.my_collection.map_reduce(mongo_map, mongo_reduce, mongo_options)`
  ```json
  {
    "operator": "map_reduce",
    "map": mongo_map,
    "reduce": mongo_reduce,
    "opts": mongo_options
  }
  ```

#### Filter Pattern
* `#_match_[something_else]_#`: add a match `{ $match: { $and: [ filters_here ] } },`, join filters with `,`
* `#_find_[something_else]_#`: `$and: [ filters_here ]`, join filters with `,`
* `#_and_[something_else]_#`: start with `,` and join filters with `,`


## Render type
* Category Serie Value
  + <u>render type:</u> category_serie_value, column_stacked_normal, column_stacked_percent, basic_line, basic_area, stacked_area, area_stacked_percent, multiple_column, windrose, spiderweb, column_stacked, fixed_placement_column
  + <u>desired field in query result:</u> category, serie, value
* Serie Value
  + <u>render type:</u> serie_value, pie_chart, half_donuts, funnel, column
  + <u>desired field in query result:</u> serie value
* Column Stacked Grouped
  + <u>render type:</u> column_stacked_grouped
  + <u>desired field in query result:</u> category, serie, value, stack
* Datestamp Value
  + <u>render type:</u> column_stacked_grouped
  + <u>desired field in query result:</u> datestamp (yyyyMMdd), value
* Boxplot
  + <u>render type:</u> boxplot
  + <u>desired field in query result:</u> category, serie, min, first_quartil, median, third_quartil, max
* Heatmap
  + <u>render type:</u> small_heatmap, large_heatmap
  + <u>desired field in query result:</u> x_category, y_category, value
* Scatter
  + <u>render type:</u> scatter
  + <u>desired field in query result:</u> serie, x ,y
* Leaflet
  + <u>render type:</u> leaflet
  + <u>desired field in query result:</u> layer_name, collection, type, geometry_type, lat, lng, any additional field would be included in the "properties"
* Other
  + <u>render type:</u> csv, treemap2, treemap3, json_value, json_array
  except for the csv, the order of fields will determine the output

# Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake db:reset` to create table and populate the database.
Then, run `bundle exec rspec spec` to run the tests. You can also run `rake console` for an interactive prompt that will allow you to experiment.

# Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hupi-analytics/data-retriever. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

# License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
