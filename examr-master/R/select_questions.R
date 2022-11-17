##' Select Questions for Exam
##'
##' Selects randomly a number of questions from a list of questions. MC options are randomly ordered.
##' @usage select_questions(x)
##' @param x list, result of parsing file with questions via read_questions
##' @param types list, indicates how many questions should be selected from each type (see example below), default: one each
##' @return a list of questions (same format as x)
##' @details The...
##' @author Ulrich Matter <umatter@protonmail.com>
##' @examples
##' myfile <- "data/exam_questions.xlsx"
##' my_questions <- read_questions(myfile)
##' select_questions(my_questions)
##' @export
##'

select_questions <-
     function(x, types=list(tf=1, mc=1, one_correct=1)) {

          selection <- x

          for (i in 1:length(types)) {

               type.i <- names(types[i])
               n_type.i <- types[[i]]

               # select all questions of given type, from this set select randomly n questions
               random_rows <- sample(1:nrow(selection[[type.i]]), n_type.i, replace = FALSE)
               selection[[type.i]] <- selection[[type.i]][random_rows,]

               # depending on type, randomize order of responses (keeping track of solutions)
               if (type.i == "mc" | type.i == "one_correct") {

                    for (j in 1:nrow(selection[[type.i]])) {

                         random_rows_j <- sample(1:nrow(selection[[type.i]][j, "choices_solutions"][[1]][[1]]),
                                                    size = nrow(selection[[type.i]][j, "choices_solutions"][[1]][[1]]),
                                                    replace = FALSE)

                         selection[[type.i]][j, "choices_solutions"][[1]][[1]] <-
                              selection[[type.i]][j, "choices_solutions"][[1]][[1]][random_rows_j,]
                    }
               }
          }

          return(selection)
     }
