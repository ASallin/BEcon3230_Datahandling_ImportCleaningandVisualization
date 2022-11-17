##' Generate Points Frame
##'
##' Generates a data frame with dimensions No. of responses x No. of scanned exams, containing the respective no. of points per correct response.
##' @usage generate_points_frame(points)
##' @param file character, the path/filename of the csv file containing the scan results
##' @param points named list, list with key-value pairs question_group-points (e.g., list(group001=1.5, group002=3, group003=2))
##' @return a data.frame
##' @details The...
##' @author Ulrich Matter <umatter@protonmail.com>
##' @examples
##' myfile <- system.file("inst/exdata/example_scan_results.csv", package="examr")
##' points <- list(group001=1.5, group002=3, group003=2)
##' my_results <- generate_points_frame(myfile, solutions)
##'
##' @export
##'


generate_points_frame <-
     function(file, points) {

          # read scan results to get dimensions
          scans <- read_scan_results(file)[,-1:-2] # first and second cols are filenames and ids

          # check question groups
          q_names <- names(scans)
          groups_split <- strsplit(q_names, "_", fixed = TRUE)
          groups <- unlist(lapply(groups_split, function(x)x[1]))
          ugroups <- unique(groups)
          ugroups_input <- unique(names(points))

          if (!identical(union(ugroups, ugroups_input),intersect(ugroups, ugroups_input))) {
               stop("Question groups in points are not consistent with scan results!")
          } else {

               # create df of scan dimensions filled with respective no. of points
               points_frame <- as.data.frame(matrix(data = 0,
                                                    nrow = nrow(scans),
                                                    ncol = ncol(scans)))
               names(points_frame) <- groups

               # fill in points
               for (i in names(points)){
                    points_frame[,names(points_frame)==i] <- points[[i]]
               }

               return(points_frame)

          }

     }

