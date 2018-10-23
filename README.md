# fuzzyjoin-australian-suburb
This experimental code is a extendable template for _batch_ __Australian suburb specific__ address correction in R.

###### The Solution 
Using fuzzy matching based on distance algorithms (levenshtein, jarowinkler, etc) the qgrams algorithm 
gives the best results for problems specific to this type of data.
The solution is a suggested suburb with a corresponding confidence level based on the distance.

###### The Problem
We have 3 distinct problems in this data - 
1.  data with more than one fuzzy possibilities (Borowral could be -> Berowral or -> Bowral)
2.  we have suburb data where the words are in opposite order (Sydney North, Hoxton West)
3.  and classic misspellings: incorrect letter, extra letter or missing letter (Wolooware, Ride, Waroonga)
 
###### Final Thoughts 
This solution is constrained to a classic distance algorithm intentionally instead of a more computational expensive algorithm. In future, the expectation is that this solution could rely on parallel processing to scale. 

I'd like to assert that Australian suburbs are the worst! for misspellings but I don't have the data to back that up. Regardless, it doesn't appear to be a problem that will be eradicated soon and this process could also be extended to other types of data cleanup. Therefore, it's here for public consumption and collaboration.

