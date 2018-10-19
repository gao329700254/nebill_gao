module Chatwork
  class Member < Base
    def self.member_list
      return [] unless enable?

      res = new.api_client.get("#{api_prefix}/members")

      return [] unless res.success?

      JSON.parse(res.body).map(&:with_indifferent_access)
    end
  end
end
