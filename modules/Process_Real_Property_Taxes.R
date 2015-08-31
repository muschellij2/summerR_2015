rm(list = ls())
library(stringr)
library(readr)
library(plyr)
library(dplyr)
root_dir = "~/Dropbox/Classes/D3JS"
root_dir = path.expand(root_dir)
sub_fol = "Module_1"
mod_dir = file.path(root_dir, sub_fol)
stopifnot(file.exists(mod_dir))

fname = "Real_Property_Taxes.csv"
fname = file.path(mod_dir, fname)
dat = read_csv(fname)

dat = as.data.frame(dat)
cns = colnames(dat)
for (icn in cns){
  dat[, icn] = str_trim(dat[, icn])
}

dat$lotSize = gsub("-", ".", dat$lotSize, fixed = TRUE)
dat$amountDue = NULL

# ONLY WANT PRINCIPAL RESIDENCES
dat = dat %>% filter( resCode %in% "PRINCIPAL RESIDENCE")
##############################
# Make the money fields to numeric
##############################
money_to_numeric = function(x){
  x[x == ""] = NA
  x = gsub(",", "", x)
  x = gsub("[$]", "", x)
  nx = as.numeric(x)
  bad = is.na(nx) & !is.na(x)
  if (any(bad)){
    print(x[bad])
  }
  x
}
dat$cityTax = money_to_numeric(dat$cityTax)
dat$stateTax = money_to_numeric(dat$stateTax)

##############################
# Fix up lot size
##############################
dat$lotSize = toupper(dat$lotSize)

dat$lotSize[ grepl("&", dat$lotSize)]
# Assuming & means AND, aka +
dat$lotSize = gsub("&", ".", dat$lotSize, fixed = TRUE)

############
# Weird back ticks
############
dat$lotSize[ grepl("`", dat$lotSize)]

############
# Space between period
############
space_period = grepl("\\d [.]", dat$lotSize)
dat$lotSize[ space_period ]
dat$lotSize = gsub("(\\d) [.]", "\\1.", dat$lotSize)
dat$lotSize[ space_period ]

# taking out percentages.
dat = dat[ !grepl("%", dat$lotSize), ]

## Taking out if 3 units were made:
# CU FT - can't assume this is to be square feet
cu = grepl("CU", dat$lotSize)
table(cu)
dat$lotSize[cu]
dat = dat[ !cu, ]



# Copying column to double check
dat$orig_lot = dat$lotSize
############################
# Replacing multiple spaces with one space
############################
dat$lotSize = str_replace(dat$lotSize, "\\s+", " ")

dat$lotSize = gsub("S.F.", "SQ FT", dat$lotSize, fixed = TRUE)
dat$lotSize = gsub("S. F.", "SQ FT", dat$lotSize, fixed = TRUE)
dat$lotSize = gsub("SF[.]$", "SQ FT", dat$lotSize)
dat$lotSize = str_replace(dat$lotSize, "SQFT", " SQ FT")
dat$lotSize = revalue(dat$lotSize, c("IMPROVEMENT ONLY" = ""))
# Putting in spaces if necessary
dat$lotSize = str_replace(dat$lotSize, "[^\\s]ACRES", " ACRES")
dat$lotSize = str_replace(dat$lotSize, "[^\\s]SQ", " SQ")

# Replacing different ways to say ACRE
dat$lotSize = str_replace(dat$lotSize, "ACRE$", "ACRES")
dat$lotSize = str_replace(dat$lotSize, "ACREAGE$", "ACRES")
dat$lotSize = str_replace(dat$lotSize, "ACRESS$", "ACRES")

nox = !grepl("X", dat$lotSize)
nospace = !grepl(" ", dat$lotSize)
noacres = !grepl("ACRES", dat$lotSize)
nosqft = !grepl("SQ FT", dat$lotSize)


# removing these cases - no idea of the units
# dat[nox & noacres & nosqft, "lotSize"]
dat = dat[ !(nox & noacres & nosqft), ]

################################
# Replace those greeen acres
################################
acres = grepl("ACRES", dat$lotSize)
acre_data = gsub(" ACRES", "", dat$lotSize[acres])
bad_acres = acre_data[is.na(as.numeric(acre_data))]
bad_acres

########## 
# A O and not 0 problem
acre_data = gsub("O", "0", acre_data)
bad_acres = acre_data[is.na(as.numeric(acre_data))]
stopifnot(length(bad_acres) == 0)
acre_data = as.numeric(acre_data) * (43560) #43560 sq ft per acre
dat$lotSize[acres] = as.character(acre_data)

################################
# Find the 3 Xs - cubic feet data
################################
xs = grepl("X", dat$lotSize)
xdata = dat$lotSize[xs]
ss = strsplit(xdata, "X")
measurements = sapply(ss, length)
table(measurements)
xdata[measurements == 3]

# these indices are for the whole data.frame
rm.ind = which(xs)[measurements == 3]
if (length(rm.ind) > 0) {
  dat$lotSize[rm.ind]
  # remove these 
  dat = dat[-rm.ind, ]
}

################################
# Delete data with no tax info
################################
dat = filter(dat, !is.na(cityTax) & !is.na(stateTax))

################################
# Make the X data in SQ FT
################################
xs = grepl("X", dat$lotSize)
xdata = dat$lotSize[xs]
x_orig_data = dat$orig_lot[xs]
ss = strsplit(xdata, "X")
measurements = sapply(ss, length)
stopifnot(all( measurements == 2))
sqft_data = sapply(ss, function(x){
  prod(as.numeric(x))
})

xdata[is.na(sqft_data)]
x_orig_data[is.na(sqft_data)]

dat$lotSize[xs] = sqft_data
dat = filter(dat, !is.na(dat$lotSize))

dat$lotSize = gsub(" SQ FT", "", dat$lotSize)
dat$lotSize = gsub("13O4", "1304", dat$lotSize)

bad = dat[ is.na(as.numeric(dat$lotSize)), ]
print(head(bad))
stopifnot(nrow(bad) <= 3)

dat$lotSize =  as.numeric(dat$lotSize)
dat = filter(dat, !is.na(dat$lotSize))

cc = complete.cases(dat)

stopifnot(all(cc))
#################
# Need some robust code

new_fname = gsub("[.]csv", 
                 "_residences_with_Taxes_cleaned.csv", 
                 fname)
write_csv(dat, 
          path = new_fname)

new_samp_fname = gsub("[.]csv", 
                      "_residences_with_Taxes_cleaned_sample.csv", 
                      fname)
write_csv(dat[sample(nrow(dat), size = 1e4),], 
          path = new_samp_fname)
