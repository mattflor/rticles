#' Elsevier journal format.
#'
#' Format for creating submissions to Elsevier journals. Adapted from
#' \href{http://journals.plos.org/plosone/s/latex}{http://journals.plos.org/plosone/s/latex}.
#'
#' @inheritParams rmarkdown::pdf_document
#' @param ... Additional arguments to \code{rmarkdown::pdf_document}
#'
#' @return R Markdown output format to pass to
#'   \code{\link[rmarkdown:render]{render}}
#'
#' @examples
#'
#' \dontrun{
#' library(rmarkdown)
#' draft("MyArticle.Rmd", template = "plos_article", package = "rticles")
#' }
#'
#' @export
plos_article <- function(...,
                         keep_tex = TRUE,
                         md_extensions = c("-autolink_bare_uris")) {
  inherit_pdf_document(...,
                       template = find_resource("plos_article", "template.tex"),
                       keep_tex = keep_tex,
                       md_extensions = md_extensions)
}


#' @export
plos_pdf <- function(rmd_file, open_viewer = TRUE) {
  base_file <- strsplit(rmd_file, split = "\\.")[[1]][1]
  tex_file <- paste0(base_file, ".tex")
  pdf_file <- paste0(base_file, ".pdf")
  rmarkdown::render(rmd_file, output_file = tex_file)
  system(paste("pdflatex", tex_file))
  system(paste("bibtex", base_file))
  system(paste("pdflatex", tex_file))
  system(paste("pdflatex", tex_file))
  if (open_viewer) system(paste("open", pdf_file))
}
