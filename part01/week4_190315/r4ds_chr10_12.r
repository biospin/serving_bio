setwd("C:\\r4ds")
install.packages("tidyverse")
install.packages("nycflights13")
library(tidyverse)

### chapter 10.

library(tidyverse)
library(nycflights13)

# nycfligths13 packages

airlines
airports
planes
weather

knitr::include_graphics("diagrams/relational-nycflights.png")


## Keys

planes %>% 
  count(tailnum) %>% 
  filter(n > 1)

weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1)

flights %>% 
  count(year, month, day, flight) %>% 
  filter(n > 1)

flights %>% 
  count(year, month, day, tailnum) %>% 
  filter(n > 1)


## Mutating joins {#mutating-joins}

flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

flights2 %>%
  select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier")

flights2 %>%
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)

### Inner join {#inner-join}

x %>% 
  inner_join(y, by = "key")

### Outer joins {#outer-join}

### Duplicate keys {#join-matches}

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)

left_join(x, y, by = "key")

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)

left_join(x, y, by = "key")


### Defining the key columns {#join-by}

flights2 %>% 
  left_join(weather)

flights2 %>% 
  left_join(planes, by = "tailnum")

flights2 %>% 
  left_join(airports, c("dest" = "faa"))

flights2 %>% 
  left_join(airports, c("origin" = "faa"))


### Other implementations

## Filtering joins {#filtering-joins}

top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest

flights %>% 
  filter(dest %in% top_dest$dest)

flights %>% 
  semi_join(top_dest)

flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)

## Join problems

airports %>% count(alt, lon) %>% filter(n > 1)


## Set operations {#set-operations}

df1 <- tribble(
  ~x, ~y,
  1,  1,
  2,  1
)

df2 <- tribble(
  ~x, ~y,
  1,  1,
  1,  2
)

intersect(df1, df2)
# Note that we get 3 rows, not 4
union(df1, df2)
setdiff(df1, df2)
setdiff(df2, df1)


###########################
# 11. manipulating string

library(tidyverse)
library(stringr)

string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'

"This is a string without a closing quote
 
 
HELP I\'M STUCK"

double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"

x <- c("\"", "\\")
x
writeLines(x)

x <- "\u00b5"
x

c("one", "two", "three")


### String length

str_length(c("a", "R for data science", NA))

str_
str

### Combining strings

str_c("x", "y")
str_c("x", "y", "z")

str_c("x", "y", sep = ", ")

x <- c("abc", NA)
str_c("|-", x, "-|")
str_c("|-", str_replace_na(x), "-|")

# str_c()는 벡터화되고 짧은 벡터가 긴 벡터와 길이가 같도록 재사용된다.
str_c("prefix-", c("a", "b", "c"), "-suffix")

name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE

str_c(
  "Good ", time_of_day, " ", name,
  if (birthday) " and HAPPY BIRTHDAY",
  "."
)

str_c(c("x", "y", "z"), collapse = ", ")

### Subsetting strings

x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
# negative numbers count backwards from end
str_sub(x, -3, -1)

str_sub("a", 1, 5)

str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x

### Locales

# Turkish has two i's: with and without a dot, and it
# has a different rule for capitalising them:
str_to_upper(c("i", "ı"))
str_to_upper(c("i", "ı"), locale = "tr")

x <- c("apple", "eggplant", "banana")
str_sort(x, locale = "en")  # English
str_sort(x, locale = "haw") # Hawaiian


## Matching patterns with regular expressions

x <- c("apple", "banana", "pear")
str_view(x, "an")

# to occur error
# Error in loadNamespace(name) : there is no package called ‘htmlwidgets’

install.packages("htmlwidgets")
library(htmlwidgets)

str_view(x, "an")

str_view(x, ".a.")

# To create the regular expression, we need \\
dot <- "\\."
# But the expression itself only contains one:
writeLines(dot)
# And this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a\\.c")

x <- "a\\b"
writeLines(x)
str_view(x, "\\\\")


### Anchors

* `^` to match the start of the string.
* `$` to match the end of the string.

x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$")

# “파워(^)로 시작하면, 돈($)으로 끝나게 한다.”

x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")
str_view(x, "^apple$")


### Character classes and alternatives

str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")
str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")
str_view(c("abc", "a.c", "a*c", "a c"), "a[ ]")

str_view(c("grey", "gray"), "gr(e|a)y")


### Repetition

x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
str_view(x, "CC+")
str_view(x, 'C[LX]+')


str_view(x, "C{2}")
str_view(x, "C{2,}")
str_view(x, "C{2,3}")

str_view(x, 'C{2,3}?')
str_view(x, 'C[LX]+?')


### Grouping and backreferences

str_view(fruit, "(..)\\1", match = TRUE)


## Tools


### Detect matches

x <- c("apple", "banana", "pear")
str_detect(x, "e")

# How many common words start with t?
sum(str_detect(words, "^t"))
# What proportion of common words end with a vowel?
mean(str_detect(words, "[aeiou]$"))

# Find all words containing at least one vowel, and negate
no_vowels_1 <- !str_detect(words, "[aeiou]")
# Find all words consisting only of consonants (non-vowels)
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")
identical(no_vowels_1, no_vowels_2)

words[str_detect(words, "x$")]
str_subset(words, "x$")

# if data.frame case, to use filter
df <- tibble(
  word = words, 
  i = seq_along(word)
)
df %>% 
  filter(str_detect(word, "x$"))

x <- c("apple", "banana", "pear")
str_count(x, "a")
# On average, how many vowels per word?
mean(str_count(words, "[aeiou]"))

df %>% 
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )

str_count("abababa", "aba")
str_view_all("abababa", "aba")


### Extract matches

length(sentences)
head(sentences)

colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")
colour_match

has_colour <- str_subset(sentences, colour_match)
matches <- str_extract(has_colour, colour_match)
head(matches)

more <- sentences[str_count(sentences, colour_match) > 1]
str_view_all(more, colour_match)
str_extract(more, colour_match)

str_extract_all(more, colour_match)

str_extract_all(more, colour_match, simplify = TRUE)
x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify = TRUE)


### Grouped matches - 명사 찾ㄱ

# definition : 최소 하나 이상의 문자(공백제외) 시퀀스찾기


noun <- "(a|the) ([^ ]+)"
has_noun <- sentences %>%
  str_subset(noun) %>%
  head(10)
has_noun %>% 
  str_extract(noun)

has_noun %>% 
  str_match(noun)

tibble(sentence = sentences) %>% 
  tidyr::extract(
    sentence, c("article", "noun"), "(a|the) ([^ ]+)", 
    remove = FALSE
  )


### Replacing matches

x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
str_replace_all(x, "[aeiou]", "-")

x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>% 
  head(5)

### Splitting

sentences %>%
  head(5) %>% 
  str_split(" ")

"a|b|c|d" %>% 
  str_split("\\|") %>% 
  .[[1]]

sentences %>%
  head(5) %>% 
  str_split(" ", simplify = TRUE)

fields <- c("Name: Hadley", "Country: NZ", "Age: 35")
fields %>% str_split(": ", n = 2, simplify = TRUE)

x <- "This is a sentence.  This is another sentence."
str_view_all(x, boundary("word"))
str_split(x, " ")[[1]]
str_split(x, boundary("word"))[[1]]


### Find matches

## Other types of pattern

# The regular call:
str_view(fruit, "nana")
# Is shorthand for
str_view(fruit, regex("nana"))

bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = TRUE))

x <- "Line 1\nLine 2\nLine 3"
str_extract_all(x, "^Line")[[1]]
str_extract_all(x, regex("^Line", multiline = TRUE))[[1]]

phone <- regex("
      \\(?     # optional opening parens
      (\\d{3}) # area code
      [) -]?   # optional closing parens, space, or dash
      (\\d{3}) # another three numbers
      [ -]?    # optional space or dash
      (\\d{3}) # three more numbers
      ", comments = TRUE)

str_match("514-791-8141", phone)


install.packages("microbenchmark")
library(microbenchmark)

microbenchmark::microbenchmark(
  fixed = str_detect(sentences, fixed("the")),
  regex = str_detect(sentences, "the"),
  times = 20
)

a1 <- "\u00e1"
a2 <- "a\u0301"
c(a1, a2)
a1 == a2


str_detect(a1, fixed(a2))
str_detect(a1, coll(a2))

# That means you also need to be aware of the difference
# when doing case insensitive matches:
i <- c("I", "İ", "i", "ı")
i

str_subset(i, coll("i", ignore_case = TRUE))
str_subset(i, coll("i", ignore_case = TRUE, locale = "tr"))

## Other uses of regular expressions

apropos("replace")
head(dir(pattern = "\\.Rmd$"))



#####################################################################

# Factors

install.packages("forcats")
library(forcats)

x1 <- c("Dec", "Apr", "Jan", "Mar")

x2 <- c("Dec", "Apr", "Jam", "Mar")

sort(x1)

month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)

y1 <- factor(x1, levels = month_levels)
y1
sort(y1)

y2 <- factor(x2, levels = month_levels)
y2

install.packages("readr")
library(readr)

y2 <- parse_factor(x2, levels = month_levels) # install readr

factor(x1)

f1 <- factor(x1, levels = unique(x1))
f1
f2 <- x1 %>% factor() %>% fct_inorder()
f2

levels(f2)


## General Social Survey

gss_cat
?gss_cat

gss_cat %>%  
  count(race)

install.packages("ggplot2")
library(ggplot2)

ggplot(gss_cat, aes(race)) +
  geom_bar()

ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)


## Modifying factor order

relig_summary <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(relig_summary, aes(tvhours, relig)) + geom_point()

ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

relig_summary %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()


rincome_summary <- gss_cat %>%
  group_by(rincome) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
ggplot(rincome_summary, aes(age, fct_reorder(rincome, age))) + geom_point()

ggplot(rincome_summary, aes(age, fct_relevel(rincome, "Not applicable"))) +
  geom_point()


by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  count(age, marital) %>%
  group_by(age) %>%
  mutate(prop = n / sum(n))

ggplot(by_age, aes(age, prop, colour = marital)) +
  geom_line(na.rm = TRUE)

ggplot(by_age, aes(age, prop, colour = fct_reorder2(marital, age, prop))) +
  geom_line() +
  labs(colour = "marital")

# fct_rev() : reverse order
gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) +
  geom_bar()


## Modifying factor levels

gss_cat %>% count(partyid)

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat"
  )) %>%
  count(partyid)

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat",
                              "Other"                 = "No answer",
                              "Other"                 = "Don't know",
                              "Other"                 = "Other party"
  )) %>%
  count(partyid)

gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat")
  )) %>%
  count(partyid)

# tide simple way
gss_cat %>%
  mutate(relig = fct_lump(relig)) %>%
  count(relig)

gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = TRUE) %>%
  print(n = Inf)
