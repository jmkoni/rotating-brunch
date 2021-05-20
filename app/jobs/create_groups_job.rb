class CreateGroupsJob < ApplicationJob
  def self.perform
    date = Date.today
    if date.monday? && date.cweek.even?
      Rails.logger.info("Running CreateGroupsJob")
      members = Slack::Client.get_channel_users
      groups = group_members(members: members)
      start_conversations(groups: groups)
    end
  end

  def self.group_members(members:)
    groups = []
    members.shuffle!
    groups << members.shift(4) while members.any?
    i = -2
    while groups.last.length < 3
      groups.last << groups[i].pop
      i -= 1
    end
  end

  def self.start_conversations(groups:)
    groups.each do |group|
      Slack::Client.create_conversation(group: group)
    end
  end
end
