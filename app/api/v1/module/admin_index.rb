# -*- encoding : utf-8 -*-
module DataRetriever
  module V1
    module Admin
      class Index < Grape::API
        format :json
        before do
          authenticate!
        end

        params do
          requires :class_called, type: String, values: %w(hdr_endpoint hdr_endpoints
                                                           hdr_export_type hdr_export_types
                                                           hdr_query_engine hdr_query_engines
                                                           hdr_query_object hdr_query_objects
                                                           hdr_filters hdr_filter)
        end
        namespace "admin" do
          desc "index", {
            headers: {
              "X-Api-Token" => {
                description: "Validates your identity",
                required: true
              }
            }
          }
          params do
            optional :filters, types: [String, Hash]
            optional :order, types: [String, Hash]
          end
          get "(:class_called)" do
            class_called = params[:class_called].singularize.camelize.constantize
            filters = convert_params(params[:filters])
            order = convert_params(params[:order])

            begin
              results = if @current_account.superadmin?
                          case class_called.to_s
                          when "HdrEndpoint"
                            HdrEndpoint.eager_load(hdr_query_objects: :hdr_query_engine)
                          else
                            class_called
                          end
                        else
                          case class_called.to_s
                          when "HdrEndpoint"
                            HdrEndpoint.eager_load(hdr_query_objects: :hdr_query_engine).where(hdr_account_id: [nil, current_account.id])
                          when "HdrQueryEngine"
                            HdrQueryEngine.where(hdr_account_id: [nil, current_account.id])
                          when "HdrQueryObject"
                            HdrQueryObject.includes(:hdr_endpoint).where(hdr_endpoints: { hdr_account_id: [nil, current_account.id] })
                          when "HdrFilter"
                            HdrFilter.includes(:hdr_query_object, :hdr_endpoint).where(hdr_endpoints: { hdr_account_id: [nil, current_account.id] })
                          when "HdrExportType"
                            HdrExportType
                          end
                        end
              present results.where(filters).order(order), with: class_called::Entity, type: :preview
            rescue ActiveRecord::StatementInvalid => e
              error!("#{e}", 400)
            end
          end
        end
      end
    end
  end
end
