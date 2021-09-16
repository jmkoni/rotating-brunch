module Slack
  class Client
    attr_reader :client

    class << self
      def get_channel_users(client: nil)
        client ||= default_client
        members = client.conversations_members(
          channel: ENV["GROUP_CHANNEL"],
          limit: 10000
        )
        # don't put channitor in a group
        members.members.reject!{|m| m == "U02F2U3RQKS" }
      end

      def create_conversation(group:)
        client ||= default_client
        conv = client.conversations_open(users: group.join(","))
        client.chat_postMessage(
          channel: conv.channel.id,
          blocks: SlackMessage.group_message(group: group)
        )
      end

      private

      def default_client
        ::Slack::Web::Client.new(token: ENV["SLACK_OAUTH_TOKEN"])
      end
    end
  end
end
