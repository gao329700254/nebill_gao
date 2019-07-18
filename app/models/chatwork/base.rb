module Chatwork
  class Base
    include ActiveModel::Model

    VIEW_FILE_ROOT = Rails.root.join('app', 'views', 'chatworks').freeze

    delegate :api_prefix, :enable?, to: :class

    class << self
      def enable?
        Rails.configuration.x.chatwork_api_token.present? && Rails.configuration.x.chatwork_room_id.present?
      end

      def api_prefix
        Pathname.new('/v2/rooms').join(Rails.configuration.x.chatwork_room_id)
      end

      def get(url, **params)
        res = new.api_client.get(url, params)

        Rails.logger.error("chatwork send message eroor! #{res.body}") unless res.success?

        return false unless res.success?

        begin
          JSON.parse(res.body)
        rescue
          nil
        end
      end

      def post(url, **params)
        res = new.api_client.post(url, params)

        Rails.logger.error("chatwork send message eroor! #{res.body}") unless res.success?

        res.success?
      end
    end

    def send_message(body)
      return false unless enable?

      self.class.post("#{api_prefix}/messages", body: body)
    end

    def render(path)
      text = File.read(VIEW_FILE_ROOT.join("#{path}.txt.erb"))
      text = text.split("\n").map(&:strip).map { |line| line[0] == '[' ? line : "#{line}\n" }.join
      Erubis::Eruby.new(text).result(binding)
    end

    def annotate_to(user)
      I18n.t('chatwork.annotate_to', id: user.chatwork_id, name: user.chatwork_name)
    end

    # APIベース
    def api_client
      @api_client ||= begin
        Faraday.new(
          url: 'https://api.chatwork.com',
          headers: {
            "Content-type" => "application/x-www-form-urlencoded;charset=UTF-8",
            "X-ChatWorkToken" => Rails.configuration.x.chatwork_api_token,
          },
        )
      end
    end
  end
end
