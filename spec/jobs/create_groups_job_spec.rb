require "rails_helper"

RSpec.describe CreateGroupsJob do
  it "groups people" do
    allow(Date).to receive(:today).and_return(Date.new(2021,6,7))
    allow(Slack::Client).to receive(:get_channel_users).and_return((1..22).to_a)
    allow(Slack::Client).to receive(:create_conversation).exactly(6)
    CreateGroupsJob.perform
  end
end
