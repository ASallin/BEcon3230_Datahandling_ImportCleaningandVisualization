# Text analysis
# Data Handling lecture 10
# A. Sallin, 2024

# Import packages

pacman::p_load(
  tidytext,
  quanteda,
  readtext,
  stringr,
  quanteda.textstats,
  quanteda.textplots
)


## From Raw Text to Corpus
# set path to the package folder
path_data <- system.file("extdata/", package = "readtext")

# import csv file
dat_inaug <- read.csv(paste0(path_data, "/csv/inaugCorpus.csv"))
names(dat_inaug)


## Create a corpus
corp <- corpus(dat_inaug, text_field = "texts")
print(corp)

# Look at the metadata in the corpus using `docvars`
docvars(corp)

# In quanteda, the metadata in a corpus can be handled like data frames.
docvars(corp, field = "Century") <- floor(docvars(corp, field = "Year") / 100) + 1


## Regular Expressions
# Count occurences of the word "peace"
str_count(corp, "[Pp]eace")

# Count occurences of the words "peace" OR "war"
str_count(corp, "[Pp]eace|[Ww]ar")


## Regular Expressions
# Count occurences of the mention of the first person pronoun "I"
str_count(corp, "I") # counts the number of "I" occurences. This is not what we want.
str_count(corp, "[I][[:space:]]") # counts the number of "I" followed by a space.

# Extract the first five words of each discourse
str_extract(corp, "^(\\S+\\s|[[:punct:]]|\\n){5}") # ^serves to anchor at the beginning of the string, (){5} shows the group of signs must be detected five times. \S if for any non-space character,  \s is for space, [[:punct:]] for punctuation, and \n for the string representation of paragraphs. Basically, it means: five the first five occurences of many non-space characters (+) followed either (|) by a space, a punctuation sign, or a paragraph sign.


## From Corpus to Tokens
toks <- tokens(corp)
head(toks[[1]], 20)


## From Corpus to Tokens
# Remove punctuation
toks <- tokens(corp, remove_punct = TRUE)
head(toks[[1]], 20)

# Remove stopwords
stopwords("en")
toks <- tokens_remove(toks, pattern = stopwords("en"))
head(toks[[1]], 20)


## From Corpus to Tokens
# We can keep words we are interested in
tokens_select(toks, pattern = c("peace", "war", "great*", "unit*"))


## From Corpus to Tokens
# Remove "fellow" and "citizen"
toks <- tokens_remove(toks, pattern = c(
  "fellow*",
  "citizen*",
  "senate",
  "house",
  "representative*",
  "constitution"
))

## From Corpus to Tokens
# Build N-grams (onegrams, bigrams, and 3-grams)
toks_ngrams <- tokens_ngrams(toks, n = 2:3)

# Build N-grams based on a structure: keep n-grams that containt a "never"
toks_neg_bigram_select <- tokens_select(toks_ngrams, pattern = phrase("never_*"))
head(toks_neg_bigram_select[[1]], 30)


## From Tokens to Document-Term Matrix
- **DTM**: Rows = documents, Columns = tokens.
- Contains count frequencies or indicators.
- Use domain knowledge to reduce DTM dimensions.

dfmat <- dfm(toks)
print(dfmat)

dfmat <- dfm_trim(dfmat, min_termfreq = 2) # remove tokens that appear less than 1 times


## Analyzing DTMs
library(quanteda.textstats)
tstat_freq <- textstat_frequency(dfmat, n = 5)
topfeatures(dfmat, 10)


## Statistics 
library(quanteda.textplots)
quanteda.textplots::textplot_wordcloud(dfmat, max_words = 100)

# END