library(rtweet)

token <- create_token(
  app = "public_health_grisanti",
  consumer_key = "XXXXXXX",
  consumer_secret = "XXXXXXX",
  acess_token = "XXXXXXXX",
  access_secret = "XXXXXX")


# post a tweet from R
post_tweet("accesing twitter data through R PC - 11/21 #hack")
## your tweet has been posted!
health_tweets <- search_tweets(q = "ill OR #ill OR ills OR sick OR #health OR sicker OR ailling", 
                               n = 100000,
                               lang = "en",
                               include_rts = FALSE,
                               retryonratelimit = TRUE,
                               geocode = lookup_coords("usa")
)

# load twitter library - the rtweet library is recommended now over twitteR
library(rtweet)
# plotting and pipes - tidyverse!
library(ggplot2)
library(dplyr)
# text mining library
library(tidytext)

# remove urls tidyverse is failing here for some reason
# climate_tweets %>%
#  mutate_at(c("stripped_text"), gsub("http.*","",.))

# remove http elements manually
health_tweets$stripped_text <- gsub("http.*","",  health_tweets$text)
health_tweets$stripped_text <- gsub("https.*","", health_tweets$stripped_text)

# remove punctuation, convert to lowercase, add id for each tweet!
health_words <- health_tweets %>% dplyr::select(stripped_text) %>% unnest_tokens(word, stripped_text)

# plot the top 15 words -- notice any issues?
health_tweets_clean %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Count",
       y = "Unique words",
       title = "Count of unique words found in tweets")

# load list of stop words - from the tidytext package
data("stop_words")
# remove stop words from your list of words
health_words_clean <- health_words %>% anti_join(stop_words)

# plot the top 15 words -- notice any issues?
health_words_clean %>%
  count(word, sort = TRUE) %>%
  top_n(200) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(y = "Count",
       x = "Unique words",
       title = "Count of unique words found in tweets",
       subtitle = "Stop words removed from the list")
