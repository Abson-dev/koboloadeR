% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/kobo_load_data.R
\name{kobo_load_data}
\alias{kobo_load_data}
\title{Kobo Load Data}
\usage{
kobo_load_data(form = "form.xlsx", app = "console")
}
\arguments{
\item{form}{The full filename of the form to be accessed (has to be xlsx file).
It is assumed that the form is stored in the data folder.}

\item{app}{The place where the function has been executed, the default is the console and the second option is the shiny app}
}
\value{
No return, all results will be saved inside new CSV files
}
\description{
Load form, building dictionnary, loading all required data into the environment, Check to split select_multiple if data is extracted from ODK, Clean variable if any and Re-encoding data based on the dictionnary
}
\examples{
\dontrun{
kobo_load_data("form.xlsx")
}

}
\author{
Edouard Legoupil, Maher Daoud
}
