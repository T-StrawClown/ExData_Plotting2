if(!(exists("NEI")) || !sum(dim(NEI) == c(6497651, 6)) == 2) {
        NEI <- readRDS("summarySCC_PM25.rds")
        SSC <- readRDS("Source_Classification_Code.rds")
} else {
        message("Data loaded already.")
}

library(dplyr)
library(ggplot2)

motor_veh_SCC <- SSC[grep("^Mobile -*", SSC$EI.Sector, ignore.case = F),]
motor_veh_SCC <- 
        motor_veh_SCC %>%
        select(SCC, EI.Sector)
motor_veh_NEI <-
        NEI %>%
        filter(fips %in% c("24510", "06037")) %>%
        select(SCC, Emissions, year, fips) %>%
        mutate(fips = ifelse(fips == "24510", "Baltimore City", "Los Angeles County"))

plotting_data <- inner_join(motor_veh_NEI, motor_veh_SCC, by = c("SCC" = "SCC"))

plotting_data <- 
        plotting_data %>%
        group_by(year, EI.Sector, fips) %>%
        summarize(Emissions = sum(Emissions))

png(filename = "plot6.png",
    width = 960,
    height = 480,
    points = "px")

plot <- ggplot(data = plotting_data,
               aes(x = year,
                   y = Emissions,
                   fill = EI.Sector)) +
        geom_area() +
        facet_grid(. ~ fips) +
        labs(title = "Emissions from Motor Vehicles Baltimore vs. LA County") +
        theme(legend.position = c(.2, .75),
              legend.background = element_rect(fill = NA))
print(plot)

dev.off()
