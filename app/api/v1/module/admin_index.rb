# -*- encoding : utf-8 -*-
module DataRetriever
  module V1
    module Admin
      class Index < Grape::API
        format :json
        before do
          authenticate!
        end

        namespace "admin" do
          # index hdr_endpoints
          params do
            optional :filters, types: [String, Hash]
            optional :order, types: [String, Hash]
          end
          get "hdr_endpoints" do
            filters = convert_params(params[:filters])
            order = convert_params(params[:order])

            begin
              results = if @current_account.superadmin?
                HdrEndpoint.where(filters).order(order)
              else
                HdrEndpoint.where(hdr_account_id: [nil, current_account.id]).where(filters).order(order)
              end
              present results, with: HdrEndpoint::Entity, type: :preview
            rescue ActiveRecord::StatementInvalid => e
              error!("#{e}", 400)
            end
          end

          # index hdr_query_engines
          params do
            optional :filters, types: [String, Hash]
            optional :order, types: [String, Hash]
          end
          get "hdr_query_engines" do
            filters = convert_params(params[:filters])
            order = convert_params(params[:order])

            begin
              results = if @current_account.superadmin?
                HdrQueryEngine.where(filters).order(order)
              else
                HdrQueryEngine.where(hdr_account_id: [nil, current_account.id]).where(filters).order(order)
              end
              present results, with: HdrQueryEngine::Entity, type: :preview
            rescue ActiveRecord::StatementInvalid => e
              error!("#{e}", 400)
            end
          end

          # index hdr_query_objects
          params do
            optional :filters, types: [String, Hash]
            optional :order, types: [String, Hash]
          end
          get "hdr_query_objects" do
            filters = convert_params(params[:filters])
            order = convert_params(params[:order])

            begin
              results = if @current_account.superadmin?
                HdrQueryObject.where(filters).order(order)
              else
                HdrQueryObject.includes(:hdr_endpoint).where(hdr_endpoints: { hdr_account_id: [nil, current_account.id] }).where(filters).order(order)
              end
              present results, with: HdrQueryObject::Entity, type: :preview
            rescue ActiveRecord::StatementInvalid => e
              error!("#{e}", 400)
            end
          end

          # index hdr_filters
          params do
            optional :filters, types: [String, Hash]
            optional :order, types: [String, Hash]
          end
          get "hdr_filters" do
            filters = convert_params(params[:filters])
            order = convert_params(params[:order])

            begin
              results = if @current_account.superadmin?
                HdrFilter.where(filters).order(order)
              else
                HdrFilter.includes(:hdr_query_object, :hdr_endpoint).where(hdr_endpoints: { hdr_account_id: [nil, current_account.id] })
              end
              present results, with: HdrFilter::Entity, type: :preview
            rescue ActiveRecord::StatementInvalid => e
              error!("#{e}", 400)
            end
          end

          # index hdr_export_type
          params do
            optional :filters, types: [String, Hash]
            optional :order, types: [String, Hash]
          end
          get "hdr_export_types" do
            filters = convert_params(params[:filters])
            order = convert_params(params[:order])

            begin
              results = HdrExportType.where(filters).order(order)
              present results, with: HdrExportType::Entity, type: :preview
            rescue ActiveRecord::StatementInvalid => e
              error!("#{e}", 400)
            end
          end
        end
      end
    end
  end
end
