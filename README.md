# ImbalancedLearning: R package for undersampling and oversampling of imbalanced data sets

The aim of the project is to provide an R package that implements a variety of undersampling and oversampling algorithms. The implementation should include parallelization (multi-core and multi-node) as an option for performance and scalability.

## About

Learning from imbalanced datasets is challenging for standard classification algorithms, as they are designed to work with balanced class distributions. Although there are different strategies to tackle this problem, methods that address the problem through the resampling of the data set through the undersampling of the majority class or the oversampling of the minority class, constitute a more general approach compared to algorithmic modifications. The resulting data sets can be used by any algorithm, not constraining the options of the user.

## Roadmap

* Compare the performance and scalability of various implementations of nearest neighbour algorithms.
* Implement random undersampling/random oversampling and establish the API for the next implementations.
* Implement SMOTE.
* Implement various published algorithms.
* Propose and implement experimental algorithms for undersampling/oversampling.
* Provide an interface to compare the performance of the algorithms on imbalanced data sets.

## Development

We welcome new contributors of all experience levels.

## Current implementation

The current implementation is a quick prototype (and therefore very low code quality) of random oversampling (random.R) , SMOTE (smote.R) and SOMO (somo.R). There is also a function that compares the results of these oversampling algorithms (eval.R).  

## References

N.V. Chawla, N. Japkowicz, and A. Kolcz. 2003. “Workshop Learning from Imbalanced Data Sets II.” Proc. Int’l Conf. Machine Learning.

Aggarwal, Charu C., Alexander Hinneburg, and Daniel A. Keim. 2001. “On the Surprising Behavior of Distance Metrics in High Dimensional Space.” Database Theory – ICDT 2001: 420–34.

Akbani, Rehan, Stephen Kwek, and Nathalie Japkowicz. 2004. “Applying Support Vector Machine to Imbalanced Datasets.” Machine Learning: ECML 2004: 39–50.

Barua, Sukarna, Md Monirul Islam, Xin Yao, and Kazuyuki Murase. 2014. “MWMOTE - Majority Weighted Minority Oversampling Technique for Imbalanced Data Set Learning.” IEEE Transactions on Knowledge and Data Engineering 26(2): 405–25.

Batista, Gustavo E. A. P. A., Ronaldo C. Prati, and Maria Carolina Monard. 2004. “A Study of the Behavior of Several Methods for Balancing Machine Learning Training Data.” ACM SIGKDD Explorations Newsletter - Special issue on learning from imbalanced datasets 6(1): 20–29. 

Bellman, R.E. 1961. “Adaptive Control Processes: A Guided Tour.” Princeton University Press 28: 1–19. http://arxiv.org/abs/1302.6677.

Beyer, Kevin, Jonathan Goldstein, Raghu Ramakrishnan, and Uri Shaft. 1999. “When Is ‘nearest Neighbor’ Meaningful?” Database Theory—ICDT’99: 217–35. 

Bunkhumpornpat, Chumphol, Krung Sinapiromsaran, and Chidchanok Lursinsap. 2009. “Safe-Level-SMOTE: Safe-Level-Synthetic Minority over-Sampling Technique for Handling the Class Imbalanced Problem.” In Lecture Notes in Computer Science (Including Subseries Lecture Notes in Artificial Intelligence and Lecture Notes in Bioinformatics), , 475–82.

Chawla, Nitesh V., Kevin W. Bowyer, Lawrence O. Hall, and W. Philip Kegelmeyer. 2002. “SMOTE: Synthetic Minority over-Sampling Technique.” Journal of Artificial Intelligence Research 16: 321–57.

D.A. Cieslak and N.V. Chawla, A. Striegel. 2006. “Combating Imbalance in Network Intrusion Datasets.” IEEE Int. Conf. Granular Comput.: 732–37.

Domingos, Pedro. 1999. “MetaCost : A General Method for Making Classifiers.” In Proceedings of the 5th International Conference on Knowledge Discovery and Data Mining, , 155–64.

E. Merenyi, K. Tasdemir and Zhang L. 2009. “Learning Highly Structured Manifolds: Harnessing the Power of SOMs. Springer.” Similarity-Based Clustering, LNAI 5400: 138–168.

Fernández, Alberto et al. 2013. “Analysing the Classification of Imbalanced Data-Sets with Multiple Classes: Binarization Techniques and Ad-Hoc Approaches.” Knowledge-Based Systems 42: 97–110.

Friedman, Jerome H. 2001. “Greedy Function Approximation: A Gradient Boosting Machine.” Annals of Statistics 29(5): 1189–1232.

Han, Hui, Wen-Yuan Wang, and Bing-Huan Mao. 2005. “Borderline-SMOTE: A New Over-Sampling Method in Imbalanced Data Sets Learning.” Advances in intelligent computing 17(12): 878–87. 

He, H., Bai, Y., Garcia, E., & Li, S. 2008. “ADASYN: Adaptive Synthetic Sampling Approach for Imbalanced Learning. In IEEE International Joint Conference on Neural Networks, 2008.” IJCNN 2008.(IEEE World Congress on Computational Intelligence) (pp. 1322– 1328): 1322– 1328.

He, Haibo, and Edwardo A. Garcia. 2009. “Learning from Imbalanced Data.” IEEE Transactions on Knowledge and Data Engineering 21(9): 1263–84.

Japkowicz, N. 2000. “Learning from Imbalanced Data Sets. Proc. Am. Assoc.” Artificial Intelligence (AAAI) Workshop.

Jo T. and Japkowicz N. 2004. “Class Imbalances versus Small Disjuncts.” ACM Sigkdd Explorations Newsletter 6: 40–49.

Kubat, Miroslav, and Stan Matwin. 1997. “Addressing the Curse of Imbalanced Training Sets: One Sided Selection.” ICML 97: 179–86.

Laurikkala, J. 2001. "Improving identification of difficult small classes by balancing class distribution." Artificial Intelligence in Medicine, 63-66.


N.V. Chawla. “, Data Mining for Imbalanced Data Sets: An Overview, Data Mining and Knowledge Discovery Handbook.” Springer: 875–86.

Nekooeimehr, Iman, and Susana K. Lai-Yuen. 2016. “Adaptive Semi-Unsupervised Weighted Oversampling (A-SUWO) for Imbalanced Datasets.” Expert Systems with Applications 46: 405–16.

P. Hart. 1968. “The Condensed Nearest Neighbor Rule.” IEEE Trans. Inform. Theory 14: 515–516.

Prati, R.C., Batista, G.E. and Silva, D.F. 2014. “Class Imbalance Revisited: A New Experimental Setup to Assess the Performance of Treatment Methods.” Knowledge and Information Systems: 1–24.

Tomek, Ivan. 1976. “Two Modifications of CNN.” IEEE Transactions on Systems, Man and Cybernetics 6: 769–72. 

Wilson, Dennis L. 1972. “Asymptotic Properties of Nearest Neighbor Rules Using Edited Data.” IEEE Transactions on Systems, Man and Cybernetics 2(3): 408–21.

Zhao, Xing Ming, Xin Li, Luonan Chen, and Kazuyuki Aihara. 2008. “Protein Classification with Imbalanced Data.” Proteins: Structure, Function and Genetics 70(4): 1125–32.
