module Gliffy
  class Account
    TYPE_BUSINESS = "Business"

    attr_reader :api
    attr_reader :id
    attr_reader :name
    attr_reader :max_users, :type, :terms_accepted
    attr_reader :expiration_date

    def self.load(api, response)
      Gliffy::Account.new(
        api,
        :id => response.integer('//g:account/@id'),
        :name => response.string('//g:account/g:name'),
        :max_users => response.integer('//g:account/@max-users'),
        :type => response.string('//g:account/@account-type'),
        :terms_accepted => response.string('//g:account/@terms') == "true",
        :expiration_date => response.timestamp('//g:account/g:expiration-date')
      )
    end

    def root
      @root ||= load_root
    end

    def users
      api.get_users(id)
        .nodes('//g:user')
        .map { |n| load_user n }
    end

    def document(document_id)
      response = api.get("/accounts/#{id}/documents/#{document_id}/meta-data.xml",
                         :action => 'get')

      Gliffy::Document.load(
        self,
        response.node('//g:document')
      )
    end

    private

    def initialize(api, params)
      @api = api

      @id = params[:id]
      @name = params[:name]
      @max_users = params[:max_users]
      @type = params[:type]
      @terms_accepted = params[:terms_accepted]
      @expiration_date = params[:expiration_date]
    end

    def load_root
      response = api.get_folders(id)

      Gliffy::Folder.load(
        self,
        response.node("/g:response/g:folders/g:folder")
      )
    end

    def load_user(node)
      Gliffy::User.load(self, node)
    end
  end
end
