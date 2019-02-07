oid_base <- "https://en.wikipedia.org"
oid_path <- "api/rest_v1/data/citation"

errs <- function(x) {
  if (x$status_code > 201) {
    fun <- fauxpas::find_error_class(x$status_code)$new()
    fun$do_verbose(x)
  }
}

oid_GET <- function(format, id, accept_language, ...) {
  cli <- crul::HttpClient$new(
    oid_base,
    headers = cp(list(
      "User-Agent" = oid_ua(),
      "X-USER-AGENT" = oid_ua(),
      "Accept-Language" = accept_language
    )),
    opts = list(...)
  )
  paths <- file.path(oid_path, format, id)
  res <- lapply(paths, function(z) cli$get(z))
  invisible(lapply(res, errs))
  return(res)
}

oid_ua <- function() {
  versions <- c(
    paste0("r-curl/", utils::packageVersion("curl")),
    paste0("crul/", utils::packageVersion("crul")),
    sprintf("rOpenSci(rcitoid/%s)",
            utils::packageVersion("rcitoid"))
  )
  paste0(versions, collapse = " ")
}
