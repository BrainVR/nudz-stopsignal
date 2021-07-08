#' Title
#'
#' @param pth
#'
#' @return
#' @export
#'
#' @examples
load_experiment <- function(pth){
  dat <- read.table(pth, header=TRUE, sep="\t")
  return(dat)
}
