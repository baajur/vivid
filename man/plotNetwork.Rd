% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotNetwork.R
\name{plotNetwork}
\alias{plotNetwork}
\title{plotNetwork}
\usage{
plotNetwork(
  mat,
  thresholdValue = 0,
  label = FALSE,
  minInt = 0,
  maxInt = NULL,
  minImp = 0,
  maxImp = NULL,
  labelNudge = 0.05,
  layout = "circle",
  cluster = F,
  ...
)
}
\arguments{
\item{mat}{A matrix of values to be plotted. Either added by the user or created using the prepFunc() function.}

\item{thresholdValue}{A value chosen by the user which will show all the edges with weights (i.e., the interacions) above that value. For example, if thresholdValue = 0.2, then only the the interacions greater than 0.2 will be displayed.}

\item{label}{If label = TRUE the numerical value for the interaction strength will be displayed.}

\item{minInt}{Minimum interaction strength to be displayed on the legend.}

\item{maxInt}{Maximum interaction strength to be displayed on the legend.}

\item{minImp}{Minimum importance value to be displayed on the legend.}

\item{maxImp}{Maximum importance value to be displayed on the legend.}

\item{labelNudge}{A value, set by the user, to determine the y_postioning of the variables names. A higher value will postion the label farther above the nodes.}

\item{layout}{Determines the shape, or layout, of the plotted graph.}

\item{cluster}{If cluster = TRUE, then the data is clustered in groups.}

\item{...}{Not currently implemented.}
}
\value{
A newtwork style plot displaying interaction strength between variables on the edges and variable importance on the nodes.
}
\description{
Create a Network style plot displaying Variable
 and Variable Interaction.
}
\examples{
# Load in the data:
aq <- data.frame(airquality)
aq <- na.omit(aq)

# Run an mlr ranger model:
library(mlr3)
library(mlr3learners)
library(ranger)
aq_Task = TaskRegr$new(id = "airQ", backend = aq, target = "Ozone")
aq_lrn = lrn("regr.ranger", importance = "permutation")
aq_Mod <- lrn$train(aq_Task)

#' # Create matrix
myMat <- prepFunc(task = aq_Task, learner = aq_Lrn, model = aq_Mod)

# Create graph:
plotNetwork(myMat, thresholdValue = 0, cluster = F)

}
