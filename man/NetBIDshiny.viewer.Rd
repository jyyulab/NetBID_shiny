% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shiny.R
\name{NetBIDshiny.viewer}
\alias{NetBIDshiny.viewer}
\title{\code{NetBIDshiny.viewer} is a function to run a shiny app for NetBID2 result visualization.}
\usage{
NetBIDshiny.viewer(
  load_data_path = NULL,
  search_path = c("Current Directory", "Home")
)
}
\arguments{
\item{load_data_path}{character, path for the pre-loaded data. If NULL, will pre-load the demo dataset.}

\item{search_path}{a vector of characters, path for master table Rdata searching in the app server. 
User could choose from: 'Current Directory','Home','R Installation','Available Volumes', 
and could put user-defined server path (better use absolute path).
Default is c('Current Directory','Home').
If set to NULL, only 'Current Directory' will be used.}
}
\description{
\code{NetBIDshiny.viewer} is a shiny app for NetBID2 result visualization. 
User could follow the online tutorial \url{https://jyyulab.github.io/NetBID_shiny/} for usage.
}
