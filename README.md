# Rotating Brunch

This application is intended to be a self-hosted version of Donut.

## System Requirements

This application uses Ruby 3.0. I recommend installing either rvm or rbenv and using a gemset (if you have either of those installed, `.ruby-gemset` should autocreate this).

## App Setup Instructions

1. Follow instructions and [create a new slack app](https://api.slack.com/authentication/basics)
2. Add the following scopes to your slack app: `users:read`, `mpim:write`, `im:write`, `chat:write`, `channels:join`, `channels:manage`, `groups:write`, `groups:read`, `mpim:read`, `im:read`, and `channels:read`.
4. Create a new app in Heroku or your hosting service of choice. Go to wherever you can add environment variables.
5. Set `MIN_GROUP_SIZE` to 3.
6. Get your oauth token for your newly created slack app (must be installed first). Store this as `SLACK_OAUTH_TOKEN`.
7. Open up the channel you want to use the app in in your browser and get the channel ID. It should start with a "C". Store this as `GROUP_CHANNEL`.
8. If you are setting this up, send error messages to yourself by setting `USER_ID_FOR_ERROR` to your Slack user id.
9. Update [`SlackMessage`](https://github.com/jmkoni/rotating-brunch/blob/meet-splice/app/models/slack_message.rb) to use whatever channel name you are adding it to.
10. Currently, the job will [only run on Mondays on even weeks](https://github.com/jmkoni/rotating_brunch/blob/meet-splice/app/jobs/create_groups_job.rb#L7). Update this if you want to change it.
11. Deploy app to Heroku (or your hosting service of choice).
12. If using Heroku, install Heroku Scheduler.
13. Schedule `rake create_groups` to run every day at a time of your choice. If you have a hosting service that will allow you to run cron jobs, you can remove the code mentioned above that checks that day and week and just use cron format. If using Heroku, just run daily and it will quit if it's not the right day 🙂
14. PROFIT!

**NOTE:** To run locally, set those environment variables in your local `.env` file in project's root directory as well. `.env` will be ignored by git.

## Linting and Tests

There is currently one test that you can run by running `rspec`. To lint this project, run `bundle exec standardrb --fix`.
