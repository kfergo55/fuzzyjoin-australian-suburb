# fuzzyjoin-australian-suburb
This template is a solution for __Australian suburb specific__ _batch_ address correction in R.

Using fuzzy matching based on distance algorithms (levenshtein, jarowinkler, etc) the qgrams algorithm 
gives the best results for problems specific to this type of data.

We have 3 distinct problems in this data - 
 1 - data with more than one fuzzy possibilities (Borowral could be -> Berowral or -> Bowral)
 2 - we have suburb data where the words are in opposite order (Sydney North, Hoxton West)
 3 - and classic misspellings: incorrect letter, extra letter or missing letter (Wolooware, Ride, Waroonga)
 
This solution is constrained to a classic distance algorithm intentionally instead of more computational expensive algorithms. In future, the expectation is that we could easily rely on parallel processing to scale this solution. 

I'd like to assert that Australian suburbs are the worst for misspellings but I don't have the data to back that up. :)

