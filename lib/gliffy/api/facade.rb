module Gliffy
  class API
    class Facade
      def self.http(api)
        Facade.new("http", api)
      end

      def self.https(api)
        Facade.new("https", api)
      end

      def raw(partial_url, params = {})
        @api.raw(api_root + partial_url, params)
      end

      def get(partial_url, params)
        @api.get(api_root + partial_url, params)
      end

      def post(partial_url, params)
        @api.post(api_root + partial_url, params)
      end

      def web(partial_url, params)
        @api.web(web_root + partial_url, params)
      end

      def get_folders(account_id)
        get("/accounts/#{account_id}/folders.xml",
            :action => 'get')
      end

      def update_document_metadata(document_id, name, shared)
        params = {
          :action => "update",
        }

        if not name.nil?
          params[:documentName] = name
        end

        if not shared.nil?
          params[:public] = shared ? "true" : "false"
        end

        post("/accounts/#{account_id}/documents/#{document_id}/meta-data.xml",
             params)
      end

      private

      def api
        @api
      end

      def account_id
        api.account_id
      end

      def initialize(protocol, api)
        @protocol = protocol
        @api = api
      end

      def api_root
        @protocol + ":" + Gliffy.api_root
      end

      def web_root
        @protocol + ":" + Gliffy.web_root
      end
    end
  end
end
