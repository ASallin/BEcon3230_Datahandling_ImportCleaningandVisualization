##' Correct Scan Results
##'
##' Reads the scan results of running FormScan on the answer sheets, and the sample solutions, corrects the exams
##' @usage correct_scan_results(file, solutions_file, groups=c("group001", "group002", "group003"), ...)
##' @param file character, the path/filename of the csv file containing the scan results
##' @param solutions_file character, the path/filename of the csv file containing the sample solutions
##' @param points named list, list with key-value pairs question_group-points (e.g., list(group001=1.5, group002=3, group003=2))
##' @param ... parameters passed down to lower level functions (e.g., id_nr="student_id_nr")
##' @return a data.frame
##' @details The...
##' @author Ulrich Matter <umatter@protonmail.com>
##' @examples
##' myfile <- system.file("inst/exdata/example_scan_results.csv", package="examr")
##' solutions <- system.file("inst/exdata/example_sample_solutions.csv", package="examr")
##' my_results <- correct_scan_results(myfile, solutions)
##'
##' @export
##'

correct_scan_results <-
     function(file, solutions_file, points, ...){

          # read solutions and official sample solutions
          exam <-read_scan_results(file, ...)
          solutions <- read.csv(solutions_file, colClasses = "character")

          # select responses, correct responses
          responses <- exam[,-1:-2] # first two columns are filename and student id

          # generate solutions frame for correction
          sol_frame <- solutions
          for (i in 2:nrow(responses)) {

               sol_frame <- rbind(sol_frame, solutions)

          }

          # correct exam
          correction <- responses == sol_frame
          # assign points
          points_frame <- generate_points_frame(file, points)
          points_assigned_m <- as.matrix(points_frame) * as.numeric(as.matrix(correction))
          points_assigned <- as.data.frame(points_assigned_m)
          points_assigned$total_points <- apply(points_assigned, 1, sum)

          # add ids, question numbers
          points_assigned <- cbind(exam[,1:2], points_assigned)
          names(points_assigned) <- c(names(exam), "total_points")

          return(points_assigned)

}
