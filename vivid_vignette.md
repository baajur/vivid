Introduction
------------

This package was designed to help a user to easily distinguish which
variables in a model are important and which variables interact with
each other. It does this by giving the user different plotting options.
These include a heat-map style plot that displays 2-way interactions and
individual variable importance. Also, a network style plot where the
size of a node represents variable importance (the bigger the node, the
more important the variable) and the edge weight represents the 2-way
interaction strength. Also included is an option to display partial
dependence plots that utilize an Eularian tour to help the user to
easily identify which variables interact the most. The interaction is
calculated using *Friedman’s H-Statistic*[1]

Data used in this vignette:
---------------------------

The data used in the following examples is the *abalone* data from the
`AppliedPredictiveModeling` package[2] which contains measurements
obtained from 4177 abalones. The data contains measurements of the type
(male, female and infant), the longest shell measurement, the diameter,
height and whole, shucked, viscera and shell weights. The response
variable is rings. The age of the abalone can be determined by counting
the rings plus 1.5. The variables are described as follows:

-   Rings: +1.5 gives the age in years.

-   Longest shell: Longest shell measurement (mm).

-   Diameter: Perpendicular to length (mm).

-   Height: With meat in shell (mm).

-   Whole weight: Whole abalone (gm).

-   Shucked weight: Weight of meat (gm).

-   Viscera weight: Gut weight (after bleeding) (gm).

-   Shell weight: After being dried (gm).

In all the following examples, a subset of the data is used and *Rings*
is used as the response variable.

Commands:
---------

`plotHeatMap()`
===============

------------------------------------------------------------------------

*Create a Heat-map style plot displaying Variable Importance and
Variable Interaction*

------------------------------------------------------------------------

**Description**

Plots a heat-map of the interaction strength with variable importance on
the off-diagonal

**Usage**

plotHeatMap(task, model, plotly, intLow, intHigh, impLow, impHigh, top,
reorder)

**Example**

Load in the data:

    library(AppliedPredictiveModeling)
    data(abalone)
    ab <- data.frame(abalone)
    ab <- na.omit(ab)
    ab <- ab[1:1500,]

Run an `mlr` random forest model:

    library(mlr)
    #> Loading required package: ParamHelpers
    #> 'mlr' is in maintenance mode since July 2019. Future development
    #> efforts will go into its successor 'mlr3' (<https://mlr3.mlr-org.com>).
    ab_task  <- makeRegrTask(data = ab, target = "Rings")
    ab_lrn <- makeLearner("regr.randomForest")
    ab_mod <- train(ab_lrn, ab_task)

To call the plot we use the `plotHeatMap()` command as follows:

    set.seed(1701)
    plotHeatMap(ab_task, ab_mod,  plotly = F,
              intLow = "floralwhite", intHigh = "dodgerblue4",
              impLow = "white", impHigh = "firebrick1")
    #>  Calculating variable importance...

![](/private/var/folders/gw/f3ycbbl96g96twvwg075c7cr0000gn/T/RtmpACFrNm/preview-370d5afb1ecf.dir/vivid_files/figure-markdown_strict/unnamed-chunk-4-1.png)
<center>
Fig 1.0: *Heat-map style plot displaying 2-way interaction strength in
blue and individual variable importance on the diagonal in red.*
</center>
From the above plot we can see that `LongestShell:VisceraWeight` weight
has the strongest interaction and `ShellWeight` is the most important
variable for predicting `rings`.

`plotNetwork()`
===============

------------------------------------------------------------------------

*Create a Network style plot displaying Variable Importance and Variable
Interaction*

------------------------------------------------------------------------

**Description**

Plots a network style graph, where node size represents variable
importance and edge width and colour represents interaction strength.
The edge colour is displayed as a gradient from black to red. Black
represents a weak interaction, whereas red displays stronger
interactions.

**Usage**

plotNetwork(task, model, thresholdValue = 0, label = FALSE, minInt = 0,
maxInt = NULL, minImp = 0, maxImp = NULL, labelNudge = 0.05, layout =
“circle”, cluster = F,…) **Example**

Load in the data:

    library(AppliedPredictiveModeling)
    data(abalone)
    ab <- data.frame(abalone)
    ab <- na.omit(ab)
    ab <- ab[1:1500,]

Run an `mlr` random forest model:

    library(mlr)
    ab_task  <- makeRegrTask(data = ab, target = "Rings")
    ab_lrn <- makeLearner("regr.randomForest")
    ab_mod <- train(ab_lrn, ab_task)

To call the plot we use the `plotNetwork()` command as follows:

    set.seed(1701)
    plotNetwork(task = ab_task, model = ab_mod, thresholdValue = 0, 
                  minInt = 0, maxInt = 1, 
                  minImp = 0, maxImp = 100,
                  labelNudge = 0.05)
    #>  Calculating variable importance...
    #> $`Variable Importance:`
    #>          Type  LongestShell      Diameter        Height   WholeWeight 
    #>          1.00          2.22          2.49          2.55          3.48 
    #> ShuckedWeight VisceraWeight   ShellWeight 
    #>          2.91          2.99          5.00 
    #> 
    #> $`Interaction Matrix:`
    #>                       Type LongestShell     Diameter       Height  WholeWeight
    #> Type          478.74145395    0.2911013 1.994324e-01 7.773153e-02 4.939713e-02
    #> LongestShell    0.29110133 1738.7592849 1.860490e-01 7.426678e-01 1.404499e-01
    #> Diameter        0.19943241    0.1860490 2.013360e+03 1.733448e-01 1.197742e-01
    #> Height          0.07773153    0.7426678 1.733448e-01 2.082786e+03 6.031257e-02
    #> WholeWeight     0.04939713    0.1404499 1.197742e-01 6.031257e-02 3.039926e+03
    #> ShuckedWeight   0.05328841    0.1250570 1.596405e-01 9.673288e-02 2.465170e-01
    #> VisceraWeight   0.19911615    1.0031715 2.749365e-01 2.772544e-01 1.139134e-01
    #> ShellWeight     0.03098178    0.1205595 9.154504e-02 5.992126e-02 6.398036e-02
    #>               ShuckedWeight VisceraWeight  ShellWeight
    #> Type           5.328841e-02  1.991161e-01 3.098178e-02
    #> LongestShell   1.250570e-01  1.003172e+00 1.205595e-01
    #> Diameter       1.596405e-01  2.749365e-01 9.154504e-02
    #> Height         9.673288e-02  2.772544e-01 5.992126e-02
    #> WholeWeight    2.465170e-01  1.139134e-01 6.398036e-02
    #> ShuckedWeight  2.451483e+03  6.289149e-02 2.652974e-01
    #> VisceraWeight  6.289149e-02  2.536229e+03 9.683194e-02
    #> ShellWeight    2.652974e-01  9.683194e-02 4.607903e+03
    #> 
    #> [[3]]

![](/private/var/folders/gw/f3ycbbl96g96twvwg075c7cr0000gn/T/RtmpACFrNm/preview-370d5afb1ecf.dir/vivid_files/figure-markdown_strict/unnamed-chunk-7-1.png)
<center>
Fig 2.0: *Network style plot displaying 2-way interaction strength
between each of the variables and individual variable importance*
</center>
The edge width, in the above plot, indicates the interaction strength,
with the actual value displayed in the centre of of the edges. The
colour of the edges also visually represents the interaction strength
through use a of colour gradient, with low values being in black and
high values being in red.

The node size represents individual variable importance with respect to
predicting the response.

From the above plot we can see that `LongestShell:VisceraWeight` weight
has the strongest interaction and `ShellWeight` is the most important
variable for predicting `rings`.

The user can control which interaction values to display by using the
`thresholdValue` argument. In the following example,
`thresholdValue = 0.11` means that only the the edges with weights
(i.e., the interactions) above 0.09 are displayed:

    set.seed(1701)
    plotNetwork(task = ab_task, model = ab_mod, method = "randomForest_importance", thresholdValue = 0.11, cluster = F)
    #>  Calculating variable importance...
    #> $`Variable Importance:`
    #>          Type  LongestShell      Diameter        Height   WholeWeight 
    #>          1.00          2.22          2.49          2.55          3.48 
    #> ShuckedWeight VisceraWeight   ShellWeight 
    #>          2.91          2.99          5.00 
    #> 
    #> $`Interaction Matrix:`
    #>                       Type LongestShell     Diameter       Height  WholeWeight
    #> Type          478.74145395    0.2911013 1.994324e-01 7.773153e-02 4.939713e-02
    #> LongestShell    0.29110133 1738.7592849 1.860490e-01 7.426678e-01 1.404499e-01
    #> Diameter        0.19943241    0.1860490 2.013360e+03 1.733448e-01 1.197742e-01
    #> Height          0.07773153    0.7426678 1.733448e-01 2.082786e+03 6.031257e-02
    #> WholeWeight     0.04939713    0.1404499 1.197742e-01 6.031257e-02 3.039926e+03
    #> ShuckedWeight   0.05328841    0.1250570 1.596405e-01 9.673288e-02 2.465170e-01
    #> VisceraWeight   0.19911615    1.0031715 2.749365e-01 2.772544e-01 1.139134e-01
    #> ShellWeight     0.03098178    0.1205595 9.154504e-02 5.992126e-02 6.398036e-02
    #>               ShuckedWeight VisceraWeight  ShellWeight
    #> Type           5.328841e-02  1.991161e-01 3.098178e-02
    #> LongestShell   1.250570e-01  1.003172e+00 1.205595e-01
    #> Diameter       1.596405e-01  2.749365e-01 9.154504e-02
    #> Height         9.673288e-02  2.772544e-01 5.992126e-02
    #> WholeWeight    2.465170e-01  1.139134e-01 6.398036e-02
    #> ShuckedWeight  2.451483e+03  6.289149e-02 2.652974e-01
    #> VisceraWeight  6.289149e-02  2.536229e+03 9.683194e-02
    #> ShellWeight    2.652974e-01  9.683194e-02 4.607903e+03
    #> 
    #> [[3]]

![](/private/var/folders/gw/f3ycbbl96g96twvwg075c7cr0000gn/T/RtmpACFrNm/preview-370d5afb1ecf.dir/vivid_files/figure-markdown_strict/unnamed-chunk-8-1.png)
<center>
Fig 2.1: *Network style plot displaying thresholded 2-way interaction
strengths between each of the variables and individual variable
importance. In this plot only the interactions greater than 0.11 are
shown.*
</center>
`ggpdpPairs()`
==============

------------------------------------------------------------------------

*Creates a pairs plot style matrix plot of the 2D partial dependence of
each of the variables in the upper diagonal, the individual pdp and ice
curves on the diagonal and a scatter-plot of the data on the lower
diagonal*

------------------------------------------------------------------------

*Description*

Plots a pdp (partial dependence plot) pairs style matrix. The partial
dependence plot shows the marginal effect one or two features have on
the predicted outcome of a machine learning model[3]. A partial
dependence plot is used to show whether the relationship between the
response variable and a feature is linear or more complex.

**Usage**

ggpdpPairs(task, model, method=“pdp”,vars=NULL, colLow = “\#132B43”,
colHigh = “\#56B1F7”, fitlims = NULL, gridsize = 10, class=1,
cardinality = 20)

**Example**

Load in the data:

    library(AppliedPredictiveModeling)
    data(abalone)
    ab <- data.frame(abalone)
    ab <- na.omit(ab)
    ab <- ab[1:1500,]

Run an `mlr` random forest model:

    library(mlr)
    ab_task  <- makeRegrTask(data = ab, target = "Rings")
    ab_lrn <- makeLearner("regr.randomForest")
    ab_mod <- train(ab_lrn, ab_task)

To call the pdp pairs plot we use:

    set.seed(1701)
    ggpdpPairs(task = ab_task, model =  ab_mod)

![](/private/var/folders/gw/f3ycbbl96g96twvwg075c7cr0000gn/T/RtmpACFrNm/preview-370d5afb1ecf.dir/vivid_files/figure-markdown_strict/unnamed-chunk-11-1.png)
<center>
Fig 3.0: *A pairs style matrix plot displaying the partial dependence
between each of the variables in the upper diagonal, the individual pdp
and ice curves on the diagonal and a scatter-plot on the lower diagonal*
</center>
From the above plot, we see the 2D pdp plots on the upper diagonal. The
individual pdp and ice cures on the diagonal and scatter-plots on the
lower diagonal. As `type` is a factor variable with 3 levels, a barplot
displaying the frequency is displayed on the diagonal and the individual
pdp curves are shown on the upper diagonal for this variable.

In addition to displaying both the variable importance and interactions
together, the following functions display only the variable importance
*or* the interaction strength.

`allInt()`
==========

------------------------------------------------------------------------

*Creates a plot, displaying the interaction strength for all the 2-way
interactions in a model*

------------------------------------------------------------------------

*Description* Plot displaying the 2-way interactions on the y-axis and
the interaction strength on the x-axis. This function also allows the
user to switch between a lollipop style plot (which is default) and a
barplot, by use of the `type` argument.

**Usage**

allInt(task, model, type)

**Example**

Load in the data:

    library(AppliedPredictiveModeling)
    data(abalone)
    ab <- data.frame(abalone)
    ab <- na.omit(ab)
    ab <- ab[1:1500,]

Run an `mlr` random forest model:

    library(mlr)
    ab_task  <- makeRegrTask(data = ab, target = "Rings")
    ab_lrn <- makeLearner("regr.randomForest")
    ab_mod <- train(ab_lrn, ab_task)

To call the pdp pairs plot we use:

    set.seed(1701)
    allInt(task = ab_task, model =  ab_mod, type = "barplot")
    #>  Initilizing...

![](/private/var/folders/gw/f3ycbbl96g96twvwg075c7cr0000gn/T/RtmpACFrNm/preview-370d5afb1ecf.dir/vivid_files/figure-markdown_strict/unnamed-chunk-14-1.png)
<center>
Fig 4.0: *A plot displaying all 2-way interaction in a model.*
</center>
From the above plot we can see that `LongestShell:VisceraWeight` has the
strongest interaction.

`interactionPlot()`
===================

------------------------------------------------------------------------

*Creates a plot, displaying the overall interaction strength for each
variable in a model*

------------------------------------------------------------------------

*Description* Plot displaying the variables on the y-axis and the
overall interaction strength on the x-axis. This function also allows
the user to switch between a lollipop style plot (which is default) and
a barplot, by use of the `type` argument.

**Usage**

interactionPlot(task, model, type)

**Example**

Load in the data:

    library(AppliedPredictiveModeling)
    data(abalone)
    ab <- data.frame(abalone)
    ab <- na.omit(ab)
    ab <- ab[1:1500,]

Run an `mlr` random forest model:

    library(mlr)
    ab_task  <- makeRegrTask(data = ab, target = "Rings")
    ab_lrn <- makeLearner("regr.randomForest")
    ab_mod <- train(ab_lrn, ab_task)

To call the pdp pairs plot we use:

    set.seed(1701)
    interactionPlot(task = ab_task, model =  ab_mod, type = "barplot")

![](/private/var/folders/gw/f3ycbbl96g96twvwg075c7cr0000gn/T/RtmpACFrNm/preview-370d5afb1ecf.dir/vivid_files/figure-markdown_strict/unnamed-chunk-17-1.png)
<center>
Fig 5.0: *A plot displaying the overall interaction strength for each
variable in a model.*
</center>
From the above plot we can see that the variable with the strongest
overall interaction strength is `ShellWeight`

`importancePlot()`
==================

------------------------------------------------------------------------

*Creates a plot, displaying the variable importance for each variable in
a model*

------------------------------------------------------------------------

*Description* Plots variables on the y-axis and the variable importance
on the x-axis. This function also allows the user to switch between a
lollipop style plot (which is default) and a barplot, by use of the
`type` argument.

**Usage**

importancePlot(task, model, type)

**Example**

Load in the data:

    library(AppliedPredictiveModeling)
    data(abalone)
    ab <- data.frame(abalone)
    ab <- na.omit(ab)
    ab <- ab[1:1500,]

Run an `mlr` random forest model:

    library(mlr)
    ab_task  <- makeRegrTask(data = ab, target = "Rings")
    ab_lrn <- makeLearner("regr.randomForest")
    ab_mod <- train(ab_lrn, ab_task)

To call the pdp pairs plot we use:

    set.seed(1701)
    importancePlot(task = ab_task, model =  ab_mod)

![](/private/var/folders/gw/f3ycbbl96g96twvwg075c7cr0000gn/T/RtmpACFrNm/preview-370d5afb1ecf.dir/vivid_files/figure-markdown_strict/unnamed-chunk-20-1.png)
<center>
Fig 6.0: *A plot displaying the variable importance for each variable in
a model.*
</center>
From the above plot, we can see that the most important variable, when
prediciting `rings` is `ShuckedWeight`

[1] Friedman, H. and Popescu, B.E. Predictive learning via rule
ensemble. The Annals of Applied Statistics. 2008. 916-954

[2] AppliedPredictiveModeling: Functions and Data Sets for ‘Applied
Predictive Modeling’. M. Kuhn and K. Johnson. 2018.
<a href="https://CRAN.R-project.org/package=AppliedPredictiveModeling" class="uri">https://CRAN.R-project.org/package=AppliedPredictiveModeling</a>

[3] Friedman, Jerome H. “Greedy function approximation: A gradient
boosting machine.” Annals of statistics (2001): 1189-1232.
