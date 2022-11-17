##' Read Scan Results
##'
##' Reads and formats the scan results of running FormScan on the answer sheets
##' @usage read_scan_results(file, id_nr="student_number", groups=c("group001", "group002", "group003"))
##' @param file character, the path/filename of the csv file containing the scan results
##' @param id_nr character, group variable indicating the file-id (i.e., students number), defaults to "student_number"
##' @param groups named list indicating the possible responses defaults to c("group001", "group002", "group003")
##' @return a data.frame/tibble
##' @details The...
##' @author Ulrich Matter <umatter@protonmail.com>
##' @examples
##' myfile <- system.file("inst/exdata/example_scan_results.csv", package="examr")
##' my_results <- read_scan_results(myfile)
##' head(my_results)
##' @export
##' @importFrom data.table fread

read_scan_results <-
     function(file, id_nr="student_id_nr", groups=c("group001", "group002", "group003")){

          # read the file
          q <- as.data.frame(fread(file = file))
          names(q)[1] <- "File.name"

          # extract student's number (format follows CH/EU convention)
          idnr <- q[,grepl(id_nr, names(q), fixed = TRUE)]
          q$idnr_formatted <-  apply(idnr,1,paste, collapse="")
          q[,grepl(id_nr, names(q), fixed = TRUE)] <- NULL

          # format responses for each of the question groups
          # groups <- grep(pattern = paste0(group_indicator, "[0-9]*\\.Question[0-9]*"),
          #                names(q), value = TRUE)
          # groups <- unique(gsub(pattern = "\\.Question[0-9]*", "",
          #                       groups))
          groups_list <- list()
          length(groups_list) <- length(groups)
          for (i in 1:length(groups)) {
               group.i <- groups[i]
               groupquestions.i <- q[,grepl(pattern = paste0(group.i, "\\.Question[0-9]*"),
                                            names(q))]
               names(groupquestions.i) <- paste0(group.i, "_", 1:length(names(groupquestions.i)))
               groups_list[[i]] <- groupquestions.i
          }
          groups_bound <- do.call("cbind", groups_list)

          results_formatted <- cbind(data.frame(file_name=q$File.name, id_nr=q$idnr_formatted), groups_bound )

          return(results_formatted)
     }
