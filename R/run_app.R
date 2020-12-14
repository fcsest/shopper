#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom purrr partial
#' @importFrom golem with_golem_options
#' @importFrom shinymanager secure_app
run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  ...
) {
  with_golem_options(
    app = shinyApp(
      ui = secure_app(app_ui),
      server = app_server,
      onStart = partial(eval,
                        expr = global_partials,
                        envir = globalenv()),
      options = options,
      enableBookmarking = enableBookmarking
    ),
    golem_opts = list(...)
  )
}
