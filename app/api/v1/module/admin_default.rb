# -*- encoding : utf-8 -*-
module DataRetriever
  module V1
    module Admin
      class Default < Grape::API
        format :json
        before do
          authenticate!
          error!("Unauthorized", 401) unless @current_account.superadmin?
        end

        params do
          requires :class_called, type: String, values: %w(hdr_endpoint hdr_endpoints
                                                           hdr_export_type hdr_export_types
                                                           hdr_query_engine hdr_query_engines
                                                           hdr_query_object hdr_query_objects
                                                           hdr_filters hdr_filter)
        end
        namespace "admin" do
          # index
          params do
            optional :filters, types: [String, Hash]
            optional :order, types: [String, Hash]
          end
          get "(:class_called)" do
            class_called = params[:class_called].singularize.camelize.constantize
            filters = case params[:filters].class.to_s
            when "Hashie::Mash"
              params[:filters].to_hash
            else
              params[:filters]
            end

            order = case params[:order].class.to_s
            when "Hashie::Mash"
              params[:order].to_hash
            else
              params[:order]
            end

            begin
              results = class_called.where(filters).order(order)
              present results, with: class_called::Entity, type: :preview
            rescue ActiveRecord::StatementInvalid => e
              error!("#{e}", 400)
            end
          end

          # read
          params do
            requires :id, type: Integer
          end
          get "(:class_called)/(:id)" do
            class_called = params[:class_called].singularize.camelize.constantize
            begin
              present class_called.find(params[:id]), with: class_called::Entity, type: :full
            rescue ActiveRecord::RecordNotFound => e
              error!("#{e}", 404)
            end
          end

          # create
          post "(:class_called)" do
            class_called = params[:class_called].singularize.camelize.constantize
            class_sym = params[:class_called].singularize.to_sym
            begin
              error!("params empty", 400) if params[class_sym].nil?
              present class_called.create!(params[class_sym].to_hash), with: class_called::Entity, type: :full
            rescue ActiveRecord::RecordInvalid => e
              error!("#{e}", 409)
            end
          end

          # update
          params do
            requires :id, type: Integer
          end
          put "(:class_called)/(:id)" do
            class_called = params[:class_called].singularize.camelize.constantize
            class_sym = params[:class_called].singularize.to_sym
            begin
              error!("params empty", 400) if params[class_sym].nil?
              present class_called.update(params[:id], params[class_sym].to_hash), with: class_called::Entity, type: :full
            rescue ActiveRecord::RecordNotFound => e
              error!("#{e}", 404)
            end
          end

          # delete
          params do
            requires :id, type: Integer
          end
          delete "(:class_called)/(:id)" do
            class_called = params[:class_called].singularize.camelize.constantize
            begin
              class_called.destroy(params[:id])
            rescue ActiveRecord::RecordNotFound => e
              error!("#{e}", 404)
            end
          end
        end
      end
    end
  end
end
