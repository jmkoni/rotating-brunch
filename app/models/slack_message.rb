module SlackMessage
  module_function

  def group_message(group:)
    group_usernames = ""
    group_usernames = " <@#{group[0]}>, <@#{group[1]}>, and <@#{group[2]}>" if group.size == 3
    group_usernames = " <@#{group[0]}>, <@#{group[1]}>, <@#{group[2]}>, and <@#{group[3]}" if group.size == 4
    [
      {
        type: "section",
        block_id: "group_introduction",
        text: {
          type: "mrkdwn",
          text: ":wave: Hi#{group_usernames}! You've both been grouped up for a coffee chat from #rotating-brunch! Find a time to meet (Calendly is great for this) and have fun!"
        }
      }
    ]
  end
end
