# -*- encoding : utf-8 -*-
module DataRetriever
  module V1
    class ApiEndpointId < Grape::API
      format :json

      before do
        authenticate!
      end

      params do
        requires :client, type: String, desc: "client name"
        requires :id, type: Integer
        requires :render_type, type: String
        optional :filters, type: Hash
      end
      post "hdr_endpoint/(:id)/data" do
        return error!("no client set", 400) if params[:client].nil? || params[:client] !~ /[^[:space:]]/

        query = HdrQueryObject.eager_load(:hdr_export_types, :hdr_filters, hdr_endpoint: :hdr_account)
                              .find_by("hdr_endpoints.id = ?
                                        AND ? = ANY (hdr_export_types.render_types)", params[:id], params[:render_type])

        # if we have found the query we execute it with the linked query_engine
        # else we try to guess wich parameters are wrong
        if query && (current_account.superadmin? || current_account == query.hdr_endpoint.hdr_account || query.hdr_endpoint.hdr_account.nil?)
          query_engine = DataRetriever::QueryEngines.get(query.hdr_query_engine, params[:client])
          query_filter = query.get_filters(params[:filters])
          query_params = params[:query_params] || {}
          export_type = HdrExportType.find_by("? = ANY (render_types)", params[:render_type])
          query_decorated = query_engine.decorate(query.query, query_filter, query_params)
          logger.debug("QUERY | #{query.hdr_query_engine.engine} | #{query.hdr_query_engine.name} | #{query_decorated}")
          begin
            cursor = query_engine.execute(query_decorated)
          rescue IOError, Mysql2::Error
            query_engine.reload
            cursor = query_engine.execute(query_decorated)
          end
          { data: Export.send(params[:render_type], cursor, query_params) }
        elsif query && !(current_account.superadmin? || current_account == query.hdr_endpoint.hdr_account || query.hdr_endpoint.hdr_account.nil?)
          error!("Unauthorized", 401)
        else
          endpoint = HdrEndpoint.find(params[:id])
          if endpoint && !endpoint.render_types.include?(params[:render_type])
            error!("render_type should be one of: #{endpoint.render_types}", 400)
          elsif endpoint.nil?
            error!("url not found: hdr_endpoint/#{params[:id]}/data", 404)
          else
            logger.error("ENDPOINT | #{endpoint.inspect}")
            error!("error unknown", 400)
          end
        end
      end

      params do
        requires :id, type: Integer
      end
      get "hdr_endpoint/(:id)/render_types" do
        endpoint = HdrEndpoint.find(params[:id])
        if endpoint && (current_account.superadmin? || current_account == query.endpoint.hdr_account || query.endpoint.hdr_account.nil?)
          endpoint.render_types
        elsif endpoint.nil?
          error!("not found", 404)
        else
          error!("Unauthorized", 401)
        end
      end
    end
  end
end
