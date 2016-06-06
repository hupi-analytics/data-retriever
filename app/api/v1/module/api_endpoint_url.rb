# -*- encoding : utf-8 -*-
module DataRetriever
  module V1
    class ApiEndpointUrl < Grape::API
      format :json

      before do
        authenticate!
      end

      desc "explain query that match the render type", {
        headers: {
          "X-Api-Token" => {
            description: "Validates your identity",
            required: true
          }
        }
      }
      params do
        requires :client, type: String, desc: "client name"
        requires :module_name, type: String
        requires :method_name, type: String
        requires :render_type, type: String
        optional :filters, type: JSON, desc: "json format"
        optional :query_params, type: JSON, desc: "json format"
      end
      post "private/:module_name/:method_name/explain" do
        return error!("no client set", 400) if params[:client].nil? || params[:client] !~ /[^[:space:]]/

        query = HdrQueryObject.eager_load(:hdr_export_types, :hdr_filters, hdr_endpoint: :hdr_account)
                              .where(
                                "hdr_endpoints.hdr_account_id is not null
                                AND hdr_endpoints.module_name = ?
                                AND hdr_endpoints.method_name = ?
                                AND ? = ANY (hdr_export_types.render_types)",
                                params[:module_name],
                                params[:method_name],
                                params[:render_type]
                              )
                              .order("hdr_query_objects.updated_at")
                              .first
        action_on_query("explain", query, params[:endpoint_type], module_name: params[:module_name], method_name: params[:method_name])
      end

      desc "explain query that match the render type", {
        headers: {
          "X-Api-Token" => {
            description: "Validates your identity",
            required: true
          }
        }
      }
      params do
        requires :client, type: String, desc: "client name"
        requires :module_name, type: String
        requires :method_name, type: String
        requires :render_type, type: String
        optional :filters, type: JSON, desc: "json format"
        optional :query_params, type: JSON, desc: "json format"
      end
      post "public/:module_name/:method_name/explain" do
        return error!("no client set", 400) if params[:client].nil? || params[:client] !~ /[^[:space:]]/

        query = HdrQueryObject.eager_load(:hdr_export_types, :hdr_filters, hdr_endpoint: :hdr_account)
                              .where(
                                "hdr_endpoints.hdr_account_id is null
                                AND hdr_endpoints.module_name = ?
                                AND hdr_endpoints.method_name = ?
                                AND ? = ANY (hdr_export_types.render_types)",
                                params[:module_name],
                                params[:method_name],
                                params[:render_type]
                              )
                              .order("hdr_query_objects.updated_at")
                              .first
        action_on_query("explain", query, "public", module_name: params[:module_name], method_name: params[:method_name])
      end

      desc "explain query of the hdr_query_object specified", {
        headers: {
          "X-Api-Token" => {
            description: "Validates your identity",
            required: true
          }
        }
      }
      params do
        requires :client, type: String, desc: "client name"
        requires :module_name, type: String
        requires :method_name, type: String
        requires :query_object_name, type: String
        requires :render_type, type: String
        optional :filters, type: JSON, desc: "json format"
        optional :query_params, type: JSON, desc: "json format"
      end
      post "private/:module_name/:method_name/:query_object_name/explain" do
        return error!("no client set", 400) if params[:client].nil? || params[:client] !~ /[^[:space:]]/

        query = HdrQueryObject.eager_load(:hdr_export_types, :hdr_filters, hdr_endpoint: :hdr_account)
                              .where(
                                "hdr_endpoints.hdr_account_id is not null
                                AND hdr_endpoints.module_name = ?
                                AND hdr_endpoints.method_name = ?
                                AND ? = ANY (hdr_export_types.render_types)
                                AND hdr_query_objects.name = ?",
                                params[:module_name],
                                params[:method_name],
                                params[:render_type],
                                params[:query_object_name]
                              )
                              .order("hdr_query_objects.updated_at")
                              .first
        action_on_query("explain", query, "private", module_name: params[:module_name], method_name: params[:method_name])
      end

      desc "explain query of the hdr_query_object specified", {
        headers: {
          "X-Api-Token" => {
            description: "Validates your identity",
            required: true
          }
        }
      }
      params do
        requires :client, type: String, desc: "client name"
        requires :module_name, type: String
        requires :method_name, type: String
        requires :query_object_name, type: String
        requires :render_type, type: String
        optional :filters, type: JSON, desc: "json format"
        optional :query_params, type: JSON, desc: "json format"
      end
      post "public/:module_name/:method_name/:query_object_name/explain" do
        return error!("no client set", 400) if params[:client].nil? || params[:client] !~ /[^[:space:]]/

        query = HdrQueryObject.eager_load(:hdr_export_types, :hdr_filters, hdr_endpoint: :hdr_account)
                              .where(
                                "hdr_endpoints.hdr_account_id is null
                                AND hdr_endpoints.module_name = ?
                                AND hdr_endpoints.method_name = ?
                                AND ? = ANY (hdr_export_types.render_types)
                                AND hdr_query_objects.name = ?",
                                params[:module_name],
                                params[:method_name],
                                params[:render_type],
                                params[:query_object_name]
                              )
                              .order("hdr_query_objects.updated_at")
                              .first
        action_on_query("explain", query, "public", module_name: params[:module_name], method_name: params[:method_name])
      end

      desc "execute query that match the render_type", {
        headers: {
          "X-Api-Token" => {
            description: "Validates your identity",
            required: true
          }
        }
      }
      params do
        requires :client, type: String, desc: "client name"
        requires :module_name, type: String
        requires :method_name, type: String
        requires :render_type, type: String
        optional :filters, type: JSON, desc: "json format"
        optional :query_params, type: JSON, desc: "json format"
      end
      post "private/:module_name/:method_name" do
        return error!("no client set", 400) if params[:client].nil? || params[:client] !~ /[^[:space:]]/

        query = HdrQueryObject.eager_load(:hdr_export_types, :hdr_filters, hdr_endpoint: :hdr_account)
                              .where(
                                "hdr_endpoints.hdr_account_id is not null
                                AND hdr_endpoints.module_name = ?
                                AND hdr_endpoints.method_name = ?
                                AND ? = ANY (hdr_export_types.render_types)",
                                params[:module_name],
                                params[:method_name],
                                params[:render_type]
                              )
                              .order("hdr_query_objects.updated_at")
                              .first
        action_on_query("execute", query, "private", module_name: params[:module_name], method_name: params[:method_name])
      end

      desc "execute query that match the render_type", {
        headers: {
          "X-Api-Token" => {
            description: "Validates your identity",
            required: true
          }
        }
      }
      params do
        requires :client, type: String, desc: "client name"
        requires :module_name, type: String
        requires :method_name, type: String
        requires :render_type, type: String
        optional :filters, type: JSON, desc: "json format"
        optional :query_params, type: JSON, desc: "json format"
      end
      post "public/:module_name/:method_name" do
        return error!("no client set", 400) if params[:client].nil? || params[:client] !~ /[^[:space:]]/

        query = HdrQueryObject.eager_load(:hdr_export_types, :hdr_filters, hdr_endpoint: :hdr_account)
                              .where(
                                "hdr_endpoints.hdr_account_id is null
                                AND hdr_endpoints.module_name = ?
                                AND hdr_endpoints.method_name = ?
                                AND ? = ANY (hdr_export_types.render_types)",
                                params[:module_name],
                                params[:method_name],
                                params[:render_type]
                              )
                              .order("hdr_query_objects.updated_at")
                              .first
        action_on_query("execute", query, "public", module_name: params[:module_name], method_name: params[:method_name])
      end

      desc "execute query that match the render type and hdr_query_object name", {
        headers: {
          "X-Api-Token" => {
            description: "Validates your identity",
            required: true
          }
        }
      }
      params do
        requires :client, type: String, desc: "client name"
        requires :module_name, type: String
        requires :method_name, type: String
        requires :query_object_name, type: String
        requires :render_type, type: String
        optional :filters, type: JSON, desc: "json format"
        optional :query_params, type: JSON, desc: "json format"
      end
      post "private/:module_name/:method_name/:query_object_name" do
        return error!("no client set", 400) if params[:client].nil? || params[:client] !~ /[^[:space:]]/

        query = HdrQueryObject.eager_load(:hdr_export_types, :hdr_filters, hdr_endpoint: :hdr_account)
                              .where(
                                "hdr_endpoints.hdr_account_id is not null
                                AND hdr_endpoints.module_name = ?
                                AND hdr_endpoints.method_name = ?
                                AND ? = ANY (hdr_export_types.render_types)
                                AND hdr_query_objects.name = ?",
                                params[:module_name],
                                params[:method_name],
                                params[:render_type],
                                params[:query_object_name]
                              )
                              .order("hdr_query_objects.updated_at")
                              .first
        action_on_query("execute", query, "private", module_name: params[:module_name], method_name: params[:method_name])
      end

      desc "execute query that match the render type and hdr_query_object name", {
        headers: {
          "X-Api-Token" => {
            description: "Validates your identity",
            required: true
          }
        }
      }
      params do
        requires :client, type: String, desc: "client name"
        requires :module_name, type: String
        requires :method_name, type: String
        requires :query_object_name, type: String
        requires :render_type, type: String
        optional :filters, type: JSON, desc: "json format"
        optional :query_params, type: JSON, desc: "json format"
      end
      post "public/:module_name/:method_name/:query_object_name" do
        return error!("no client set", 400) if params[:client].nil? || params[:client] !~ /[^[:space:]]/

        query = HdrQueryObject.eager_load(:hdr_export_types, :hdr_filters, hdr_endpoint: :hdr_account)
                              .where(
                                "hdr_endpoints.hdr_account_id is null
                                AND hdr_endpoints.module_name = ?
                                AND hdr_endpoints.method_name = ?
                                AND ? = ANY (hdr_export_types.render_types)
                                AND hdr_query_objects.name = ?",
                                params[:module_name],
                                params[:method_name],
                                params[:render_type],
                                params[:query_object_name]
                              )
                              .order("hdr_query_objects.updated_at")
                              .first
        action_on_query("execute", query, "public", module_name: params[:module_name], method_name: params[:method_name])
      end

      desc "return available render_types for the endpoint specified", {
        headers: {
          "X-Api-Token" => {
            description: "Validates your identity",
            required: true
          }
        }
      }
      params do
        requires :module_name, type: String
        requires :method_name, type: String
      end
      get "render_types/:module_name/:method_name" do
        endpoint = HdrEndpoint.find_by(module_name: params[:module_name], method_name: params[:method_name])
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
