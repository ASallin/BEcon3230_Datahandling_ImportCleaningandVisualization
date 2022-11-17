##' Generate Exam Files
##'
##' Generates pandoc documents for exam and solutions
##' @usage generate_exam(x)
##' @param author character string, the author of the exam
##' @param title character string, the title of the course/exam
##' @param date character string, the date of the exam (by default the system date)
##' @param output character string, indicating in what format the exam and solution should be generated. either 'markdown', 'html', 'pdf', 'odt' or 'docx'. Default:pdf
##' @param file character, the path/filename of the excel-sheet containing the questions to be read
##' @param year character vector indicating from which years questions should be selected, if empty (NULL) questions from all years are selected.
##' @param mock logical, if TRUE, only mock exam questions are selected (FALSE by default)
##' @param topic character vector, indicating which question topics should be selected ('topic' column), defaults to NULL
##' @param types list, indicates how many questions should be selected from each type, default: one each
##' @param type_headers list, indicating the headers to be used for each question type section (see example)
##' @return a list of pandoc objects (the function also generates output to disk, see output)
##' @details The...
##' @author Ulrich Matter <umatter@protonmail.com>
##' @examples
##' myfile <- "inst/exdata/exam_questions.xlsx"
##' generate_exam(author="Ulrich Matter", title="Econ 101", output="pdf", file = myfile)
##' @export
##' @import rmarkdown


generate_exam <-
     function(author, title, date=Sys.Date(),
              output='pdf', file, year=NULL, mock=FALSE, topic = NULL,
              types=list(tf=1, mc=1, one_correct=1),
              type_headers = list(tf="## Part 1: TRUE/FALSE Questions\nFor each of the following statements, decide whether the statement is TRUE (T) or FALSE (F).\n",
                                  mc="## Part 2: Multiple Choice Type A\nFor each of the following questions/statements, decide which of the possible responses are correct. NOTE: Either ONE OR SEVERAL of the response statements can be correct. In order to get a point, all correct response statements need to be marked!\n",
                                  one_correct="## Part 3: Multiple Choice  Type B (only one correct!)\nFor each of the following questions/statements, decide which of the possible responses is correct. NOTE: For each question only ONE of the possible responses is correct. Select ONLY ONE of the response statements per question!\n")) {

          # initialize the YAML header section
          .author <- paste0("author: ", author, "\n")
          .title <- paste0("title: ", title, "\n")
          .title_solutions <- paste0("title: ", title, " --SOLUTIONS--\n")
          .date <- paste0("date: ", as.character(date), "\n")
          .theme <- "theme: cerulean \n"
          .highlight <- "highlight: tango \n"
          if (output=="pdf"){
               .output <- "output: pdf_document \n"
               filterfile <- system.file("exdata/math.py", package="examr")
               .pandoc_args <- paste0("pandoc_args: \n - --filter \n - ", filterfile, " \n")

               .latex_header <- "header-includes: \n   \\usepackage{xcolor} \n \\usepackage[T1]{fontenc} \n"
          }
          if (output=="docx"){
               .output <- "output: word_document \n"
               filterfile <- system.file("exdata/math.py", package="examr")
               .pandoc_args <- paste0("pandoc_args: \n - --filter \n - ", filterfile, " \n")

               .latex_header <- "header-includes: \n   \\usepackage{xcolor} \n \\usepackage[T1]{fontenc} \n"
          }
          yaml_header_exam <- paste0("---\n",
                                .title, .author, .date, .output, .theme, .highlight, .pandoc_args, .latex_header,
                                "---\n\n")
          yaml_header_solutions <- paste0("---\n",
                                     .title_solutions, .author, .date, .output, .latex_header,
                                     "---\n\n")


          # read, select/randomize questions/exercises
          exercises <- read_questions(file, year, mock, topic)
          exam_selection <- select_questions(exercises, types)

          # generate the exam and solutions
          exam_text <- generate_question_text(exam_selection, type_headers = type_headers)
          solutions <- generate_solution_text(exam_selection, type_headers = type_headers)
          solutions_text <- solutions[[1]] # text to use in pdf
          solutions_coded <- solutions[[2]] # coded solutions to use in autocorreciton of scan results

          # generate files
          # exam files
          exam_text <- paste0(yaml_header_exam, exam_text, collapse = "\n")
          exam_output_path <- paste0("exam_", title, ".rmd")
          cat(exam_text, file = exam_output_path)
          rmarkdown::render(exam_output_path, clean = TRUE)

          # answer sheet
          generate_answersheet(title = title, date = date)

          # solutions files
          # for print
          solutions_text <- paste0(yaml_header_solutions, solutions_text, collapse = "\n")
          solutions_output_path <- paste0("solutions_exam_", title, ".rmd")
          cat(solutions_text, file = solutions_output_path)
          rmarkdown::render(solutions_output_path, clean = TRUE)
          # for auto correction
          solutions_coded_path <- paste0("solutions_coded_exam_", title, ".csv")
          write.csv(as.data.frame(t(solutions_coded)),
                    solutions_coded_path,
                    row.names = FALSE)


     }


