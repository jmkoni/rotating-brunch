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
          text: ":wave: Hi #{group_usernames}! You've both been grouped up for a coffee chat from #meet-splice! Find a time to meet and have fun!"
        }
      }
    ]
  end

  def error_message(error:)
    if error.backtrace
      backtrace = []
      error.backtrace.first(10).each do |trace|
        backtrace << trace
      end
      backtrace_block = {
        type: "section",
        block_id: "backtrace",
        text: {
          type: "mrkdwn",
          text: "*Backtrace:*\n```\n" + backtrace.join("\n") + "```"
        }
      }
    end
    primary = [
      {
        type: "section",
        block_id: "error_message",
        text: {
          type: "mrkdwn",
          text: "MEET SPLICE IS DOWN! Please investigate.\n\n*Message:* #{error.message}"
        }
      }
    ]
    primary << backtrace_block if backtrace_block
    primary
  end
end
