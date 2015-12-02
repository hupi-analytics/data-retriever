# -*- encoding : utf-8 -*-
module DataRetriever
  module V1
    class ApiEndpoint < Grape::API
      format :json

      before do
        error!("no client set", 400) if params[:client].nil? || params[:client] !~ /[^[:space:]]/
      end

      params do
        requires :client, type: String, desc: "client name"
        requires :module_name, type: String
        requires :method_name, type: String
        requires :render_type, type: String
        optional :filters, type: Hash
      end
      post "(:module_name)/(:method_name)" do
        query = HdrQueryObject.eager_load(:hdr_endpoint, :hdr_export_types).find_by("hdr_endpoints.module_name = '#{params[:module_name]}' AND hdr_endpoints.method_name = '#{params[:method_name]}' AND '#{params[:render_type]}' = ANY (hdr_export_types.render_types)")
        # if we have found the query we execute it with the linked query_engine
        # else we try to guess wich parameters are wrong
        if query
          query_engine = DataRetriever::QueryEngines.get(query.hdr_query_engine, params[:client])
          query_filter = query.get_filters(params[:filters])
          query_params = params[:query_params] || {}
          export_type = HdrExportType.find_by("'#{params[:render_type]}' = ANY (render_types)")
          query_decorated = query_engine.decorate(query.query, query_filter, query_params)
          logger.debug("QUERY | #{query.hdr_query_engine.engine} | #{query.hdr_query_engine.name} | #{query_decorated}")
          begin
            cursor = query_engine.execute(query_decorated)
          rescue IOError
            query_engine.reload
            cursor = query_engine.execute(query_decorated)
          end
          { data: Export.send(params[:render_type], cursor, query_params) }
        else
          endpoint = HdrEndpoint.find_by(module_name: params[:module_name], method_name: params[:method_name])
          if endpoint
            error!("render_type should be one of: #{endpoint.render_types}", 400)
          else
            error!("url not found: #{params[:module_name]}/#{params[:method_name]}", 404)
          end
        end
      end
    end
  end
end
