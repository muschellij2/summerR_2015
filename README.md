
Help using ?
Describing a help page

# Classes of objects
- Data frame vs. a matrix
- Vectors

# Programming 
- for loops
- if statements

# Classes of Vectors

- logical
- numeric
- character
- factor
    - coercion from factor to character
        - as.character(fac)
    - coercion from factor to numeric
            - as.numeric(as.character(fac))
- NA
- NaN
- Inf

# Character vector operations
- paste and paste0
- file.path - putting together paths of directory


# Getting data into R

- `readr` package - [https://github.com/hadley/readr](https://github.com/hadley/readr)
    - has `read_csv` and `write_csv` similar to the versions with `.` instead of `_`
    - can be much faster than `read.csv`
    - may want to do `as.data.frame` after object is read in
- haven package - [https://github.com/hadley/haven](https://github.com/hadley/haven)
    - allows for SPSS, SAS and other data types, supercedes `foreign` package
- `foreign` package - [https://cran.r-project.org/web/packages/foreign/index.html](https://cran.r-project.org/web/packages/foreign/index.html)



[Summer R 2015 Class from Andrew Jaffe](http://www.aejaffe.com/summerR_2015/)
