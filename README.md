# Description of the French National Forest Inventory data
# Georges Kunstler

Irstea EMGR Grenoble France <georges.kunstler@gmail.com>

## Introduction

This repository provides R codes to format the French National Forest Inventory. In this README I describes the data from the French National Forest Inventory (NFI). At the moment the code is quite messy and mainly provided in .Rmd file where R code is mixed with explanation. I need to split that in functions and text.

### Data downloaded
 The data were downloaded from
 [IGN website](http://inventaire-forestier.ign.fr/spip/spip.php?rubrique153) for each of
 following year of inventory: 2008 to 2013. For each year, four files are provided: individual alive trees data, individual dead trees data, ecological data. To merge data for each year, it is need to homogenize the different variables because the variables and the category of the variables have changed between years (see at the end of the document). 

## Data description

A detail description of the French NFI is provided by [Vidal et al. (2005)](http://www.nrs.fs.fed.us/pubs/gtr/gtr_wo077/gtr_wo077_067.pdf).

Here is a short description.
The French National Forest Inventory comprises a network of temporary plots established on a grid of approximately 1000 x 1000 m. Ten percent of the cell is sampled each year. If a particular grid node falls within a forested area, a plot is established (randomly located in a square of 450m around the center of the cell), the soil type is characterized and dendrometric data are measured. Measurements are taken in three concentric circular subplots of different radii, based on circumference at breast height ($C_{130}$). All trees with $C_{130}$  > 23.5 cm, > 70.5 cm and > 117.5 cm are measured within a radius of 6 m, 9 m and 15 m, respectively.  For each measured tree, stem circumference, species, status (dead or alive, including only tree that died less than five years ago according to bark and small branches state), and radial growth over five years were recorded.  The radial growth are determined from two short cores taken at breast height.  Soil properties are analysed using a soil pit of up to 1 m depth located in the center of the plot.  One or two soil horizons are distinguished from the soil pit, and depth, texture (based on eight classes) and coarse fragment content were recorded for each horizon.

## Processed data

* The basal area per species at the time of measurement was computed based on the circumference of each alive tree and their respective weight according to size of the subplot. We then computed the basal area five years before using the following information to reconstruct the stand:
    + the five years radial growth of alive tree,
	+ the tree that died during the five years period (so were alive five years ago),
	+ the trees that recruited during this period (their $C_{130}$ were below the minimum circumference five years ago according to their growth).

The following document give details about data formatting and the computation of the basal area at the two dates.


## Simplified tree

If the number of tree of given species and a given size class
($C_{130}$ classes 23.5-70.5, 70.5-117.5, 117.5-164.5, more than 164.5cm) is greater than 6, the radial growth is measured only on 6 individuals. To compute the basal area on the plot 5-years ago it is need to estimate the growth of the trees lacking growth measurement (simplified tree). We explored two methods to predict the growth of this individuals. 

* We affected to the individual with missing growth data on a plot the average growth rate of the measured individual of the same species and same size class.
* We fitted mixed model of radial growth ($G$) as a function of $C_{130}$ ($log(G) = a_p + b \times log(C_{130})$ with a random intercept drawn for each plot ($a_p$). We then predicted radial growth for each tree with missing data according to their $C_{130}$ and their plot. The model was fitted in a Hierarchical Bayesian framework using JAGS (Plummer 2003).

We used the prediction of the mixed model because it allows for a continuous effect of tree size ($C_{130}$).

## Recruitment

A tree was considered as a recruit during the five years period if according to its five years radial growth rate it $C_{130}$ was less than 23.5cm five years ago ($C_{130} -G \times 2 < 23.5$).


## Matching of different years

See R script READ.DATA.NFI.R

### Alive tree

- *simplif* and *sfcoeur* are missing in 2008.


### Plot data

- The variables $gest$ $incid$ $peupnr$ $asperite$ $tm2$ were
missing in 2008.

### Ecological data

We only use the pedological variables. The was no changes in variables between years for the variables we used (soil description).



## References

- Kunstler, G., Albert, C.H., Courbaud, B., Lavergne, S., Thuiller, W., Vieilledent, G., Zimmermann, N.E., Coomes, D.A. (2011) Effects of competition on tree radial-growth vary in importance but not in intensity along climatic gradients. Journal of Ecology, **99**, 300–312.

- Plummer, M. (2003) JAGS: A program for analysis of Bayesian graphical models using Gibbs sampling. In Proceedings of the 3rd International Workshop on Distributed Statistical Computing (DSC 2003). March, pp. 20–22.
