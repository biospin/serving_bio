#Chapter 7:Tibbles with tibble
#Creating Tibbles
library(tidyverse)
as_tibble(iris)
tibble(
  x=1:5,
  y=1,
  z=x^2+y
)
tb <- tibble(
  `:)`="smile",
  ` `="space",
  `2000`="number"
)
tb
tribble(
  ~x,~y,~z,
  "a",2,3.6,
  "b",1,8.5
)
#Tibbles Versus data.frame
#Printing
tibble(
  a=lubridate::now()+runif(1e3)*86400,
  b=lubridate::today()+runif(1e3)*30,
  c=1:1e3,
  d=runif(1e3),
  e=sample(letters,1e3,replace=TRUE)
)
nycflights13::flights %>%
  print(n=10,width=Inf)
#Subsetting
df <- tibble(
  x=runif(5),
  y=rnorm(5)
)
df
df$x
df[["x"]]
df[[1]]
df %>% .$x
df %>% .[["x"]]
#Interacting with Older Code
class(as.data.frame(tb))
#Chapter 8:Data import with readr
library(tidyverse)
read_csv("a,b,c
         1,2,3
         4,5,6")
read_csv("The first line of metadata
         The second line of metadata
         x,y,z
         1,2,3",skip=2)
read_csv("#A comment I want to skip
         x,y,z
         1,2,3",comment="#")
read_csv("1,2,3\n4,5,6",col_names=FALSE)           
read_csv("1,2,3\n4,5,6",col_names=c("x","y","z"))           
read_csv("a,b,c\n1,2,.",na=".")
#Compare to Base R
#Parsing a Vector
str(parse_logical(c("TRUE","FALSE","NA")))
str(parse_integer(c("1","2","3")))
str(parse_date(c("2010-01-01","1979-10-14")))
parse_integer(c("1","231",".","456"),na=".")
x <- parse_integer(c("123","345","abc","123.45"))
x
problems(x)
#Numbers
parse_double("1.23")
parse_double("1,23",locale=locale(decimal_mark=","))
parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")
parse_number("$123,456,789")
parse_number(
  "123.456.789",
  locale=locale(grouping_mark=".")
)
parse_number(
  "123`456`789",
  locale=locale(grouping_mark="`")
)
#Strings
charToRaw("Hadley")
x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
parse_character(x1, locale=locale(encoding="Latin1"))
parse_character(x2, locale=locale(encoding="Shift-JIS"))
guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))
#Factors
fruit <- c("apple","banana")
parse_factor(c("apple","banana","bananana"),levels=fruit)
#Dates, Date-Times and Times
parse_datetime("2010-10-01T2010")
parse_datetime("20101010")
parse_date("2010-10-01")
library(hms)
parse_time("01:10am")
parse_time("20:10:01")
parse_date("01/02/15","%m/%d/%y")
parse_date("01/02/15","%d/%m/%y")
parse_date("01/02/15","%y/%m/%d")
parse_date("1 janvier 2015","%d %B %Y",locale=locale("fr"))
#Parsing a file
#Strategy
guess_parser("2010-10-01")
guess_parser("15:01")
guess_parser(c("TRUE","FALSE"))
guess_parser(c("1","5","9"))
guess_parser(c("12,352,561"))             
str(parse_guess("2010-10-10"))
#Problems
challenge <- read_csv(readr_example("challenge.csv"))
problems(challenge)
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types=cols(
    x=col_integer(),
    y=col_character()
  )
)
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types=cols(
    x=col_double(),
    y=col_character()
  )
)
challenge
tail(challenge)
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types=cols(
    x=col_double(),
    y=col_date()
  )
)
tail(challenge)
#Other Strategies
challenge2 <- read_csv(
  readr_example("challenge.csv"),
  guess_max=1001
)
challenge2
challenge2 <- read_csv(readr_example("challenge.csv"),
                       col_types=cols(.default=col_character()))
challenge2
df <- tribble(
  ~x,~y,
  "1","1.21",
  "2","2.32",
  "3","4.56"
)
df
type_convert(df)
#Writing to a File
write_csv(challenge,"challenge.csv")
challenge
write_csv(challenge,"challenge-2.csv")
read_csv("challenge-2.csv")
write_rds(challenge,"challenge.rds")
read_rds("challenge.rds")
library(feather)
write_feather(challenge,"challenge.feather")
read_feather("challenge.feather")
#Chapter9:Tidy data with tidyr
#Tidy data
table1
table2
table3
table4a
table4b
table1 %>%
  mutate(rate=cases/population*10000)
table1 %>%
  count(year,wt=cases)
library(ggplot2)
ggplot(table1,aes(year,cases))+
  geom_line(aes(group=country),color="grey50")+
  geom_point(aes(color=country))
#Spreading and Gathering
#Gathering
table4a
table4a %>%
  gather(`1999`,`2000`,key="year",value="cases")
table4b %>%
  gather(`1999`,`2000`,key="year",value="population")
tidy4a <- table4a %>%
  gather(`1999`,`2000`,key="year",value="cases")
tidy4b <- table4b %>%
  gather(`1999`,`2000`,key="year",value="population")
left_join(tidy4a,tidy4b)
#Spreading
table2
spread(table2,key=type,value=count)
#Separating and Pull
#Separate
table3
table3 %>%
  separate(rate, into=c("cases","population"))
table3 %>%
  separate(rate,into=c("cases","population"),sep="/")
table3 %>%
  separate(
    rate,
    into=c("cases","population"),
    convert=TRUE
  )
table3 %>%
  separate(year, into=c("century","year"),sep=2)
#Unite
table5 %>%
  unite(new, century, year)
table5 %>%
  unite(new, century, year,sep="")
#Missing Values
stocks <- tibble(
  year=c(2015,2015,2015,2015,2016,2016,2016),
  qtr=c(1,2,3,4,2,3,4),
  return=c(1.88,0.59,0.35,NA,0.92,0.17,2.66)
)
stocks
stocks %>%
  spread(year,return)
stocks %>%
  spread(year,return) %>%
  gather(year,return,`2015`:`2016`,na.rm=TRUE)
stocks %>%
  complete(year,qtr)
treatment <- tribble(
  ~person,~treatment,~response,
  "Derrik Whitmore",1,7,
  NA,2,10,
  NA,3,9,
  "KAtherine Burke",1,4
)
treatment
treatment %>%
  fill(person)
#Case study
who
who1 <- who %>%
  gather(
    new_sp_m014:newrel_f65,key="key",
    value="cases",
    na.rm=TRUE
  )
who1
who1 %>%
  count(key)
who2 <- who1 %>%
  mutate(key=stringr::str_replace(key,"newrel","new_rel"))
who2
who3 <- who2 %>%
  separate(key,c("new","type","sexage"),sep="_")
who3
who3 %>%
  count(new)
who4 <- who3 %>%
  select(-new,-iso2,-iso3)
who5 <- who4 %>%
  separate(sexage,c("sex","age"),sep=1)
who5
who %>%
  gather(code,value,new_sp_m014:newrel_f65,na.rm=TRUE)%>%
  mutate(
    code=stringr::str_replace(code,"newrel","new_rel")
  ) %>%
  separate(code,c("new","var","sexage")) %>%
  select(-new,-iso2,-iso3) %>%
  separate(sexage,c("sex","age"),sep=1)