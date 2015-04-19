# R will call this function each time it starts up
.First <- function() {

    # the following settings will only apply if the user
    # is running in interactive mode.
    if (interactive()) {
        # load utils package quietly
        suppressMessages(require(utils))

        options(help_type='html',
                digits.secs=3,              # show sub-second values in datimes
                browserNLdisabled = TRUE,   # ignore newlines when browse()-ing (use 'c' for continuing)
                digits=4,                   # precision when displaying numbers
                prompt='R> ',               # change the R prompt. Useful if using R from the terminal.
                continue='  ',              # replace the line continuation marker ' +' with empty spaces. This is useful for copy-pasting code from the prompt that is reusable.
                #warn=2,                     # treat warnings as errors
                max.print=100,               # limit the amount that R will print to screen.
                editor = '"C:/Program Files (x86)/Vim/vim74/gvim.exe" "-c" "set filetype=r"',
                shiny.reactlog=TRUE,
                #repos=list(CRAN="http://cran.us.r-project.org")
                #devtools.desc.author='Matthew Plourde <plourde.m@gmail.com>',
                devtools.desc.license='GPL',
                useFancyQuotes=FALSE,
                error=recover,
                show.error.locations=TRUE
                #pilotdb.testing=TRUE
                #shiny.error=recover
                )

        #options(repos=c(getOption("repos"), oow="file:D:/Data/MatthewPlourde/R"))
        #options(repos=c(getOption("repos"), oow="file:\\\\28-aramplour3/Data/MatthewPlourde/R"))
        #options(repos=c(oow="file:\\\\28-aramplour3/r", getOption("repos")))
        #        #, getOption("repos"))

        # Windows only. Use internet explorer proxy settings
        setInternet2(TRUE) 

        # not using any more. switched to default in My Documents
        # create a local package directory for storing installed packages. This avoids 
        # permission conflicts.
        #if (! isTRUE(file.info(Sys.getenv('R_LIBS_USER'))$isdir)) {
        #    dir.create(Sys.getenv('R_LIBS_USER'), recursive=TRUE)
        #}
        ## set your local package directory to the default
        #.libPaths(Sys.getenv('R_LIBS_USER'))

        # possible way auto-update packages, buggy, need to fix
        #pkgs.that.cant.update <- c('devtools', 'evaluate')
        #old.pkgs <- old.packages()
        #old.pkgs <- old.pkgs[!rownames(old.pkgs) %in% pkgs.that.cant.update, ]
        #update.packages(ask=FALSE, oldPkgs=old.pkgs)

        #invisible(setRepositories(graphics=FALSE, addURLs="file:D:/Data/MatthewPlourde/R"))

        # default packages to load on startup
        #user.pkgs <- 
        #pkgs <- c('ggplot2', 'devtools', 'sos', 'RODBC', 'fortunes', 'gdata', 'data.table', 'vimcom.plus')
        # if any of these packages aren't installed, install them.
        #for (pkg in pkgs) {
        #    ret <- try(if (! pkg %in% installed.packages()) install.packages(pkg))
        #    if (! 'try-error' %in% class(ret)) suppressMessages(require(pkg, character.only=TRUE))
        #    else {
        #        message(paste(paste("Couldn't load", pkg, ':'), ret, sep='\n'))
        #    }
        #}

        options(devtools.desc.author=dQuote(person('Matthew', 'Plourde', email='plourde.m@gmail.com', role=c('aut', 'cre'))))
        httr::set_config(httr::use_proxy(url="webproxy.phila.gov", port=8080))

        # define an environment to hold an assortment of convenience functions for interactive mode
        .interactive.env <- new.env()

        # define constant to desired default working directory
        machine.name <- Sys.info()['nodename']
        if (machine.name == '28-ARAMPLOUR3') {
            .ws <- 'D:/Data/MatthewPlourde'
        } else {
            .ws <- '~/workspace'
        }

            #c('ggplot2', 'devtools', 'sos', 'RODBC', 'fortunes', 'shiny', 'roxygen2', 'httr', 'Cairo', 'data.table',
            #'magrittr', 'stringr', 'gridSVG', 'lubridate', 'grid', 'gridDebug', 'ggthemes', 'dplyr', 'tidyr')
        assign('.userpkgs', c('shiny') , env=.interactive.env)

        loadpkgs <- function() {
            for (pkg in .userpkgs) {
                ret <- try(if (! pkg %in% installed.packages()) install.packages(pkg))
                if (! 'try-error' %in% class(ret)) {
                    try(suppressMessages(library(pkg, character.only=TRUE)))
                } else {
                    message(paste(paste("Couldn't load", pkg, ':'), ret, sep='\n'))
                }
            }
        }
        environment(loadpkgs) <- .interactive.env
        assign('.loadpkgs', loadpkgs, env=.interactive.env)
        loadpkgs()

        unloadpkgs <- function() {
            pkgs <- names(sessionInfo()$otherPkgs)
            .userpkgs <<- pkgs
            for (pkg in paste0('package:', pkgs))
                try(detach(pkg, unload=TRUE, force=FALSE, character.only=TRUE), silent=FALSE)

            #for (pkg in pkgs)
            #    try(unloadNamespace(pkg), silent=TRUE)
        }
        environment(unloadpkgs) <- .interactive.env
        assign('.unloadpkgs', unloadpkgs, env=.interactive.env)

        # mask the print.data.frame function so that if the number of 
        # of rows is greater than N, print only the first n and last n rows.
        assign('print.data.frame', function(df, ...) {
               N <- 10
               n <- 5
               if (nrow(df) > N) {
                    cat('HEAD:\n', fill=TRUE)
                    base::print.data.frame(head(df, n), ...)
                    cat('\n  --- ', nrow(df) - n * 2,' rows omitted ---\n', fill=TRUE)
                    cat('TAIL:', fill=TRUE)
                    base::print.data.frame(tail(df, n), ...)
               } else {
                    base::print.data.frame(df, ...)
               }
        }, env=.interactive.env)

        # define convenience function for frequently used command rm(list=ls())
        assign('.rm', function() rm(list=ls(envir=.GlobalEnv), envir=.GlobalEnv), env=.interactive.env)

        # define constant to desired default working directory
        assign('.ws', .ws, env=.interactive.env)

        # define convenience function for reformatting Windows' paths
        assign('.winpath', function() {
           cat('Paste windows file path and hit RETURN twice', fill=TRUE)
           cat('> ')
           x <- readLines(n=1)
           xa <- gsub('\\\\', '/', x)
           return(xa)
        }, env=.interactive.env)

        assign('.p', function(d) {
            m.p <- getOption('max.print')
            options(max.print=9999)
            base::print.data.frame(d)
            options(max.print=m.p)
        }, env=.interactive.env)


        assign('.pp', function(...) {
            output <- capture.output(print(...))
            cat(output, file=stderr(), sep='\n')
        }, env=.interactive.env)

        assign('.pplot', function(...) {
            dev.new()
            print(...)
        }, env=.interactive.env)

        assign('.ed', function(d) {
            d[] <- lapply(d, function(x) if ('POSIXct' %in% class(x)) format(x, '%Y-%m-%d %H:%M:%S') else x)
            edit(d)
        }, env=.interactive.env)

        assign('.oca', function () {
            RODBC::odbcCloseAll()
        }, env=.interactive.env)

        assign('.clean', function() {
            # this function came from http://stackoverflow.com/questions/1448600/
            if (.Platform$OS.type == "unix" && .Platform$pkgType == "mac.binary") {
              to_edit <- readLines(pipe("pbpaste")) # Mac ONLY solution
            } else {
              to_edit <- readLines("clipboard") # Windows/Unix solution
            }
            opts <- options()
            cmdPrompts <- paste("^", opts$prompt, "|^", opts$continue, sep="")

            # can someone help me here? how to escape the + to \\+, as well as other special chars

            id_commands <- grep("^> |^\\+ ", to_edit) # which are command or continuation lines
            to_edit[id_commands] <- sub("^> |^\\+ ", "", to_edit[id_commands]) # remove prompts
            to_edit[-id_commands] <- paste("  # ", to_edit[-id_commands]) # comment output
            writeLines(to_edit)
        })

        # define convenience functions for recording the current plot and retrieving it later
        assign('.recplot', function() assign('.plot', recordPlot(), envir=.interactive.env), env=.interactive.env)
        assign('.revplot', function() {
            if (exists('.plot', envir=.interactive.env)) replayPlot(get('.plot', .interactive.env))
        }, env=.interactive.env)

        # define a list with paths to your R projects by name
        # note, these are only useful if you use the devtools package to manage your projects
        assign('.dev', 
            list(
                genplotter = file.path(.ws, 'GARY', 'genplotter'), # path to genplotter project
                #ppdb=file.path(.ws, 'DWAYNE', 'PilotProgram', 'ppdb'), # path to ppdb
                pilotdb=file.path(.ws, 'DWAYNE', 'pilotdb', 'pilotdb'), # path to ppdb
                wpcpSummary=file.path(.ws, 'RAJESH', 'WPCP_summary', 'wpcpSummary'),
                shinyTable=file.path(.ws, 'DWAYNE', 'shinyTable'),
                netflixex=file.path(.ws, 'netflix', 'netflixex'),
                GGally=file.path(.ws, 'netflix', 'ggally'),
                raininterp=file.path(.ws, 'GARY', 'inverse_distance_24gage', 'raininterp'),
                leaflet=file.path(.ws, 'GARY', 'inverse_distance_24gage', 'leaflet-shiny'),
                roow=file.path(.ws, 'RAJESH', 'roow'),
                DispersionCalculator=file.path(.ws, 'JIM', 'dye_study', 'dispersion-calculator'),
                bigpicture=file.path(.ws, 'ED', 'bigpicture'),
                plantanalysis=file.path(.ws, 'RAJESH', 'plantanalysis'),
                oow=file.path(.ws, 'RAJESH', 'oow'),
                plotly=file.path(.ws, 'RAJESH', 'plotly'),
                gsi13=file.path(.ws, 'HENRY', 'gsi13'),
                tracerProp=file.path(.ws, 'GARY', 'tracerProp'),
                svgg=file.path(.ws, 'DWAYNE', 'svgg'),
                ggplot2=file.path(.ws, 'DWAYNE', 'ggplot2'),
                gridSVG=file.path(.ws, 'DWAYNE', 'gridSVG', 'pkg'),
                wetWeatherTreatmentAnalysis=file.path(.ws, 'GARY', 'wet-weather-treatment-analysis'),
                shinyGridster=file.path(.ws, 'DWAYNE', 'shiny-gridster'),
                postorm=file.path(.ws, 'RAJESH', 'poststorm', 'postorm')
            ), env=.interactive.env)

        # define function that takes a project name in .dev and loads the project with devtools::load_all
        assign('.dm', function(...) {
            devtools::dev_mode(...)
        }, env=.interactive.env)

        assign('.load', function(pkg, character.only=FALSE, ...) {
            if (! character.only)
                pkg <- deparse(substitute(pkg))

            if (pkg %in% names(.dev)) {
                devtools::load_all(.dev[[pkg]], ...)
            } else {
                stop(paste(pkg, ' not found in .dev'))
            }
        }, env=.interactive.env)

        assign('.doc', function(pkg, character.only=FALSE) {
            if (!character.only)
                pkg <- deparse(substitute(pkg))
            devtools::document(.dev[[pkg]])
        }, env=.interactive.env)

        assign('.inst', function(pkg, character.only=FALSE, doc=FALSE, ...) {
            if (!character.only)
                pkg <- deparse(substitute(pkg))

            if (pkg %in% names(.dev)) {
                if (doc) {
                    .doc(pkg, character.only=TRUE)
                }
                devtools::install(.dev[[pkg]], reload=FALSE, ...)
                library(pkg, character.only=TRUE)
            } else {
                stop(paste(pkg, ' not found in .dev'))
            }
        }, env=.interactive.env)

        assign('.uinst', function(pkg, character.only=FALSE) {
            if (!character.only)
                pkg <- deparse(substitute(pkg))
            try(detach(paste('package', pkg, sep=':'), unload=TRUE, force=TRUE), silent=TRUE)
            remove.packages(pkg)
        }, env=.interactive.env)

        assign('.sdm', function(pkg, character.only=FALSE) {
            if (!character.only)
                pkg <- deparse(substitute(pkg))
            .dm(pkg, character.only=TRUE)
            
            path <- .dev[[pkg]]
            name <- basename(path)
            app.source.path <- file.path(path, 'inst', paste0(name, '_app'))
            app.name <- basename(app.source.path)

            installed.path <- file.path(getOption('devtools.path'), name)
            installed.app.path <- file.path(installed.path, app.name)
            tryCatch(unlink(installed.app.path, recursive=TRUE), warning=function(w) NULL)
            if (! file.exists(installed.app.path)) {
                file.symlink(app.source.path, installed.app.path)
            }
        }, env=.interactive.env)

        assign('.dm', function(pkg, character.only=FALSE) {
            dev_mode()
            if (!character.only)
                pkg <- deparse(substitute(pkg))
            .rinst(pkg, character.only=TRUE)
        }, env=.interactive.env)

        assign('.rinst', local({ 
            cached.pkg <- NULL
            function(pkg, character.only=FALSE, ...) {
                if (missing(pkg)) {
                    if (is.null(cached.pkg))
                        stop("You must supply the name of a package.")
                    pkg <- cached.pkg
                    character.only <- TRUE
                }

                if (!character.only)
                    pkg <- deparse(substitute(pkg))

                cached.pkg <<- pkg

                try(.uinst(pkg, character.only=TRUE), silent=TRUE)
                .inst(pkg, character.only=TRUE, ...)
            } 
        }) , env=.interactive.env)

        assign('.clr', function() {
            .rm()
            .oca()
            graphics.off()
            closeAllConnections()
        }, env=.interactive.env)

        assign('.q', function() {
            .clr()
            q('no')
        }, env=.interactive.env)



        # define a convenience function that returns the appropriate odbc connection string 
        # using the specified database type and file
        assign('.channel.str', function(name = c('excel', 'access', 'postgres'), path) {
            if (missing(name)) stop("Provide a driver name.")
            channel.strs <- list(excel="DRIVER=Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb);DBQ=",
                              access="Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=",
                              postgres="Driver={PostgreSQL ANSI};Server=localhost;Uid=postgres;Pwd=watershed.123;Database=")
            driver.str <- mget(name, as.environment(channel.strs), ifnotfound=list(NULL))
            if (is.null(unlist(driver.str)))
                stop(paste('Not connection string associated with', name))
            else if (!file.exists(path)) {
                stop(paste0('No such file:', path))
            } else {
                return(paste0(driver.str, normalizePath(path)))
            }
        }, env=.interactive.env)


        # From Dirk E
        assign('.ls.objects', function(pos=1, pattern, order.by='Size', decreasing=TRUE, head=FALSE, n=20) {
            napply <- function(names, fn) sapply(names, function(x)
                                                 fn(get(x, pos = pos)))
            names <- ls(pos = pos, pattern = pattern)
            obj.class <- napply(names, function(x) as.character(class(x))[1])
            obj.mode <- napply(names, mode)
            obj.type <- ifelse(is.na(obj.class), obj.mode, obj.class)
            obj.prettysize <- napply(names, function(x) {
                                   capture.output(format(utils::object.size(x), units = "auto")) })
            obj.size <- napply(names, object.size)
            obj.dim <- t(napply(names, function(x)
                                as.numeric(dim(x))[1:2]))
            vec <- is.na(obj.dim)[, 1] & (obj.type != "function")
            obj.dim[vec, 1] <- napply(names, length)[vec]
            out <- data.frame(obj.type, obj.size, obj.prettysize, obj.dim)
            names(out) <- c("Type", "Size", "PrettySize", "Rows", "Columns")
            if (!missing(order.by))
                out <- out[order(out[[order.by]], decreasing=decreasing), ]
            if (head)
                out <- head(out, n)
            out
        }, env=.interactive.env)

        # alt .ls.objects
        #napply <- function(names, fn) sapply(names, function(x)
        #                                     fn(get(x, pos = pos)))
        #names <- ls(pos = pos, pattern = pattern)
        #obj.class <- napply(names, function(x) aggggs.character(class(x))[1])
        #obj.mode <- napply(names, mode)
        #obj.type <- ifelse(is.na(obj.class), obj.mode, obj.class)
        #obj.size <- napply(names, object.size)
        #obj.prettysize <- sapply(obj.size, function(r) prettyNum(r, big.mark = ",") )
        #obj.dim <- t(napply(names, function(x)
        #                    as.numeric(dim(x))[1:2]))
        #vec <- is.na(obj.dim)[, 1] & (obj.type != "function")
        #obj.dim[vec, 1] <- napply(names, length)[vec]
        #out <- data.frame(obj.type, obj.size,obj.prettysize, obj.dim)
        #names(out) <- c("Type", "Size", "PrettySize", "Rows", "Columns")
        #if (!missing(order.by))
        #    out <- out[order(out[[order.by]], decreasing=decreasing), ]
        #    out <- out[c("Type", "PrettySize", "Rows", "Columns")]
        #    names(out) <- c("Type", "Size", "Rows", "Columns")
        #if (head)
        #    out <- head(out, n)
        #out
        #

        # attach the convenience functions and constants defined in .interactive.env
        attach(.interactive.env)

    # print a quote from the fortune package
    print(fortunes::fortune())

    # possible way to update prompt with current timestamp --- doesn't work yet, need to fix
    #updatePrompt <- function(...) {options(prompt=paste(Sys.time(),"> ")); return(TRUE)}
    #addTaskCallback(updatePrompt)
    }
}

# R will call this function every time it closes.
.Last <- function() {
    # when R quits, close all remaining open file connections
    graphics.off()
    closeAllConnections()
}

