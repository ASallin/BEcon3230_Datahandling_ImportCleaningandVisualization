##' Generate Answer Sheet
##'
##' Based on a template, generates an excel workbooks as answer sheet for FormScanner
##' @usage generate_answersheet(as_template=NULL, title, date=Sys.Date())
##' @param as_template character string, path/filename of the excel workbook to be used as temlate (defaults to the one delivered in the package)
##' @param title character string, the title of the course/exam
##' @param date character string, the date of the exam (by default the system date)
##' @return the path/filename of the generated answer sheet
##' @details The...
##' @author Ulrich Matter <umatter@protonmail.com>
##' @examples
##' generate_answersheet(title="Econ 101")
##' @export
##' @import XLConnect


generate_answersheet <-
     function(as_template=NULL, title, date=Sys.Date()) {

          if (is.null(as_template)){
               fpath <- system.file("exdata/default_answersheet.xlsx", package="examr")
          } else {
               fpath <- as_template
          }

          # load the template answersheet
          as <- XLConnect::loadWorkbook(fpath)
          # add exam info (note: the named region is predefined in the default_answersheet)
          # add the course name
          writeNamedRegion(object = as, data = data.frame(title), name = "course_name", header = FALSE, rownames = FALSE)
          # add the date of the exam
          writeNamedRegion(object = as, data = data.frame(as.character(date)), name = "exam_date", header = FALSE, rownames = FALSE)

          # write workbook to file
          as_output_path <- paste0("exam_answersheet_", title, ".xlsx")
          saveWorkbook(as, file = as_output_path)


          return(as_output_path)


     }

