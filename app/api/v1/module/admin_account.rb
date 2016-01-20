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
          # index
          params do
            optional :filters, type: Hash
            optional :order, type: Hash
          end
          get "hdr_accounts" do
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
              results = HdrAccount.where(filters).order(order)
              present results, with: HdrAccount::Entity, type: :preview
            rescue ActiveRecord::StatementInvalid => e
              error!("#{e}", 400)
            end
          end

          # read
          params do
            requires :id, type: String
          end
          get "hdr_account/(:id)" do
            begin
              present HdrAccount.find(params[:id]), with: HdrAccount::Entity, type: :full
            rescue ActiveRecord::RecordNotFound => e
              error!("#{e}", 404)
            end
          end

          # create
          post "hdr_account" do
            begin
              present HdrAccount.create!(params[:hdr_account].to_hash), with: HdrAccount::Entity, type: :full
            rescue ActiveRecord::RecordInvalid => e
              error!("#{e}", 409)
            end
          end

          # update
          params do
            requires :id, type: String
          end
          put "hdr_account/(:id)" do
            begin
              present HdrAccount.update(params[:id], params[:hdr_account].to_hash), with: HdrAccount::Entity, type: :full
            rescue ActiveRecord::RecordNotFound => e
              error!("#{e}", 404)
            end
          end

          # delete
          params do
            requires :id, type: String
          end
          delete "hdr_account/(:id)" do
            begin
              HdrAccount.destroy(params[:id])
            rescue ActiveRecord::RecordNotFound => e
              error!("#{e}", 404)
            end
          end

          # refresh token
          params do
            requires :id, type: String
          end
          get "hdr_account/(:id)/refresh_token" do
            begin
              account = HdrAccount.find(params[:id])
              access_token = account.generate_access_token
              account.save
              { access_token: access_token }
            rescue ActiveRecord::RecordNotFound => e
              error!("#{e}", 404)
            end
          end
        end
      end
    end
  end
end
