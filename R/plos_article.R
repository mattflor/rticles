#' PLOS journal format.
#'
#' Format for creating submissions to PLOS journals. Adapted from
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


#' Make a PLOS journal PDF
#'
#' @export
make_plos_article <- function(rmd_file, open_viewer = TRUE) {
  # filenames
  base_file <- strsplit(rmd_file, split = "\\.")[[1]][1]
  tex_file <- paste0(base_file, ".tex")
  pdf_file <- paste0(base_file, ".pdf")

  # knit and convert .Rmd to .tex
  rmarkdown::render(rmd_file, output_file = tex_file)

  # latex commands
  pdflatex_cmd <- paste("pdflatex", tex_file)
  bibtex_cmd <- paste("bibtex", base_file)

  # create .pdf by running
  # pdflatex, the bibtex, then pdflatex twice
  message("pdflatex run #1 ...")
  system(pdflatex_cmd)
  message("bibtex run ...")
  system(bibtex_cmd)
  message("pdflatex run #2 ...")
  system(pdflatex_cmd)
  message("pdflatex run #3 ...")
  system(pdflatex_cmd)

  # open .pdf
  if (open_viewer) system(paste("open", pdf_file))
}
