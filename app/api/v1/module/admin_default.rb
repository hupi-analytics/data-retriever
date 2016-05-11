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
          desc "read", {
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
          get ":class_called/:id" do
            class_called = params[:class_called].singularize.camelize.constantize
            begin
              present class_called.find(params[:id]), with: class_called::Entity, type: :full
            rescue ActiveRecord::RecordNotFound => e
              error!("#{e}", 404)
            end
          end

          desc "create", {
            headers: {
              "X-Api-Token" => {
                description: "Validates your identity",
                required: true
              }
            }
          }
          post ":class_called" do
            class_called = params[:class_called].singularize.camelize.constantize
            class_sym = params[:class_called].singularize.to_sym
            begin
              error!("params empty", 400) if params[class_sym].nil?
              present class_called.create!(params[class_sym].to_hash), with: class_called::Entity, type: :full
            rescue ActiveRecord::RecordInvalid => e
              error!("#{e}", 409)
            end
          end

          desc "update", {
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
          put ":class_called/:id" do
            class_called = params[:class_called].singularize.camelize.constantize
            class_sym = params[:class_called].singularize.to_sym
            error!("params empty", 400) if params[class_sym].nil?
            object_updated = class_called.find(params[:id])
            if object_updated.update_attributes(params[class_sym].to_hash)
              present object_updated, with: class_called::Entity, type: :full
            else
              error!(object_updated.errors.to_hash, 409)
            end
          end

          desc "delete", {
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
          delete ":class_called/:id" do
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
