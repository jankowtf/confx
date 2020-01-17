test_that(".onAttach() works", {
  confx:::.onAttach()

  env_auto_load <- as.logical(Sys.getenv("CONFX_AUTO_LOAD", FALSE))
  expect_false(env_auto_load)
  getOption("config.yml")
  option_names <- names(options())

  expect_false(any(stringr::str_detect(option_names, "\\.yml$")))
})

test_that(".onAttach() works: auto load enabled", {
  devtools::unload()
  Sys.setenv(CONFX_AUTO_LOAD = TRUE)
  expect_true(as.logical(Sys.getenv("CONFX_AUTO_LOAD")))
  devtools::load_all()

  # confx:::.onAttach()
  option_names <- names(options())

  expect_true(any(stringr::str_detect(option_names, "\\.yml$")))

  # Clean up:
  idx <- stringr::str_which(option_names, "\\.yml$")
  option_names[idx] %>%
    purrr::walk(function(.x) {
      arg_list <- list(NULL) %>%
        purrr::set_names(.x)
      rlang::call2(quote(options), !!!arg_list) %>%
        rlang::eval_tidy()
    })
  option_names <- names(options())
  expect_false(any(stringr::str_detect(option_names, "\\.yml$")))
  Sys.setenv(CONFX_AUTO_LOAD = FALSE)
  devtools::unload()
  devtools::load_all()
})

