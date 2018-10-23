###############################################
# Trial of fuzzy matching on Australian Suburbs
# kfergo55 - Orig Mar 2018
# Updated Oct 2019 to remove client references
# and to extend to git
###############################################

#######################################
# We have 3 distinct problems - 
# 1 - more than one fuzzy possibilities (Borowral)
# 2 - we have 2 word suburbs where the words are in opposite order (Sydney North, Hoxton West)
# 3 - classic misspellings, wrong letter, extra letter or missing letter 
# (Wolooware, Ride, Waroonga)
######################################

# notes on the distance algorithms:
# jarowinkler(str1, str2, W_1=1/3, W_2=1/3, W_3=1/3, r=0.5)
# levenshteinSim(str1, str2)
# levenshteinDist(str1, str2)

# levenshtein is calculated by 1 - d(str1,str2) / max(A,B), where d is 
# the Levenshtein distance function and A and B are the lenghts of the strings.

# String comparison is case-sensitive, 
# which means that for example "R" and "r" have a similarity of 0

#######################################
# Trial 1 - using R package RecordLinkage
#######################################

# install.packages("RecordLinkage")

library(RecordLinkage)

# read in subset of suburb data
bad_burb = read.csv("~/Documents/WORK - Kim/policy_bad_suburb.csv", header=FALSE, sep=",", dec=".")
good_burb = read.csv("~/Documents/WORK - Kim/policy_good_suburb.csv", header=FALSE, sep=",", dec=".")

# run the string distance algorithm
results = compare.linkage(bad_burb, good_burb, strcmp=TRUE, strcmpfun=jarowinkler)

summary(results)

# example of use of this function toextend to additional columns
# rpairs=compare.linkage(RLdata500,RLdata10000,blockfld=c(1,7),phonetic=c(1,3))

results=emWeights(results)
results=emClassify(results)

# getPairs(results, single.rows=TRUE, filter.link="link")

getPairs(results)
# results - I only got Waroonga correct

# not using the following extensions of this package (model)
# as we don't want to rely on a collection of
# known misspelled Aus suburbs to train on

# l=splitData(results, prop=0.5, keep.mprop=TRUE)                    
# model=trainSupv(results, method="rpart")
# result=classifySupv(model=model, newdata=bad_burb)
summary(result)

#####################################
# End of Trial 1
# compare.linkage defaults to jarowinkler but levenshteim performs better
# compare.linkage gets the easy ones correct and you can easily combine many columns
# summary: better candidate for what it is intended for (link or dedup)

#################################
# Trial 2 - package fuzzymatching
#################################

install.packages("fuzzyjoin")
library(fuzzyjoin)

stringdist_left_join(bad_burb, good_burb, max_dist =2)
# results - max_dist 2, 2 records found for Borowral. Found Wolooware and Waronga
# sameresults for osa and dl methods, lv is the default 

stringdist_left_join(bad_burb, good_burb, method = "soundex", max_dist =2)
# results - soundex picks up Hoxton West but doesn't match on Borowral

stringdist_left_join(bad_burb, good_burb, method = "qgram", max_dist =2)
# result= Found Wolooware, Hoxton West, Borowral to Bowral and Waroonga and Sydney North
# missed Borowral as Berowra but performs the best thus far

stringdist_left_join(bad_burb, good_burb, method = "qgram", max_dist =3)
# result - finds all results and also finds 2 records Berowra and Bowral

################################
# second pass with the 
# suburbs + postcode

bad_burb2 = read.csv("~/Documents/WORK - Kim/policy_bad_suburb2.csv", header=FALSE, sep=",", dec=".")
good_burb2 = read.csv("~/Documents/WORK - Kim/policy_good_suburb2.csv", header=FALSE, sep=",", dec=".")

stringdist_left_join(bad_burb2, good_burb2, method = "qgram", max_dist =2)
# result= Did not find a match for Borowral

stringdist_left_join(bad_burb2, good_burb2, method = "qgram", max_dist =3)
# result= All tests succeeded! Found Bewrowra for Borowral

###################################################################################
# Based on our experiments above we should scale our suggested suburbs with a score
# The closer the distance, the better the score
# We can also firm up our score based on the postcode
#
#
# Recommended code workflow:
# Use the stringdist_left_join function from fuzzyjoin package.
# 1.) Process exact match records: (use left_join from dplyr)
#   filter exact matches on suburb to auspost suburb -> if true set confidence .9 %>%
#   exact match suburb+postode to auspost suburb+postcode -> if true leave as .9
#   else downgrade confidence to .85
# 2.) Process the remaining suburb records *fuzzily*:
#   with remaining rejected records from step 1, use stringdist_left_join on suburb
#   using method = qgram and max_dist = 2 -> 
#   if true set confidence .8 %>% 
#   exact match suburb+postcode to auspost suburb+postocde -> 
#   if match equals previous pass do nothing else
#   if a new match exists set suburb to this result and downgrade confidence to .75 
# 3.) repeat step 2 with remaining rejected records but with max_dist = 3 with a 
#   lower confidence
# 4.) any remaining rejected records sent to additional exception handling process. 

# pre-processing steps - encoding, nulls and known stop words like "TBD"
# and "Un-named Suburbs"
# exception handling - adding additional stop words and if postcode is valid then set
# to a default suburb


