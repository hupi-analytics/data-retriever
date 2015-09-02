# -*- encoding : utf-8 -*-
module DataRetriever
  module V1
    class ApiEndpoint < Grape::API
      # version "v1", using: :accept_version_header
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
        # if we have found the queyr we execute it with the linked
        # else we try to guess wich parameters are wrong
        if query
          query_engine = DataRetriever::QueryEngines.get(query.hdr_query_engine)
          query_filter = query.get_filters(params[:filters])
          cursor = query_engine.execute(query.query, params[:client], query_filter)
          { data: Export.new(cursor: cursor).send("to_#{params[:render_type]}") }
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
