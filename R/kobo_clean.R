#' @name kobo_clean
#' @rdname kobo_clean
#' @title  Add cleaned variables to the frame based on a reference table
#'
#' @description  The function works on a loop based on the dictionnary.
#' Add a column clean and insert in the cell the name of the csv file that will be used to generate the cleaned variable
#' The first column of that file will be used for the matching, the second column will be added to the dataframe.
#' The new cleaned variable will be inserted in the dictionnary. with a suffix '.clean'
#'
#'
#' @param  frame dataframe to use
#' @param  form name of the form file in xls format
#' @param app The place where the function has been executed, the default is the console and the second option is the shiny app
#'
#'
#' @author Edouard Legoupil
#'
#'
#' @export kobo_clean
#'
#' @examples
#' \dontrun{
#' kobo_clean(frame, form = "form.xlsx")
#' }
#'
#'

kobo_clean <- function(frame, form = "form.xlsx", app = "console") {

  mainDir <- kobo_getMainDirectory()
  form <- as.character(form)
  #cat(paste0(form,"\n"))
  formpath <- as.character(paste0(mainDir,"/data/dico_",form,".csv"))
  #cat(paste0(formpath,"\n"))
  dico <- utils::read.csv(formpath, encoding = "UTF-8", na.strings = "")
  
  
  #formpath <- as.character(paste0(mainDir,"/data/dico_",form,".rda"))
  #cat(paste0(formpath,"\n"))
  #load(formpath)

  # frame <- MainDataFrame
  # frame <- household
  # framename <- "household"
  # framename <- "MainDataFrame"
  framename <- as.character(deparse(substitute(frame)))
  ## library(digest)
  ## Get the anonymisation type defined within the xlsform / dictionnary

  if (levels(as.factor(dico$clean)) == "no") {
    cat(paste0("You have not defined variables to clean within your xlsform. \n"))
    cat(paste0(" Insert a column named clean and reference the csv file to use for cleaning. \n"))
    }  else {
     dico.clean <- dico[ !(is.na(dico[, c("clean")])) ,  ]
      if (nrow(dico.clean) > 0) {
        cat(paste0(nrow(dico.clean), " potential variables to clean\n"))
        
        if (file.exists("R/apply_clean.R")) file.remove("R/apply_clean.R")
          for (i in 1:nrow(dico.clean)) {
           # i <- 1
            cat(paste0(i, "- Clean through an external table, if exists, the value of question: ", as.character(dico.clean[ i, c("label")]),"\n"))
            ## Build and run the formula to insert the indicator in the right frame  ###########################
            varia <- paste0(framename,"$",as.character(dico.clean[ i, c("fullname")]))
            variable <- paste0(as.character(dico.clean[ i, c("fullname")]))
            cleanfile <- paste0(as.character(dico.clean[ i, c("clean")]))
            cleanframe <- paste0(substr(as.character(dico.clean[ i, c("clean")]), 1, nchar(cleanfile) - 4))
            formula1 <-  paste0(cleanframe," <- utils::read.csv(\"data-raw/", cleanfile,"\", encoding = \"UTF-8\", na.strings = \"\")" )
            formula2 <- paste0("names(",cleanframe,")[1] <- \"",dico.clean[ i, c("fullname")],"\"" )
            formula3 <- paste0("names(",cleanframe,")[2] <- \"",dico.clean[ i, c("fullname")],".clean\"" )
            formula4 <- paste0("colname <- which(colnames(",framename,") == \"", variable,"\")")
            formula5 <- paste0(framename," <- join(x = ",framename,", y = ", cleanframe,", by = \"",variable ,"\", type = \"left\")")
            formula6 <- paste0("tolcolumn <-  ncol(",framename,")")
            formula7 <- paste0(framename," <- ",framename,"[c(1:as.integer(colname), as.integer(tolcolumn), as.integer(colname + 1):as.integer(tolcolumn - 1) )]")
            formula8 <- paste0("cat(paste0(\"Matching level for the variable is : \",")
            formula9 <- paste0("round( nrow(", framename ,"[ !(is.na(", framename ,"$", variable ,".clean)), ]) / nrow(", framename ,") *100,digits = 1),\"%\n\n\"))")


            cat(paste0("if (\"", as.character(dico.clean[ i, c("fullname")]) , "\" %in% names(", framename, ")) {" ), file = "R/apply_clean.R" , sep = "\n", append = TRUE)
            cat(paste0(formula1, ""), file = "R/apply_clean.R" , sep = "\n", append = TRUE)
            cat(paste0(formula2, ""), file = "R/apply_clean.R" , sep = "\n", append = TRUE)
            cat(paste0(formula3, ""), file = "R/apply_clean.R" , sep = "\n", append = TRUE)
            cat(paste0(formula4, ""), file = "R/apply_clean.R" , sep = "\n", append = TRUE)
            cat(paste0(formula5, ""), file = "R/apply_clean.R" , sep = "\n", append = TRUE)
            cat(paste0(formula6, ""), file = "R/apply_clean.R" , sep = "\n", append = TRUE)
            cat(paste0(formula7, ""), file = "R/apply_clean.R" , sep = "\n", append = TRUE)
            cat(paste0(formula8, ""), file = "R/apply_clean.R" , sep = "\n", append = TRUE)
            cat(paste0(formula9, "} else {cat(\" That variable is not in that frame...\n\") } "), file = "R/apply_clean.R" , sep = "\n", append = TRUE)

          } 
        source("R/apply_clean.R")
        #if (file.exists("R/apply_clean.R")) file.remove("R/apply_clean.R")
      }
  }
  return(frame)
}
NULL
