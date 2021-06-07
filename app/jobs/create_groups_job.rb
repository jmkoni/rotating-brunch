class CreateGroupsJob < ApplicationJob
  MAX_GROUP_SIZE = 4

  def self.perform
    date = Date.today
    if date.monday? && date.cweek.odd?
      Rails.logger.info("Running CreateGroupsJob")
      members = Slack::Client.get_channel_users
      groups = group_members(members: members)
      start_conversations(groups: groups)
    end
  end

  def self.group_members(members:)
    groups = []
    members.shuffle!
    groups << members.shift(MAX_GROUP_SIZE) while members.any?
    i = -2
    while groups.last.length < (MAX_GROUP_SIZE - 1)
      groups.last << groups[i].pop
      i -= 1
    end
    groups
  end

  def self.start_conversations(groups:)
    groups.each do |group|
      Slack::Client.create_conversation(group: group)
    end
  end
end
