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
    while members.size > 9
      members, groups = group(members: members, groups: groups, num: 4)
    end
    if members.size == 9
      3.times { members, groups = group(members: members, groups: groups, num: 3) }
    elsif members.size == 8
      2.times { members, groups = group(members: members, groups: groups, num: 4) }
    elsif members.size == 7
      members, groups = group(members: members, groups: groups, num: 4)
      members, groups = group(members: members, groups: groups, num: 3)
    elsif members.size == 6
      2.times { members, groups = group(members: members, groups: groups, num: 3) }
    end
    groups << members.to_a if members.size > 0
    groups
  end

  def self.start_conversations(groups:)
    groups.each do |group|
      Slack::Client.create_conversation(group: group)
    end
  end

  private
  def self.group(members:, groups:, num:)
    temp_group = members.sample(num)
    groups << temp_group
    temp_group.each { |group| members.delete(group) }
    [members, groups]
  end
end
