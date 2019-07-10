# source('test/main_vis.R')
OS.type = .Platform$OS.type
if (OS.type == 'windows') {
    windowsFonts(
        Times = windowsFont("Times New Roman"), 
        Arial = windowsFont("Arial"), 
        YH = windowsFont("Microsoft Yahei")
    )
} else if (OS.type == 'unix'){
    Cairo::CairoFonts(
        regular="Times New Roman:style=Regular",
        bold="Times New Roman:style=Bold",
        italic="Times New Roman:style=Oblique",
        bolditalic="Times New Roman:style=BoldOblique"
    )
}

fontsize <- 12
delta    <- -0.02
lwd_grid <- 0.25
# , base_family = "Times"
theme_default <- theme_bw(base_size = 12, base_family = "Times") + 
    theme(
        panel.grid.minor = element_blank(), 
        panel.grid.major = element_line(size = lwd_grid, linetype = 2), # element_blank()
        axis.text = element_text(color = "black", size = fontsize),
        axis.title = element_text(size = fontsize+1, face = "bold"),
        strip.text = element_text(size = fontsize+2, face = "bold"),
        legend.text = element_text(size = fontsize),
        # legend.title = element_text(size = fontsize+2, face = "bold"),
        legend.title = element_blank(),
        legend.key.width = unit(1.5,"cm"),
        legend.background=element_rect(fill = "transparent"),
        # legend.box.background=element_rect(fill = "transparent"), 
        legend.key=element_rect(fill = "transparent"),
        legend.position = c(0, 1), 
        legend.justification = c(0, 1) + c(-1, 1)*delta)
theme_set(theme_default)

## variables
# indices <- c("intensity", "frequency", "duration", "volume", "PR", "FAR")
# indices_label <- c('Maximum annual intensity (°C)', 'Annual mean frequency', 'Annual mean duration (days)', 
#     'Annual cumulative mean intensity (°C)', 'Probability ratio', 'Fraction of attributable risk')
# # (℃)
# scenarios <- c("historical", "historicalGHG", "historicalMisc", "historicalNat", "RCP26", "RCP45", "RCP60", "RCP85")
