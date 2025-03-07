% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/build.r
\name{build_site}
\alias{build_site}
\title{Build a complete pkgdown website}
\usage{
build_site(pkg = ".", examples = TRUE, run_dont_run = FALSE,
  seed = 1014, lazy = FALSE, override = list(), preview = NA,
  new_process = TRUE, devel = TRUE, document = "DEPRECATED")
}
\arguments{
\item{pkg}{Path to package.}

\item{examples}{Run examples?}

\item{run_dont_run}{Run examples that are surrounded in \\dontrun?}

\item{seed}{Seed used to initialize so that random examples are
reproducible.}

\item{lazy}{If \code{TRUE}, will only rebuild articles and reference pages
if the source is newer than the destination.}

\item{override}{An optional named list used to temporarily override
values in \code{_pkgdown.yml}}

\item{preview}{If \code{TRUE}, or \code{is.na(preview) && interactive()}, will preview
freshly generated section in browser.}

\item{new_process}{If \code{TRUE}, will run \code{build_site()} in a separate process.
This enhances reproducibility by ensuring nothing that you have loaded
in the current process affects the build process.}

\item{devel}{If \code{TRUE} (the default), assumes you are in a live development
environment, so automatically runs \code{\link[devtools:document]{devtools::document()}} and loads
package with \code{\link[devtools:load_all]{devtools::load_all()}}. If \code{FALSE}, does not re-document,
and uses the installed version of the package for examples.}

\item{document}{\strong{Deprecated} Use \code{devel} instead.}
}
\description{
\code{build_site()} is a convenient wrapper around six functions:
\itemize{
\item \code{\link[=init_site]{init_site()}}
\item \code{\link[=build_home]{build_home()}}
\item \code{\link[=build_reference]{build_reference()}}
\item \code{\link[=build_articles]{build_articles()}}
\item \code{\link[=build_tutorials]{build_tutorials()}}
\item \code{\link[=build_news]{build_news()}}
}

See the documentation for the each function to learn how to control
that aspect of the site.

Note if names of generated files were changed, you will need to use
\code{\link[=clean_site]{clean_site()}} first to clean up orphan files.
}
\section{YAML config}{

There are four top-level YAML settings that affect the entire site:
\code{destination}, \code{url}, \code{title}, \code{template}, and \code{navbar}.

\code{destination} controls where the site will be generated. It defaults to
\code{docs/} (for GitHub pages), but you can override if desired. Relative
paths will be taken relative to the package root.

\code{url} optionally specifies the url where the site will be published.
Supplying this will:
\itemize{
\item Allow other pkgdown sites to link to your site when needed,
rather than using generic links to \url{https://rdrr.io}.
\item Generate a \code{sitemap.xml}, increasing the searchability of your site.
\item Automatically generate a \code{CNAME} when
\link[=deploy_site_github]{deploying to github}.
}\preformatted{url: http://pkgdown.r-lib.org
}

\code{title} overrides the default site title, which is the package name.
It's used in the page title and default navbar.

You can also provided information to override the default display of
the authors. Provided a list named with the name of each author,
including \code{href} to add a link, or \code{html} to override the
text:\preformatted{authors:
  Hadley Wickham:
    href: http://hadley.nz
  RStudio:
    href: https://www.rstudio.com
    html: <img src="https://www.tidyverse.org/rstudio-logo.svg" height="24" />
}
}

\section{Development mode}{

The development mode of a site controls four main things:
\itemize{
\item Where the site is built.
\item The colour of the package version in the navbar.
\item The optional tooltip associated with the version.
\item The indexing of the site by search engines.
}

There are currently three possible development modes:
\itemize{
\item \strong{release}: site written to \code{docs/}, the version gets the default
colouring, and no message.
\item \strong{development}: written to \code{docs/dev/}, the version gets a danger label,
and message stating these are docs for an in-development version of the
package. The \code{noindex} meta tag is used to ensure that these packages are
not indexed by search engines.
\item \strong{unreleased}: the package is written to \code{docs/}, the version gets a "danger"
label, and the message indicates the package is not yet on CRAN.
}

The default development mode is "release". You can override it by adding a
new \code{development} field to \code{_pkgdown.yml}, e.g.\preformatted{development:
  mode: devel
}

You can also have pkgdown automatically detect the mode with:\preformatted{development:
  mode: auto
}

The mode will be automatically determined based on the version number:
\itemize{
\item \code{0.0.0.9000} (\code{0.0.0.*}): unreleased
\item four version components: development
\item everything else -> release
}

There are three other options that you can control:\preformatted{development:
  destination: dev
  version_label: danger
  version_tooltip: "Custom message here"
}

\code{destination} allows you to override the default subdirectory used for the
development site; it defaults to \code{dev/}. \code{version_label} allows you to
override the style used for development (and unreleased) versions of the
package. It defaults to "danger", but you can set to "default", "info", or
"warning" instead. (The precise colours are determined by your bootstrap
theme, but become progressively more eye catching as you go from default
to danger). Finally, you can choose to override the default tooltip with
\code{version_tooltip}.
}

\section{YAML config - navbar}{

\code{navbar} controls the navbar at the top of the page. It has two primary
components: \code{structure} and \code{components}. These components interact in
a somewhat complicated way, but the complexity allows you to make minor
tweaks to part of the navbar while relying on pkgdown to automatically
generate the rest.

The \code{structure} defines the layout of the navbar, i.e. the order
of the components, and whether they're right aligned or left aligned.
You can use this component to change the order of the default components,
and to add your own components.\preformatted{navbar:
  structure:
    left:  [home, intro, reference, articles, tutorials, news]
    right: [github]
}

The \code{components} describes the appearance of each element in the navbar.
It uses the same
syntax as \href{http://rmarkdown.rstudio.com/rmarkdown_websites.html#site_navigation}{RMarkdown}.
The following YAML snippet illustrates some of the most important features.\preformatted{components:
  home: ~
  articles:
    text: Articles
    menu:
    - text: Category A
    - text: Title A1
      href: articles/a1.html
    - text: Title A2
      href: articles/a2.html
    - text: -------
    - text: "Category B"
    - text: Title B1
      href: articles/b1.html
   twitter:
     icon: "fab fa-twitter fa-lg"
     href: http://twitter.com/hadleywickham
}

Components can contain sub-\code{menu}s with headings (indicated by missing
\code{href}) and separators (indicated by a bunch of \code{-}). You can also use \code{icon}s
from \href{https://fontawesome.com/icons?d=gallery}{fontawesome}.

This yaml would override the default "articles" component, eliminate
the "home" component, and add a new "twitter" component. Unless you
explicitly mention new components in the \code{structure} they'll be added
to the far right of the left menu.
}

\section{YAML config - search}{

You can use \href{https://community.algolia.com/docsearch/}{docsearch} by algolia
to add search to your site.\preformatted{template:
  params:
    docsearch:
      api_key: API_KEY
      index_name: INDEX_NAME
}

You also need to add a \code{url:} field, see above.
}

\section{YAML config - template}{

You can get complete control over the appearance of the site using the
\code{template} component. There are two components to the template:
the HTML templates used to layout each page, and the css/js assets
used to render the page in the browser.

The easiest way to tweak the default style is to use a bootswatch template,
by passing on the \code{bootswatch} template parameter to the built-in
template:\preformatted{template:
  params:
    bootswatch: cerulean
}

See a complete list of themes and preview how they look at
\url{https://gallery.shinyapps.io/117-shinythemes/}:

Optionally provide the \code{ganalytics} template parameter to enable
\href{https://www.google.com/analytics/}{Google Analytics}. It should
correspond to your
\href{https://support.google.com/analytics/answer/1032385}{tracking id}.

When enabling Google Analytics, be aware of the type and amount of
user information that you are collecting. You may wish to limit the
extent of data collection or to add a privacy disclosure to your
site, in keeping with current laws and regulations.\preformatted{template:
  params:
    ganalytics: UA-000000-01
}

Suppress indexing of your pages by web robots by setting \code{noindex: true}:\preformatted{template:
  params:
    noindex: true
}

You can also override the default templates and provide additional
assets. You can do so by either storing in a \code{package} with
directories \code{inst/pkgdown/assets} and \code{inst/pkgdown/templates},
or by supplying \code{path} and \code{asset_path}. To suppress inclusion
of the default assets, set \code{default_assets} to false.\preformatted{template:
  package: mycustompackage

# OR:

template:
  path: path/to/templates
  assets: path/to/assets
  default_assets: false
}

These settings are currently recommended for advanced users only. There
is little documentation, and you'll need to read the existing source
for pkgdown templates to ensure that you use the correct components.
}

\section{Options}{

Users with limited internet connectivity can disable CRAN checks by setting
\code{options(pkgdown.internet = FALSE)}. This will also disable some features
from pkgdown that requires an internet connectivity. However, if it is used
to build docs for a package that requires internet connectivity in examples
or vignettes, this connection is required as this option won't apply on them.

Users can set a timeout for \code{build_site(new_process = TRUE)} with
\code{options(pkgdown.timeout = Inf)}, which is useful to prevent stalled builds from
hanging in cron jobs.
}

\examples{
\dontrun{
build_site()

build_site(override = list(destination = tempdir()))
}
}
