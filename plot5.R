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
        filter(fips == "24510") %>%
        select(SCC, Emissions, year)

plotting_data <- inner_join(motor_veh_NEI, motor_veh_SCC, by = c("SCC" = "SCC"))

plotting_data <- 
        plotting_data %>%
        group_by(year, EI.Sector) %>%
        summarize(Emissions = sum(Emissions))

png(filename = "plot5.png")

plot <- ggplot(data = plotting_data,
               aes(x = year,
                   y = Emissions,
                   fill = EI.Sector)) +
        geom_area() +
        labs(title = "Total Emissions from Motor Vehicles in Baltimore") +
        theme(legend.position = c(.7, .75),
              legend.background = element_rect(fill = NA))
print(plot)

dev.off()
