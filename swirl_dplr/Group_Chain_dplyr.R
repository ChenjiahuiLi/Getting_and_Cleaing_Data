top_counts <- filter(pack_sum, count > 679)
head(top_counts, 20)
arrange(top_counts,desc(count))

quantile(pack_sum$unique, probs = 0.99)
top_unique <- filter(pack_sum, unique > 465)
arrange(top_unique, desc(unique))

# Chaining(Piping)
# Chaining allows you to string together multiple functions
# calls in a way that is compact and readable
by_package <- group_by(cran, package)
pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size))
quantile(pack_sum$countries,probs = 0.99)
top_countries <- filter(pack_sum, countries > 60)
result1 <- arrange(top_countries, desc(countries))
result2 <- arrange(top_countries, desc(countries), avg_bytes)
# result2 sorted top_countries primarily by country, but used avg_bytes 
# (in ascending order) as a tie breaker
# result 2 can also be programmed as follow
result2 <-
    arrange(
        filter(
            summarize(
                group_by(cran,
                         package
                ),
                count = n(),
                unique = n_distinct(ip_id),
                countries = n_distinct(country),
                avg_bytes = mean(size)
            ),
            countries > 60
        ),
        desc(countries),
        avg_bytes
    )
# In this script, we've used a special chaining operator, %>%, which is part of the
# dplyr package. You can pull up the related documentation with ?chain. The benefit of
# %>% is that it allows us to chain the function calls in a linear fashion. The code to
# the right of %>% operates on the result from the code to the left of %>%.
result3 <-
    cran %>%
    group_by(package) %>%
    summarize(count = n(),
              unique = n_distinct(ip_id),
              countries = n_distinct(country),
              avg_bytes = mean(size)
    ) %>%
    filter(countries > 60) %>%
    arrange(desc(countries), avg_bytes)
# My code here
cran %>%
    select(ip_id, country, package, size) %>%
    mutate(size_mb = size / 2^20) %>%
    filter(size_mb <= 0.5) %>%
    # Your call to arrange() goes here
    arrange(desc(size_mb)) %>%
    print()