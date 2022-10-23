# Approximate string matching

a.k.a. string proximity search, error-tolerant search, string similarity search, fuzzy string searching, error tolerant pattern matching.

## Definitions

### Edit distance

**Edit distance** of two strings `dist(x, y)` is the minimal number of edit operations needed to transform first string (`x`) into the second (`y`).

Diffrent edit distances can have different **edit operations**: deletion, insertion, substitution, transposition.

|                              | deletion | insertion | substitution | transposition |
| ---------------------------- | -------- | --------- | ------------ | ------------- |
| Levenshtein distance         | +        | +         | +            |               |
| Damerau-Levenshtein distance | +        | +         | +            | +             |
| Hamming distance             |          |           | +            |               |
| Longest common subsequence   | +        | +         |              |               |

Distance is a metric. Metric is a function which has following properties:

1. `dist(x, x) = 0` identity
2. `dist(x, y) >= 0` non-negativity
3. `dist(x, y) = dist(y, x)` symmetry
4. `dist(x, y) <= dist(x, z) + dist(z, y)` triangle inequality

Examples of metrics:

- Euclidean distance
- Manhattan distance
- Hamming distance

Different edit operations can have different cost. But if we want it to preserve metric properties deletion and insertion must be the same cost.

```
I N T E - N T I O N
- E X E C U T I O N
d s s   i s
```

- If each operation has cost of 1 - distance between these is 5.
- If substitutions cost 2 (Levenshtein) - distance between these is 8.

In order to determine minimal number of edit operations we need optimal squence alignment:

```
H A N D    H A N D - - - -     H A N D -
A N D I    - - - - A N D I     - A N D I
```

Some distances may have more than one algorithm to compute it, for example [Levenshtein distance](https://ceptord.net/20200815-Comparison.html):

- **Wagner-Fischer**. Wagner, Robert A., and Michael J. Fischer. "The string-to-string correction problem." Journal of the ACM 21.1 (1974): 168-173.
- **Myers**. Myers, Gene. "A fast bit-vector algorithm for approximate string matching based on dynamic programming." Journal of ACM (JACM) 46.3 (1999): 395-415.

Distance-like measures which does not hold metric properties are called **dissimilarities**.

Distance-like measures require sequential data e.g. interpret string as array of tokens (letters or words).

### String similarity

**Similarity** is the measure of how two strings are similar. For distance - the lower the value, the closer the two strings. But for similarity: the higher the value, the closer the two strings.

Similarity is not a metric. Edit distance can be converted to similarity, for example:

```
sim(x, y) = 1 - dist(x, y) / max(len(x), len(y))
```

On the other hand similarity doesn't have to rely on edit distance. For example, simplest but probably not most effective measure can be number of similar symbols in the string (aka unigrams). But trigrams would be quite good estimation.

```
dice(x ,y) = 2 * len(commom(x, y)) / (len(x) + len(y))
```

Normalized similarity is in the range `[0, 1]` . Where 0 means strings are different, 1 that strings are equal.

Similarity often doesn't need alignment, so it's much computationally-cheaper to calculate. It can be used to pre-filter set of strings before applying more expensive edit distance algorithms.

### String is ...

String can be treated as sequence of letters or as sequence of words or can be converted to n-grams (unigrams, bigrams, trigrams etc.)

Classically edit distance applied to letters. `abc` vs `acb` - one transposition. But also it can be applied to words `abc def` vs `def abc` - one transposition.

If we want to work with words we need tokenizer, which is language dependant. The most primitive tokenizer for western languages is to split string by all non-alphanumeric letters. `Hello, Joe!` turns into `Hello`, `Joe`. But this approach is quite limited and doesn't work for words like, `O'neil`, `aren't`, `T.V.`, `B-52`, compound proper nouns, etc. Also this approach doesn't work for CJK (Chinese, Japanese, Korean).

### n-grams

[n-grams](https://en.wikipedia.org/wiki/N-gram) is a set of all substrings of length `n` contained in a given string. For example, `abc` bigrams are `ab` and `bc`.

n-grams can be padded. We can add special symbol(s) before and after string to increase number of strings. For example `bigram-1ab` for `abc` are `#a`, `ab`, `bc`, `c#`.

Sometimes padded n-grams give much better similarity measure. For example, it is empiracally shown that `trigram-2b` gives much better result for matching drug names with errors. See [Similarity as a risk factor in drug-name confusion errors, B Lambert et al., 1999](https://www.researchgate.net/profile/Sanjay-Gandhi-3/publication/12701019_Similarity_as_a_risk_factor_in_drug-name_confusion_errors_the_look-alike_orthographic_and_sound-alike_phonetic_model/links/0deec51e6f14b979c1000000/Similarity-as-a-risk-factor-in-drug-name-confusion-errors-the-look-alike-orthographic-and-sound-alike-phonetic-model.pdf).

n-grams are language independent (unlike tokenization). n-grams can be used to create indexes in database, for example PostgreSQL has trigram index.

### Overlap coefficient

Overlap coefficient is the type of similarity which works for sets. In cotext of strings - can be applied to n-grams or set of tokens (words).

| name                            | formula                                             | comment                                                                                           |
| ------------------------------- | --------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| Jaccard index                   | \|x ∩ y\| / \|x ∪ y\|                               | Grove Karl Gilbert in 1884, Paul Jaccard, Tanimoto                                                |
| Dice coefficient                | 2\|x ∩ y\| / (\|x\| + \|y\|)                        | Lee Raymond Dice in 1945, Thorvald Sørensen in 1948. The same as F1 (?)                           |
| Tversky index                   | \|x ∩ y\| / (\|x ∩ y\| + a\|x \\ y\| + b\|y \\ x\|) | Amos Tversky in 1977. If a=b=1 the same as Jaccard index. If a=b=0.5 the same as Dice coefficient |
| Szymkiewicz–Simpson coefficient | \|x ∩ y\| / min(\|x\|, \|y\|)                       | Sometimes called overlap coefficient                                                              |

### Relevance and ranking

> Relevance is the degree to which something is related or useful to what is happening or being talked about:
>
> -- https://dictionary.cambridge.org/dictionary/english/relevance

> Relevance is the art of ranking content for a search based on how much that content satisfies the needs of the user and the business. The devil is completely in the details.
>
> -- https://livebook.manning.com/book/relevant-search/chapter-1/8

Sometimes relevance and ranking considered to be separate steps.

Relevance is a binary function which returns `true` or `false` e.g. if document (row in a table) is relevant to the search or not.

Ranking is a function which assigns some score to each relevant result in order to bring more relevant results in the top of the list.

Relevance and ranking are connected. Sometimes it can be calculated in one step, for example, calculate similarity - similarity would be ranking function, and relevance would be similarity more than some threshold. Sometimes it can be two different steps and two different algorithms.

### Phonetic indexing

> Index - a list (as of bibliographical information or citations to a body of literature) arranged usually in alphabetical order of some specified datum (such as author, subject, or keyword)
>
> -- https://www.merriam-webster.com/dictionary/index

Phonetic algorithm able to prodcue some kind of hash. If hash for different words the same we can assume that those words sound the same.

Phonetic algorithms are language dependent and typically used to compare people names, which can have different spelling, for example `Claire` and `Clare`.

Phonetic algorithm returns a hash, two hashes can be compared - this way we can get relevance function. For ranking function we can use for example edit distance or similarity.

| name                    | language                                                            | comment                                                                             |
| ----------------------- | ------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Soundex                 | En                                                                  | Robert C. Russell and Margaret King Odell around 1918                               |
| Cologne phonetics       | En (optimized to match the German language)                         | Hans Joachim Postel in 1969                                                         |
| NYSIIS                  | En                                                                  | Sometimes called Reverse Soundex. 1970                                              |
| Match rating approach   | En                                                                  | Western Airlines in 1977                                                            |
| Daitch–Mokotoff Soundex | En                                                                  | Add support for Germanic or Slavic surnames. Gary Mokotoff and Randy Daitch in 1985 |
| Metaphone               | En                                                                  | Lawrence Philips in 1990                                                            |
| Double metaphone        | En (of Slavic, Germanic, Celtic, Greek, Chinese, and other origins) | Lawrence Philips in 2000                                                            |
| Metaphone 3             | En                                                                  | Lawrence Philips in 2009                                                            |
| Caverphone              | En (optimized for accents present in parts of New Zealand)          | David Hood in 2002                                                                  |
| Beider–Morse            | En                                                                  | Improvement over Daitch–Mokotoff Soundex. 2008                                      |

Other variations of Soundex:

- ONCA - The Oxford Name Compression Algorithm
- Phonex
- SoundD

Algorithms for other languages:

- [French Phonetic Algorithms](https://yomguithereal.github.io/talisman/phonetics/french)
- [German Phonetic Algorithms](https://yomguithereal.github.io/talisman/phonetics/german)

## Types of search

| Type of search | Is precise? | Name             | Intention                        | Example of data                                             |
| -------------- | ----------- | ---------------- | -------------------------------- | ----------------------------------------------------------- |
| text           | precise     | Substring search | starts/ends with..., contains... | logs, match by part of word, etc.                           |
|                |             | Regexp           | contains pattern                 | logs, match by part of word, etc.                           |
|                | approximate | Phonetic         | sounds like                      | names, emails, words with alternative spelling, etc.        |
|                |             | Orhtographic     | looks like                       | drug names, biological species, typos in proper nouns, etc. |
|                |             | Full-text        | relevant to                      | texts in natural language                                   |
| parametric     | precise     | Filter           | filter rows by parameters        | structured data, like RBDMS tables                          |
