# filter() (and slice()) - subsetting rows
# arrange() - sorting the data.frame by columns
# select() (and rename() - renaming columns)
# distinct()
# mutate() (and transmute())
# summarise()
# sample_n() and sample_frac()
rm(list=ls())
library(dplyr)
head(mtcars)

colnames(mtcars)
rownames(mtcars)

colnames(mtcars)[1] 
colnames(mtcars)[1] = "Miles_Per_Gallon"

colnames(mtcars)[1] = "mpg"

mtcars2 = rename(mtcars, 
                 Miles_Per_Gallon = mpg,
                 cylinders = cyl)

mt = mtcars
mt$Car = rownames(mtcars)

mt_over20 = filter(mt, 
                   mpg > 20)

mt_over20_6cyl = filter(mt, 
                        mpg > 20,
                        cyl == 6)

mt_over20_or_6cyl = filter(mt, 
                           mpg > 20 | cyl == 6, )

mt2 = mt[ (mt$mpg > 20 | mt[, "cyl"] == 6),]

# slice(mtcars, 1:5)
# mtcars[1:5,]

mt_mpg_sort = arrange(mt, cyl, desc(mpg))

carbdf = select(mt, carb, mpg)
head(carbdf)
carbdf = mt[, c("carb", "mpg")]

filter(mt, Car == "Mazda RX4")
mt[ mt$Car == "Mazda RX4", ]
mt["Mazda RX4", ] # requires rownames 


mt = mutate(mt, mpg2 = mpg^2) #using dplyr
mt$mpg2 = mt$mpg^2 # standard R syntax

mt$mpg2 = NULL # remove mpg2 column
mt_mut = mutate(mt, 
            mpg2 = mpg^2,
            cyl2 = cyl^2,
            disp = disp^2,
            over20_mpg = mpg > 20,
            mpg2_over140 = mpg2 > 140) #using dplyr

mt$mpg2 = mt$mpg^2  # create the column
mp$mpg2_over140 = mt$mpg2 > 140 # use the column


mt_tmut = transmute(mt, 
                mpg2 = mpg^2,
                cyl2 = cyl^2,
                disp = disp^2,
                over20_mpg = mpg > 20,
                mpg2_over140 = mpg2 > 140,
                Car,
                carb)

summarise(mt, 
          mean_cyl = mean(cyl),
          max_cyl = max(cyl),
          quantile(cyl, probs = 0.25)
          )

# ?group_by
g_cyl = group_by(mt, cyl, gear) # group data by number of cylinders
sum_cyl = summarise(g_cyl,
          mean_mpg = mean(mpg),
          mean_disp = mean(disp))


library(plyr)

