if(!(exists("NEI")) || !sum(dim(NEI) == c(6497651, 6)) == 2) {
        NEI <- readRDS("summarySCC_PM25.rds")
        SSC <- readRDS("Source_Classification_Code.rds")
} else {
        message("Data loaded already.")
}

library(dplyr)
library(ggplot2)

coal_comb_SCC <- SSC[grep("^fuel comb -(.*)- coal$", SSC$EI.Sector, ignore.case = T),]
plotting_data <- semi_join(NEI, coal_comb_SCC, by = c("SCC" = "SCC"))

plotting_data <- 
        plotting_data %>%
        group_by(year) %>%
        summarize(Emissions = sum(Emissions))

png(filename = "plot4.png")

plot <- ggplot(data = plotting_data,
               aes(x = year,
                   y = Emissions)) +
        geom_line() +
        geom_point(size = 4,
                   shape = 21,
                   fill = "Grey") +
        labs(title = "Total Emissions from Coal Combustion Across US")
print(plot)

dev.off()
