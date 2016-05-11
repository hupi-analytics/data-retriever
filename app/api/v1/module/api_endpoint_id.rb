# -*- encoding : utf-8 -*-
module DataRetriever
  module V1
    class ApiEndpointId < Grape::API
      format :json

      before do
        authenticate!
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
        requires :id, type: Integer
        requires :render_type, type: String
        optional :filters
        optional :query_params
      end
      post "hdr_endpoint/(:id)/data" do
        return error!("no client set", 400) if params[:client].nil? || params[:client] !~ /[^[:space:]]/

        query = HdrQueryObject.eager_load(:hdr_export_types, :hdr_filters, hdr_endpoint: :hdr_account)
                .where("hdr_endpoints.id = ?
                        AND ? = ANY (hdr_export_types.render_types)", params[:id], params[:render_type]).order(:updated_at).first
        action_on_query("execute", query, "id", id: params[:id])
      end

      desc "explain query", {
        headers: {
          "X-Api-Token" => {
            description: "Validates your identity",
            required: true
          }
        }
      }
      params do
        requires :client, type: String, desc: "client name"
        requires :id, type: Integer
        requires :render_type, type: String
        optional :filters
        optional :query_params
      end
      post "hdr_query_object/(:id)/explain" do
        return error!("no client set", 400) if params[:client].nil? || params[:client] !~ /[^[:space:]]/

        query = HdrQueryObject.eager_load(:hdr_export_types, :hdr_filters, hdr_endpoint: :hdr_account)
                .where("hdr_query_objects.id = ?
                        AND ? = ANY (hdr_export_types.render_types)", params[:id], params[:render_type]).order(:updated_at).first
        action_on_query("explain", query, "hqo_id", id: params[:id])
      end

      desc "return accepted render_types for the hdr_endpoint", {
        headers: {
          "X-Api-Token" => {
            description: "Validates your identity",
            required: true
          }
        }
      }
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
