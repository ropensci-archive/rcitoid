#' Get Citoid data
#'
#' @export
#' @param id (character) id of an article, DOI, ISBN, PMCID or PMID
#' @param format (character) the format to use for the resulting citation data.
#' one of mediawiki (default), zotero, mediawiki-basefields, bibtex
#' @param accept_language (character) a field_name; all the rows that have an empty
#' value in the field_name specified are removed from the result set
#' @param accept (character) json, bibtex, or problem-json
#' @param ... curl options passed on to [crul::verb-GET]
#' @return data.frame, see http://opencitations.net/index/coci/api/v1 for
#' explanation of the resulting columns
#' @references https://en.wikipedia.org/api/rest_v1/#!/Citation/getCitation,
#' https://www.mediawiki.org/wiki/Citoid
#' @examples \dontrun{
#' doi1 <- "10.1108/jd-12-2013-0166"
#' pmid1 <- 30446726
#' pmcid1 <- "PMC4679344"
#' isbn1 <- 1439895619
#'
#' # different formats
#' cit_oid(doi1)
#' cit_oid(pmid1, format = "mediawiki")
#' cit_oid(pmid1, format = "zotero")
#' cit_oid(pmid1, format = "mediawiki-basefields")
#' cat(cit_oid(pmid1, format = "bibtex"))
#'
#' # PMID example
#' cit_oid(pmid1, verbose = TRUE)
#'
#' # ISBN example
#' cit_oid(isbn1, verbose = TRUE)
#' 
#' # PMCID example
#' cit_oid(pmcid1)
#' }
cit_oid <- function(id, format = "mediawiki", accept = "json",
  accept_language = NULL, ...) {

  assert(id, c("character", "numeric", "integer"))
  assert(format, "character")
  assert(accept, "character")
  assert(accept_language, "character")

  if (!format %in% oid_formats) {
    stop("'format' must be one of: ", paste0(oid_formats, collapse = ", "))
  }
  accept <- switch(
    accept,
    "json" = "application/json; charset=utf-8",
    "problem-json" = "application/problem+json",
    "bibtex" = "application/x-bibtex; charset=utf-8"
  )
  x <- oid_GET(format, curl::curl_escape(id), accept, accept_language, ...)
  txt <- x$parse("UTF-8")
  type <- get_ctype(x)
  switch(type, bibtex = txt, json = jsonlite::fromJSON(txt, FALSE))
  # oid_parser(x)
}

# oid_parser <- function(x) {
#   x <- jsonlite::fromJSON(x, FALSE)
#   (z <- data.table::setDF(
#     data.table::rbindlist(x, fill = TRUE, use.names = TRUE)))
#   structure(z, class = c("tbl_df", "tbl", "data.frame"))
# }

oid_formats <- c("mediawiki", "zotero", "mediawiki-basefields", "bibtex")

get_ctype <- function(x) {
  ctype <- x$response_headers$`content-type`
  if (grepl("bibtex", ctype)) {
    "bibtex"
  } else if (grepl("json", ctype)) {
    "json"
  }
}
