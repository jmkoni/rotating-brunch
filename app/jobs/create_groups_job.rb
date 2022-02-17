class CreateGroupsJob < ApplicationJob
  MAX_GROUP_SIZE = 4

  class << self
    def perform
      date = Date.today
      if date.monday? && date.cweek.even?
        perform!
      end
    end

    def perform!
      Rails.logger.info("Running CreateGroupsJob")
      members = Slack::Client.get_channel_users
      groups = group_members(members: members)
      start_conversations(groups: groups)
    rescue => e
      Rails.logger.error("MEET SPLICE IS DOWN: #{e}")
      Slack::Client.send_error_message(error: e)
    end

    def group_members(members:)
      groups = []
      members.shuffle!
      groups << members.shift(MAX_GROUP_SIZE) while members.any?
      balance_groups(groups)
    end

    def balance_groups(groups)
      return groups if groups.length < 2
      i = -2
      while groups.last.length < (MAX_GROUP_SIZE - 1)
        groups.last << groups[i].pop
        i -= 1
      end
      groups
    end

    def start_conversations(groups:)
      groups.each do |group|
        Slack::Client.create_conversation(group: group)
      end
    end
  end
end
