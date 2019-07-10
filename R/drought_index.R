#' @export
chr2num <- function(x){
    gsub(",", "", x) %>% as.numeric()
}

#' SPI drought index
#' @import data.table
#' @export
cal_spi <- function(d){
    # add date
    if (!('date' %in% colnames(d))){
        date <- sprintf("%4d-%02d-01", d$year, d$month) %>% ymd()
        d <- data.table(date, pr = d$pr)
    }

    d[, `:=`(
        spi_3m  = spi(pr, scale = 3)$fitted %>% as.numeric(),
        spi_6m  = spi(pr, scale = 6)$fitted %>% as.numeric(),
        spi_12m  = spi(pr, scale = 12)$fitted %>% as.numeric())]
}
