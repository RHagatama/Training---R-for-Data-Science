library(nycflights13)
library(tidyverse)
nycflights13::flights
?flights

## Filter Rows
#filter dataframe to preserve
filter(flights,month==1,day==1)
#save the result as a new dataframe
jan1 <- filter(flights,month==1,day==1)
#print out result and save at the same time
(dec25 <- filter(flights,month==12,day==25))

# standard suite: 
#  > (more than), >= (more than or equal),
#  < (less than), <= (less than or equal),
#  != (not equal), == (equal)
#  & (and), | (or), ! (not)

## Logical Operator
#filter to find all flights that departed in November or December
filter(flights,month==11|month==12)
#filter to find flights that weren't delayed more than 2 hours
filter(flights,arr_delay<=120,dep_delay<=120)

## Missing Value
#Practice to find NA value
df <- tibble(x=c(1,NA,3))
filter(df,x>1)
filter(df,is.na(x)|x>1)

#exercise
#find arr_delay >= 2 hours
filter(flights,arr_delay>=120)
#find dest == IAH | HOU
filter(flights,dest=="IAH"|dest=="HOU")
#find carrier United, American, or Delta
nycflights13::airlines
filter(flights,carrier=="AA"|carrier=="UA"|carrier=="DL")
#find month == 7 | 8 | 9
filter(flights,month==7|month==8|month==9)
#find arr_time > 120, dept_time <= 0
filter(flights,arr_delay>120,dep_delay<=0)
#find dep_delay <= 60, arr_delay > 30
filter(flights,dep_delay<=60,arr_delay>30)
#find dep_time >= 0000 & dep_time < 0600
filter(flights,dep_time>=0000&dep_time<=0600)
#find missing value in dep_time
filter(flights,is.na(dep_time))
#use between function to solve prior challenge
?between
filter(flights,between(month,7,9))
filter(flights,between(dep_time,0000,0600))

## Arrange Rows with arrange()
arrange(flights,year,month,day)
arrange(flights,desc(arr_delay))
?arrange

#Exercise
#Sort all missing value to start
arrange(flights,desc(is.na(dep_time)))
#Sort flights to the most delayed, find flights that left earliest
arrange(flights,desc(dep_delay))
arrange(flights,dep_delay)
#Find the fastest ship
arrange(flights,air_time)
#Find the flight's longest and shortest distance
arrange(flights,distance)
arrange(flights,desc(distance))

## Select Columns with select()
#select column by name
select(flights,year,month,day)
#select all columns between year and day (inclusive)
select(flights,year:day)
#select all columns except those from year and day (inclusive)
select(flights,-(year:day))

# Some helper functions within select
#  starts_with("abc") matches names that begin with "abc"
#  ends_with("xyz") matches names that end with "xyz"
#  contains("ijk") matches names that contain "ijk"
#  num_range("x",1:3) matches x1. x2, and x3

#rename variable
rename(flights,tail_num=tailnum)
#move variables to the start of the data frame
select(flights,time_hour,air_time,everything())

#exercise
#select dep_time, dep_delay, arr_time, and arr_delay from flights
select(flights,dep_time,dep_delay,arr_time,arr_delay)
#include the name of a variable multiple times in a select()
select(flights,dep_time,dep_delay,dep_time) #only one included
#use one_of() function in conjunction with below vector
vars <- c("year","month","day","dep_delay","arr_delay")
select(flights,one_of(vars))
#try below function and learn how the select helpers deal with case by default
select(flights,contains("TIME"))

## Add New Variables with mutate()
flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time
                      )
#Add variable "gain" and "speed"
mutate(flights_sml,
       gain=arr_delay-dep_delay,
       speed=distance/air_time*60
       )
#Add variable based on newly added variable
mutate(flights_sml,
       gain=arr_delay-dep_delay,
       hours=air_time/60,
       gain_per_hour=gain/hours
       )
#Only keep the new variable
transmute(flights,
          gain=arr_delay-dep_delay,
          hours=air_time/60,
          gain_per_hour=gain/hours
          )

# Useful Creation Function
#  Arithmetic operator
transmute(flights,
          air_time,
          hours=air_time/60
          )
#  Modular arithmetic
transmute(flights,
          dep_time,
          hour=dep_time%/%100,
          minute=dep_time%%100
          )
#  Ranking
transmute(flights,
          air_time,
          rank=min_rank(flights$air_time)
          ) #put large number on large rank
transmute(flights,
          air_time,
          rank=min_rank(desc(flights$air_time))
          ) #put large number on small rank
transmute(flights,
          air_time,
          row_number(air_time)
          ) #put large number on large row number
transmute(flights,
          air_time,
          dense_rank(air_time)
          ) #same as min_rank but didn't count NA
transmute(flights,
          air_time,
          percent_rank(air_time)
          ) #put percentage as rank

#exercise
#make dep_time and sched_dep_time easier to compute
transmute(flights,
          dep_time,
          dep_hour=dep_time%/%100,
          dep_minute=dep_time%%100,
          sched_dep_time,
          sched_dep_hour=sched_dep_time%/%100,
          sched_dep_minute=sched_dep_time%%100
          )
#compare air_time with arr_time - dep_time, fix it
transmute(flights,
          arr_time,
          dep_time,
          on_plane=arr_time-dep_time,
          air_time
          ) #on_plane must be converted to minute
transmute(flights,
          arr_hour=arr_time%/%100,
          arr_minute=arr_time%%100,
          arr_time.min=arr_hour*60+arr_minute,
          dep_hour=dep_time%/%100,
          dep_minute=dep_time%%100,
          dep_time.min=dep_hour*60+dep_minute,
          on_plane=arr_time.min-dep_time.min,
          air_time,
          compare=on_plane-air_time
          ) #fixed
#compare dep_time, sched_dep_time, and dep_delay
transmute(flights,
          dep_time=((dep_time%/%100)*60)+dep_time%%100,
          sched_dep_time=((sched_dep_time%/%100)*60)+sched_dep_time%%100,
          delay=dep_time-sched_dep_time,
          dep_delay
          )%>%
  filter(dep_delay!=delay)%>%
  mutate(delay=delay+1440)
#find top 10 most delayed flights
transmute(flights,
          dep_delay,
          rank=min_rank(desc(dep_delay)))%>%
  arrange(rank)

## Grouped Summaries with summarize()
# Collapse a data frame to a single row
summarize(flights,delay=mean(dep_delay,na.rm=TRUE))
# Get average delay per date
by_day <- group_by(flights,year,month,day)
summarize(by_day,delay=mean(dep_delay,na.rm=TRUE))

## Combining Multiple Operations with the Pipe
# Explore relationship between the distance and average delay for each location (w/o pipe)
by_dest <- group_by(flights,dest)
delay <- summarize(by_dest,
                   count=n(),
                   dist=mean(distance,ma.rm=TRUE),
                   delay=mean(arr_delay,na.rm=TRUE)
                   )
delay2 <- filter(delay,count>20,dest!="HNL")
ggplot(data=delay2,mapping=aes(x=dist,y=delay))+
  geom_point(aes(size=count),alpha=1/3)+
  geom_smooth(se=FALSE)
# Explore relatiionship between the distance and average delay for each location with pipe
delays <- flights %>%
  group_by(dest) %>%
  summarize(
    count=n(),
    dist=mean(distance,na.rm=TRUE),
    delay=mean(arr_delay,na.rm=TRUE)
    ) %>%
  filter(count>20,dest!="HNL")

## Missing Value
# if there is missing value in the input, then the output will be missing value
flights %>%
  group_by(year,month,day) %>%
  summarize(mean=mean(dep_delay))
# use na.rm argument to remove missing values prior to computation
flights %>%
  group_by(year,month,day) %>%
  summarize(mean=mean(dep_delay,na.rm=TRUE))
# remove NA (cancelled flights) first as new dataframe
not_cancelled <- flights %>%
  filter(!is.na(dep_delay),!is.na(arr_delay))
not_cancelled %>%
  group_by(year,month,day) %>%
  summarize(mean=mean(dep_delay))

## Counting
# Planes that have the highest average delays
delays2 <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    delay=mean(arr_delay)
    )
ggplot(data=delays2,mapping=aes(x=delay))+
  geom_freqpoly(binwidth=10)
# Make a scatterplot of number of flights versus average delay
delays3 <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    delay=mean(arr_delay,na.rm=TRUE),
    n=n()
  )
ggplot(data=delays3,mapping=aes(x=n,y=delay))+
  geom_point(alpha=1/10)
# explore smaller number of observation to find more pattern and variation
delays3 %>%
  filter(n>25) %>%
  ggplot(mapping=aes(x=n,y=delay))+
  geom_point(alpha=1/10)
# explore how average performanca of batters related to number of times they're at bat
batting <- as_tibble(Lahman::Batting)
batters <- batting %>%
  group_by(playerID) %>%
  summarize(
    ba=sum(H,na.rm=TRUE)/sum(AB,na.rm=TRUE),
    ab=sum(AB,na.rm=TRUE)
  )
batters %>%
  filter(ab>100) %>%
  ggplot(mapping=aes(x=ab,y=ba))+
  geom_point()+
  geom_smooth(se=FALSE)
# Example fallacy on ranking
batters %>%
  arrange(desc(ba))

## Usefeul Summary Function
# Measures of location
not_cancelled %>%
  group_by(year,month,day) %>%
  summarize(
    # average delay
    avg_delay1=mean(arr_delay),
    # average positive delay
    avg_delay2=mean(arr_delay[arr_delay>0])
  )
# Measures of spread sd(x), IQR(x), mad(x)
#why is distance to some destinations more variable?
not_cancelled %>%
  group_by(dest) %>%
  summarize(distance_sd=sd(distance)) %>%
  arrange(desc(distance_sd))
# Measures of rank min(x), quantile(x,0.25), max(x)
#when do the first and last flights leave each day?
not_cancelled %>%
  group_by(year,month,day) %>%
  summarize(
    first=min(dep_time),
    last=max(dep_time)
  )
# Measures of position first(x), nth(x,2), last(x)
#find first and last departement of each day
not_cancelled %>%
  group_by(year,month,day) %>%
  summarize(
    first_dep=(first(dep_time)),
    last_dep=(last(dep_time))
  )
#filter to give all variables, with each observation in a separate row
not_cancelled %>%
  group_by(year,month,day) %>%
  mutate(r=min_rank(desc(dep_time))) %>%
  filter(r%in%range(r))
# Counts
#note: n() return size of current group without takes any argument
#      sum(!is.na(x)) to count the number of non missing value
#      n_distinct(x) to count number of distinct (unique) value
#which destinations have the most carriers?
not_cancelled %>%
  group_by(dest) %>%
  summarize(carriers=n_distinct(carrier)) %>%
  arrange(desc(carriers))
#just count
not_cancelled %>%
  count(dest)
#count the total number of miles a plane flew
not_cancelled %>%
  count(tailnum,wt=distance)
#counts and proportions of logical values
#how many flights left before 5am
not_cancelled %>%
  group_by(year,month,day) %>%
  summarize(n_early=sum(dep_time<500))
#what proportion of flights are delayed by more than an hour
not_cancelled %>%
  group_by(year,month,day) %>%
  summarize(hour_perc=mean(arr_delay>60))

## Grouping By Multiple Variables
# Grouping multiple variables make each summary peels off one level of the grouping
daily <- group_by(flights,year,month,day)
(per_day <- summarize(daily,flights=n()))
(per_month <- summarize(per_day,flights=sum(flights)))
(per_year <- summarize(per_month,flights=sum(flights)))

## Ungrouping
# To remove grouping
daily %>%
  ungroup() %>%
  summarize(flights=n())

#exercise
#find 5 different ways to assess the typical delay characteristics of flights group
delay_char <- flights %>%
  na.omit() %>%
  group_by(flight) %>%
  summarize(n=n(),
            early_15=mean(arr_delay<=-15),
            late_15=mean(arr_delay>=15),
            alwayslate_10=mean(arr_delay>=10),
            early_30=mean(arr_delay<=-30),
            late_30=mean(arr_delay>=30),
            on_time=mean(arr_delay==0),
            late_2h=mean(arr_delay>=120))
filter(delay_char,early_15>=0.5,late_15>=0.5)
filter(delay_char,alwayslate_10==1)
filter(delay_char,early_30>=0.5,late_30>=0.5)
filter(delay_char,on_time>=0.99,late_2h<=0.01)
#come up with another approach that will give the same output as:
not_cancelled %>% count(dest) #1
not_cancelled %>% count(tailnum,wt=distance) #2
not_cancelled %>% 
  group_by(dest) %>%
  summarise(n=n())
not_cancelled %>%
  group_by(tailnum) %>%
  summarise(sum(distance))
#optimize the definition of cancelled flights as follows:
cancelled_flights <- flights %>%
  mutate(cancelled=is.na(dep_delay)|is.na(arr_delay))
filter(cancelled_flights,cancelled=="TRUE")
 #If a flight never departs, then it won’t arrive. 
 #A flight could also depart and not arrive if it crashes, 
 #or if it is redirected and lands in an airport other than its intended destination. 
 #So the most important column is arr_delay, which 
 #indicates the amount of delay in arrival.
#identify pattern of the number of cancelled flights per day
cancelled_flights2 <- cancelled_flights %>%
  group_by(year,month,day) %>%
  summarise(
    cancelled_num=(sum(cancelled)),
    flight_num=n(),
    cancelled_mean=mean(cancelled),
    arr_delay_mean=mean(arr_delay,na.rm=T),
    dep_delay_mean=mean(dep_delay,na.rm=T)
  )
ggplot(cancelled_flights2)+
  geom_point(aes(x=flight_num,y=cancelled_num))
ggplot(cancelled_flights2)+
  geom_point(aes(x=arr_delay_mean,y=cancelled_mean))
ggplot(cancelled_flights2)+
  geom_point(aes(x=dep_delay_mean,y=cancelled_mean))
#Which carrier has the worst delay? Disentangle effect of bad airport vs bad carrier
group_by(flights,carrier) %>%
  summarise(arr_delay=mean(arr_delay,na.rm=T)) %>%
  arrange(desc(arr_delay))
 #objective: find mean_delay of 1) carrier c airport, 2) carrier, 3) airport
 #mean delay = sum(arr_delay)/sum(flight) of each group
 #mean_delay carrier c airport
flights.odc <- flights %>%
  filter(!is.na(arr_delay),!is.na(carrier),!is.na(origin),!is.na(dest)) %>%
  group_by(origin,dest,carrier) %>%
  summarise(
    sumdelay_odc=sum(arr_delay),
    sumflights_odc=n()
  ) %>%
  #mean_delay airport
  group_by(origin,dest) %>%
  mutate(
    sumdelay_od=sum(sumdelay_odc),
    sumflights_od=sum(sumflights_odc)
  ) %>%
  ungroup() %>%
  #mean_delay airport & !carrier
  mutate(
    meandelay_odc=sumdelay_odc/sumflights_odc,
    meandelay_odc.e=(sumdelay_od-sumdelay_odc)/(sumflights_od-sumflights_odc),
    meandelay_diff=meandelay_odc-meandelay_odc.e
  ) %>%
  filter(!is.nan(meandelay_diff)) %>%
 #mean_delay carrier & !airport
  group_by(carrier) %>%
  mutate(meandelay_diff.c=mean(meandelay_diff)) %>%
  arrange(desc(meandelay_diff.c))

## Grouped Mutated (and Filters)
#Find the worst members of each group
flights_sml %>%
  group_by(year,month,day) %>%
  filter(rank(desc(arr_delay))<10)
#Find all groups bigger than a threshold
popular_dests <- flights %>%
  group_by(dest) %>%
  filter(n()>365)
#Standardize to compute per group metrics
popular_dests %>%
  filter(arr_delay>0) %>%
  mutate(prop_delay=arr_delay/sum(arr_delay)) %>%
  select(year:day,dest,arr_delay,prop_delay)