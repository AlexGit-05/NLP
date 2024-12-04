# Read data from CSV file
df <- read.csv("qatar.csv")
df$created_at[1]

# Load required libraries
library(dplyr)                 # Data manipulation
library(ggplot2)               # Data visualization
library(quanteda)              # Text analysis
library(rtweet)                # Twitter data handling
library(tidyr)                 # Tidy data operations
library(tidytext)              # Text mining and analysis
library(corrplot)              # Correlation plot
library(epiDisplay)            # Epidemiological data display
library(Hmisc)                 # Harrell Miscellaneous (used for correlation matrix)
library(lm.beta)               # Standardized beta coefficients
library(psych)                 # Psychological and statistical functions
library(stargazer)             # Table creation
library(writexl)               # Excel writing capabilities
library(textdata)              # Text mining tools


# Data preprocessing
df <- df %>%
  mutate(datetime = as.POSIXct(created_at),
         row_num = row_number(),
         raw_text = tweet)

# Time series plot
ts_plot(df) # frequency of text by day

ts_plot(df, by="hours", col="violet", lwd=1) + 
  theme_classic() # frequency of text by hour

# Clean tweet text
df <- df %>%
  mutate(clean_tweet = tweet,
         clean_tweet = gsub("<U\\+?[0-9a-fA-F]+>", " ", clean_tweet),  # Remove unicode characters
         clean_tweet = tolower(clean_tweet),  # Convert text to lowercase
         clean_tweet = gsub("@\\S+", "", clean_tweet),  # Remove mentions (@username)
         clean_tweet = gsub("http(s?):\\S+", "", clean_tweet),  # Remove URLs
         clean_tweet = gsub("#\\S+", "", clean_tweet),  # Remove hashtags
         clean_tweet = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", clean_tweet),  # Remove retweets
         clean_tweet = gsub("[[:punct:]]", "", clean_tweet),  # Remove punctuation
         clean_tweet = gsub("[^\x20-\x7E]", "", clean_tweet),  # Remove non-ASCII characters
         clean_tweet = gsub("[[:digit:]]", "", clean_tweet),  # Remove digits
         clean_tweet = gsub("\n", " ", clean_tweet),  # Replace newline characters with space
         clean_tweet = gsub("^\\s+|\\s+$|\\s+(?=\\s)", "", clean_tweet, perl=T))  # Remove leading, trailing, and multiple consecutive spaces

# Create a new dataframe with tokenized and cleaned tweet
df_nrc <- df %>% 
  dplyr::select(row_num, clean_tweet) %>% 
  unnest_tokens(input = clean_tweet, output = word) %>% # tokenizing words in the clean tweets
  filter(!word %in% stop_words$word) %>% # removing stop words (articles and conjuctions)
  dplyr::group_by(row_num) %>% # grouping by ranks
  summarise(cleaner_tweet = paste(word, collapse = " "))

# Merge dataframes
df <- df %>% 
  left_join(df_nrc, by = row_num)

# Extract keywords and write to Excel file
keywords <- df %>%
  dplyr::select(row_num, clean_tweet) %>%
  unnest_tokens(clean_tweet, output=word) %>%
  filter(!word %in% stop_words$word) %>%
  count(word) %>%
  arrange(-n)

write_xlsx(keywords, "keywords.xlsx")

# Analyze sentiments
nrc <- get_sentiments("nrc")

nrc %>%
  count(sentiment) %>%
  arrange(-n)

# Merge sentiment data
df_nrc <- df %>%
  group_by(row_num) %>%
  unnest_tokens(cleaner_tweet, output=word) %>%
  full_join(get_sentiments("nrc")) %>%
  count(sentiment) %>%
  spread(sentiment, n, fill=0)

df <- df %>%
  left_join(df_nrc)

# Write final dataframe to CSV
write.csv(df, "data_with_sentiments.csv")

# Create custom dictionaries
danger.lexicon <- dictionary(
  list(danger = c(
    "assassin*", "behead*", "danger", "death", 
    "eliminat*", "execut*", "exterminat*", "hang*",
    "kill", "lethal", "murder*", "risk*", "shoot",
    "shot", "threat"
  ))
)

qatar.lexicon <- dictionary(
  list(danger = c(
    "qatar", "world", "cup", "people", "fifa", "joy", "best", 
    "worst", "attention", "asia", "europe", "africa"
  ))
)

qatar = c("saudi", "uae", "fifa", "psg", "emirates",
          "turkey", "saudis", "pakistan", "islam",
          "morocco", "iranian")

women = c("female", "men", "adult", "girls", "child",
          "wife", "lady", "girlfriend")

qatar.lexicon <- dictionary(
  list(danger = c(
    "qatar", "world", "cup", "people", "fifa",
    "worst", "attention", "asia", "europe", "africa"
  ))
)

