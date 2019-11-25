# -*- encoding : utf-8 -*-
module DataRetriever
  module V1
    module Admin
      class Account < Grape::API
        format :json
        before do
          authenticate!
          error!("Unauthorized", 401) unless @current_account.superadmin?
        end

        namespace "admin" do
          desc "index", {
            headers: {
              "X-Api-Token" => {
                description: "Validates your identity",
                type: "String",
                required: true
              },
              "Accept-Version" => {
                description: "use api version",
                required: true,
                type: "String"
              }
            }
          }
          params do
            optional :filters, types: [String, Hash]
            optional :order, types: [String, Hash]
          end
          get "hdr_accounts" do
            filters = HdrAccount.send(:sanitize_sql_for_conditions, convert_params(params[:filters]))
            order = HdrAccount.send(:sanitize_sql, convert_params(params[:order]))

            begin
              results = HdrAccount.where(filters).order(order)
              present results, with: HdrAccount::Entity, type: :preview
            rescue ActiveRecord::StatementInvalid => e
              error!(e.to_s, 400)
            end
          end

          desc "read", {
            headers: {
              "X-Api-Token" => {
                description: "Validates your identity",
                required: true
              }
            }
          }
          params do
            requires :id, type: String
          end
          get "hdr_account/:id" do
            begin
              present HdrAccount.find(params[:id]), with: HdrAccount::Entity, type: :full
            rescue ActiveRecord::RecordNotFound => e
              error!(e.to_s, 404)
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
          post "hdr_account" do
            begin
              present HdrAccount.create!(params[:hdr_account].to_hash), with: HdrAccount::Entity, type: :full
            rescue ActiveRecord::RecordInvalid => e
              error!(e.to_s, 409)
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
            requires :id, type: String
          end
          put "hdr_account/:id" do
            error!("params empty", 400) if params[:hdr_account].nil?
            hdr_account = HdrAccount.find(params[:id])
            if hdr_account.update_attributes(params[:hdr_account].to_hash)
              present hdr_account, with: HdrAccount::Entity, type: :full
            else
              error!(hdr_account.errors.to_hash, 409)
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
            requires :id, type: String
          end
          delete "hdr_account/:id" do
            begin
              HdrAccount.destroy(params[:id])
            rescue ActiveRecord::RecordNotFound => e
              error!(e.to_s, 404)
            end
          end

          desc "refresh account token", {
            headers: {
              "X-Api-Token" => {
                description: "Validates your identity",
                required: true
              }
            }
          }
          params do
            requires :id, type: String
          end
          get "hdr_account/:id/refresh_token" do
            begin
              account = HdrAccount.find(params[:id])
              access_token = account.generate_access_token
              account.save
              { access_token: access_token }
            rescue ActiveRecord::RecordNotFound => e
              error!(e.to_s, 404)
            end
          end
        end
      end
    end
  end
end
