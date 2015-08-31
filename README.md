
# Finding help
- Help using `?function_name`
- Describing a help page
- `help(package = "haven")`
- Google using `R` and `CRAN` tags

# Classes of objects
I use the words referencing, indexing, and subsetting interchangeably.   They may have slightly different meanings, but the idea is to extract part of an object.  
- Vectors (scalars are 1-length vectors)
    - referencing using single bracket `vec[2]`
    - referencing using names if named `vec["elem_2"]`
- Matrix
    - row/column referencing
- Data frame 
    - `data.frame` vs. `matrix` notation
    - `data.frame` descends from `matrix` but not other way around
        - so `df[,1]` works on a `data.frame`, but `mat$col1` does not work for a `matrix`
- Lists
    - Generic holder of things
    - 
- Generic classes (such as `lm` or `ROCR`)

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
