//
//// BCP1 Preliminary Stata Command File
//


// Set Directory
clear
cd "..."

// Create Log
capture log close
log using "bcp1_out", replace

// Load Data
insheet using bcp1_master.csv
save bcp1_master.dta, replace
xtset pair period


//// Generate Variables

gen r2_3 = (round > 1)
gen r3 = (round == 3)

gen od_disclose = opt_disc * disclose
gen low_sp = (prd_start_stat_pts <= 50)
gen offer_low_sp = offer * low_sp

gen offer_disclose = offer * disclose
gen offer_od = offer * opt_disc
gen offer_od_disclose = offer * od_disclose

gen low_sp_disclose = low_sp * disclose
gen low_sp_od = low_sp * opt_disc
gen low_sp_od_disclose = low_sp * od_disclose

gen offer_low_sp_disclose = offer_low_sp * disclose
gen offer_low_sp_od = offer_low_sp * opt_disc
gen offer_low_sp_od_disclose = offer_low_sp * od_disclose

gen r2_3_disclose = r2_3 * disclose
gen r2_3_od = r2_3 * opt_disc
gen r2_3_od_disclose = r2_3 * od_disclose

gen r3_disclose = r3 * disclose
gen r3_od = r3 * opt_disc
gen r3_od_disclose = r3 * od_disclose


//// SUMMARY STATS

// ND, Round 1
sum offer disclose accept prd_end_stat_pts prd_earn_prop prd_earn_resp if non_disc == 1 & round == 1
// ND, Round 2
sum offer disclose accept prd_end_stat_pts prd_earn_prop prd_earn_resp if non_disc == 1 & round == 2
// ND, Round 3
sum offer disclose accept prd_end_stat_pts prd_earn_prop prd_earn_resp if non_disc == 1 & round == 3
// ND, All Rounds
sum offer disclose accept prd_end_stat_pts prd_earn_prop prd_earn_resp if non_disc == 1

// MD, Round 1
sum offer disclose accept prd_end_stat_pts prd_earn_prop prd_earn_resp if man_disc == 1 & round == 1
// MD, Round 2
sum offer disclose accept prd_end_stat_pts prd_earn_prop prd_earn_resp if man_disc == 1 & round == 2
// MD, Round 3
sum offer disclose accept prd_end_stat_pts prd_earn_prop prd_earn_resp if man_disc == 1 & round == 3
// MD, All Rounds
sum offer disclose accept prd_end_stat_pts prd_earn_prop prd_earn_resp if man_disc == 1

// OD, Round 1
sum offer disclose accept prd_end_stat_pts prd_earn_prop prd_earn_resp if opt_disc == 1 & round == 1
// OD, Round 2
sum offer disclose accept prd_end_stat_pts prd_earn_prop prd_earn_resp if opt_disc == 1 & round == 2
// OD, Round 3
sum offer disclose accept prd_end_stat_pts prd_earn_prop prd_earn_resp if opt_disc == 1 & round == 3
// OD, All Rounds
sum offer disclose accept prd_end_stat_pts prd_earn_prop prd_earn_resp if opt_disc == 1

// OD, Hidden, Round 1
sum offer accept if opt_disc == 1 & disclose == 0 & round == 1
// OD, Hidden, Round 2
sum offer accept if opt_disc == 1 & disclose == 0 & round == 2
// OD, Hidden, Round 3
sum offer accept if opt_disc == 1 & disclose == 0 & round == 3
// OD, Hidden, All Rounds
sum offer accept if opt_disc == 1 & disclose == 0

// OD, Disclosed, Round 1
sum offer accept if opt_disc == 1 & disclose == 1 & round == 1
// OD, Disclosed, Round 2
sum offer accept if opt_disc == 1 & disclose == 1 & round == 2
// OD, Disclosed, Round 3
sum offer accept if opt_disc == 1 & disclose == 1 & round == 3
// OD, Disclosed, All Rounds
sum offer accept if opt_disc == 1 & disclose == 1


//// OFFERS, REGRESSIONS

// Round 1
xtreg offer disclose opt_disc od_disclose risk_lvl_prop prop_know_stat_pts_fl if round == 1, re cluster(pair)
// Round 2
xtreg offer disclose opt_disc od_disclose risk_lvl_prop prop_know_stat_pts_fl if round == 2, re cluster(pair)
// Round 3
xtreg offer disclose opt_disc od_disclose risk_lvl_prop prop_know_stat_pts_fl if round == 3, re cluster(pair)
// All Rounds
xtreg offer disclose opt_disc od_disclose risk_lvl_prop prop_know_stat_pts_fl r2_3 r2_3_disclose r2_3_od r2_3_od_disclose r3 r3_disclose r3_od r3_od_disclose, re cluster(pair)


//// OFFERS, LEVENE'S TEST

// ND vs MD, Round 1
robvar offer if opt_disc == 0 & round == 1, by(man_disc)
// ND vs MD, Round 2
robvar offer if opt_disc == 0 & round == 2, by(man_disc)
// ND vs MD, Round 3
robvar offer if opt_disc == 0 & round == 3, by(man_disc)
// ND vs MD, All Rounds
robvar offer if opt_disc == 0, by(man_disc)

// OD, Hidden vs Disclosed, Round 1
robvar offer if opt_disc == 1 & round == 1, by(disclose)
// OD, Hidden vs Disclosed, Round 2
robvar offer if opt_disc == 1 & round == 2, by(disclose)
// OD, Hidden vs Disclosed, Round 3
robvar offer if opt_disc == 1 & round == 3, by(disclose)
// OD, Hidden vs Disclosed, All Rounds
robvar offer if opt_disc == 1, by(disclose)


// ACCEPTANCE, REGRESSIONS (OLS)

// Round 1
xtreg accept disclose opt_disc od_disclose risk_lvl_resp offer offer_disclose offer_od offer_od_disclose low_sp low_sp_disclose low_sp_od low_sp_od_disclose offer_low_sp offer_low_sp_disclose offer_low_sp_od offer_low_sp_od_disclose if round == 1, re cluster(pair)
// Round 2
xtreg accept disclose opt_disc od_disclose risk_lvl_resp offer offer_disclose offer_od offer_od_disclose low_sp low_sp_disclose low_sp_od low_sp_od_disclose offer_low_sp offer_low_sp_disclose offer_low_sp_od offer_low_sp_od_disclose if round == 2, re cluster(pair)
// Round 3
xtreg accept disclose opt_disc od_disclose risk_lvl_resp offer offer_disclose offer_od offer_od_disclose low_sp low_sp_disclose low_sp_od low_sp_od_disclose offer_low_sp offer_low_sp_disclose offer_low_sp_od offer_low_sp_od_disclose if round == 3, re cluster(pair)
// All Rounds
xtreg accept disclose opt_disc od_disclose risk_lvl_resp offer offer_disclose offer_od offer_od_disclose low_sp low_sp_disclose low_sp_od low_sp_od_disclose offer_low_sp offer_low_sp_disclose offer_low_sp_od offer_low_sp_od_disclose r2_3 r2_3_disclose r2_3_od r2_3_od_disclose r3 r3_disclose r3_od r3_od_disclose, re cluster(pair)


// ACCEPTANCE, REGRESSIONS (PROBIT)

// Round 1
quietly xtprobit accept disclose opt_disc od_disclose risk_lvl_resp offer offer_disclose offer_od offer_od_disclose low_sp low_sp_disclose low_sp_od low_sp_od_disclose offer_low_sp offer_low_sp_disclose offer_low_sp_od offer_low_sp_od_disclose if round == 1, re vce(robust) nolog
margins, dydx(disclose opt_disc od_disclose risk_lvl_resp offer offer_disclose offer_od offer_od_disclose low_sp low_sp_disclose low_sp_od low_sp_od_disclose offer_low_sp offer_low_sp_disclose offer_low_sp_od offer_low_sp_od_disclose) atmeans
// Round 2
quietly xtprobit accept disclose opt_disc od_disclose risk_lvl_resp offer offer_disclose offer_od offer_od_disclose low_sp low_sp_disclose low_sp_od low_sp_od_disclose offer_low_sp offer_low_sp_disclose offer_low_sp_od offer_low_sp_od_disclose if round == 2, re vce(robust) nolog
margins, dydx(disclose opt_disc od_disclose risk_lvl_resp offer offer_disclose offer_od offer_od_disclose low_sp low_sp_disclose low_sp_od low_sp_od_disclose offer_low_sp offer_low_sp_disclose offer_low_sp_od offer_low_sp_od_disclose) atmeans
// Round 3
quietly xtprobit accept disclose opt_disc od_disclose risk_lvl_resp offer offer_disclose offer_od offer_od_disclose low_sp low_sp_disclose low_sp_od low_sp_od_disclose offer_low_sp offer_low_sp_disclose offer_low_sp_od offer_low_sp_od_disclose if round == 3, re vce(robust) nolog
margins, dydx(disclose opt_disc od_disclose risk_lvl_resp offer offer_disclose offer_od offer_od_disclose low_sp low_sp_disclose low_sp_od low_sp_od_disclose offer_low_sp offer_low_sp_disclose offer_low_sp_od offer_low_sp_od_disclose) atmeans
// All Rounds
quietly xtprobit accept disclose opt_disc od_disclose risk_lvl_resp offer offer_disclose offer_od offer_od_disclose low_sp low_sp_disclose low_sp_od low_sp_od_disclose offer_low_sp offer_low_sp_disclose offer_low_sp_od offer_low_sp_od_disclose r2_3 r2_3_disclose r2_3_od r2_3_od_disclose r3 r3_disclose r3_od r3_od_disclose, re vce(robust) nolog
margins, dydx( disclose opt_disc od_disclose risk_lvl_resp offer offer_disclose offer_od offer_od_disclose low_sp low_sp_disclose low_sp_od low_sp_od_disclose offer_low_sp offer_low_sp_disclose offer_low_sp_od offer_low_sp_od_disclose r2_3 r2_3_disclose r2_3_od r2_3_od_disclose r3 r3_disclose r3_od r3_od_disclose) atmeans


log close