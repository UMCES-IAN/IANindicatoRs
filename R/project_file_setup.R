# `standard` `parameters` is obviously dummy for whatever conventions you use
# name is the name of the actual project

setup_basic_project <- function(IAN_project, indicator, base_dir = "."){
  usethis::ui_done("setting up standard folder structure")
  root <- fs::path(base_dir, glue::glue(format(Sys.Date(),
                                               "%Y-%m-%d"),"_{IAN_project}_{indicator}"))
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
                                                  "%Y-%m-%d"),"_{parameters}_{name}.Rmd")),
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
  # switch over to the new project
  usethis::proj_activate(root)

  #initialize the project with renv
  renv::init(project = root,
             bare = TRUE, #don't need to discover packages
             force = TRUE) #accept home directory lockfile

}
