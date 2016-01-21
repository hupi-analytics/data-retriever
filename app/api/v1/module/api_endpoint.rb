# -*- encoding : utf-8 -*-
module DataRetriever
  module V1
    class ApiEndpoint < Grape::API
      format :json

      before do
        authenticate!
      end

      params do
        requires :client, type: String, desc: "client name"
        requires :module_name, type: String
        requires :method_name, type: String
        requires :render_type, type: String
        optional :filters, type: Hash
        optional :token, type: String
      end
      post "private/(:module_name)/(:method_name)" do
        return error!("no client set", 400) if params[:client].nil? || params[:client] !~ /[^[:space:]]/

        query = HdrQueryObject.eager_load(:hdr_export_types, :hdr_filters, hdr_endpoint: :hdr_account).find_by("hdr_endpoints.hdr_account_id is not null AND hdr_endpoints.module_name = '#{params[:module_name]}' AND hdr_endpoints.method_name = '#{params[:method_name]}' AND '#{params[:render_type]}' = ANY (hdr_export_types.render_types)")
        # if we have found the query we execute it with the linked query_engine
        # else we try to guess wich parameters are wrong
        if query && (current_account.superadmin? || current_account == query.hdr_endpoint.hdr_account)
          query_engine = DataRetriever::QueryEngines.get(query.hdr_query_engine, params[:client])
          query_filter = query.get_filters(params[:filters])
          query_params = params[:query_params] || {}
          export_type = HdrExportType.find_by("'#{params[:render_type]}' = ANY (render_types)")
          query_decorated = query_engine.decorate(query.query, query_filter, query_params)
          logger.debug("QUERY | #{query.hdr_query_engine.engine} | #{query.hdr_query_engine.name} | #{query_decorated}")
          begin
            cursor = query_engine.execute(query_decorated)
          rescue IOError, Mysql2::Error
            query_engine.reload
            cursor = query_engine.execute(query_decorated)
          end
          { data: Export.send(params[:render_type], cursor, query_params) }
        elsif query && !(current_account.superadmin? || current_account == query.hdr_endpoint.hdr_account)
          error!("Unauthorized", 401)
        else
          endpoint = HdrEndpoint.find_by(module_name: params[:module_name], method_name: params[:method_name])
          if endpoint && !endpoint.render_types.include?(params[:render_type])
            error!("render_type should be one of: #{endpoint.render_types}", 400)
          elsif endpoint && !endpoint.hdr_account
            error!("endpoint not linked to an account", 400)
          elsif endpoint.nil?
            error!("url not found: private/#{params[:module_name]}/#{params[:method_name]}", 404)
          else
            logger.error("ENDPOINT | #{endpoint.inspect}")
            error!("error unknown", 400)
          end
        end
      end

      params do
        requires :module_name, type: String
        requires :method_name, type: String
      end
      get "render_types/(:module_name)/(:method_name)" do
        puts "rende type: #{params[:module_name]}/#{params[:method_name]}"
        endpoint = HdrEndpoint.find_by(module_name: params[:module_name], method_name: params[:method_name])
        puts endpoint
        if endpoint && (current_account.superadmin? || current_account == query.endpoint.hdr_account)
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
