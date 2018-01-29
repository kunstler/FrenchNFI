read_tree <- function(path = "data"){
  list.tree <- lapply(2008:2013,
        function(y) read.csv(file.path(path, y,
                                       paste0("arbres_foret_", y, ".csv")),
                              sep=";"))
  ## Change Variables to be consistent across different years and merge across year
  ## *simplif* and *sfcoeur* are missing in 2008, add them
  list.tree[[1]]$simplif <-rep(NA, nrow(list.tree[[1]]))
  list.tree[[1]]$sfcoeur <-rep(NA, nrow(list.tree[[1]]))
  list.tree[[1]] <- list.tree[[1]][,names(list.tree[[2]])]
  # add year to each data
  list.tree <- lapply(1:6,
           function(i, list.t, years){
                 list.t[[i]]$year <- years[i];
                 return(list.t[[i]])
           },
           list.tree, 2008:2013)
  data.tree <- do.call("rbind", list.tree)
  return(data.tree)
}



read_couv <- function(path = "data"){
  list.couv <- lapply(2008:2013,
        function(y) read.csv(file.path(path, y,
                                       paste0("couverts_foret_", y, ".csv")),
                              sep=";"))
  # add year to each data
  list.couv <- lapply(1:6,
           function(i, list.t, years){
                 list.t[[i]]$year <- years[i];
                 return(list.t[[i]])
           },
           list.couv, 2008:2013)
  data.couv <- do.call("rbind", list.couv)
  return(data.couv)
}


read_dead_tree <-  function(path = "data"){
  list.tree.dead <- lapply(2008:2013,
    function(y) read.csv(file.path(path, y,
                                   paste0("arbres_morts_foret_",
                                          y, ".csv")),
                          sep=";"))
  list.tree.dead <- lapply(1:6,
           function(i, list.t, years){
                 list.t[[i]]$year <- years[i];
                 return(list.t[[i]])
           },
           list.tree.dead, 2008:2013)
  data.tree.dead <- do.call("rbind", list.tree.dead)
  return(data.tree.dead)
}

merge_dead_alive <- function(data.tree, data.tree.dead){
  tree.dead.alive <-  data.frame(
    idp = c(data.tree$idp, data.tree.dead$idp),
    a = c(data.tree$a, data.tree.dead$a),
    veget = c(data.tree$veget, data.tree.dead$veget),
    simplif = c(data.tree$simplif, rep(NA, length = length(data.tree.dead$idp))),
    acci = c(data.tree$acci, rep(NA, length = length(data.tree.dead$idp))),
    espar = c(as.character(data.tree$espar), as.character(data.tree.dead$espar)),
    ori = c(data.tree$ori, data.tree.dead$ori),
    lib = c(data.tree$lib, rep(NA, length = length(data.tree.dead$idp))),
    forme = c(data.tree$forme, rep(NA, length = length(data.tree.dead$idp))),
    tige = c(data.tree$tige, rep(NA, length = length(data.tree.dead$idp))),
    mortb = c(data.tree$mortb, rep(NA, length = length(data.tree.dead$idp))),
    sfgui = c(data.tree$sfgui, rep(NA, length = length(data.tree.dead$idp))),
    sfgeliv = c(data.tree$sfgeliv, rep(NA, length = length(data.tree.dead$idp))),
    sfpied = c(data.tree$sfpied, rep(NA, length = length(data.tree.dead$idp))),
    sfdorge = c(data.tree$sfdorge, rep(NA, length = length(data.tree.dead$idp))),
    sfcoeur = c(data.tree$sfcoeur, rep(NA, length = length(data.tree.dead$idp))),
    c13 = c(data.tree$c13, data.tree.dead$c13),
    ir5 = c(data.tree$ir5, rep(NA, length = length(data.tree.dead$idp))),
    htot = c(data.tree$htot, rep(NA, length = length(data.tree.dead$idp))),
    hdec = c(data.tree$hdec, rep(NA, length = length(data.tree.dead$idp))),
    decoupe = c(data.tree$decoupe, rep(NA, length = length(data.tree.dead$idp))),
    q1 = c(data.tree$q1, rep(NA, length = length(data.tree.dead$idp))),
    q2 = c(data.tree$q2, rep(NA, length = length(data.tree.dead$idp))),
    q3 = c(data.tree$q3, rep(NA, length = length(data.tree.dead$idp))),
    r = c(data.tree$r, rep(NA, length = length(data.tree.dead$idp))),
    lfsd = c(data.tree$lfsd, rep(NA, length = length(data.tree.dead$idp))),
    age = c(data.tree$age, rep(NA, length = length(data.tree.dead$idp))),
    v = c(data.tree$v, data.tree.dead$v),
    w = c(data.tree$w, rep(10000/(pi*(c(15))^2), length = length(data.tree.dead$w))),
  ## all dead tree are sampled on the whole plot as explained in the method
    year = c(data.tree$year, data.tree.dead$year),
    datemort = c(rep(NA, length = length(data.tree$year)), data.tree.dead$datemort),
    dead = c(rep(0, length = length(data.tree$year)),
           rep(1, length = length(data.tree.dead$idp))))
  return(tree.dead.alive)
}


read_plot <- function(path = "data"){
  ## Read the plot data for each year.
  list.plot <- lapply(2008:2013,
        function(y) read.csv(file.path(path, y,
                                       paste0("placettes_foret_", y, ".csv")),
                              sep=";"))
  list.plot <- lapply(1:6,
           function(i, list.t, years){
                  list.t[[i]]$year <- years[i];
                  return(list.t[[i]])
           },
           list.plot, 2008:2013)
  ## Replace with NA variable missing in 200 and Merge plot data.
  list.plot[[1]]$gest <- NA
  list.plot[[1]]$incid <- NA
  list.plot[[1]]$peupnr <- NA
  list.plot[[1]]$portance <- NA
  list.plot[[1]]$asperite <- NA
  list.plot[[1]]$tm2 <- NA
  list.plot[[1]] <- list.plot[[1]][, names(list.plot[[2]])]
  data.plot <- do.call("rbind", list.plot)
  return(data.plot)
}


map_plot <- function(data.plot){
  require(sp)
  require(raster)
  require(rgdal)
  coordinates(data.plot) =~ xl93+yl93
  proj4string(data.plot) <- CRS("+init=epsg:2154")
  ## set projection to lambert93
  ### plot of map of plots over FRANCE
  x   <- cbind(data.plot$xl93,data.plot$yl93)
  data <- as.data.frame(x)
  names(data) <- c("X","Y")
  colors  <- densCols(x)
  plot(x, col=colors, pch=20,cex=0.25,xlab="X",ylab="Y")
}


read_ecological_data <-  function(path = "data"){
  # READ ECOLOGICAL DATA (SOIL AND ABIOTIC VARIABLES) for each year.
  list.ecol <- lapply(2008:2013,
        function(y) read.csv(file.path(path, y,
                                       paste0("ecologie_", y, ".csv")),
                              sep=";"))
  # remove new variables from 2013
  list.ecol[[6]]$obsriv <- NULL
  list.ecol[[6]]$obsriv2 <- NULL
  list.ecol[[6]]$distriv <- NULL
  list.ecol[[6]]$denivriv <- NULL

  data.ecol <- do.call("rbind", list.ecol)
  return(data.ecol)
}
