## This Script displays just variable importance

#' importancePlot
#'
#' @description Plots variable importance
#'
#' @param task Task created from the mlr package, either regression or classification.
#' @param model Any machine learning model.
#' @param method A list of variable importance methods to be set by the user. These can include any of the importance methods contained within the mlr package. The default is method = randomForest.
#' @param type The type of plot to display, either "lollipop" (default), "barplot", or "circleBar"
#' @param ... Not currently implemented
#'
#'
#' @importFrom mlr "getTaskData"
#' @importFrom mlr "normalizeFeatures"
#' @importFrom mlr "generateFilterValuesData"
#' @importFrom mlr "getTaskFeatureNames"
#' @importFrom iml "Predictor"
#' @importFrom iml "Interaction"
#' @importFrom ggplot2 "ggplot"
#'
#'@examples
#' # Load in the data:
#' aq <- data.frame(airquality)
#' aq <- na.omit(aq)
#'
#' # Run an mlr random forest model:
#' library(mlr)
#' library(randomForest)
#' aqRgrTask  <- makeRegrTask(data = aq, target = "Ozone")
#' aqRegrLrn <- makeLearner("regr.randomForest")
#' aqMod <- train(aqRegrLrn, aqRgrTask)
#'
#' # Create plot:
#' importancePlot(aqRgrTask, aqMod)
#'
#' @export



# Function ----------------------------------------------------------------



importancePlot <- function(task,model, method = "randomForest_importance", type = "lollipop", ...){

data <- getTaskData(task)

# Get Importance Measures -------------------------------------------------

normTask <- normalizeFeatures(task, method = "standardize")

impFeat <- generateFilterValuesData(normTask, method = method)
yImp <- impFeat$data$value
yImpRound <- round(yImp, 2)
nam <- getTaskFeatureNames(task)

yDF <- reorder(nam, yImp)
yDF <- data.frame(yDF)

# Barplot
p <- ggplot(yDF, aes(x = yDF, y = yImp)) +
  geom_col(aes(fill = yImp)) +
  scale_fill_gradient2(low = "white",
                       high = "firebrick1") +
  ggtitle(label = "Variable Importance") +
  geom_text(aes(label = yImpRound), vjust = 1.6, color = "black", size = 3.5)+
  theme_minimal() +
  xlab('Variable') +
  ylab("Importance\nValue") +
  theme(axis.title.y = element_text(angle = 0, vjust = 0.5)) +
  coord_flip()
p <- p + labs(fill = "Variable\nImportance")

# Circular barplot

  pp <- ggplot(yDF, aes(x=yDF, y=yImp)) +
    geom_col(aes(fill = yImp)) +
    scale_fill_gradient2(low = "white",
                         high = "firebrick1") +
    ylim(-1,max(yImp)) +
    theme_minimal() +
    theme(
      axis.text = element_blank(),
      axis.title = element_blank(),
      panel.grid = element_blank(),
      legend.position = c(0.9,0.5), #"none",
      plot.margin=unit(c(0,-2,0,0), "cm")) + # remove the margin and centre plot
    coord_polar(start = 0) + # This makes the coordinate polar instead of cartesian.
    geom_text(aes(label = nam), vjust = 1.6, color = "black", size = 3.5) +
    geom_text(aes(label = yImpRound),vjust = 4, color = "black", size = 3)
  pp <- pp + labs(fill = "Variable\nImportance") #+ ggtitle(label = "Variable Importance")


  # lollipop plot
  ppp <- ggplot( yDF, aes(x=yDF, y=yImp)) +
    geom_linerange(ymin=0, aes(ymax=yImp)) + geom_point()+
    xlab('Variable') +
    ylab("Importance\nValue") +
    theme_bw() +
    coord_flip()


  if(type == "barplot"){
    return(p)
  }else if(type == "circleBar"){
    return(pp)
  }else if(type == "lollipop")
    return(ppp)

}







