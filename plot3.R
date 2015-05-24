if(!(exists("NEI")) || !sum(dim(NEI) == c(6497651, 6)) == 2) {
        NEI <- readRDS("summarySCC_PM25.rds")
        SSC <- readRDS("Source_Classification_Code.rds")
} else {
        message("Data loaded already.")
}

library(dplyr)
library(ggplot2)

plotting_data <- 
        NEI %>%
        filter(fips == "24510") %>%
        select(Emissions, type, year) %>%
        mutate(type = as.factor(type)) %>%
        group_by(type, year) %>%
        summarize(Emissions = sum(Emissions))

png(filename = "plot3.png")
plot <- ggplot(data = plotting_data,
               aes(x = year,
                   y = Emissions,
                   group = type,
                   colour = type)) +
        geom_line() +
        geom_point(size = 4,
                   shape = 21,
                   fill = "Grey") +
        labs(title = "Change in Total Emissions by Type in Baltimore")
print(plot)

dev.off()
