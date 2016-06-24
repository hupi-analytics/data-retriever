module ApiEndpoint
  extend Grape::API::Helpers

  def action_on_query(action, query, type, obj_params)
    if query
      error!("Endpoint Disable for API request", 404) unless query.hdr_endpoint.api || current_account.superadmin?
      error!("Unauthorized", 401) unless query_authorized?(type, current_account, query, params[:client])

      query_engine = DataRetriever::QueryEngines.get(query.hdr_query_engine, params[:client])
      query_filter = query.get_filters(params[:filters])
      query_params = params[:query_params] || {}
      query_decorated = query_engine.decorate(query.query, query_filter, query_params)
      logger.debug(desc: "QUERY DEBUG", hqe_engine: query.hdr_query_engine.engine, hqe_name: query.hdr_query_engine.name, query: query_decorated)
      info = {
        module_name: query.hdr_endpoint.module_name,
        method_name: query.hdr_endpoint.method_name,
        updated_at: query.updated_at,
        query_object_name: query.name || "default"
      }
      begin
        cursor = query_engine.send(action, query_decorated, info)
      rescue IOError, Mysql2::Error, PG::UnableToSend
        query_engine.reload
        cursor = query_engine.send(action, query_decorated, info)
      end
      if action == "execute"
        het = HdrExportType.find_by("? = ANY(hdr_export_types.render_types)", params[:render_type])
        { data: Export.send(het.name, cursor, query_params) }
      else
        { data: cursor }
      end
    else
      check_endpoint_error(type, obj_params, params[:render_types])
    end
  end

  def check_endpoint_error(type, obj_params, render_type)
    obj = if type == "hqo_id"
            HdrQueryObject.find_by(obj_params)
          else
            HdrEndpoint.find_by(obj_params)
          end

    if obj && !obj.render_types.include?(render_type)
      error!("render_type should be one of: #{obj.render_types}", 400)
    elsif obj && type == "public" && !obj.hdr_account.nil?
      error!("not a public endpoint", 400)
    elsif obj && type == "private" && obj.hdr_account.nil?
      error!("not a private endpoint", 400)
    elsif obj.nil?
      error!("not found with: #{obj_params}", 404)
    else
      if type == "hqo_id"
        logger.error(desc: "QUERY OBJECT ERROR", query_object: endpoint.inspect)
      else
        logger.error(desc: "ENDPOINT ERROR", endpoint: endpoint.inspect)
      end
      error!("error unknown", 400)
    end
  end

  def query_authorized?(type, current_account, query, client)
    case type
    when "public"
      (current_account.superadmin? || (query.hdr_endpoint.hdr_account.nil? && current_account.name == client))
    when "private"
      (current_account.superadmin? || current_account == query.hdr_endpoint.hdr_account)
    when "id", "hqo_id"
      (current_account.superadmin? || current_account == query.hdr_endpoint.hdr_account || (query.hdr_endpoint.hdr_account.nil? && current_account.name == client))
    else
      false
    end
  end
end
