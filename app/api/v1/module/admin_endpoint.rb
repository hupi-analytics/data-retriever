# -*- encoding : utf-8 -*-
module DataRetriever
  module V1
    class AdminEndpoint < Grape::API
      format :json

      params do
        requires :class_called, type: String, values: %w(hdr_endpoint hdr_endpoints hdr_export_type hdr_export_types hdr_query_engine hdr_query_engines hdr_query_object hdr_query_objects hdr_filters hdr_filter)
      end
      namespace "admin" do
        # index
        params do
          optional :filters, type: Hash
          optional :order, type: Hash
        end
        get "(:class_called)" do
          class_called = params[:class_called].singularize.camelize.constantize
          filters = params[:filters].to_hash if params[:filters]
          order = params[:order].to_hash if params[:order]
          results = class_called.where(filters).order(order)
          present results, with: class_called::Entity, type: :preview
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
