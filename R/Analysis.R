# =============================================================================
# ECONOMETRICS 871 Panel Econometrics - API Assignment
# FRED API: Brent Crude Oil Price (USD per Barrel)
# =============================================================================

# --- Packages ----------------------------------------------------------------

if (!require("pacman", quietly = TRUE)) install.packages("pacman")
p_load(fredr, tidyverse)

# --- API Key -----------------------------------------------------------------

fredr_set_key("Your API key here")

# --- Fetch Data --------------------------------------------------------------

brent_raw <- fredr(
    series_id         = "DCOILBRENTEU",       # Brent crude, USD per barrel
    observation_start = as.Date("2000-01-01"),
    observation_end   = as.Date("2024-12-01")
)

# --- Clean -------------------------------------------------------------------

brent <- brent_raw %>%
    select(date, price = value) %>%
    drop_na()

# --- Plot 1: Price over time -------------------------------------------------

ggplot(brent, aes(x = date, y = price)) +
    geom_line(colour = "steelblue") +
    labs(
        title   = "Brent Crude Oil Price (USD per Barrel), 2000–2024",
        x       = "Year",
        y       = "Price (USD)",
        caption = "Source: FRED — DCOILBRENTEU"
    ) +
    theme_bw()

ggsave("figures/fig1_brent_price.png", width = 8, height = 5)

# --- Plot 2: Year-on-year % change -------------------------------------------

brent <- brent %>%
    mutate(returns = (price / lag(price, 365) - 1) * 100)

ggplot(brent, aes(x = date, y = returns)) +
    geom_col(fill = "steelblue", alpha = 0.7) +
    geom_hline(yintercept = 0, colour = "black", linewidth = 0.4) +
    labs(
        title   = "Brent Crude Oil: Year-on-Year Change (%)",
        x       = "Year",
        y       = "Annual Return (%)",
        caption = "Source: FRED — DCOILBRENTEU"
    ) +
    theme_bw()

ggsave("figures/fig2_brent_returns.png", width = 8, height = 5)

# --- Save data ---------------------------------------------------------------

write_csv(brent, "data/brent_clean.csv")