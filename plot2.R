if(!(exists("NEI")) || !sum(dim(NEI) == c(6497651, 6)) == 2) {
        NEI <- readRDS("summarySCC_PM25.rds")
        SSC <- readRDS("Source_Classification_Code.rds")
} else {
        message("Data loaded already.")
}

library(dplyr)

plotting_data <- 
        NEI %>%
        filter(fips == "24510") %>%
        group_by(year) %>%
        summarize(total_emissions = sum(Emissions))

png(filename = "plot2.png")
with(plotting_data,{
        plot(year, total_emissions,
             type = "b",
             xaxt = "n",
             yaxt = "n",
             ylab = "Total emissions",
             xlab = "Year",
             main = "Change in Total Emissions in Baltimore (1999 - 2008)")
        axis(side = 1,
             at = year)
        text(year, total_emissions,
             labels = format(round(total_emissions), big.mark = " "),
             pos = c(4, NULL, NULL, 2),
             cex = .7)
        }
     )

dev.off()
