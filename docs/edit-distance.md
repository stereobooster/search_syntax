# Edit distance

**Edit distance** of two strings `dist(x, y)` is the minimal number of edit operations needed to transform first string (`x`) into the second (`y`).

Diffrent edit distances can have different **edit operations**: deletion, insertion, substitution, transposition.

|                              | deletion | insertion | substitution | transposition |
| ---------------------------- | -------- | --------- | ------------ | ------------- |
| Hamming distance             |          |           | +            |               |
|                              |          |           |              |               |
| Longest common subsequence   | +        | +         |              |               |
| Levenshtein distance         | +        | +         | +            |               |
| Damerau-Levenshtein distance | +        | +         | +            | +             |

## Hamming distance

Hamming distance is a very specific measure. It assumes that strings are of the same length. It is rather makes sense for networks, signal processing, where messages (think of network packets) have constant size.

So I won't compare it to other measures.

## LCS distnace

LCS stands for Longest Common Subsequence (not substring). I will denote it as `lcs(x, y)`. And length of the string as `len(x)`. Than:

- `lcs(test, east)` is `est`
- `len(test)` is `4`

Now let's assume we want to measure edit distance between string, using only **delete** and **insert** operations:

- number of letters we need to delete from `x` in order to turn it in `y` is `len(x) - len(lcs(x, y))`
- number of letters we need to insert in `x` in order to turn it in `y` is `len(y) - len(lcs(x, y))`

So edit distance is: `lcs_dist(x, y) = len(x) + len(y) - 2*len(lcs(x, y))`.

We can see that maximum of "LCS edit distance" is `len(x) + len(y)`, than normalized distance is: `lcs_dist_norm(x, y) = 1 - 2*len(lcs(x, y))/(len(x) + len(y))`

and "LCS similarity" is: `lcs_sim_norm(x, y) = 2*len(lcs(x, y))/(len(x) + len(y))`

Which looks very similar to Dice coefficient: `dice_sim(x, y) = 2*len(int(x,y))/(len(x) + len(y))`, where `int` is set intersection.

## Levenshtein distance

`lcs_dist(test, east)` is `2`. But `lcs_dist(test, text)` is also `2`, which doesn't make sense. Levenshtein distance improves "LCS edit distance" by adding **substitution** operation, so `lev(test, text)` becomes `1`.

Maximum of Levenshtein distance is `max(len(x), len(y))`, than normalized distance is: `lev_dist_norm(x, y) = lev_dist(x, y) / max(len(x), len(y))`.

Levenshtein similarity is: `lev_sim_norm(x, y) = 1 - lev_dist(x, y) / max(len(x), len(y))`

### Weighted Levenshtein distance

Another variation is to add weight (or score) to edit operations:

- We can modify wiegth of delete and insert, but they need to be the same to preserve symmetry property
- We can modify weight of substitution, but it makes sense to choose values less than to 2 times weight of insert/delete. Otherwise algorithm can as well count it as 1 deletion, 1 insertion.

The more chances of replacing one letter with another, the less weight, for example:

- if letters are close on keyboard
- if letters sound similar, like s and z in organisation and organization.
- if letters look similar, like letter o and 0 (zero). This is usefull for OCR

See: [weighted-levenshtein](https://github.com/infoscout/weighted-levenshtein).

## Damerau-Levenshtein distance

`lev_dist(test, tset)` is `2`, but this is common typo - accidentally type letters in reverse order. Damerau-Levenshtein distance improves Levenshtein distance by adding **transposition** operation, so `dam_lev_dist(test, tset)` becomes `1`.

Maximum of Damerau-Levenshtein distance distance is `max(len(x), len(y))`, than normalized distance is: `dam_lev_dist_norm(x, y) = dam_lev_dist(x, y) / max(len(x), len(y))`.

Damerau-Levenshtein similarity is: `dam_lev_sim_norm(x, y) = 1 - dam_lev_dist(x, y) / max(len(x), len(y))`

## More...

We can think of another types of operations or weights, for example:

- deleting or inserting duplicate letter, like in `mesage` and `message` can weight less - typical error
- deleting or inserting letters in the start and end can weight more. To take into account cognitive effect which allows people to recognize scrambled words. See: [Typoglycemia](https://www.dictionary.com/e/typoglycemia/)
- allow transposition with a distance

## Jaro similarity

`lcs_sim_norm(FAREMVIEL, FARMVILLE) = 7 / 9 ~ 0.77`. But `lcs(FAREMVIEL, FARMVILLE)` are `FARMVIL`, `FARMVIE` e.g. two different strings, but the same length. Jaro similarity improves LCS similarity by taking into account such situations. `jaro_sim_norm(FAREMVIEL, FARMVILLE) = 0.88`. `jaro_subsequence(FAREMVIEL, FARMVILLE)` are `FARMVIEL` are `FARMVILE`.

Check out [wikipedia page](https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance) for the formula.

But Jaro similarity is not direct extension of LCS similarity, otherwise in the absence of transposition they would return the same value:

- `lcs_sim_norm(test, east) = 3/4`
- `jaro_sim_norm(test, east) = 5/6`
- `lev_sim_norm(test, east) = 1/2`

## Jaro–Winkler similarity

Jaro–Winkler similarity uses a prefix scale which gives more favorable ratings to strings that match from the beginning for a set prefix of given length

## Reading

- [A Comparison of String Metrics for Matching Names and Records](https://www.cs.cmu.edu/afs/cs/Web/People/wcohen/postscript/kdd-2003-match-ws.pdf)
