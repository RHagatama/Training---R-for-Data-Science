library(tidyverse)

## Tidy Data
table1
table2
table3
table4a
table4b

# Work with table1
# - Compute rate per 10000
table1 %>%
  mutate(rate = cases / population * 10000)

# - Compute cases per year
table1 %>%
  count(year, wt = cases)

# - Visualize change over time
library(ggplot2)
ggplot(table1, aes(year, cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country))

## Exercise
# 1. Describe how the variables and observations are
#    organized in each of the sample tables.

table1
# table1 row represent country, year combination, columns 
# case and population contain value for those variables

table2
# table2 row represent country, year, and type combination,
# column count contain value for those variables

table3
# table3 row represent country, year combination,
# column rate contain both case and population in case/population format

table4a
table4b
# table4 row represent country, table4a column contain values of cases
# table4b columns contain values of population

# 2. Compute the rate for table2, and table4a + table4b
t2_cases <- table2 %>%
  filter(type == "cases") %>%
  rename(cases = count) %>%
  select(country, year, cases) %>%
  arrange(country, year)

t2_population <- table2 %>%
  filter(type == "population") %>%
  rename(population = count) %>%
  select(country, year, population) %>%
  arrange(country, year)

t2_rate <- t2_cases %>%
  mutate(population = t2_population$population,
         rate = (cases / population) * 10000)

