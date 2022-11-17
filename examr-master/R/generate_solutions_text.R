##' Generate Solution Text
##'
##' Generates Rmd strings for a set of questions with indicated sample solutions
##' @usage generate_solution_text(x, groups=c("group001", "group002", "group003"))
##' @param x list, result of parsing file with questions via read_questions/select_questions
##' @param type_headers list, indicating the headers to be used for each question type section (see example)
##' @param groups named list indicating the possible responses defaults to c("group001", "group002", "group003")
##' @return a list of character strings (with markdown syntax)
##' @details The...
##' @author Ulrich Matter <umatter@protonmail.com>
##' @examples
##' myfile <- "inst/exdata/exam_questions.xlsx"
##' my_questions <- read_questions(myfile)
##' selection <-select_questions(my_questions)
##' generate_solution_text(selection)
##' @export
##'


generate_solution_text <-
     function(x, type_headers = list(tf="## Part 1: TRUE/FALSE Questions\nFor each of the following statements, decide whether the statement is TRUE (T) or FALSE (F).\n",
                                     mc="## Part 2: Multiple Choice Type A\nFor each of the following questions/statements, decide which of the possible responses are correct. NOTE: Either ONE OR SEVERAL of the response statements can be correct. In order to get a point, all correct response statements need to be marked!\n",
                                     one_correct="## Part 3: Multiple Choice  Type B (only one correct!)\nFor each of the following questions/statements, decide which of the possible responses is correct. NOTE: For each question only ONE of the possible responses is correct. Select ONLY ONE of the response statements per question!\n"),
              groups=c("group001", "group002", "group003")) {

          # process TRUE/FALSE questions
          # select input
          tfs <- x$tf
          tfs$question_nr <- paste0("### ", 1:nrow(tfs), ".  ")
          tfs_header <- type_headers$tf
          tfs$sol_color <- "\n\\textcolor{green}{"
          tfs$sol_color[tfs$solution=="F"] <- "\n\\textcolor{red}{"
          tfs$sol_color <- paste0(tfs$sol_color, tfs$solution, "}")

          # generate text output
          tf_text <- paste(tfs$question_nr,
                            tfs$question, "\n", sep = " ")

          tf_text <- paste(tf_text, tfs$sol_color, collapse = "\n\n ---------------- \n\n")

          tf_text <- paste0(tfs_header, "\n",
                            tf_text, "\n")
          # generate serialized solutions for automated correction of scan results
          tf_solutions <- tfs$solution
          names(tf_solutions) <- trimws(paste0(groups[[1]], "_", gsub( "\\. ", "", tfs$question_nr)))



          # process MC questions
          mcs <- x$mc
          mcs$question_nr <- paste0("### ", 1:nrow(mcs), ".  ")
          mcs_header <- type_headers$mc

          # generate text output
          # questions
          q_text<- paste0(mcs$question_nr,
                          mcs$question, "\n\n")
          # responses per question
          responses_text <- list()
          responses_letters <- list()
          for (i in 1:nrow(mcs)) {

               # extract response text, add letters
               response_letters <- toupper(letters[1:length(mcs[i,]$choices_solutions[[1]]$choices)])
               # color correct solutions (latex)
               solutions <- as.logical(mcs[i,]$choices_solutions[[1]]$solutions)
               response_letters_colored <- paste0("\n\\textcolor{red}{", response_letters, ")} ")
               response_letters_colored[solutions] <- paste0("\n\\textcolor{green}{", response_letters[solutions], ")} ")

               # put all together
               responses_colored <- paste0(response_letters_colored,
                                   trimws(as.character(mcs[i,]$choices_solutions[[1]]$choices)), "\n\n")
               responses_text[[i]] <- paste0(responses_colored, collapse = "")
               # solutions for correction output
               responses_letters[[i]] <- paste(response_letters[solutions], collapse = "|") # FormScan deliminates multiple choice responses with the pipe character!

          }
          responses_text <- unlist(responses_text)

          # put it together
          mcs_text <- paste0(q_text, "\n", responses_text, collapse="\n\n ------------ \n\n")
          mcs_text <- paste0(mcs_header, "\n", mcs_text )

          # mcs: generate serialized solutions for automated correction of scan results
          mcs_solutions <- unlist(responses_letters)
          names(mcs_solutions) <- trimws(paste0(groups[[2]], "_", gsub( "\\.", "", mcs$question_nr)))


          # process MC questions (only one correct)
          mcs_oc <- x$one_correct
          mcs_oc$question_nr <- paste0("### ", 1:nrow(mcs_oc), ".  ")
          mcs_oc_header <- type_headers$one_correct

          # create text output
          # questions
          q_text_oc<- paste0(mcs_oc$question_nr,
                             mcs_oc$question, "\n\n")

          # responses per question
          responses_text_oc <- list()
          response_letters_oc <- list()
          for (i in 1:nrow(mcs_oc)) {

               # extract response text, add letters
               response_letter <- toupper(letters[1:length(mcs_oc[i,]$choices_solutions[[1]]$choices)])
               # color correct solutions (latex)
               solutions <- as.logical(mcs_oc[i,]$choices_solutions[[1]]$solutions)
               response_letter_colored <- paste0("\n\\textcolor{red}{", response_letter, ")} ")
               response_letter_colored[solutions] <- paste0("\n\\textcolor{green}{", response_letter[solutions], ")} ")
               responses_colored <- paste0(response_letter_colored,
                                   trimws(as.character(mcs_oc[i,]$choices_solutions[[1]]$choices)), "\n\n")
               # put it all together
               responses_text_oc[[i]] <- paste0(responses_colored, collapse = "")
               # for output correction
               response_letters_oc[[i]] <- response_letter[solutions]

          }
          responses_text_oc <- unlist(responses_text_oc)

          # put it together
          mcs_oc_text <- paste0(q_text_oc, "\n", responses_text_oc, collapse = "\n\n --------- \n \n")
          mcs_oc_text <- paste0(mcs_oc_header, "\n", mcs_oc_text )

          # mcs, one correct: generate serialized solutions for automated correction of scan results
          mcs_oc_solutions <- unlist(response_letters_oc)
          names(mcs_oc_solutions) <- trimws(paste0(groups[[3]], "_", gsub( "\\.", "", mcs_oc$question_nr)))





          # Put all questions in one text
          all_text <- paste0(tf_text, "\n\n --------- \n \n",
                             mcs_text,"\n\n --------- \n \n",
                             mcs_oc_text)
          all_solutions <- c(tf_solutions, mcs_solutions, mcs_oc_solutions)
          names(all_solutions) <- gsub("### ", "", names(all_solutions))


          return(list(all_text, all_solutions))

     }
