
require(RGA)
library(httr)
RGA


# 1. Find OAuth settings for google:
#    https://developers.google.com/accounts/docs/OAuth2InstalledApp
oauth_endpoints("google")

# 2. Register an application at https://cloud.google.com/console#/project
#    Insert your values below - if secret is omitted, it will look it up in
#    the GOOGLE_CONSUMER_SECRET environmental variable.
myapp <- oauth_app("google", "92236194482-n8v0o4fnlnq6jc9tfhg50p8a2ljf9n0n.apps.googleusercontent.com", secret = "1JgK9ZzKGgq6OKOcAZTwFQ85")

# 3. Get OAuth credentials
google_token <- oauth2.0_token(oauth_endpoints("google"), myapp,
                               scope = "https://www.googleapis.com/auth/userinfo.profile")

# 4. Use API
req <- GET("https://www.googleapis.com/oauth2/v1/userinfo",
           config(token = google_token))
stop_for_status(req)
content(req)








get_ga("9598333-1", start.date = "7daysAgo", end.date = "yesterday",
       metrics = "ga:users,ga:sessions,ga:pageviews",
       max.results = NULL, token = google_token, verbose = getOption("rga.verbose", FALSE)