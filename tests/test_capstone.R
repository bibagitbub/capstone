library(testthat)

earthquakes <- readr::read_delim("signif.txt",delim="\t")
earthquakes <- eq_clean_data(earthquakes)

expect_that(capstone::eq_clean_data(earthquakes),is_a("data.frame"))



x <- as.Date("2000-01-01")
xmax <- as.Date("2017-01-01")
countries <- c("ITALY","USA")
n_max <- 10

to_plot <- earthquakes %>%
  filter(date >= x & date <=xmax & (COUNTRY %in% countries)) %>%
  filter(!is.na(INTENSITY) & !is.na(DEATHS)) %>%
  mutate(COUNTRY = factor(COUNTRY, levels = unique(COUNTRY)))

to_plot2 <- to_plot[order(to_plot$INTENSITY,decreasing = TRUE),]
to_plot2 <- to_plot2[1:min(n_max,nrow(to_plot2)),]

g <- ggplot(data = to_plot) +
  geom_segment(aes(x = x, xend = xmax, y = COUNTRY, yend = COUNTRY),
               alpha = 0.5, color = "gray") +
  capstone::geom_timeline(aes(x = date, y = COUNTRY, i = INTENSITY, d = DEATHS)) +
  geom_segment(data = to_plot2, aes(x = date, xend = date, y = COUNTRY, yend = as.numeric(COUNTRY) + 0.25),
               alpha = 0.5, color = "gray") +
  capstone::geom_timeline_label(data = to_plot2, aes(x = date, y = as.numeric(COUNTRY) + 0.4, label = LOCATION_NAME)) +
  theme_minimal()

expect_that(g,is_a("ggplot"))



g <- readr::read_delim("signif.txt", delim = "\t") %>%
  capstone::eq_clean_data() %>%
  dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(date) >= 2000) %>%
  dplyr::mutate(popup_text = eq_create_label(.)) %>%
  capstone::eq_map(annot_col = "popup_text")

expect_that(g,is_a("leaflet"))