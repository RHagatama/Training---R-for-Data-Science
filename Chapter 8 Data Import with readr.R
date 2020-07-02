library(tidyverse)

# Most of readr’s functions are concerned with turning flat files into 
# data frames:

# read_csv()
SP500 <- read_csv("data_csv.csv")

# Supply an inline CSV file
read_csv("a, b, c
         1, 2, 3
         4, 5, 6")

# skip = n to skip the first n lines; or use
# comment = "#" to drop all lines that start with (#)
read_csv("The first line of metadata
         The second line of metadata
         x, y, z
         1, 2, 3,", skip = 2)

read_csv("# A comment i want to skip
         x, y, z
         1, 2, 3", comment = "#")

# To not to treat the first row as headings,
# and instead label them sequentially from X1 to Xn
read_csv("a, 2, 3\n4, 5, 6", col_names = FALSE)

# Pass col_names a character vector, which
# will be used as the column names
read_csv("1, 2, 3\n4, 5, 6", col_names = c("x", "y", "z"))

# To specifies the value (or values) that are 
# used to represent missing values
read_csv("a, b, c\n4, 5, .", na = ".")


## Exercises
# 1. What function must be used to read a file separated with “|”?
# read_delim(data, delim = "|")

# 2. what other arguments do read_csv() and read_tsv() have in common?
#?read_csv
#?read_tsv
union(names(formals(read_csv)), names(formals(read_csv)))

# 3. What are the most important arguments to read_fwf()?
#?read_fwf

# 4. What arguments do you need to specify to 
#    read the following text into a data frame?
# "x, y\n1, 'a,b'"
read_csv("x, y\n1, 'a, b'", quote = "'")

# 5. Identify what is wrong with each of the following inline CSV 
#    files. What happens when you run the code?

read_csv("a,b\n1,2,3\n4,5,6")
# observations per row require 3 column

read_csv("a,b,c\n1,2\n1,2,3,4")
# value of c2 is NA, and last value of third row won't be displayed

read_csv("a,b\n\"1")
# value of b2 is NA, \" will be ignored

read_csv("a,b\n1,2\na,b")
# nothing's wrong

read_csv("a;b\n1;3")
# value separated with ";", use read_csv2 instead


## Parsing A Vector

# Take a character vector and return a more specialized
# vector like a logical, integer, or date
str(parse_logical(c("TRUE", "FALSE", "NA")))
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1979-10-14")))

# na argument specifies which strings should be treated as missing
parse_integer(c("1", "231", ".", "456"), na = ".")

# If parsing fail
x <- parse_integer(c("123", "345", "abc", "123.45"))
x

# Use problems() to get the complete set of tibble 
# which can be manipulated with dplyr
problems(x)

## Numbers

# Override default value decimal mark on a fractional number
parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark = ","))

# Extract number embedded in characters that provide context
parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")

# Ignore the grouping mark
# used in America;
parse_number("$123,456,789")
# used in many part of Europe;
parse_number(
  "123.456.789",
  locale = locale(grouping_mark = ".")
)
# used in Switzerland
parse_number(
  "123'456'789",
  locale = locale(grouping_mark = "'")
)

## Strings

# Get at the underlying representation of a string
charToRaw("Hagatama")

# Handling string data produced by older system
x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

# How to find the correct encoding
guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))

## Factors

# Represent categorical variables that have a known
# set of possible value
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)

## Dates, Date-Times, and Times

# Date-Time
parse_datetime("2010-10-01T2010")
parse_datetime("20101010")

# Date
parse_date("2010-10-01")

# Time
library(hms)
parse_time("01:10 am")
parse_time("20:10:01")

# Supply customized date and/or time format
parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%y/%m/%d")

# Parse non-English month name
parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))


## Exercise
# 1. Most important arguments to locale()
# The locale object has arguments to set the following:
# - date and time formats: date_names, date_format, and time_format
# - time zone: tz
# - numbers: decimal_mark, grouping_mark
# - encoding: encoding

# 2. What happens decimal_mark and grouping_mark being set
#    to the same character? What happens to the default
#    value of grouping_mark when decimal_mark was set to ",“?
#    What happens to the default value of decimal_mark when
#    grouping_mark was set to ".“?
locale(decimal_mark = ".", grouping_mark = ".")
locale(decimal_mark = ",")
locale(grouping_mark = ".")

# 3. What do date_format and time_format options to locale() do?
# Those arguments used to set default date and time format
custom_datetime <- locale(date_format = "Yr. %y Mn. %b Day %d",
                          time_format = "%H:%M:%Ss")

dummy_date <- c("Yr. 93 Mn. Sep Day 14", "Yr. 94 Mn. Jul Day 29")
parse_date(dummy_date)
parse_date(dummy_date, locale = custom_datetime)

dummy_time <- c("01:02:15s", "20:09:14s")
parse_time(dummy_time)
parse_time(dummy_time, locale = custom_datetime)

# 4. Create a new locale object that encapsulates the settings 
#    for the types of files you read most commonly.
parse_date("02/01/2006")
id_locale <- locale(date_format = "%d/%m/%Y")
parse_date("02/01/2006", locale = id_locale)

# 7. Generate the correct format string to parse each of 
#    the following dates and times:
d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014
t1 <- "1705"
t2 <- "11:15:10.12 PM"

parse_date(d1, locale = locale(date_format = "%B %d, %Y"))
parse_date(d2, locale = locale(date_format = "%Y-%b-%d"))
parse_date(d3, locale = locale(date_format = "%d-%b-%Y"))
parse_date(d4, locale = locale(date_format = "%B %d (%Y)"))
parse_date(d5, locale = locale(date_format = "%m/%d/%y"))
parse_time(t1, locale = locale(time_format = "%H%M"))
parse_time(t2, locale = locale(time_format = "%I:%M:%OS %p"))


## Parsing A File

## Strategy

# guess_parser() returns readr’s best guess
# parse_guess() to uses that guess to parse the column
guess_parser("2010-10-01")
guess_parser("15:01")
guess_parser(c("TRUE", "FALSE"))
guess_parser(c("1", "5", "9"))
guess_parser(c("12,352,561"))
str(parse_guess("2010-10-01"))

## Problems

# readr only read the first thousand observations.
# - What if the first thousand observations is unique value?
# - what if the first thousand observations is missing value?
# example:
challenge <- read_csv(readr_example("challenge.csv"))
tail(challenge)

# Pull out the problem
problems(challenge)

# Tweak the type of the y column to date
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)

## Other Strategy

# To define how much observations will be guessed by readr
challenge2 <- read_csv(
  readr_example("challenge.csv"),
  guess_max = 1001
)
challenge2

# read in all the columns as character vector
challenge2 <- read_csv(readr_example("challenge.csv"),
                       col_types = cols(.default = col_character())
                       )

df <- tribble(
  ~x, ~y,
  "1", "1.21",
  "2", "2.32",
  "3", "4.56"
)
df
type_convert(df)

## Writing to a File
write_csv(challenge, "challenge.csv")
challenge

write_csv(challenge, "challenge-2.csv")
read_csv("challenge-2.csv")

# Store data in R’s custom binary format called RDS
write_rds(challenge, "challenge.rds")

# Implements a fast binary file format that 
# can be shared across programming languages
library(feather)
write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")
