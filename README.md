# hupi data retriever #

- [Usage](#usage)
  - [Header Params](#header-params)
  - [Endpoints](#endpoints)
    * [Admin](#admin)
  - [Query](#query)
    * [mysql](#sql-query)
    * [postgresql](#sql-query)
    * [impala](#sql-query)
    * [mongodb](#mongodb-query)
    * [elasticsearch](#elasticsearch-query)
    * [openscoring](#openscoring)
    * [http](#http)
  - [Render type](#render-type)
    * [category serie value](#category-serie-value)
    * [fixed placement column](#fixed-placement-column)
    * [serie value](#serie-value)
    * [column stacked grouped](#column-stacked-grouped)
    * [boxplot](#boxplot)
    * [small heatmap](#small-heatmap)
    * [large heatmap](#large-heatmap)
    * [scatter](#scatter)
    * [bubble](#bubble)
    * [leaflet](#leaflet)
    * [CSV](#csv)
    * [multiple CSV](#multiple-csv)
    * [JSON value](#json-value)
    * [JSON array](#json-array)
    * [value](#value)
    * [cursor](#cursor)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Usage ##
this project use swagger Documentation
go to : [http://petstore.swagger.io/](http://petstore.swagger.io/)

paste : `http://api.dataretriever.hupi.io/swagger_doc`

### Header Params ###
* Content-Type: "application/json"
* Accept-Version: "v1"
* X-API-Token: "your_token"

### Endpoints ###
only hdr_endpoint with `api` fields to true are accessible with a non superadmin account.

#### POST `http://api.dataretriever.hupi.io/private/(:module_name)/(:method_name)` ####
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
    },
    "query_params": {
      "something": 42
    }
  }
  ```
  * <u>client:</u> (String) client name
  * <u>render_type:</u> (String) depends of the configuration of the hdr_endpoint
  * <u>query_params:</u> (JSON)
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

#### POST `http://api.dataretriever.hupi.io/private/(:module_name)/(:method_name)/(:query_object_name)` ####
* <u>module_name:</u> (String)
* <u>method_name:</u> (String)
* <u>query_object_name:</u> (String)
* <u>body:</u>

  ```json
  {
    "client": client_name,
    "render_type": render_type,
    "filters": {
      filter_name1: { "operator": operator, "value": value},
      filter_name2: value
    },
    "query_params": {
      "something": 42
    }
  }
  ```
  * <u>client:</u> (String) client name
  * <u>render_type:</u> (String) depends of the configuration of the hdr_endpoint
  * <u>query_params:</u> (JSON)
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

#### POST `http://api.dataretriever.hupi.io/estimate/(:subject)` ####
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

#### GET `http://api.dataretriever.hupi.io/render_types/(:module_name)/(:method_name)` ####
* <u>module_name:</u> (String)
* <u>method_name:</u> (String)


#### Admin ####
admin endpoints follows REST convention.
* index: GET `http://api.dataretriever.hupi.io/admin/(:model_name)s`
* create: POST `http://api.dataretriever.hupi.io/admin/(:model_name)`
* read: GET `http://api.dataretriever.hupi.io/admin/(:model_name)/(:id)`
* update: PUT `http://api.dataretriever.hupi.io/admin/(:model_name)/(:id)`
* delete: DELETE `http://api.dataretriever.hupi.io/admin/(:model)/(:id)`

```
+---------------------+ (1,n)  (1,0)  +---------------------+
|     hdr_account     |<--------------|  hdr_query_engine   |
+---------------------+               +---------------------+
|*id(uuid)            |               |*id(Int)             |
|*name(String)        |               |*name(String)        |
|*access_token(String)|               |*desc(String)        |
|*role(String)        |               |*engine(String)      |
|*created_at(DateTime)|               |*settings(JSON)      |
|*updated_at(DateTime)|               |*created_at(DateTime)|
+---------------------+               |*updated_at(DateTime)|
          ^                           +---------------------+
          |(1,n)                                 ^
          |                                      |(1,n)
          |                                      |
          |                                      |
          |(1,0)                                 |(1,1)
          |                                      |
+---------+-----------+ (1,n)   (1,1) +----------+----------+ (1,n)   (1,n) +---------------------+
|    hdr_endpoint     |-------------->|   hdr_query_object  |-------------->|   hdr_export_type   |
+---------------------+               +---------------------+               +---------------------+
|*id(Int)             |               |*id(Int)             |               |*id(Int)             |
|*module_name(String) |               |*name(String)        |               |*name(String)        |
|*method_name(String) |               |*desc(String)        |               |*desc(String)        |
|*api(Boolean)        |               |*query(String)       |               |*render_types(Array) |
|*created_at(DateTime)|               |*created_at(DateTime)|               |*created_at(DateTime)|
|*updated_at(DateTime)|               |*updated_at(DateTime)|               |*updated_at(DateTime)|
+---------------------+               +----------+----------+               +---------------------+
                                                 |
                                                 |(1,n)
                                                 |
                                                 |
                                                 |(1,1)
                                                 V
                                    +-------------------------+
                                    |      hdr_filters        |
                                    +-------------------------+
                                    |*id(Int)                 |
                                    |*pattern(String)         |
                                    |*value_type(String)      |
                                    |*field (String)          |
                                    |*default_operator(String)|
                                    |*created_at(DateTime)    |
                                    |*updated_at(DateTime)    |
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
## Query ##

in order to have a result formated for Highchart, query should rename field according to the desired render_type. Below we list the different renaming convention and the associated render type.

If you want to better understand what each field does take a look in `lib/export/` and `spec/lib/export`

#### Add filter ####
To add filter in your query simply insert a pattern `#_your_pattern_#` at the desired place in the query, and add the corresponding hdr_filter. the pattern will be replaced by the filter given when you call the hdr_endpoint or if there is no filter given it will be replaced by an empty string.

#### Filter field types

* Filter types supported are int, string and array.
* Comparison operators can be used int type filters.
* To compare dates, set the type as 'string' and compare. Date as an explicit
type is not supported

#### Available Query engine ####
- [mysql](#SQL Query)
- [postgresql](#SQL Query)
- [impala](SQL Query)
- [mongodb](MongoDB Query)
- [elasticsearch](#ElasticSearch Query)
- [openscoring](#Openscoring)
- [http](#http)

### SQL Query ###
write a valid sql query, you can use every function that your query_engine recognize.
#### Filter Pattern ####
filter recognize specific pattern:
* `#_and_[something_else]_#`: Add `AND` at the beginning and `AND` between each filter that match the pattern
  ```
  select fruit as category, color as serie, quantity as value from fruit_table where color="red" #_and_f1_#
  ```

* `#_where_[something_else]_#`: Add `WHERE` at the beginning and `AND` between each filter that match the pattern

  ```
  select fruit as category, color as serie, quantity as value from fruit_table #_where_f1_#
  ```
* `#_limit_[something_else]_#` and `#_offset_[something_else]_#`: Add `limit` filter and `offset` filter.

  Example filter value is:-
  { operator: "=", value: "10", field: "limit", value_type: "int" }
  It will replace it by
  ```
  select fruit as category, color as serie, quantity as value from fruit_table limit 10;
  ```

### MongoDB Query ###
since MongoDB only provide api to query their database, we use a JSON query that we match with their api.
```json
{
  "collection": "colleciton_name",
  "query": [ operator ]
}
```

#### operator ####

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

#### Filter Pattern ####
* `#_match_[something_else]_#`: add a match `{ $match: { $and: [ filters_here ] } },`, join filters with `,`
`#_limit_[something_else]_#`: Limit number of results. Limit filter values example: - `{ operator: "$limit", value: "100", field: "total", value_type: "int" }`

  ```json
  {
    "collection": "metrics",
    "query": [
      {
        "operator": "aggregate",
        "pipeline":[
          #_match_f1_#
          {
            "$group": {
              "_id": { "year": "$year", "month": "$month"},
              "value": { "$sum": "$sessions"}
            }
          },
          {
            "$project": {
              "_id": 0,
              "category": "$_id.month",
              "serie": "$_id.year",
              "value": "$value"
            }
          },
          {
            "$sort": {
              "category": 1,
              "serie": 1
            }
          },
          #_limit_f1_#
        ]
      }
    ]
  }
  ```

* `#_find_[something_else]_#`: `$and: [ filters_here ]`, join filters with `,`

  ```json
  {
    "collection": "metrics",
    "query": [
      {
        "operator": "find",
        "filter": {#_find_f1_#},
        "opts": {
          "$sort": {
            "year": 1,
            "month": 1,
            "day": 1
          }
        }
      }
    ]
  }
  ```

* `#_and_[something_else]_#`: start with `,` and join filters with `,`

  ```json
  {
    "collection": "metrics",
    "query": [
      {
        "operator": "find",
        "filter": {"$and": [{ "year": 2014 } #_and_f1_#]},
        "opts": {
          "$sort": {
            "year": 1,
            "month": 1,
            "day": 1
          }
        }
      }
    ]
  }
  ```

* `#_replace_field_filter_[something_else]_#`: start with `,` and join filters with `,` To limit number of documents use replace_field filter and field as $limit. And for offset, use also replace_field filter where we skip a specified number of documents, pass field as $skip. And operator should always be $eq for replace field.

  ```json
  {
    "collection": "metrics",
    "query": [
      {
        "operator": "find",
        "filter": {"$and": [{ "year": 2014 }]},
        "opts": {
          "$sort": {
            "year": 1,
            "month": 1,
            "day": 1
          }
        }  #_replace_field_filter_f3_#  #_replace_field_filter_f2_#
      }
    ]
  }
  ```

replace_field example values:-
```json
  { operator: "$eq", value: "100", field: "$skip", value_type: "int" },
  { operator: "$eq", value: "100", field: "$limit", value_type: "int" }
```

With the following values of filters, `replace_field_filter_f3` will be replaced by {"$limit": 100} and `replace_field_filter_f3` by {"$skip": 100}

### ElasticSearch Query ###
write a regular ElasticSearch POST query. See [ElasticSearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html) for available operator.
the result returned are the one in `[hits][_source]` key.
```json
{
  "index": "index_name",
  "body": {
    "query" : {
      your_query
    }
  }
}
```

#### Filter ####
* `#_sub_[something_else]_#`: join operator filters with `,` and replace `#_value_#` in the operator by the value provided
```json
{
  "index": "index_name",
  "body": {
    "query" : {
      "bool": {
        "should": [
          #_sub_f1_#
        ]
      }
    }
  }
}
```

* `#_sub_and_[something_else]_#`: join operator filters with `,` and replace `#_value_#` in the operator by the value provided. Add `,` at the and of filter
```json
{
  "index": "index_name",
  "body": {
    "query" : {
      "bool": {
        "should": [
          #_sub_and_f1_#
          {"match":{"my_field":{"query":"my_value"}}}
        ]
      }
    }
  }
}
```

##### example #####
HdrFilter:
```json
{
  "pattern": "sub_f1",
  "value_type": "string",
  "field": "my_field",
  "default_operator": "{\"match\":{\"my_field\":{\"query\":#_value_#,\"boost\":1}}}",
  "name": "my_filter"
}
```
```json
{
  "pattern": "sub_f1",
  "value_type": "string",
  "field": "my_field2",
  "default_operator": "{\"match\":{\"my_field2\":{\"query\":#_value_#,\"boost\":1}}}",
  "name": "my_filter2"
}
```

Filter:
```json
{
  "my_filter": "my_value",
  "my_filter2": "my_value2"
}
```

Query:
```json
{
  "index": "index_name",
  "body": {
    "query" : {
      "bool": {
        "should": [
          #_sub_f1_#
        ]
      }
    }
  }
}
```

Query Generated:
```json
{
  "index": "index_name",
  "body": {
    "query" : {
      "bool": {
        "should": [
          {"match":{"my_field":{"query":"my_value","boost":1}}},
          {"match":{"my_field2":{"query":"my_value2","boost":1}}}
        ]
      }
    }
  }
}
```
##### timeout #####
To have request timeout limit, use this option in the query engine.
```json
transport_options: {request: {timeout: 1}}
```
### Openscoring ###
Place your PMML file in the query field. HdrFilter doesn't apply for this query engine. To make prediction, you should provide your features as JSON in the `query_params` key.

### Http ###
To make query, you should provide your input as JSON in the `query_params` key. Basically this is used to predict results and query params is mandatory.
Example query:-
```json
{
	"client": "client_name",
	"render_type": "cursor",
	"query_params": "{\"input_text\":\"blah blah\"}"
}
```

And to use filters, filters replace the value you dynamically want to send. So filters won't have a field name
But you can give a dummy field name, likewise to default operator as well. field_name and default_operator
doesn't apply for http query engine filters. Hence replace with them some value
Example query_object filter:-
```json
{
	"input":{"visitor_id": "#_replace_f1_#"}
}
```
And filter will be with these values 
```json
{pattern: 'replace_f1', field_type: 'String', field: 'Anyfieldname', defaultOperator: 'doesnot apply', filter_name: 'vid'}
```

To make a query to this endpoint with the query_object and filter values, your query body should be like this
```json
{
	"client":"hupi",
	"render_type":"cursor",
	"filters":"{\"vid\":\"45edcb88030b8da9\"}"
}
```

## Render type ##
all render type output are JSON. All output presented below are in the `data` key of the response body. When there is an error, the response body contain an `error` key that contain an explanation of the error and the response code is not 201.

* [category serie value](#category-serie-value)
* [fixed placement column](#fixed-placement-column)
* [serie value](#serie-value)
* [column stacked grouped](#column-stacked-grouped)
* [boxplot](#boxplot)
* [small heatmap](#small-heatmap)
* [large heatmap](#large-heatmap)
* [scatter](#scatter)
* [bubble](#bubble)
* [leaflet](#leaflet)
* [CSV](#csv)
* [multiple CSV](#multiple-csv)
* [JSON value](#json-value)
* [JSON array](#json-array)
* [value](#value)
* [cursor](#cursor)

#### Category Serie Value ####
  + <u>render type:</u> category_serie_value, column_stacked_normal, column_stacked_percent, basic_line, basic_area, stacked_area, stacked_area_percent, multiple_column, windrose, spiderweb, column_stacked
  + <u>required field in query result:</u> category, serie, value
  + <u>input:</u>

    ```json
    [
      { "category": "cat1", "serie": "ser1", "value": 10 },
      { "category": "cat1", "serie": "ser2", "value": 9 },
      { "category": "cat1", "serie": "ser3", "value": 6 },
      { "category": "cat2", "serie": "ser1", "value": 8 },
      { "category": "cat2", "serie": "ser2", "value": 7 }
    ]
    ```
  + <u>output:</u>

    ```json
    {
      "series": [
        { "name": "ser1", "data": [10, 8] },
        { "name": "ser2", "data": [9, 7] },
        { "name": "ser3", "data": [6, 0] }
      ],
      "categories": ["cat1", "cat2"]
    }
    ```

#### Fixed Placement Column ####
  + <u>render type:</u> fixed_placement_column
  + <u>required field in query result:</u> category, serie, value
  + <u>input:</u>

    ```json
    [
      { "category": "cat1", "serie": "ser1", "value": 10 },
      { "category": "cat1", "serie": "ser2", "value": 9 },
      { "category": "cat1", "serie": "ser3", "value": 8 },
      { "category": "cat1", "serie": "ser4", "value": 7 },
      { "category": "cat2", "serie": "ser1", "value": 1 },
      { "category": "cat2", "serie": "ser2", "value": 2 },
      { "category": "cat2", "serie": "ser3", "value": 3 },
      { "category": "cat2", "serie": "ser4", "value": 4 }

    ]
    ```
  + <u>output:</u>

    ```json
    {
      "categories": ["cat1", "cat2"],
      "series": [
        { "name": "ser1", "data": [10, 1], "color": "rgba(165,170,217,1)", "pointPlacement": -0.2,  "pointPadding": 0.3 },
        { "name": "ser2", "data": [9, 2], "color": "rgba(248,161,63,1)", "pointPlacement": 0.2,  "pointPadding": 0.3 },
        { "name": "ser3", "data": [8, 3], "color": "rgba(126,86,134,.9)", "pointPlacement": -0.2,  "pointPadding": 0.4, "yAxis": 1 },
        { "name": "ser4", "data": [7, 4], "color": "rgba(186,60,61,.9)", "pointPlacement": 0.2,  "pointPadding": 0.4, "yAxis": 1 }
      ]
    }
    ```

#### Serie Value ####
  + <u>render type:</u> serie_value, pie_chart, half_donuts, funnel, column, mult_iple_infobox
  + <u>required field in query result:</u> serie, value
  + <u>input:</u>

    ```json
    [
      { "serie": "ser1", "value": 10 },
      { "serie": "ser2", "value": 9 },
      { "serie": "ser3", "value": 6 },
      { "serie": "ser1", "value": 8 },
      { "serie": "ser2", "value": 7 }
    ]
    ```
  + <u>output:</u>

    ```json
    {
      "series": [
        ["ser1", 10],
        ["ser2", 9],
        ["ser3", 6],
        ["ser1", 8],
        ["ser2", 7]
      ]
    }
      ```

#### Column Stacked Grouped ####
  + <u>render type:</u> column_stacked_grouped
  + <u>required field in query result:</u> category, serie, value, stack
  + <u>input:</u>

    ```json
    [
      { "category": "Apples", "serie": "John", "stack": "male", "value": 5 },
      { "category": "Oranges", "serie": "John", "stack": "male", "value": 3 },
      { "category": "Pears", "serie": "John", "stack": "male", "value": 4 },
      { "category": "Grapes", "serie": "John", "stack": "male", "value": 7 },
      { "category": "Bananas", "serie": "John", "stack": "male", "value": 2 },

      { "category": "Apples", "serie": "Joe", "stack": "male", "value": 3 },
      { "category": "Oranges", "serie": "Joe", "stack": "male", "value": 4 },
      { "category": "Pears", "serie": "Joe", "stack": "male", "value": 4 },
      { "category": "Grapes", "serie": "Joe", "stack": "male", "value": 2 },

      { "category": "Apples", "serie": "Jane", "stack": "female", "value": 2 },
      { "category": "Oranges", "serie": "Jane", "stack": "female", "value": 5 },
      { "category": "Pears", "serie": "Jane", "stack": "female", "value": 6 },
      { "category": "Grapes", "serie": "Jane", "stack": "female", "value": 2 },
      { "category": "Bananas", "serie": "Jane", "stack": "female", "value": 1 },

      { "category": "Apples", "serie": "Janet", "stack": "female", "value": 3 },
      { "category": "Pears", "serie": "Janet", "stack": "female", "value": 4 },
      { "category": "Grapes", "serie": "Janet", "stack": "female", "value": 4 },
      { "category": "Bananas", "serie": "Janet", "stack": "female", "value": 3 }
    ]
    ```
  + <u>output:</u>

    ```json
    {
      "series": [
        { "name": "Jane", "stack": "female", "data": [2, 5, 6, 2, 1] },
        { "name": "Janet", "stack": "female", "data": [3, 0, 4, 4, 3] },
        { "name": "Joe", "stack": "male", "data": [3, 4, 4, 2, 0] },
        { "name": "John", "stack": "male", "data": [5, 3, 4, 7, 2] }
      ],
      "categories": ["Apples", "Oranges", "Pears", "Grapes", "Bananas"]
    }
    ```

#### Boxplot ####
  + <u>render type:</u> boxplot
  + <u>required field in query result:</u> category, serie, min, first_quartil, median, third_quartil, max
  + <u>input:</u>

    ```json
    [
      { "category": "cat1", "serie": "observation1", "min": 1, "first_quartil": 6, "median": 12, "third_quartil": 31, "max": 45 },
      { "category": "cat2", "serie": "observation1", "min": 2, "first_quartil": 7, "median": 22, "third_quartil": 32, "max": 46 },
      { "category": "cat1", "serie": "observation2", "min": 3, "first_quartil": 8, "median": 32, "third_quartil": 33, "max": 47 },
      { "category": "cat2", "serie": "observation2", "min": 4, "first_quartil": 9, "median": 42, "third_quartil": 34, "max": 48 },
    ]
    ```
  + <u>output:</u>

    ```json
    {
      "categories": ["cat1", "cat2"],
      "series": [
        {
          "name": "observation1",
          "data": [
            [1, 6, 12, 31, 45],
            [2, 7, 22, 32, 46]
          ]
        },
        {
          "name": "observation2",
          "data": [
            [3, 8, 32, 33, 47],
            [4, 9, 42, 34, 48]
          ]
        }
      ]
    }
    ```

#### Small Heatmap ####
  + <u>render type:</u> small_heatmap
  + <u>required field in query result:</u> x_category, y_category, value
  + <u>input:</u>

    ```json
    [
      { "x_category": "cat1", "y_category": "ser1", "value": 1 },
      { "x_category": "cat1", "y_category": "ser2", "value": 9 },
      { "x_category": "cat1", "y_category": "ser3", "value": 6 },
      { "x_category": "cat2", "y_category": "ser1", "value": 8 },
      { "x_category": "cat2", "y_category": "ser2", "value": 7 }
    ]
    ```
  + <u>output:</u>

    ```json
    {
      "x_category": ["cat1", "cat2"],
      "y_category": ["ser1", "ser2", "ser3"],
      "data": [
        [0, 0, 1],
        [0, 1, 9],
        [0, 2, 6],
        [1, 0, 8],
        [1, 1, 7],
        [1, 2, 0]
      ]
    }
    ```

#### Large Heatmap ####
  + <u>render type:</u> large_heatmap
  + <u>required field in query result:</u> x_category, y_category, value
  + <u>input:</u>

    ```json
    [
      { "x_category": "cat1", "y_category": "ser1", "value": 1 },
      { "x_category": "cat1", "y_category": "ser2", "value": 9 },
      { "x_category": "cat1", "y_category": "ser3", "value": 6 },
      { "x_category": "cat2", "y_category": "ser1", "value": 8 },
      { "x_category": "cat2", "y_category": "ser2", "value": 7 }
    ]
    ```
  + <u>output:</u>

    ```json
    {
      "x_category": ["cat1", "cat2"],
      "y_category": ["ser1", "ser2", "ser3"],
      "data": "0,0,1\n0,1,9\n0,2,6\n1,0,8\n1,1,7\n1,2,0\n"
    }
    ```

#### Scatter ####
  + <u>render type:</u> scatter
  + <u>required field in query result:</u> serie, x ,y
  + <u>input:</u>

    ```json
    [
      { "serie": "ser1", "x": 1, "y": 1, "value": 1 },
      { "serie": "ser1", "x": 1, "y": 2, "value": 9 },
      { "serie": "ser2", "x": 1, "y": 3, "value": 6 },
      { "serie": "ser2", "x": 2, "y": 1, "value": 8 },
      { "serie": "ser1", "x": 2, "y": 2, "value": 7 }
    ]
    ```
  + <u>output:</u>

    ```json
    {
      "series": [
        { "name": "ser1", "color": "hsla(102, 70%, 50%, 0.5)", "data": [[1, 1], [1, 2], [2, 2]] },
        { "name": "ser2", "color": "hsla(348, 70%, 50%, 0.5)", "data": [[1, 3], [2, 1]] }
      ]
    }
    ```

#### Bubble ####
  + <u>render type:</u> scatter
  + <u>required field in query result:</u> serie, x ,y
  + <u>input:</u>

    ```json
    [
      { "serie": "ser1", "x": 1, "y": 1, "z": 1, "name": "n1" },
      { "serie": "ser1", "x": 1, "y": 2, "z": 9, "name": "n2" },
      { "serie": "ser2", "x": 1, "y": 3, "z": 6, "name": "n3" },
      { "serie": "ser2", "x": 2, "y": 1, "z": 8, "name": "n4" },
      { "serie": "ser1", "x": 2, "y": 2, "z": 7, "name": "n5" }
    ]
    ```
  + <u>output:</u>

    ```json
    {
      "series": [
        {
          "name": "ser1",
          "data": [
            { "x": 1, "y": 1, "z": 1, "name": "n1" },
            { "x": 1, "y": 2, "z": 9, "name": "n2" },
            { "x": 2, "y": 2, "z": 7, "name": "n5" }
          ]
        },
        {
          "name": "ser2",
          "data": [
            { "x": 1, "y": 3, "z": 6, "name": "n3" },
            { "x": 2, "y": 1, "z": 8, "name": "n4" }
          ]
        }
      ]
    }
    ```

#### Leaflet ####
  + <u>render type:</u> leaflet
  + <u>required field in query result:</u> layer_name, collection, type, geometry_type, lat, lng, any additional field would be included in the "properties"
  + <u>input:</u>

    ```json
    [
      { "collection": "features", "layer_name": "calque", "type": "Feature", "geometry_type": "Point", "lat": 10.00, "lng": 0.0, "data1": "ab", "data2": "bc" },
      { "collection": "features", "layer_name": "calque", "type": "Feature", "geometry_type": "Point", "lat": 20.00, "lng": 1.0, "data1": "ac", "data2": "bd" },
      { "collection": "features", "layer_name": "calque", "type": "Feature", "geometry_type": "Point", "lat": 30.00, "lng": 2.0, "data1": "ad", "data2": "be" }
    ]
    ```
  + <u>output:</u>

    ```json
    {
      "calque": {
        "type": "FeatureCollection",
        "features": [
          { "type": "Feature", "geometry": { "type": "Point", "coordinates": [0.0, 10.0] }, "properties": { "data1": "ab", "data2": "bc" } },
          { "type": "Feature", "geometry": { "type": "Point", "coordinates": [1.0, 20.0] }, "properties": { "data1": "ac", "data2": "bd" } },
          { "type": "Feature", "geometry": { "type": "Point", "coordinates": [2.0, 30.0] }, "properties": { "data1": "ad", "data2": "be" } }
        ]
      }
    }
    ```

#### CSV ####
  + <u>render type:</u> csv
  + <u>required field in query result:</u> none
  + <u>input:</u>

    ```json
    [
      { "category": "cat1", "serie": "ser1", "value": 10, "datestamp": 20141001 },
      { "category": "cat1", "serie": "ser2", "value": 9, "datestamp": 20141002 },
      { "category": "cat1", "serie": "ser3", "value": 6, "datestamp": 20141003 },
      { "category": "cat2", "serie": "ser1", "value": 8, "datestamp": 20141004 },
      { "category": "cat2", "serie": "ser2", "value": 7, "datestamp": 20141005 }
    ]
    ```
  + <u>output:</u>

    ```json
    {
      "rows": [
        ["cat1", "ser1", 10, 20141001],
        ["cat1", "ser2", 9, 20141002],
        ["cat1", "ser3", 6, 20141003],
        ["cat2", "ser1", 8, 20141004],
        ["cat2", "ser2", 7, 20141005]
      ],
      "header": ["category", "serie", "value", "datestamp"]
    }
    ```

#### Multiple CSV ####
  + <u>render type:</u> multiple_csv
  + <u>required field in query result:</u> none
  + <u>input:</u>

    ```json
    [
      { "category": "cat1", "serie": "ser1", "value": 10, "datestamp": 20141001 },
      { "category": "cat1", "serie": "ser2", "value": 9, "datestamp": 20141002 },
      { "category": "cat1", "serie": "ser3", "value": 6, "datestamp": 20141003 },
      { "category": "cat2", "serie": "ser1", "value": 8, "datestamp": 20141004 },
      { "category": "cat2", "serie": "ser2", "value": 7, "datestamp": 20141005 }
    ]
    ```
  + <u>output:</u>

    ```json
    {
      "header": ["serie", "value", "datestamp"],
      "rows": {
        "cat1": [
          ["ser1", 10, 20141001],
          ["ser2",  9, 20141002],
          ["ser3",  6, 20141003]
        ],
        "cat2": [
          ["ser1",  8, 20141004],
          ["ser2",  7, 20141005]
        ]
      }
    }
    ```

#### JSON Value ####
  + <u>render type:</u> treemap2, treemap3, json_value
  + <u>required field in query result:</u> none
  + <u>description:</u> indent according to the order of the key
  + <u>input:</u>

    ```json
    [
      { "category": "cat1", "serie": "ser1", "ser": "s", "value": 10 },
      { "category": "cat1", "serie": "ser1", "ser": "s", "value": 4 },
      { "category": "cat1", "serie": "ser2", "ser": "s", "value": 9 },
      { "category": "cat1", "serie": "ser3", "ser": "s", "value": 6 },
      { "category": "cat2", "serie": "ser1", "ser": "s", "value": 8 },
      { "category": "cat2", "serie": "ser2", "ser": "s1", "value": 7 },
      { "category": "cat2", "serie": "ser2", "ser": "s2", "value": 5 }
    ]
    ```
  + <u>output:</u>

    ```json
    {
      "cat1": {
        "ser1": { "s": 4 },
        "ser2": { "s": 9 },
        "ser3": { "s": 6 }
      },
      "cat2": {
        "ser1": { "s": 8 },
        "ser2": { "s1": 7, "s2": 5 }
      }
    }
    ```

#### JSON Array ####
  + <u>render type:</u> json_array
  + <u>required field in query result:</u> none
  + <u>description:</u> indent according to the order of the key
  + <u>input:</u>

    ```json
    [
      { "category": "cat1", "serie": "ser1", "ser": "s", "value": 10 },
      { "category": "cat1", "serie": "ser1", "ser": "s", "value": 4 },
      { "category": "cat1", "serie": "ser2", "ser": "s", "value": 9 },
      { "category": "cat1", "serie": "ser3", "ser": "s", "value": 6 },
      { "category": "cat2", "serie": "ser1", "ser": "s", "value": 8 },
      { "category": "cat2", "serie": "ser2", "ser": "s1", "value": 7 },
      { "category": "cat2", "serie": "ser2", "ser": "s2", "value": 5 }
    ]
    ```
  + <u>output:</u>

    ```json
    {
      "cat1": {
        "ser1": { "s": [10, 4] },
        "ser2": { "s": [9] },
        "ser3": { "s": [6] }
      },
      "cat2": {
        "ser1": { "s": [8] },
        "ser2": { "s1": [7], "s2": [5] }
      }
    }
    ```

#### Value ####
  + <u>render type:</u> value, infobox
  + <u>required field in query result:</u> none
  + <u>description:</u> return the last value of the last key
  + <u>input:</u>

    ```json
    [
      { "my_field1": 14, "my_field2": 15 },
      { "my_field1": 41, "my_field2": 42 }
    ]
    ```
  + <u>output:</u>

    ```json
    { "value": 42 }
    ```

#### Cursor ####
  + <u>render type:</u> cursor
  + <u>required field in query result:</u> none
  + <u>description:</u> send result of the query without modification
  + <u>input:</u>

    ```json
    [
      { "field1": "cat1", "field2": "ser1", "field3": "s",  "field4": 10 },
      { "field1": "cat1", "field2": "ser1", "field3": "s",  "field4": 4  },
      { "field1": "cat1", "field2": "ser2", "field3": "s",  "field4": 9  },
      { "field1": "cat1", "field2": "ser3", "field3": "s",  "field4": 6  },
      { "field1": "cat2", "field2": "ser1", "field3": "s",  "field4": 8  },
      { "field1": "cat2", "field2": "ser2", "field3": "s1", "field4": 7  },
      { "field1": "cat2", "field2": "ser2", "field3": "s2", "field4": 5  }
    ]
    ```
  + <u>output:</u>

    ```json
    [
      { "field1": "cat1", "field2": "ser1", "field3": "s",  "field4": 10 },
      { "field1": "cat1", "field2": "ser1", "field3": "s",  "field4": 4  },
      { "field1": "cat1", "field2": "ser2", "field3": "s",  "field4": 9  },
      { "field1": "cat1", "field2": "ser3", "field3": "s",  "field4": 6  },
      { "field1": "cat2", "field2": "ser1", "field3": "s",  "field4": 8  },
      { "field1": "cat2", "field2": "ser2", "field3": "s1", "field4": 7  },
      { "field1": "cat2", "field2": "ser2", "field3": "s2", "field4": 5  }
    ]
    ```

# Development #

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake db:reset` to create table and populate the database.
Then, run `bundle exec rspec spec` to run the tests. You can also run `rake console` for an interactive prompt that will allow you to experiment.

# Contributing #

Bug reports and pull requests are welcome on GitHub at https://github.com/hupi-analytics/data-retriever. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

# License #

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
