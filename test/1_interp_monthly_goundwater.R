# Dongdong Kong
# 2019-07-10
source('test/main_pkgs.R')
source('test/main_vis.R')
library(lubridate)
library(readxl)
library(foreach)
library(iterators)
library(SPEI)
library(grid)
library(gridExtra)


## 1. tidy input ---------------------------------------------------------------
{
    d_gd <- read_xls('inst/extdata/groundwater.xls') %>% data.table() %>%
        melt(c("year", "month"))
    d_gd[, date := make_date(year, month, 1)]

    d_mete <- fread('inst/extdata/mete_terra.csv')
    d_mete$date %<>% as.Date('%b %d, %Y')
    d_mete[, pdsi := pdsi/100]

    I_fix <- sapply(d_mete, is_character) %>% which() # convert chr to num
    temp <- foreach(I = I_fix) %do% {
        d_mete[[I]] %<>% chr2num()
    }
    # mete drought index
    # spei <- spei(d$pr - d$pet, scale = 6)$fitted %>% as.numeric()
    d_mete[, `:=`(
        spei_3m = spei(pr - pet, scale = 3)$fitted %>% as.numeric(),
        spei_6m = spei(pr - pet, scale = 6)$fitted %>% as.numeric(),
        spei_12m = spei(pr - pet, scale = 12)$fitted %>% as.numeric())]
    # d_mete %<>% cal_spi()

    d_prcp <- read_xlsx("/media/kongdd/093D-C7E3/1966-2015湛江地区12个站降水数据/zhanjiangchikan.xlsx",
                        col_names = FALSE) %>% set_colnames(c("year", "month", "pr")) %>%
        data.table() %>% cal_spi()
    d <- merge(d_gd, d_mete) %>% merge(d_prcp)
}

## 1. Drought Index ------------------------------------------------------------
{
    # 1. groundwater level
    p_gd <- ggplot(d, aes(date, value, color = variable)) +
        # geom_point() +
        geom_line()

    # 2. PDSI
    p_pdsi <- ggplot(d, aes(date, pdsi)) +
        # geom_point() +
        geom_line() +
        geom_hline(yintercept = -2, color = "red") +
        ggtitle("PDSI index")

    # 3. spei_3m, spi_3m,
    pdat <- d[, .(date, spei_12m, spi_12m)] %>% unique() %>%
        melt("date")
    p_spi <- ggplot(pdat, aes(date, value, color = variable)) +
        # geom_point() +
        geom_line() +
        geom_hline(yintercept = -0.8, color = "red") +
        ggtitle("Mete index, scale = 12month")
    p <- arrangeGrob(p_gd, p_spi, p_pdsi)
    write_fig(p, "Fig1_drought.pdf", 8, 10)
}

# E=110º21' 48.482''; N= 21º16' 02.891''
# 48.482/3600 + 21/60 + 110 = 110.3635
# 02.891/3600 + 16/60 + 21  = 21.26747
# st <- data.table(id = 1, lon = 110.3635, lat = 21.26747)
# sp <- df2sp(st)

# 2. meteorilogical drought
