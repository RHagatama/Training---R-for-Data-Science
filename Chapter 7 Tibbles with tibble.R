library(tidyverse)

## Creating Tibbles

# Coerce data frame to a tibble
as_tibble(iris)

# Create new tibble from individual vector with tibble()
tibble(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y
)

# To refer to variables name that are not valid to R, 
# surround them with backticks, (``)
tb <- tibble(
  `:)` = "smile",
  ` ` = "space",
  `2000` = "number"
)

# Create tibble with tribble
# - Column headings defined by formula (~)
# - Entries are separated by commas
tribble(
  ~x, ~y, ~z,
  #--/--/----
  "a", 2, 3.6,
  "b", 1, 8.5
)

## Tibbles Versus data.frame

## Printing
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace=TRUE)
)

# To control the number of rows and width of the display
nycflights13::flights %>%
  print(n = 10, width = Inf)

## Subsetting
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

# Extract by name
df$x
df[["x"]]

# Extract by position
df[[1]]

# Use in the pipeline
df %>% .$x
df %>% .[["x"]]


## Interacting with Older Code

# To turn a tibble back to a data frame
class(as.data.frame(tb))


## Exercise
# 1. How to tell if an object is a tibble?

# Check if:
# - there are no data type (str, fct, dbl, etc.)
# - they display all observation
mtcars

# Or check using is_tibble()
is_tibble(mtcars)

# 2. Compare following operation on a data.frame and tibble
dfx <- data.frame(abc = 1, xyz = "a")
dfx$x
dfx[, "xyz"]
dfx[, c("abc", "xyz")]

# Using tibble
tbx <- as_tibble(dfx)
tbx$x
tbx[, "xyz"]
tbx[, c("abc", "xyz")]
# - if there are more than one variable with x in its name then data.frame
#   operation may target different variable that not the one we needed
# - if only one variable called, data.frame operation will return the data
#   as list instead of data frame

# 3. How to extract the reference variable from following tibble?
var <- "mpg"
as_tibble(var)

# 4. Practice referring nonsyntactic names in the following data frame by:
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

#    a. Extracting the variable called 1
annoying$`1`
annoying[["1"]]

#    b. Plotting scatterplot of 1 versus 2
ggplot(annoying, aes(x = `1`, y = `2`)) +
  geom_point()

#    c. Creating new column called 3, which is 2 divided by 1
annoying.c <- mutate(annoying, `3` = `2` / `1`)

#    d. renaming the column to one , two, and three
rename(annoying.c, one = `1`, two = `2`, three = `3`)

# 5. What does tibble::enframe do? When to use it?

# run these following code to know its function (remove hashtag first):
# ?enframe

tibble::enframe(c(a = 2, b = 3))