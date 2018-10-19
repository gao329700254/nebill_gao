module Chatwork
  class Base
    include ActiveModel::Model

    VIEW_FILE_ROOT = Rails.root.join('app', 'views', 'chatworks').freeze

    delegate :api_prefix, :enable?, to: :class

    class << self
      def enable?
        ENV['CHATWORK_API_TOKEN'].present? && ENV['CHATWORK_ROOM_ID'].present?
      end

      def api_prefix
        Pathname.new('/v2/rooms').join(ENV['CHATWORK_ROOM_ID'])
      end
    end

    def send_message(body)
      return false unless enable?

      res = api_client.post("#{api_prefix}/messages", body: body)

      Rails.logger.error("chatwork send message eroor! #{res.body}") unless res.success?

      res.success?
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
            "X-ChatWorkToken" => ENV['CHATWORK_API_TOKEN'],
          },
        )
      end
    end
  end
end
