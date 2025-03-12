#### Week 8
** Two ANOVA models were used to calculate p-values of treatments done on malathion datasets**

The reuslt of both models is shown in the following table. The R script related to this analysis is available [here](code/scripts/week8). 

| Index | Chromosome | Position | logp.x     | logp.y     |
|-------|-----------|----------|------------|------------|
| 1     | chrX      | 316075   | 0.21718506 | 0.22209860 |
| 2     | chrX      | 336075   | 0.33603094 | 0.34591865 |
| 3     | chrX      | 356075   | 0.41239107 | 0.42662523 |
| 4     | chrX      | 376075   | 0.38940081 | 0.40222365 |
| 5     | chrX      | 396075   | 0.36248061 | 0.37376460 |
| 6     | chrX      | 416075   | 0.12130618 | 0.12353085 |
| 7     | chrX      | 436075   | 0.09138484 | 0.09296253 |
| 8     | chrX      | 456075   | 0.09658811 | 0.09827273 |
| 9     | chrX      | 476075   | 0.11798080 | 0.12012961 |
| 10    | chrX      | 496075   | 0.14175556 | 0.14447017 |

logp.x corresponds to the ANOVA model whre the net effect of the treament equals to zero. And logp.y is calculated with the ANOVA model where there is a two-way interaction between treat and founder. 