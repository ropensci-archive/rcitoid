#' Get Citoid data
#'
#' @export
#' @param id (character) id of an article, DOI, ISBN, PMCID or PMID
#' @param format (character) the format to use for the resulting citation data.
#' one of mediawiki (default), zotero, mediawiki-basefields, bibtex
#' @param accept_language (character) for some articles the result depends on
#' the accept language value, so provide it if localized content is required
#' @param ... curl options passed on to [crul::verb-GET]
#' @details `cit_oid_()` gets raw text (either bibtex or JSON), and `cit_oid()`
#' parses the text as appropriate for the type
#' @return list of lists or character, see
#' http://opencitations.net/index/coci/api/v1 for explanation of the resulting
#' columns
#' @references https://en.wikipedia.org/api/rest_v1/#!/Citation/getCitation,
#' https://www.mediawiki.org/wiki/Citoid
#' @examples \dontrun{
#' doi1 <- "10.1108/jd-12-2013-0166"
#' doi2 <- "10.1371/journal.pone.0058568"
#' pmid1 <- 30446726
#' pmcid1 <- "PMC4679344"
#' isbn1 <- 1439895619
#'
#' # different formats
#' cit_oid(doi1)
#' cit_oid(pmid1, format = "mediawiki")
#' cit_oid(pmid1, format = "zotero")
#' cit_oid(pmid1, format = "mediawiki-basefields")
#' cat(cit_oid(pmid1, format = "bibtex")[[1]])
#'
#' # PMID example
#' cit_oid(pmid1, verbose = TRUE)
#'
#' # ISBN example
#' cit_oid(isbn1, verbose = TRUE)
#'
#' # PMCID example
#' cit_oid(pmcid1)
#'
#' # set the accept language
#' x <- cit_oid(pmid1, accept_language = "fr-FR", verbose = TRUE)
#' x <- cit_oid(doi2, accept_language = "de-DE", verbose = TRUE)
#'
#' # just get raw text/json
#' cit_oid_(pmcid1)
#'
#' # many ids at once
#' cit_oid(id = c(pmid1, pmcid1, isbn1))
#' cit_oid_(id = c(pmid1, pmcid1, isbn1))
#' cit_oid_(id = c(pmid1, pmcid1, isbn1), format = "bibtex")
#' }
cit_oid <- function(id, format = "mediawiki", accept_language = NULL, ...) {
  x <- cit_oid_(id, format, accept_language, ...)
  lapply(x, function(w) {
    switch(
      attr(w, "type"),
      bibtex = w,
      json = jsonlite::fromJSON(w, FALSE)[[1]]
    )
  })
}

#' @export
#' @rdname cit_oid
cit_oid_ <- function(id, format = "mediawiki", accept_language = NULL, ...) {
  assert(id, c("character", "numeric", "integer"))
  assert(format, "character")
  assert(accept_language, "character")

  if (!format %in% oid_formats) {
    stop("'format' must be one of: ", paste0(oid_formats, collapse = ", "))
  }
  # x <- oid_GET(format, curl::curl_escape(id), accept_language, ...)
  x <- oid_GET_async(format, curl::curl_escape(id), accept_language, ...)
  lapply(x, function(w) structure(w$parse("UTF-8"), type = get_ctype(w)))
}

oid_formats <- c("mediawiki", "zotero", "mediawiki-basefields", "bibtex")

get_ctype <- function(x) {
  ctype <- x$response_headers$`content-type`
  if (grepl("bibtex", ctype)) {
    "bibtex"
  } else if (grepl("json", ctype)) {
    "json"
  }
}
