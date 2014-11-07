# swirl courses : Getting and Cleaing Data

             # lesson 1 dplyr #
# Just to build the habit
library(dplyr)
packageVersion("dplyr")
mydf <- read.csv(path2csv,stringsAsFactors = FALSE)
# Use dim() to look at the dimensions of mydf.
dim(mydf)
# [1] 225468     11
head(mydf)

# The first step of working with data in dplyr is to load the data into 
# what the package authors call a 'data frametbl' or 'tbl_df'. 
# Use the following code to create a new tbl_df called cran:
cran <- tbl_df(mydf)
# To avoid confusion and keep things running smoothly, 
# let's remove the original dataframe from your workspace with
rm("mydf")
# let's see how tbl_df make data set more neat
cran
# you can see that dplyr only shows the first 10 rows of the data
# those variables which have been ignored are listed in the bottom
# Specifically, dplyr supplies five 'verbs' that cover all fundamental data manipulation tasks:
# select(), filter(), arrange(), mutate(), and summarize().
?manip 

#.1 select() : Columns selection
# focus on the most important variables and list them in order using select()
select(cran,ip_id,package,country)
# properly use ":" to make things easier
# e.g select all columns start from r_arch to country
select(cran, r_arch:country)
# or in the reverse order
select(cran, country:r_arch)
# We can also throw away some of the variables
select(cran,-time)
select(cran, -(X:size))

#.2 filter() : Rows selection
filter(cran, package == "swirl") # package == "swirl" returns a vector of TRUEs and FALSEs
filter(cran, r_version == "3.1.1", country == "US") # no logic operation like "&"
?Comparison
filter(cran, r_version <= "3.0.2", country == "IN")
# now, move on to "or", "and" 
filter(cran, country == "US"| country=="IN")      # "or"
filter(cran, size > 100500 , r_os == "linux-gnu") # "and"
# is.na()
is.na(c(3,5,NA,10)) # return a vector contains only "TRUE" and "FALSE"
!is.na(c(3,5,NA,10)
# use !is.na() in filter() to choose all the rows of cran for which r_version is not NA
filter(cran, !is.na(r_version))

#.3 arrange()
# sometimes we want to order the rows of a dataset according to the values of particular variable
cran2 <- select(cran,size:ip_id)
arrange(cran2,ip_id) # ascending 1,2,3
arrange(cran2,desc(ip_id)) # descending 13859, 13858
arrange(cran2,package,ip_id)
arrange(cran2,country,desc(r_version),ip_id)

#.4 mutate()
# The size variable represents the download size in bytes, 
# which are units of computer memory. These days, 
# megabytes (MB) are a more common unit of measurement. 
# One megabyte is equal to 2^20 bytes.That's 2 to the power of 20, which is approximately one million bytes!
cran3 <- select(cran,ip_id,package,size)
mutate(cran3,size_mb = size/2^20)
mutate(cran3,size_mb = size/2^20, size_gb = size_mb/2^10)
mutate(cran3,correct_size = size+1000)

#.5 summarize()
# collapses the dataset to a single row
summarize(cran, avg_bytes = mean(size))
# summarize() is most useful when working with data that has been 
# grouped by the values of a particular variable.