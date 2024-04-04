
allSamplesFile <- "CFS-M_phase-PolQ-2023.csv"
sampleFile     <- "CFS-M_phase-PolQ-2023_XXXX.csv"
allSamples <- read.table(allSamplesFile, header = TRUE, sep = ",", stringsAsFactors = FALSE)
lowAph <- list(
    GM12878 = "..0.4uM_APH",
    HCT116  = "..0.2uM_APH",
    HF1     = "..0.6uM_APH"
)
ART558 <- list(
    GM12878 = "..10uM_ART558",
    HF1     = "..10uM_ART558" # HCT116 used two different ART558 doses
)
for(cell_line in unique(allSamples$cell_line)){
    d <- allSamples[allSamples$cell_line == cell_line,]
    if(!is.null(lowAph[[cell_line]])) names(d)[names(d) == "low_APH"] <- lowAph[[cell_line]]
    if(!is.null(ART558[[cell_line]])) names(d)[names(d) == "ART558"] <- ART558[[cell_line]]
    write.table(
        d, 
        file = sub("XXXX", cell_line, sampleFile), 
        quote = FALSE, 
        sep = ",",
        row.names = FALSE,
        col.names = TRUE
    )
}
