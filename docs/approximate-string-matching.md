# Approximate string matching

a.k.a. string proximity search, error-tolerant search, string similarity search, fuzzy string searching, error tolerant pattern matching.

## Definitions

### Edit distance

**Edit distance** of two strings `dist(x, y)` is the minimal number of edit operations needed to transform first `x` into second `y`.

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

- Euclidean distanc
- Manhattan distance
- Hamming distance

Different edit operations can have different cost. But if we want it to preserve metric properties deletion and insertion must be the same cost.

```
I N T E * N T I O N
* E X E C U T I O N
d s s   i s
```

- If each operation has cost of 1 - distance between these is 5.
- If substitutions cost 2 (Levenshtein) - distance between these is 8.

In order to determine minimal number of edit operations we need optimal squence alignment:

```
h a n d    h a n d - - - -     h a n d -
a n d i    - - - - a n d i     - a n d i
```

Some distances may have more than one algorithm to compute it, for example [Levenshtein distance](https://ceptord.net/20200815-Comparison.html):

- **Wagner-Fischer**. Wagner, Robert A., and Michael J. Fischer. "The string-to-string correction problem." Journal of the ACM 21.1 (1974): 168-173.
- **Myers**. Myers, Gene. "A fast bit-vector algorithm for approximate string matching based on dynamic programming." Journal of ACM (JACM) 46.3 (1999): 395-415.

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

String can be treated as sequence of letters or as sequence of words or can be converted to q-grams (unigrams, bigrams, trigrams etc.)

Classically edit distance applied to letters. `abc` vs `acb` - one transposition. But also it can be applied to words `abc def` vs `def abc` - one transposition.

If we want to work with words we need tokenizer, which is language dependant. The most primitive tokenizer for western languages is to split string by all non-alphanumeric letters. `Hello, Joe!` turns into `Hello`, `Joe`. But this approach is quite limited and doesn't work for words like, `O'neil`, `aren't`, `T.V.`, `B-52`, compound proper nouns, etc. Also this approach doesn't work for CJK (Chinese, Japanese, Korean).

### q-grams

q-grams is a set of all substrings of length `q` contained in a given string. For example, `abc` bigrams are `ab` and `bc`.

q-grams can be padded. We can add special symbol(s) before and after string to increase number of strings. For example `bigram-1ab` for `abc` are `#a`, `ab`, `bc`, `c#`.

Sometimes padded q-grams give much better similarity measure. For example, it is empiracally shown that `trigram-2b` gives much better result for matching drug names with errors. See [Similarity as a risk factor in drug-name confusion errors, B Lambert et al., 1999](https://www.researchgate.net/profile/Sanjay-Gandhi-3/publication/12701019_Similarity_as_a_risk_factor_in_drug-name_confusion_errors_the_look-alike_orthographic_and_sound-alike_phonetic_model/links/0deec51e6f14b979c1000000/Similarity-as-a-risk-factor-in-drug-name-confusion-errors-the-look-alike-orthographic-and-sound-alike-phonetic-model.pdf).

q-grams are language independent (unlike tokenization). q-grams can be used to create indexes in database, for example PostgreSQL has trigram index.

## Types of search

| Type of search | Is precise? | Name             | Intention                        | Example of data                                             |
| -------------- | ----------- | ---------------- | -------------------------------- | ----------------------------------------------------------- |
| text           | precise     | Substring search | starts/ends with..., contains... | logs, match by part of word, etc.                           |
|                |             | Regexp           | contains pattern                 | logs, match by part of word, etc.                           |
|                | approximate | Phonetic         | sounds like                      | names, emails, words with alternative spelling, etc.        |
|                |             | Orhtographic     | looks like                       | drug names, biological species, typos in proper nouns, etc. |
|                |             | Full-text        | relevant to                      | texts in natural language                                   |
| parametric     | precise     | Filter           | filter rows by parameters        | structured data, like RBDMS tables                          |
