
variables_monthly

set.seed(123)

as.matrix(variables_monthly) |>
  bsvars::specify_bsvar$new(p = 4) |>
  bsvars::estimate(S = 500) |> 
  bsvars::estimate(S = 5000, thin = 2) -> post

post |> bsvars::forecast(horizon = 12) -> fore
fore_mea  = apply(fore$forecasts[1,,], 1, median)
fore_hdi  = apply(fore$forecasts[1,,], 1, HDInterval::hdi, credMass = .68)



icr_dwnld   = readrba::read_rba(series_id = "FIRMMCRTD")   # Cash Rate Target
icr_tmp     = xts::xts(icr_dwnld$value, icr_dwnld$date)
crt         = xts::to.monthly(icr_tmp, OHLC = FALSE)
dates_tmp   = xts::xts(as.Date(icr_dwnld$date), icr_dwnld$date)

# Trade-weighted Index May 1970 = 100
twi_dwnld  = readrba::read_rba(series_id = "FXRTWI")
twi_tmp    = xts::xts(twi_dwnld$value, twi_dwnld$date)
twi        = xts::to.monthly(twi_tmp, OHLC = FALSE)

# US dollar trade-weighted index
twius_dwnld  = readrba::read_rba(series_id = "FUSXRTWI")
twius_tmp    = xts::xts(twius_dwnld$value, twius_dwnld$date, tclass = 'yearmon')
twius        = xts::to.monthly(twius_tmp, OHLC = FALSE)

# Canada Target Rate
rcan_dwnld  = readrba::read_rba(series_id = "FOOIRCTR")
rcan_tmp    = xts::xts(rcan_dwnld$value, rcan_dwnld$date, tclass = 'yearmon')
rcan        = xts::to.monthly(rcan_tmp, OHLC = FALSE)

# Euro Area Refinancing Rate
reur_dwnld  = readrba::read_rba(series_id = "FOOIREARR")
reur_tmp    = xts::xts(reur_dwnld$value, reur_dwnld$date, tclass = 'yearmon')
reur        = xts::to.monthly(reur_tmp, OHLC = FALSE)

# Japan Policy Rate
rjap_dwnld  = readrba::read_rba(series_id = "FOOIRJTCR")
rjap_tmp    = xts::xts(rjap_dwnld$value, rjap_dwnld$date, tclass = 'yearmon')
rjap        = xts::to.monthly(rjap_tmp, OHLC = FALSE)

# United Kingdom Bank Rate
rgbt_dwnld  = readrba::read_rba(series_id = "FOOIRUKOBR")
rgbt_tmp    = xts::xts(rgbt_dwnld$value, rgbt_dwnld$date, tclass = 'yearmon')
rgbt        = xts::to.monthly(rgbt_tmp, OHLC = FALSE)

# United States Federal Funds Minimum Target Rate
rusa_dwnld  = readrba::read_rba(series_id = "FOOIRUSFFTRMX")
rusa_tmp    = xts::xts(rusa_dwnld$value, rusa_dwnld$date, tclass = 'yearmon')
rusa        = xts::to.monthly(rusa_tmp, OHLC = FALSE)

foreign = na.omit(merge(
  crt, twi, twius, rcan, reur, rjap, rgbt, rusa
))
