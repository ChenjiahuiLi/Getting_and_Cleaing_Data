library(dplyr)
library(tidyr)
# The philosophy of this package 
# http://vita.had.co.nz/papers/tidy-data.pdf

# What is tidy data? Satisfy 3 rules:
#.1 each variable forms a column
#.2 each observation forms a row
#.3 each type of observation unit forms a table

# Examples of messy data:
#.2: Variables are stored in both rows and columns
#.3: A single observational unit is stored in multiple tables
#.4: Multiple variables are stored in one column
#.5: Multiple types of observational units are stored in the same table
#.6: Column headers are values, not variable names

# First, each colums should represent one single variable
# do not seperate values of one variable into two colums
# wrong: grade male female
# right: grade sex count
?gather
gather(students, sex, count, -grade) # conbine variables except for grade

#.4 Multiple variables are stored in one column
# names(students2): grade male_1 female_1 male_2 female_2
res <- gather(students2, sex_class, count, -grade)
separate(data=res, col=sex_class, into=c("sex","class"))
# We can also write the code in Chaining style
students2 %>%
    gather(sex_class, count, -grade) %>%
    separate( col=sex_class, c("sex", "class")) %>%
    print

#.2 Variables are stored in both rows and columns
students3 
# Q1:midterm and final should each occupy one column => spread()
# Q2:class1 to class 5 should be stored in one variable class => mutate()
?spread
?extract_numeric
extract_numeric("class5")
students3 %>%
    gather(class, grade, class1:class5, na.rm = TRUE) %>%
    spread(test, grade) %>%
    mutate(class=extract_numeric(class)) %>%
    print

#.5: Multiple types of observational units are stored in the same table
students4
student_info <- students4 %>%
    select(id, name, sex) %>%
    ### Your code here %>%
    unique() %>%
    print
gradebook <- students4 %>%
    select(id,class,midterm,final) %>%
    print
passed <- passed %>%
    mutate(status="passed") 
failed <- failed %>%
    mutate(status="failed")
?rbind_list()  
rbind_list(passed,failed)

# Do some real Coding!!
# http://research.collegeboard.org/programs/sat/data/cb-seniors-2013
# 1. select() all columns that do NOT contain the word "total",
# since if we have the male and female data, we can always
# recreate the total count in a separate column, if we want it.
# Hint: Use the contains() function, which you'll
# find detailed in 'Selection' section of ?select.
#
# 2. gather() all columns EXCEPT score_range, using
# key = part_sex and value = count.
#
# 3. separate() part_sex into two separate variables (columns),
# called "part" and "sex", respectively. You may need to check
# the 'Examples' section of ?separate to remember how the 'into'
# argument should be phrased.
#
# 4. Use group_by() (from dplyr) to group the data by part and
# sex, in that order.
#
# 5. Use mutate to add two new columns, whose values will be
# automatically computed group-by-group:
#
#   * total = sum(count)
#   * prop = count / total
#
sat %>%
    select(-contains("total")) %>%
    gather(part_sex, count, -score_range) %>%
    separate(part_sex, c("part", "sex")) %>%
    group_by(part,sex) %>%
    mutate(total = sum(count),
           prop = count/total
    ) %>% print