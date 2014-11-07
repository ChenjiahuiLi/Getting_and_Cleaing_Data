# Unfortunately, due to different date and time representations, this lesson is only
# guaranteed to work with an "en_US.UTF-8" locale. To view your locale, type
# Sys.getlocale("LC_TIME").
Sys.getlocale("LC_TIME")
library(lubridate)
help(package=lubridate)
this_day <- today()
wday(this_day, label=TRUE)
this_moment <- now()
hour(this_moment)
minute(this_moment)
second(this_moment)

my_date <- ymd("1989-05-17")
class(my_date)
# lubradate is smart, so you should arrange y m d in a right sequence
ymd("1989 May 17") 
# [1] "1989-01-07 UTC"
mdy("March 12, 1975")
# [1] "1975-01-02 UTC"
dmy(25081985)
# [1] "1985-08-25 UTC"
ymd("192012")
# [1] NA
# So, no quotes for numeric value !
ymd("1920/1/2") # "/ " is called foward slash!

# In addition to dates, we can parse date-times. I've created a date-time object called dt1. Take a look
# at it now.
ymd_hms(dt1)
hms("03:22:14")
dt2
# [1] "2014-05-14" "2014-09-22" "2014-07-11"
ymd(dt2)

this_moment
# [1] "2014-11-03 20:58:56 CST"
update(this_moment, hours=8, minutes = 34, seconds=55)
# [1] "2014-11-03 08:34:55 CST"
# It's important to recognize that the previous command does not 
# alter this_moment unless we reassign the result to this_moment.
this_moment <- update(this_moment, hours=9, minutes=30, seconds=40)

# Now, pretend you are in New York City and you are planning to visit a friend in Hong Kong. You seem
# to have misplaced your itinerary, but you know that your flight departs New York at 17:34 (5:34pm)
# the day after tomorrow. You also know that your flight is scheduled to arrive in Hong Kong exactly 15
# hours and 50 minutes after departure.
nyc <- now(tzone="America/New_York") # http://en.wikipedia.org/wiki/List_of_tz_database_time_zones
# One nice aspect of lubridate is that it allows you to 
# use arithmetic operators on dates and times.
depart <- nyc + days(2)
depart <- update(depart, hours=17, minutes=34)
arrive <- depart + hours(15) + minutes(50)

?with_tz
arrive <- with_tz(arrive, "Asia/Hong_Kong")
last_time <- mdy("June 17, 2008", tz="Singapore") # year之前要空格
?new_interval
how_long <- new_interval(last_time,arrive)
as.period(how_long)
# four classes of time related objects: 
# instants, intervals, durations, and periods.
# you can find a complete discussion in the 2011 Journal of Statistical Software paper titled 
# 'Dates and Times Made Easy with lubridate'.
# link: http://www.jstatsoft.org/v40/i03/paper
stopwatch()







