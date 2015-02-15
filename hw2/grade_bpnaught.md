### Homework report preparation: 10/10

* Is the homework submitted timely (Feb 11 @ 11:59PM)? Note submission time is defined as the git tagging time.
- Yes

* Is the report in pdf or html? 
- Yes

* How is the report prepared? RMarkdown/IPython is preferred, Sweave/LaTex is ok), but handwritten report is not accepted.
- Rmd
  
  * Is the report clear (whole sentences, typos, grammar)?
- Yes

* Do readers have a clear idea what's going on and how are results produced by just reading the report?
- Yes

### Q1: 10/10

* Are derivations complete, correct and clear?
- Yes

### Q2, Q3: 10/10

* Are the solutions at ranks r = 10, 20, 30, 40, 50 correct? Check objective values.

* Code style. Maximum 80 characters per line. Consistent indenting. Plenty of and clear comments.
- Yes

* Are all questions answered?
- Yes

### Q4: 6.4/10

* (5 pts) Are the starting points and convergence criterion same as described in Q4? Are the run times obtained on the teaching server? That is are the timing results comparable to others?
If yes, give 5 pts and go to the next bullet. If not, give 0 pts for Q4.
- Yes

* (5 pts) Efficiency of CPU code. Score = Dr Zhou's total Julia CPU run time (35.8400 seconds) / submitted total GPU run time * 5
- Time: 130.647
- Score: 1.4

### Q5, Q7: 9/10

* (5 pts) Do you find different starting points yield different answers? Are explanations given for the observations (Q5)?   
Give full credit if it's realized that it's a non-convex problem thus admits many local minima. It's _not_ defect of algorithm.
- Yes, but non-convexity was not mentioned.

* (5 pts) Do basis images (rows of W) at r = 50 appear right?
- Yes

### Q6 (bonus): 5.9/10

* (5 pts) Is GPU computing successful? Do they give same results as CPU version?
If yes, give 5 pts and go to the next bullet. If not, give 0 pts for Q6.
- Yes

* (5 pts) Efficiency of GPU code. Score = Dr Zhou's total GPU DP run time (7.8968 seconds) / submitted total GPU DP run time * 5
- Time: 42.816
- Score: 0.9

### Usage of Git: 10/10

* Are branches (`master` and `develop`) correctly set up? Is the hw submission put into the `master` branch?   
- Yes 

* Are there enough commits esp. in the `develop` branch? Are commit messages clear?
- Yes

* Is the hw2 submission tagged? HW submission time is according to tag time.
- Yes

* Are the folders (`hw1`, `hw2`, ...) created correctly?
- Yes

### Reproducibility: 10/10

* Are there sufficient materials (files and instructions) provided in the `master` branch for reproducing all the results?
- Yes

* Are there clear instructions, either in report and in a separate file, how to reproduce the results?
- Yes
