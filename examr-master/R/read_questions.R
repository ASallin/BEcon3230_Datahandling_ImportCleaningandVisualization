##' Read Exam Questions
##'
##' Reads an excel sheet with exam question of different types (T/F, MC, etc.)
##' @usage read_questions(file)
##' @param file character, the path/filename of the excel-sheet containing the questions to be read
##' @param year character vector indicating from which years questions should be selected, if empty (NULL) questions from all years are selected.
##' @param mock logical, if TRUE, only mock exam questions are selected (FALSE by default)
##' @param topic character vector, indicating which question topics should be selected ('topic' column), defaults to NULL
##' @return a list
##' @details The...
##' @author Ulrich Matter <umatter@protonmail.com>
##' @examples
##' myfile <- "inst/exdata/exam_questions.xlsx"
##' my_questions <- read_questions(myfile)
##' head(my_questions)
##' @export
##' @import readxl readr

read_questions <-
     function(file, year=NULL, mock=FALSE, topic = NULL) {

          # read the file, if not excel-file, assume csv
          if (grepl("\\.xlsx", file)) {
               q <- readxl::read_xlsx(file)

          } else {
               if (grepl("\\.xls", file)) {
                    q <- readxl::read_xls(file)

               } else {
                         q <- read_csv(file)
                    }
          }

          # select only mock or real exam questions
          if (mock==TRUE){
               q <- q[q$used_in=="mock" & !is.na(q$used_in), ]
          }

          if (mock==FALSE) {
               q <- q[q$used_in!="mock" | is.na(q$used_in), ]
          }

          # select only from certain year
          if (!is.null(year)){
               q <- q[q$year==year,]
          }

          # select certain topics
          if (!is.null(topic)) {
               q <- q[q$topic %in% topic,]
          }

          # remove nas
          q <- q[!is.na(q$type),]


          # parse different question types
          # TRUE/FALSE questions
          if (any(q$type=="tf")) {
               tf_questions <- q[q$type=="tf", c("question", "solution", "year", "used_in")]
          } else {
                    tf_questions <- NULL
               }


          # Multiple choice (several correct)
          if (any(q$type=="mc")) {
               mc <- q[q$type=="mc", c("question", "choices", "solution", "year", "used_in")]
               choices <- lapply(strsplit(mc$choices, ";"), trimws)
               solutions <- lapply(strsplit(mc$solution, ";"), trimws)
               choices_solutions  <- lapply(1:length(choices), FUN = function(i){
                    data.frame(choices=choices[[i]], solutions=solutions[[i]])
               })
               mc_questions <- mc[, c("question", "year", "used_in")]
               mc_questions$choices_solutions <- choices_solutions

          } else {
               mc_questions <- NULL
          }

          # Multiple choice, one correct
          if (any(q$type=="one_correct")) {
               one_correct <- q[q$type=="one_correct", c("question", "choices", "solution", "year", "used_in")]
               choices_oc <- strsplit(one_correct$choices, ";")
               solutions_oc <- one_correct$solution
               choices_solutions_oc  <- lapply(1:length(choices_oc), FUN = function(i){
                    data.frame(choices=choices_oc[[i]], solutions=solutions_oc[i]==choices_oc[[i]])
               })
               one_correct_questions <- one_correct[, c("question", "year", "used_in")]
               one_correct_questions$choices_solutions <- choices_solutions_oc

          } else {
               one_correct_questions <- NULL

          }


          # combine all for further processing in other functions
          parsed_questions <- list(tf=tf_questions, mc=mc_questions, one_correct=one_correct_questions)

          return(parsed_questions)
     }
