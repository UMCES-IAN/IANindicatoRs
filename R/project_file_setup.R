#' setup_project
#'
#' Create a project folder structure and directory for file organization,
#' provide framework for a connection to a database within an rstudio session,
#' add an Rmarkdown template to the Rstudio template options and have one be an example template,
#' and initialize the new project with renv to then refer to a pre-defined renv.lock file.
#'
#' @exportPattern ^[[:alpha:]]+
#' @importFrom fs path
#' @importFrom glue glue
#' @importFrom purrr walk
#' @importFrom renv init
#' @import usethis
#'
#'
#' @param IAN_project what the IAN project is named
#' @param base_dir where should the project be placed in your file directory. Can use
#' here::here() to keep file paths relative, or use absolute path from your computer
#' (less preferred), e.g., "/Users/yourName/Documents/Projects/etc"
#'
#' @return a new project that with folders, an Rmarkdown folder, and a renv.lock file
#' @export
#'
#' @examples
#' #a new IAN project has started for the "Chesapeake Bay."
#' #Y-m-d will be added to the front of the project name.
#' setup_project("Chesapeake_Bay", here("Desktop"))
#' 
setup_project <- function(IAN_project, base_dir = "."){
  usethis::ui_done("setting up project folder structure for indicator analysis")
  root <- fs::path(base_dir, glue::glue(format(Sys.Date(),
                                               "%Y-%m-%d"),"_{IAN_project}"))
  usethis::create_project(path = root, open = FALSE)
  # add the standard internal structure
  sub <- c("data","output")
  purrr::walk(sub, ~dir.create(fs::path(root, .x)))
  # additional standard subdirectories
  dir.create(fs::path(root, "data", "data-raw"))
  # add your standard Rmd etc from `inst/templates` in your package
  usethis::with_project(
    root,
    code = {
      usethis::use_template(
        template = "skeleton.Rmd",
        save_as = fs::path("R", glue::glue(format(Sys.Date(),
                                                  "%Y-%m-%d"),"_{IAN_project}_template.Rmd")),
        data = list(IAN_project = IAN_project),
        # use the actual package name
        package = "IANindicatoRs",
        open = TRUE
      );
      usethis::use_template(
        template = "renv.lock",
        # use the actual package name
        package = "IANindicatoRs",
        open = FALSE
      )
      # more as fit your needs
    }
  )

  #initialize the project with renv
  renv::init(project = root,
             bare = TRUE, #don't need to discover packages
             force = TRUE) #accept home directory lockfile

}
