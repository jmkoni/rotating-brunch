module SlackMessage
  module_function

  def group_message(group:)
    group_usernames = group.map { |user| "<@#{user}>" }.to_sentence
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
