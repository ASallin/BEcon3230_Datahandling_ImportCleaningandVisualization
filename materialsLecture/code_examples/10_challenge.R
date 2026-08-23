library(ggplot2)

dataChallenge <- data.frame(
  Location = rep(c("Bahamas Beach", "French Riviera", "Hawaiian Club"), each = 3),
  Fiscal_Year = rep(c("FY93", "FY94", "FY95"), times = 3),
  Revenue = c(
    250000, 275000, 350000,  # Bahamas Beach (FY93, FY94, FY95)
    260000, 200000, 210000,  # French Riviera (FY93, FY94, FY95)
    450000, 500000, 400000   # Hawaiian Club (FY93, FY94, FY95)
  )
)

ggplot(dataChallenge, aes(x = Fiscal_Year, y = Revenue, fill = Location)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(
    title = "Resort Revenues by Location and Year",
    x = "",
    y = "Revenue (in USD)"
  ) +
  scale_y_continuous(labels = scales::dollar) +
  scale_x_discrete(labels = c("1993", "1994", "1995")) +
  theme_classic() +
  theme(legend.position = "bottom")


ggplot(dataChallenge, aes(x = Fiscal_Year, y = Revenue, color = Location,
                          group = Location)) +
  geom_line() +
  labs(
    title = "Resort Revenues by Location and Year",
    x = "",
    y = "Revenue (in USD)"
  ) +
  scale_y_continuous(labels = scales::dollar) +
  scale_x_discrete(labels = c("1993", "1994", "1995"),
                   expand = expansion(add = c(0.5, 0.5))) +
  theme_classic() +
  theme(legend.position = "bottom")


ggplot(dataChallenge, aes(x = Fiscal_Year, y = Revenue, color = Location,
                          group = Location)) +
  geom_line(size = 2) +
  geom_text(data = dataChallenge[dataChallenge$Fiscal_Year == "FY95", ],
            aes(label = Location), hjust = 0, nudge_x = 0.1, nudge_y = 0) +
  labs(
    title = "Resort Revenues by Location and Year",
    x = "",
    y = "Revenue (in USD)"
  ) +
  scale_y_continuous(labels = scales::dollar, limits = c(0, 500000)) +
  scale_x_discrete(labels = c("1993", "1994", "1995"), 
                   expand = expansion(add = c(0.5, 1))) +
  theme_classic() +
  theme(legend.position = "none")  +
  scale_color_brewer(palette = "Set1")


ggplot(dataChallenge, aes(x = Fiscal_Year, y = Revenue, color = Location,
                          group = Location)) +
  geom_line(size = 2) +
  geom_text(data = dataChallenge[dataChallenge$Fiscal_Year == "FY95", ],
            aes(label = Location), hjust = 0, nudge_x = 0.1, nudge_y = 0) +
  labs(
    title = "Resort Revenues by Location and Year",
    x = "",
    y = "Revenue (in USD)"
  ) +
  scale_y_continuous(labels = scales::dollar, limits = c(0, 500000)) +
  scale_x_discrete(labels = c("1993", "1994", "1995"), 
                   expand = expansion(add = c(0.5, 1))) +
  theme_classic() +
  theme(legend.position = "none")  +
  scale_color_brewer(palette = "Set1")
  
  
ggplot(dataChallenge, aes(x = Fiscal_Year, y = Revenue, color = Location,
                          group = Location)) +
  geom_line(size = 2) +
  geom_text(data = dataChallenge[dataChallenge$Fiscal_Year == "FY95", ],
            aes(label = Location), hjust = 0, nudge_x = 0.1, nudge_y = 0) +
  labs(
    title = "Resort Revenues by Location and Year",
    x = "",
    y = "Revenue (in USD)"
  ) +
  scale_y_continuous(labels = scales::dollar, limits = c(0, 500000)) +
  scale_x_discrete(labels = c("1993", "1994", "1995"), 
                   expand = expansion(add = c(0.5, 1))) +
  theme_classic() +
  theme(legend.position = "none") +
  scale_color_brewer(palette = "Greys")
