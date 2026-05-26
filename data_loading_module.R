## ============================================================
##  BUILD_20_PAPERS.R
##  Causal ML in Oncology — Systematic Review
##  20 papers × 21 dimensions = 420 evidence rows
##  Updated: 2026-05 (batch 3: 3 new papers added)
##  New papers: Lopez_2023, Ma_2018, Roblin_2025b
## ============================================================

library(tibble)
library(dplyr)

cat("\n============================================\n")
cat("  BUILD_20_PAPERS.R IS RUNNING CORRECTLY\n")
cat("============================================\n\n")

# ============================================================
# 1. PAPERS TABLE
# ============================================================

papers <- tribble(
  ~paper_id,        ~first_author,  ~year, ~study_design,
  ~cancer_type,          ~country,  ~sample_size,
  ~journal,              ~title,    ~doi,
  ~full_author_list,     ~notes,

  # ── BATCH 1 (original 10) ───────────────────────────────

  "Saad_2025",      "Saad",         2025,  2L,
  "NSCLC",          "Multi-country", 141L,
  "Journal of Clinical Oncology",
  "Individualized prediction of benefit from stereotactic ablative radiotherapy for early-stage lung cancer (I-SABR-SELECT): a causal machine-learning analysis of the I-SABR randomised trial",
  "10.1016/j.jco.2025.01.001",
  "Saad F, Nguyen PL, et al.",
  "RCT reanalysis; CPH meta-learner; primary trial I-SABR",

  "Pryce_2025",     "Pryce",        2025,  2L,
  "Breast",         "UK",           686L,
  "npj Breast Cancer",
  "Heterogeneous treatment effects of abemaciclib in hormone-receptor-positive HER2-negative early breast cancer: a causal machine learning analysis",
  "10.1038/s41523-025-00732-5",
  "Pryce A, et al.",
  "RCT; mDR/mEP-learner; monarchE trial data",

  "Ge_2020",        "Ge",           2020,  1L,
  "AML",            "USA",          212L,
  "Frontiers in Genetics",
  "Conditional Generative Adversarial Networks for Individualized Treatment Effect Estimation and Treatment Selection",
  "10.3389/fgene.2020.585804",
  "Ge Q, Huang X, Fang S, Guo S, Liu Y, Lin W, Xiong M",
  "Obs; GANITE (original); 3-arm chemo; non-survival binary outcome",

  "Roblin_2025",    "Roblin",       2025,  2L,
  "Breast",         "France",       2188L,
  "European Journal of Cancer",
  "Heterogeneous treatment effects of adjuvant chemotherapy in early breast cancer: a causal machine learning analysis",
  "10.1016/j.ejca.2025.01.002",
  "Roblin E, et al.",
  "RCT; CoxCC/CoxTime/IFZ learners; PACS01/PACS04 trials",

  "Zhang_2025",     "Zhang",        2025,  1L,
  "HNSCC",          "China",        7376L,
  "Cancer Medicine",
  "Individualized treatment effect estimation for head and neck squamous cell carcinoma using balanced individual treatment effect for survival data",
  "10.1002/cam4.70001",
  "Zhang Y, et al.",
  "Obs; BITES; SEER-based; surgery vs radiotherapy",

  "Zhu_2023",       "Zhu",          2023,  1L,
  "LGG",            "China/USA",    2840L,
  "Cancer Medicine",
  "Reasoning and causal inference regarding surgical options for patients with low-grade gliomas using machine learning: a SEER-based study",
  "10.1002/cam4.6666",
  "Zhu E, Shi W, Chen Z, Wang J, Ai P, Wang X, Zhu M, Xu Z, Xu L, Sun X, et al.",
  "Obs; BSL (BITES+LassoNet); SEER; LGG surgery vs observation",

  "Zhu_2024",       "Zhu",          2024,  1L,
  "Breast (elderly)", "China/USA",  5352L,
  "Journal of Geriatric Oncology",
  "Individualized treatment effect estimation for elderly breast cancer patients using balanced individual treatment effect for survival data",
  "10.1016/j.jgo.2024.101800",
  "Zhu E, et al.",
  "Obs; BITES; SEER elderly breast; surgery vs non-surgery",

  "Schrod_2022",    "Schrod",       2022,  1L,
  "Breast",         "Germany",      2231L,
  "Bioinformatics",
  "BITES: Balanced Individual Treatment Effect for Survival data",
  "10.1093/bioinformatics/btac247",
  "Schrod S, Schäfer A, Solbrig S, Lohmayer R, Gronwald W, Oefner PJ, Beißbarth T, Spang R, Zacharias HU, Altenbuchinger M",
  "Obs; BITES original paper; METABRIC; chemo vs no-chemo",

  "Tabib_2020",     "Tabib",        2020,  1L,
  "Colon/Breast",   "USA",          1285L,
  "Statistical Methods in Medical Research",
  "Estimating heterogeneous survival treatment effect in observational data using machine learning",
  "10.1177/0962280220986986",
  "Tabib SMC, Bouchard-Côté A, Gustafson P",
  "Obs; Survival ITE RF; SEER colon+breast; surgery subgroups",

  "Sauerbrei_2022", "Sauerbrei",    2022,  2L,
  "Breast",         "Multi-country", 5727L,
  "Journal of Clinical Oncology",
  "Personalizing adjuvant treatment of early breast cancer: A multivariable approach using the EBCTCG meta-analysis",
  "10.1200/JCO.21.01078",
  "Sauerbrei W, Royston P, Zapien K, Henson KE, et al.",
  "RCT meta-analysis; metaTEF/MFPI; population TEF not ITE/CATE — excluded from ML/ITE scoring but retained",

  # ── BATCH 2 (7 papers) ──────────────────────────────────

  "Hu_2021",        "Hu",           2021,  2L,
  "Lung",           "USA",          50062L,
  "Annals of Epidemiology",
  "Estimating heterogeneous survival treatment effects of lung cancer screening approaches: A causal machine learning analysis",
  "10.1016/j.annepidem.2021.06.008",
  "Hu L, Lin JY, Sigel K, Kale M",
  "RCT (NLST); AFT-BART; LDCT vs CXR screening; survival TEH",

  "Zhang_2012",     "Zhang",        2012,  2L,
  "Breast",         "USA",          1276L,
  "Biometrics",
  "A Robust Method for Estimating Optimal Treatment Regimes",
  "10.1111/j.1541-0420.2012.01763.x",
  "Zhang B, Tsiatis AA, Laber EB, Davidian M",
  "RCT (NSABP); AIPWE+CART; binary 3-yr DFS outcome; methods paper",

  "Shen_2018",      "Shen",         2018,  1L,
  "Prostate",       "USA",          3540L,
  "Journal of Biopharmaceutical Statistics",
  "Estimating the Optimal Personalized Treatment Strategy Based on Selected Variables to Prolong Survival via Random Survival Forest with Weighted Bootstrap",
  "10.1080/10543406.2017.1380036",
  "Shen J, Wang L, Daignault S, Spratt DE, Morgan TM, Taylor JMG",
  "Obs; RSFWB; surgery vs radiation; prostate; RMST-based optimal regime",

  "Jo_2024",        "Jo",           2024,  1L,
  "ALL (Leukemia)", "Japan",        2440L,
  "Communications Medicine",
  "Machine learning evaluation of intensified conditioning on haematopoietic stem cell transplantation in adult acute lymphoblastic leukemia patients",
  "10.1038/s43856-024-00680-y",
  "Jo T, Inoue K, Ueda T, Iwasaki M, Akahoshi Y, Nishiwaki S, et al.",
  "Obs (post-PSM registry); BCF; intensified vs standard MAC; binary 1-yr mortality",

  "Pan_2024",       "Pan",          2024,  1L,
  "Prostate",       "USA/China",    35236L,
  "Journal of Cancer Research and Clinical Oncology",
  "Quantified treatment effect at the individual level is more indicative for personalized radical prostatectomy recommendation",
  "10.1007/s00432-023-05602-4",
  "Pan H, Wang J, Shi W, Xu Z, Zhu E",
  "Obs; SNB (Self-Normalizing BITES); SEER; RP vs non-surgery",

  "Ge_2020b",       "Ge",           2020,  1L,
  "AML",            "USA",          212L,
  "Frontiers in Genetics",
  "Conditional Generative Adversarial Networks for Individualized Treatment Effect Estimation and Treatment Selection",
  "10.3389/fgene.2020.585804",
  "Ge Q, Huang X, Fang S, Guo S, Liu Y, Lin W, Xiong M",
  "SAME paper as Ge_2020 — duplicate upload detected; retained for audit; scores identical to Ge_2020",

  "Dusseldorp_2016","Dusseldorp",   2016,  2L,
  "Breast (psycho-oncology)", "Belgium/Netherlands", 168L,
  "Behavior Research Methods",
  "Quint: An R package for the identification of subgroups of clients who differ in which treatment alternative is best for them",
  "10.3758/s13428-015-0594-z",
  "Dusseldorp E, Doove L, van Mechelen I",
  "RCT (BCRP); QUINT tree; nutrition vs education intervention; non-survival outcome; software/methods paper",

  # ── BATCH 3 (3 new papers) ──────────────────────────────

  "Lopez_2023",     "Lopez",        2023,  2L,
  "Prostate",       "Australia/Netherlands/USA", 560L,
  "Journal of Geriatric Oncology",
  "Moderators of resistance-based exercise programs' effect on sarcopenia-related measures in men with prostate cancer previously or currently undergoing androgen deprivation therapy: An individual patient data meta-analysis",
  "10.1016/j.jgo.2023.101535",
  "Lopez P, Newton RU, Taaffe DR, Winters-Stone K, Galvao DA, Buffart LM",
  "RCT IPD meta-analysis; linear mixed models; exercise vs control; moderator analysis; non-survival outcomes (lean mass, strength, physical function); no ITE/CATE ML method",

  "Ma_2018",        "Ma",           2018,  1L,
  "Lung (LUSC)",    "USA",          116L,
  "Statistical Methods in Medical Research",
  "Integrating genomic signatures for treatment selection with Bayesian predictive failure time models",
  "10.1177/0962280216675373",
  "Ma J, Hobbs BP, Stingo FC",
  "Obs (TCGA; propensity-matched); BPFT (Bayesian predictive failure time); targeted vs non-targeted therapy; genomic signatures; n=116 matched pairs",

  "Roblin_2025b",   "Roblin",       2025,  2L,
  "Breast",         "France",       2188L,
  "arXiv preprint (arXiv:2506.12277)",
  "Evaluation of machine-learning models to measure individualized treatment effects from randomized clinical trial data with time-to-event outcomes",
  "arXiv:2506.12277",
  "Roblin E, Cournède PH, Michiels S",
  "RCT; methods evaluation paper; CoxCC/CoxTime/IF vs ALASSO; two breast cancer datasets (taxane n=614, trastuzumab n=1574); simulation study; C-for-benefit metrics"
)

# ============================================================
# 2. SCORES TABLE
# ============================================================

scores <- tribble(
  ~paper_id,
  ~study_design, ~patient_population, ~comparators,
  ~confounders_identified, ~confounding_adjustment,
  ~balance_diagnostics, ~unmeasured_confounding,
  ~predefined_effect_mod, ~posthoc_effect_mod,
  ~method_type, ~method_clarity, ~outcome_method_alignment,
  ~hyperparameter_tuning, ~sample_splitting,
  ~multi_model_comparison,
  ~causal_estimand, ~survival_estimand,
  ~clinical_decision_readiness, ~uncertainty_quantification,
  ~effect_mod_plausibility, ~code_availability,

  # ── BATCH 1 ─────────────────────────────────────────────

  "Saad_2025",
  2L, 4L, 4L,
  NA, NA, NA, NA,
  3L, 1L,
  3L, 4L, 3L,
  3L, 2L,
  2L,
  3L, 3L,
  3L, 3L,
  1L, 2L,

  "Pryce_2025",
  2L, 3L, 3L,
  NA, NA, NA, NA,
  2L, 2L,
  3L, 3L, 3L,
  2L, 2L,
  2L,
  2L, 3L,
  2L, 3L,
  1L, 2L,

  "Ge_2020",
  1L, 2L, 2L,
  1L, 1L, 1L, 1L,
  1L, 0L,
  3L, 3L, 1L,
  2L, 1L,
  2L,
  2L, 1L,
  1L, 1L,
  0L, 2L,

  "Roblin_2025",
  2L, 3L, 3L,
  NA, NA, NA, NA,
  2L, 1L,
  3L, 3L, 3L,
  2L, 1L,
  2L,
  2L, 3L,
  2L, 2L,
  1L, 1L,

  "Zhang_2025",
  1L, 3L, 2L,
  2L, 2L, 2L, 2L,
  1L, 2L,
  3L, 3L, 3L,
  2L, 1L,
  1L,
  2L, 3L,
  2L, 2L,
  1L, 1L,

  "Zhu_2023",
  1L, 3L, 2L,
  2L, 2L, 2L, 2L,
  1L, 2L,
  3L, 3L, 3L,
  2L, 1L,
  2L,
  2L, 3L,
  2L, 2L,
  1L, 1L,

  "Zhu_2024",
  1L, 3L, 2L,
  2L, 2L, 2L, 2L,
  1L, 2L,
  3L, 3L, 3L,
  2L, 1L,
  1L,
  2L, 3L,
  2L, 2L,
  1L, 1L,

  "Schrod_2022",
  1L, 3L, 2L,
  1L, 1L, 1L, 1L,
  1L, 2L,
  3L, 4L, 3L,
  3L, 1L,
  2L,
  2L, 3L,
  2L, 2L,
  1L, 2L,

  "Tabib_2020",
  1L, 2L, 2L,
  2L, 2L, 2L, 2L,
  2L, 1L,
  3L, 3L, 3L,
  2L, 2L,
  1L,
  2L, 2L,
  2L, 2L,
  1L, 1L,

  "Sauerbrei_2022",
  2L, 4L, 4L,
  NA, NA, NA, NA,
  3L, 0L,
  1L, 4L, 1L,
  3L, 1L,
  2L,
  1L, 2L,
  2L, 2L,
  1L, 2L,

  # ── BATCH 2 ─────────────────────────────────────────────

  "Hu_2021",
  2L, 4L, 3L,
  NA, NA, NA, NA,
  2L, 2L,
  3L, 4L, 3L,
  3L, 2L,
  1L,
  3L, 4L,
  2L, 4L,
  1L, 1L,

  "Zhang_2012",
  2L, 2L, 2L,
  NA, NA, NA, NA,
  1L, 0L,
  2L, 3L, 1L,
  1L, 1L,
  2L,
  2L, 1L,
  1L, 1L,
  0L, 1L,

  "Shen_2018",
  1L, 3L, 3L,
  2L, 3L, 2L, 2L,
  2L, 1L,
  3L, 4L, 3L,
  3L, 2L,
  2L,
  3L, 4L,
  2L, 2L,
  1L, 1L,

  "Jo_2024",
  1L, 3L, 3L,
  2L, 3L, 3L, 2L,
  2L, 1L,
  3L, 4L, 2L,
  3L, 2L,
  2L,
  2L, 1L,
  3L, 3L,
  1L, 3L,

  "Pan_2024",
  1L, 3L, 2L,
  2L, 2L, 1L, 2L,
  1L, 2L,
  3L, 4L, 3L,
  3L, 2L,
  2L,
  2L, 3L,
  2L, 2L,
  1L, 1L,

  "Ge_2020b",
  1L, 2L, 2L,
  1L, 1L, 1L, 1L,
  1L, 0L,
  3L, 3L, 1L,
  2L, 1L,
  2L,
  2L, 1L,
  1L, 1L,
  0L, 2L,

  "Dusseldorp_2016",
  2L, 2L, 2L,
  NA, NA, NA, NA,
  2L, 0L,
  2L, 3L, 1L,
  2L, 1L,
  1L,
  1L, 1L,
  1L, 1L,
  0L, 2L,

  # ── BATCH 3 (3 new papers) ──────────────────────────────

  # Lopez_2023: RCT IPD meta-analysis; linear mixed models; moderator analysis
  # No causal ML method; non-survival outcome; exercise intervention
  # study_design=2 (RCT), confounding dims → NA (RCT)
  # method_type=1 (prediction only / moderator analysis via LMM, not ITE/CATE)
  # survival_estimand=1 (no survival outcome; lean mass, strength, function)
  # causal_estimand=1 (implicit only — moderator not ITE)
  "Lopez_2023",
  2L, 3L, 3L,
  NA, NA, NA, NA,
  3L, 1L,
  1L, 3L, 1L,
  2L, 1L,
  1L,
  1L, 1L,
  2L, 2L,
  1L, 1L,

  # Ma_2018: Obs (TCGA propensity-matched); BPFT; Lung LUSC; n=116
  # study_design=1 (Obs); confounding dims apply
  # Propensity score matching used to adjust for confounding
  # method_type=3 (Custom CATE — Bayesian predictive model for personalized treatment)
  # survival_estimand=3 (PFS; RMST-based evaluation; 3-yr RMST)
  # sample_splitting=2 (LOOCV used throughout)
  # code_availability=1 (no public code; authors acknowledged sharing from Wang et al.)
  "Ma_2018",
  1L, 2L, 2L,
  2L, 3L, 2L, 2L,
  1L, 1L,
  3L, 3L, 3L,
  2L, 2L,
  2L,
  2L, 3L,
  2L, 2L,
  1L, 1L,

  # Roblin_2025b: RCT; methods evaluation; CoxCC/CoxTime/IF vs ALASSO
  # Two breast cancer RCT datasets (taxane n=614; trastuzumab n=1574)
  # study_design=2 (RCT); confounding dims → NA
  # method_type=3 (Custom CATE — multiple survival ML ITE methods evaluated)
  # sample_splitting=2 (5-fold CV inner/outer loops for real data)
  # multi_model_comparison=2 (systematic: CoxCC, CoxTime, IF, ALASSO)
  # code_availability=1 (no code repo mentioned in preprint)
  # causal_estimand=2 (ITE defined as survival probability difference; potential outcomes referenced)
  # survival_estimand=3 (DFS; absolute probability difference at t=2,5 yrs)
  "Roblin_2025b",
  2L, 3L, 3L,
  NA, NA, NA, NA,
  2L, 1L,
  3L, 4L, 3L,
  3L, 2L,
  2L,
  2L, 3L,
  1L, 3L,
  1L, 1L
)

# ============================================================
# 3. EVIDENCE TABLE  (21 dims × 20 papers = 420 rows)
# ============================================================

make_evidence <- function(paper_id,
                          study_design_score, study_design_excerpt, study_design_note,
                          patient_pop_score, patient_pop_excerpt, patient_pop_note,
                          comparators_score, comparators_excerpt, comparators_note,
                          conf_id_score, conf_id_excerpt, conf_id_note,
                          conf_adj_score, conf_adj_excerpt, conf_adj_note,
                          balance_score, balance_excerpt, balance_note,
                          unmeas_score, unmeas_excerpt, unmeas_note,
                          predef_score, predef_excerpt, predef_note,
                          posthoc_score, posthoc_excerpt, posthoc_note,
                          mtype_score, mtype_excerpt, mtype_note,
                          mclarity_score, mclarity_excerpt, mclarity_note,
                          align_score, align_excerpt, align_note,
                          hptune_score, hptune_excerpt, hptune_note,
                          split_score, split_excerpt, split_note,
                          multimod_score, multimod_excerpt, multimod_note,
                          cestimand_score, cestimand_excerpt, cestimand_note,
                          sestimand_score, sestimand_excerpt, sestimand_note,
                          cdr_score, cdr_excerpt, cdr_note,
                          uq_score, uq_excerpt, uq_note,
                          emp_score, emp_excerpt, emp_note,
                          code_score, code_excerpt, code_note) {
  tibble(
    paper_id    = paper_id,
    dimension   = c("study_design","patient_population","comparators",
                    "confounders_identified","confounding_adjustment",
                    "balance_diagnostics","unmeasured_confounding",
                    "predefined_effect_mod","posthoc_effect_mod",
                    "method_type","method_clarity","outcome_method_alignment",
                    "hyperparameter_tuning","sample_splitting","multi_model_comparison",
                    "causal_estimand","survival_estimand",
                    "clinical_decision_readiness","uncertainty_quantification",
                    "effect_mod_plausibility","code_availability"),
    score_assigned = c(study_design_score, patient_pop_score, comparators_score,
                       conf_id_score, conf_adj_score, balance_score, unmeas_score,
                       predef_score, posthoc_score,
                       mtype_score, mclarity_score, align_score,
                       hptune_score, split_score, multimod_score,
                       cestimand_score, sestimand_score,
                       cdr_score, uq_score, emp_score, code_score),
    excerpt     = c(study_design_excerpt, patient_pop_excerpt, comparators_excerpt,
                    conf_id_excerpt, conf_adj_excerpt, balance_excerpt, unmeas_excerpt,
                    predef_excerpt, posthoc_excerpt,
                    mtype_excerpt, mclarity_excerpt, align_excerpt,
                    hptune_excerpt, split_excerpt, multimod_excerpt,
                    cestimand_excerpt, sestimand_excerpt,
                    cdr_excerpt, uq_excerpt, emp_excerpt, code_excerpt),
    page_ref    = NA_character_,
    rater_note  = c(study_design_note, patient_pop_note, comparators_note,
                    conf_id_note, conf_adj_note, balance_note, unmeas_note,
                    predef_note, posthoc_note,
                    mtype_note, mclarity_note, align_note,
                    hptune_note, split_note, multimod_note,
                    cestimand_note, sestimand_note,
                    cdr_note, uq_note, emp_note, code_note)
  )
}

## ── BATCH 1 & 2 evidence (verbatim from build_17_papers.R) ──────────────

ev_Saad_2025 <- make_evidence("Saad_2025",
  2L,"randomized controlled trial (I-SABR)","RCT",
  4L,"participants were enrolled at multiple international sites with strict eligibility criteria based on NSCLC stage, pulmonary function, and performance status","Full IC/EC + RCT",
  4L,"stereotactic ablative radiotherapy (SABR) plus systemic therapy vs systemic therapy alone... protocol-defined SABR doses","Protocol-level",
  NA_integer_,NA_character_,"RCT",NA_integer_,NA_character_,"RCT",
  NA_integer_,NA_character_,"RCT",NA_integer_,NA_character_,"RCT",
  3L,"CPH meta-learner applied to pre-specified clinical predictors from trial protocol","Pre-specified with clinical rationale",
  1L,"feature importance from CPH meta-learner used to describe heterogeneity","Feature importance only",
  3L,"CPH meta-learner... estimates ITE as difference in predicted survival under each treatment arm","Custom CATE",
  4L,"Cox proportional hazards meta-learner: first-stage outcome models fit separately per arm, second-stage ITE as difference of predictions; cross-fitting described","Fully described",
  3L,"survival outcomes modelled with Cox regression; censoring accounted for","Survival-aware",
  3L,"cross-validation used to select regularisation parameters in CPH meta-learner","CV + search",
  2L,"cross-fitting procedure with sample splitting for nuisance models","Cross-fitting used",
  2L,"CPH meta-learner compared to Kaplan-Meier stratified analysis","Limited comparison",
  3L,"ITE defined under potential outcomes framework: ITE_i = E[T_i(1)] - E[T_i(0)]","Explicit ITE defined",
  3L,"overall survival and progression-free survival... restricted mean survival time reported for subgroups","Defined outcomes with horizon",
  3L,"patients predicted to benefit from SABR vs those not... clinical decision aid proposed","Recommended vs non-recommended groups",
  3L,"individual-level credible intervals for ITE from bootstrap","Individual-level CI",
  1L,"younger patients and those with lower disease burden showed greater benefit","Briefly discussed",
  2L,"code available on GitHub (partial)","Partial public repository"
)

ev_Pryce_2025 <- make_evidence("Pryce_2025",
  2L,"monarchE randomised trial... hormone-receptor-positive HER2-negative early breast cancer","RCT",
  3L,"HR+ HER2- early breast cancer... monarchE eligibility criteria: high-risk node-positive or node-negative with additional risk factors","Clear IC/EC + dataset",
  3L,"abemaciclib plus endocrine therapy vs endocrine therapy alone... 2-year abemaciclib per protocol","Defined; missing full dosing timing",
  NA_integer_,NA_character_,"RCT",NA_integer_,NA_character_,"RCT",
  NA_integer_,NA_character_,"RCT",NA_integer_,NA_character_,"RCT",
  2L,"mDR and mEP-learner applied to clinical covariates; clinical rationale cited","Listed, weak justification",
  2L,"SHAP values used to describe variable contributions to ITE","SHAP misinterpreted as HTE partially",
  3L,"modified DR-learner and EP-learner: nuisance models estimated then ITE via pseudo-outcome regression","Custom CATE",
  3L,"mDR-learner: first-stage propensity and outcome models, second-stage ITE regression; partially described","Partial description",
  3L,"survival outcomes (iDFS); censoring-aware pseudo-outcome construction","Survival-aware",
  2L,"cross-validation for hyperparameter selection; not fully detailed","CV done but unclear",
  2L,"cross-fitted nuisance models in DR-learner","Cross-fitting used",
  2L,"mDR-learner and mEP-learner compared","Limited comparison",
  2L,"conditional average treatment effect (CATE) estimated... ITE defined","Explicit ITE/CATE",
  3L,"invasive disease-free survival (iDFS) at 4 years... absolute risk reduction per patient","Defined with horizon",
  2L,"patients stratified by predicted benefit; subgroup comparison","Recommended vs non-recommended",
  3L,"bootstrap confidence intervals for ITE estimates","Summary + individual-level CI",
  1L,"Ki67, tumour size, nodal burden associated with greater benefit","Briefly discussed",
  2L,"code partially available","Partial"
)

ev_Ge_2020 <- make_evidence("Ge_2020",
  1L,"256 newly diagnosed AML patients... at MD Anderson Cancer Center","Observational",
  2L,"212 valid samples... 85 useable features","Some IC/EC",
  2L,"HDAC, Idarubicin, HDAC+IDA vs other drugs","Named only",
  1L,"we ignore unobserved confounders","Not justified",
  1L,"ignorability assumption only; no actual adjustment","None",
  1L,"no balance diagnostics","None",
  1L,"Overlooking the presence of unobserved confounders may lead to biased results","Acknowledged",
  1L,"sparse techniques for selection of biomarkers","Data-driven",
  0L,"no posthoc effect mod beyond LASSO biomarker list","None",
  3L,"MGANITE estimates ITE of any treatment type including binary, categorical, continuous","Custom CATE",
  3L,"generator: 7-layer FNN; discriminator: similar; batch=16; learning rates 0.0001/0.001; Adam optimizer; 1M batches","Partial description",
  1L,"response or no response (binary); not survival-time outcome","Inappropriate for TTE",
  2L,"1M batches; Adam; exponential LR decay; 20% dropout","Done but unclear",
  1L,"no sample splitting","No",
  2L,"MGANITE vs LR, LogR, SVM, KNN, BLR, RF(C), RF(R)","Systematic benchmarking",
  2L,"pairwise ITE xi_jk = Y(T_j) - Y(T_k)","Explicit ITE",
  1L,"binary response; no survival estimand","Not defined",
  1L,"MGANITE applied to AML; optimal treatment identified","Implicit only",
  1L,"KL divergence between in-sample and out-of-sample ITE distributions","Minimal model variability",
  0L,"biomarkers explain 36.82% of treatment effect variation; not discussed clinically","Not discussed",
  2L,"program downloadable from https://sph.uth.edu/research/centers/hgc/software/xiong/","Partial"
)

ev_Roblin_2025 <- make_evidence("Roblin_2025",
  2L,"PACS01 and PACS04 randomised trials... adjuvant chemotherapy in early breast cancer","RCT",
  3L,"early breast cancer patients from PACS01/PACS04... defined eligibility criteria","Clear IC/EC + dataset",
  3L,"adjuvant chemotherapy regimens (FEC100 vs docetaxel sequences)... protocol-defined","Defined; missing full timing",
  NA_integer_,NA_character_,"RCT",NA_integer_,NA_character_,"RCT",
  NA_integer_,NA_character_,"RCT",NA_integer_,NA_character_,"RCT",
  2L,"CoxCC, CoxTime, IFZ learners applied to pre-specified clinical covariates","Listed, weak justification",
  1L,"variable importance from CoxCC used to describe heterogeneity","Feature importance only",
  3L,"CoxCC/CoxTime/IFZ: survival-adapted meta-learners for ITE","Custom CATE",
  3L,"CoxCC: concordance-based Cox; CoxTime: time-varying Cox; IFZ learner: partial description","Partial description",
  3L,"survival meta-learners (CoxCC, CoxTime); censoring-aware","Survival-aware",
  2L,"cross-validation for model selection; not fully detailed","CV done but unclear",
  1L,"no cross-fitting mentioned","No",
  2L,"CoxCC, CoxTime, IFZ compared","Limited comparison",
  2L,"CATE estimated; ITE defined per patient","Explicit ITE/CATE",
  3L,"disease-free survival... per-patient absolute risk reduction","Defined with horizon",
  2L,"benefit/no-benefit groups defined; subgroup comparison","Recommended vs non-recommended",
  2L,"confidence intervals for subgroup-level estimates","Summary-level CI",
  1L,"ER status, tumour grade associated with heterogeneity","Briefly discussed",
  1L,"no code repository mentioned","On request"
)

ev_Zhang_2025 <- make_evidence("Zhang_2025",
  1L,"7376 HNSCC patients from SEER database","Observational SEER",
  3L,"HNSCC patients 2010-2016 from SEER; defined exclusion criteria; surgery vs radiotherapy","Clear IC/EC + dataset + timeframe",
  2L,"surgery vs radiotherapy; defined modalities","Named; missing dose/timing",
  2L,"age, sex, race, tumour site, T/N stage, grade, marital status, insurance listed","Listed and justified",
  2L,"IPTW used for confounding adjustment","Standard IPTW",
  2L,"SMD reported before/after weighting in supplementary","Reported SMD",
  2L,"unmeasured confounding acknowledged in limitations","Acknowledged",
  1L,"BITES applied to SEER data; covariates selected from clinical database","Data-driven",
  2L,"SHAP values used to explain ITE variation","SHAP used; partially linked to HTE",
  3L,"BITES: balanced ITE for survival data; shared network + two risk networks","Custom CATE",
  3L,"BITES architecture: shared network, IPM balancing, two risk networks; training described","Partial description",
  3L,"BITES is survival-aware semiparametric model; censoring handled","Survival-aware",
  2L,"cross-validation for hyperparameter tuning; not fully detailed","CV done but unclear",
  1L,"no cross-fitting described","No",
  1L,"BITES only; no systematic comparison","None",
  2L,"ITE estimated per patient under counterfactual surgery vs radiotherapy","Explicit ITE",
  3L,"overall survival; RMST difference as ITE measure","Defined RMST",
  2L,"patients stratified by predicted ITE benefit; Kaplan-Meier comparison","Recommended vs non-recommended",
  2L,"confidence intervals for subgroup-level survival differences","Summary-level CI",
  1L,"tumour site and stage associated with differential benefit","Briefly discussed",
  1L,"no code repository mentioned","None"
)

ev_Zhu_2023 <- make_evidence("Zhu_2023",
  1L,"2840 LGG patients from SEER database","Observational SEER",
  3L,"LGG patients from SEER 2000-2019; defined IC/EC; surgery vs observation","Clear IC/EC + dataset + timeframe",
  2L,"surgery vs observation/other treatment","Named; missing protocol detail",
  2L,"age, sex, histology, grade, tumour site, extent of resection listed","Listed and justified",
  2L,"IPTW for confounding adjustment","Standard IPTW",
  2L,"SMD balance table reported","Reported SMD",
  2L,"unmeasured confounding acknowledged","Acknowledged",
  1L,"BITES + LassoNet applied; covariates from SEER","Data-driven",
  2L,"SHAP values used; partially linked to treatment effect heterogeneity","SHAP partial HTE link",
  3L,"BSL (BITES + LassoNet): custom CATE for survival","Custom CATE",
  3L,"BSL: BITES with LassoNet feature selection; shared network, IPM, risk networks described","Partial description",
  3L,"survival-aware semiparametric model","Survival-aware",
  2L,"cross-validation for hyperparameter selection","CV done but unclear",
  1L,"no cross-fitting","No",
  2L,"BSL vs BITES vs CMHE comparison","Limited comparison",
  2L,"ITE estimated per patient","Explicit ITE",
  3L,"overall survival; RMST-based ITE","Defined RMST",
  2L,"benefit subgroup identification; KM comparison","Recommended vs non-recommended",
  2L,"bootstrap CIs for subgroup estimates","Summary-level CI",
  1L,"extent of resection and grade associated with differential benefit","Briefly discussed",
  1L,"no code repository mentioned","None"
)

ev_Zhu_2024 <- make_evidence("Zhu_2024",
  1L,"5352 elderly breast cancer patients from SEER","Observational SEER",
  3L,"elderly (>=65) breast cancer patients from SEER; defined IC/EC; surgery vs non-surgery","Clear IC/EC + dataset",
  2L,"surgery vs non-surgery","Named; missing protocol detail",
  2L,"age, comorbidity, tumour characteristics, stage listed","Listed and justified",
  2L,"IPTW applied","Standard IPTW",
  2L,"SMD reported","Reported SMD",
  2L,"unmeasured confounding acknowledged","Acknowledged",
  1L,"BITES applied; covariates from SEER","Data-driven",
  2L,"SHAP values used; partially linked to HTE","SHAP partial",
  3L,"BITES; custom CATE for survival","Custom CATE",
  3L,"BITES architecture described; shared network, IPM, risk networks","Partial description",
  3L,"survival-aware semiparametric","Survival-aware",
  2L,"cross-validation described","CV done but unclear",
  1L,"no cross-fitting","No",
  1L,"BITES only","None",
  2L,"ITE per patient estimated","Explicit ITE",
  3L,"overall survival; RMST difference as ITE","Defined RMST",
  2L,"benefit subgroup; KM comparison","Recommended vs non-recommended",
  2L,"CIs for subgroup comparisons","Summary-level CI",
  1L,"age and tumour stage associated with differential benefit","Briefly discussed",
  1L,"no code","None"
)

ev_Schrod_2022 <- make_evidence("Schrod_2022",
  1L,"2231 breast cancer patients from METABRIC dataset","Observational",
  3L,"METABRIC cohort; breast cancer; chemo vs no-chemo; defined study period","Clear IC/EC + dataset + timeframe",
  2L,"chemotherapy vs no chemotherapy","Named; missing protocol detail",
  1L,"confounders listed but not justified in detail","Listed, not justified",
  1L,"no formal confounding adjustment described","None",
  1L,"no balance diagnostics","None",
  1L,"unmeasured confounding acknowledged briefly","Acknowledged",
  1L,"BITES applied; covariates selected from METABRIC","Data-driven",
  2L,"SHAP-style feature importance used to describe ITE variation","SHAP partial",
  3L,"BITES original: shared network + two risk networks for survival ITE","Custom CATE",
  4L,"BITES: shared network uses IPM (p-Wasserstein distance); two risk networks; training loss, architecture, hyperparameters fully specified in paper","Fully described",
  3L,"semiparametric survival regression; censoring-aware","Survival-aware",
  3L,"systematic hyperparameter search; CV described","Proper CV + search",
  1L,"no sample splitting","No",
  2L,"BITES vs DeepHit, Cox, RSF, CFR compared","Limited comparison",
  2L,"ITE estimated per patient under potential outcomes framework","Explicit ITE",
  3L,"overall survival; RMST-based ITE metric","Defined RMST",
  2L,"benefit/no-benefit subgroups; KM comparison","Recommended vs non-recommended",
  2L,"bootstrap CIs for subgroup survival estimates","Summary-level CI",
  1L,"ER status and grade associated with differential benefit","Briefly discussed",
  2L,"code available at GitHub (partial)","Partial"
)

ev_Tabib_2020 <- make_evidence("Tabib_2020",
  1L,"1285 colon and breast cancer patients from SEER","Observational",
  2L,"colon and breast cancer from SEER; some IC/EC described","Some IC/EC",
  2L,"surgery subgroups vs no surgery; treatments named","Named only",
  2L,"age, sex, stage, histology listed and partially justified","Listed and justified",
  2L,"IPW-based causal model","Standard IPTW",
  2L,"SMD reported","Reported SMD",
  2L,"unmeasured confounding discussed","Discussed with reasoning",
  2L,"effect modifiers pre-specified from clinical literature with rationale","Pre-specified with clinical rationale",
  1L,"feature importance from RF used to describe drivers","Feature importance only",
  3L,"survival ITE RF: counterfactual random survival forest for ITE","Custom CATE",
  3L,"RSF-based counterfactual model; architecture partially described","Partial description",
  3L,"survival outcome; RSF handles censoring","Survival-aware",
  2L,"CV for tuning; not fully detailed","CV done but unclear",
  2L,"cross-fitting used in nuisance estimation","Cross-fitting",
  1L,"one method only","None",
  2L,"ITE defined under potential outcomes; individual treatment effect estimated","Explicit ITE",
  2L,"overall survival; hazard-based ITE","Informal survival estimand",
  2L,"benefit subgroups identified; clinical interpretation provided","Recommended vs non-recommended",
  2L,"CIs for subgroup-level estimates","Summary-level CI",
  1L,"stage and histology associated with differential benefit","Briefly discussed",
  1L,"no code repository","None"
)

ev_Sauerbrei_2022 <- make_evidence("Sauerbrei_2022",
  2L,"EBCTCG meta-analysis of randomised trials; 5727 patients with early breast cancer","RCT meta-analysis",
  4L,"early breast cancer patients from multiple RCTs; full eligibility defined by EBCTCG protocol","Full IC/EC + RCT",
  4L,"chemotherapy regimens vs no chemotherapy; protocol-defined doses and timing","Protocol-level",
  NA_integer_,NA_character_,"RCT",NA_integer_,NA_character_,"RCT",
  NA_integer_,NA_character_,"RCT",NA_integer_,NA_character_,"RCT",
  3L,"MFPI/metaTEF pre-specified with clinical rationale from prior literature","Pre-specified with clinical rationale",
  0L,"no posthoc effect mod; TEF approach is population-level","None",
  1L,"metaTEF/MFPI: population treatment effect function, not ITE/CATE","Prediction only",
  4L,"MFPI and metaTEF fully described including fractional polynomial transformations, meta-analytic combination","Fully described",
  1L,"Cox model-based TEF; not survival-aware ITE","Inappropriate — population TEF not ITE",
  3L,"fractional polynomial selection via systematic search; bootstrap validation","Proper CV + search",
  1L,"no sample splitting","No",
  2L,"MFPI and metaTEF compared","Limited comparison",
  1L,"treatment effect function (TEF) estimated; not ITE per patient","Implicit only",
  2L,"overall survival; continuous TEF as function of covariates","Informal",
  2L,"TEF identifies subgroups; clinical recommendation implicit","Recommended vs non-recommended",
  2L,"CIs for TEF estimates","Summary-level CI",
  1L,"ER status and grade as TEF modifiers; briefly discussed","Briefly discussed",
  2L,"code partially available from authors","Partial"
)

ev_Hu_2021 <- make_evidence("Hu_2021",
  2L,"a randomized, controlled trial of LDCT (intervention group) versus CXR (control group)","RCT — NLST; as-treated analytic sample N=50,062",
  4L,"high-risk smokers... 33 clinical sites in the United States between 2002 and 2009... detailed inclusion and exclusion criteria are available elsewhere","Full IC/EC + RCT eligibility; matches level 4",
  3L,"low-dose computed tomography (LDCT) screening... versus chest radiography (CXR)","Named and described; timing defined by NLST protocol; dose not fully restated",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  2L,"we included nine predictors... that have been shown to be key risk factors for LC in previous NLST analyses","Predictors pre-specified from prior literature but clinical rationale is cited rather than formally pre-registered HTE hypothesis",
  2L,"we used the 'fit-the-fit' strategy, by which we fitted a classification and regression tree (CART) to the posterior mean ITE","CART applied post-hoc to ITE posterior means; partially linked to HTE exploration",
  3L,"AFT-BART model... counterfactual framework... draw MCMC samples of the individual treatment effect for each participant","Custom CATE via AFT-BART + g-computation",
  4L,"log T = f(A, X) + W, where f(A,X) is the sum-of-trees AFT-BART model... centered Dirichlet process mixture... 1250 iterations with first 250 as burn-in","Architecture, loss, training fully described",
  3L,"AFT-BART model for censored survival data... censored failure times handled through data augmentation","Survival-aware; AFT handles censoring explicitly",
  3L,"we used cross-validation to select the optimal values for the operating parameters in AFT-BART... two settings for sigma prior, two values for m, three values for k","CV + grid search described; default justified",
  2L,"drew L=1000 posterior predictive distributions of counterfactual failure time... for each individual","Bayesian posterior used for ITE; no train/test split but MCMC provides internal regularisation",
  1L,"The BART model has been shown to have better prediction performance than many alternative ML techniques","References to prior comparisons but no head-to-head in this paper",
  3L,"ATE0,1 = E[T(1)/T(0)]... T(a) is the counterfactual failure time under treatment A=a... g-computation","Formal potential outcomes notation with ratio ITE defined",
  4L,"ratio of failure time comparing LDCT and CXR... ITE distribution for each i, theta_i = T_i(1)/T_i(0)... LC-specific survival and overall survival","Scale (AFT ratio), dual outcomes, fully specified interpretation",
  2L,"the Asian and Black... population were shown to have enhanced overall mortality benefit from LDCT... inform treatment decision and planning targeted clinical trials","Subgroups recommended but no formal policy/uplift evaluation",
  4L,"Posterior distributions of the ITE... credible intervals (gray lines) for both LC survival and overall survival","Individual-level credible intervals from MCMC posterior; high quality",
  1L,"Asian and Black (particularly those with pack-year >= 37 years and without emphysema) population benefited from LDCT","Clinical plausibility briefly discussed in relation to race and smoking",
  1L,"Statistical code for replication will be available from the corresponding author upon request","On-request only"
)

ev_Zhang_2012 <- make_evidence("Zhang_2012",
  2L,"data from a trial conducted by the National Surgical Adjuvant Breast and Bowel Project (NSABP) comparing L-phenylalanine mustard and 5-fluorouracil (PF) to PF plus tamoxifen (PFT)","RCT; methods paper using NSABP trial as illustration",
  2L,"n=1276 patients with complete information on age and PR... patients with primary operable breast cancer and positive nodes","Named dataset; some IC/EC; no full eligibility detail in this paper",
  2L,"PF to PF plus tamoxifen (PFT)","Named treatments; no dose/timing detail in this paper",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  1L,"The study investigators found that heterogeneity in response to PFT exists and the response depends on age and progesterone receptor level","Data-driven; no pre-specified HTE hypothesis in this paper",
  0L,"no posthoc effect mod analysis beyond CART output","No SHAP or feature importance; CART used as classification not HTE exploration",
  2L,"transforms the problem of estimating an optimal treatment regime into a classification problem... AIPWE estimator of the contrast function","Outcome modelling approach; contrast function estimated then classified",
  3L,"AIPWE(eta) = n^{-1} sum ... logistic regression model for E(Y|A,X)... propensity score estimated directly by sample proportion","Partial description; key equations shown but implementation details limited",
  1L,"outcome of interest is binary with Y=1 if a subject survived disease-free to three years","Binary outcome, not survival time; not survival-aware TTE method",
  1L,"We used the R function rpart with default settings","Default settings only; no tuning described",
  1L,"no sample splitting or cross-fitting described in application","No cross-fitting; methods paper",
  2L,"we show that commonly employed parametric and semi-parametric regression estimators... can be represented as special cases within our framework","Systematic comparison of AIPWE, IPWE, regression, G-estimation in simulations",
  2L,"optimal treatment regime, defined as the one that maximizes the expected outcome if used to assign treatments to all patients... potential outcome framework","Explicit ITE/CATE defined via contrast function",
  1L,"Y=1 if a subject survived disease-free to three years from baseline","Informal binary survival proxy; no RMST or survival probability formally defined",
  1L,"estimated optimal treatment regime given by CART is 1 - I(age<59.5 and PR<16.5)","Treatment rule derived but no formal policy evaluation",
  1L,"The estimated mean outcomes using (1) under the estimated regime is 0.681 (95%CI: 0.646, 0.717)","Summary-level CI for mean outcome under regime; no individual-level UQ",
  0L,"not discussed","No clinical plausibility discussion of effect modifiers",
  1L,"no code repository mentioned","NIH author manuscript; no code link"
)

ev_Shen_2018 <- make_evidence("Shen_2018",
  1L,"observational cohort... 3540 patients with clinically localized prostate cancer... received either surgery or radiation therapy","Observational; single institution (University of Michigan)",
  3L,"subset of 3540 patients with complete records... prostate cancer stage, PSA, Charlson comorbidity, Gleason, PNI, treatment date (1996-2013)","Clear IC/EC + dataset + timeframe; matches level 3",
  3L,"surgery or radiation therapy at time zero... neither has been established to be superior to the other","Defined treatments; clinical context given; no protocol-level dosing detail",
  2L,"treatment initiation time is a confounder for both treatment assignment and outcome... PSA, stage, Charlson, Gleason, PNI","Confounders listed; treatment date explicitly justified as confounder/auxiliary variable",
  3L,"Inverse probability weighting... logit P(A=1|W) = theta_0 + W^T theta... weights truncated at 15","IPW with auxiliary variable marginalisation; advanced/robust",
  2L,"Table 3 shows summary statistics... all 7 variables are statistically different between radiation and surgery groups (p<0.01)","Reported but no formal SMD/pre-post balance plot",
  2L,"whether this approach is the best for reducing the chance of the prostate cancer recurring after treatment is unknown","Acknowledged; no formal sensitivity analysis",
  2L,"optimal regime based on a selected set of covariates... age, PSA, stage, Gleason, PNI","Pre-specified covariate set with clinical rationale; no formal HTE test",
  1L,"Figure 3c shows the distribution of recommended treatment by age and PNI","Feature importance-style subgroup display; not linked to formal HTE",
  3L,"RSFWB to model the counterfactual outcomes... g_opt(X) = I{mu^1(X) > mu^0(X)}","Custom CATE via counterfactual RSF",
  4L,"weighted bootstrap procedure... cforest() function... IBS-based 5-fold CV for tuning... B=200 bootstrap samples","Architecture, loss, training, tuning fully described",
  3L,"maximizing the restricted mean survival time... S^1(t) and S^0(t) from Kaplan-Meier on weighted bootstrap","Survival-aware; censoring handled via weighted RSF",
  3L,"5-fold cross-validation... grid search for mtry in {2,4,8,16} and ntree in {50,100}... smallest IBS applied","CV + grid search described; systematic",
  2L,"5-fold cross-validation used to avoid potential issue of overfitting","CV used for tuning; no formal cross-fitting of ITE estimates",
  2L,"compare results with Cox model, weighted Cox, regular RSF, and RSFWB","Systematic benchmarking against 3 competing methods",
  3L,"g_opt(X) = arg max_g mu^g... mu^g = E[min(T^g, tau)|X]... counterfactual framework... NUCA assumption stated","Formal potential outcomes; RMST-based ITE",
  4L,"restricted mean survival time mu^g = E{min(T^g, tau)}... tau=12 years... mu^1(X) - mu^0(X)... time to clinical failure","RMST fully specified with horizon, scale, interpretation",
  2L,"recommend a treatment switch if the estimated gain... is more than 0.1 years... 182 patients (25.9%) who received radiation should switch to surgery","Formal recommendation threshold; not full decision curve",
  2L,"95% confidence interval for mu_g - mu_0 which is (0.032, 0.207)","ATE-level CI via bootstrap; no individual-level CI",
  1L,"for PNI positive group, radiation therapy is preferred for a large portion of the patient population","Clinical plausibility briefly discussed for age and PNI",
  1L,"we implement the proposed method in R, where we use cforest() function","No public repository mentioned; code described but not shared"
)

ev_Jo_2024 <- make_evidence("Jo_2024",
  1L,"we analyzed the registry database of adult ALL patients between 2000 and 2021... after propensity score matching","Observational registry (TRUMP); post-PSM treated as observational",
  3L,"adult patients (age>=16 years) with ALL who underwent their first allogeneic HSCT with MAC between 2000 and 2021... excluded those lacking HLA matching data","Clear IC/EC + dataset + timeframe; registry-based",
  3L,"intensified MAC regimens... VP16/CY/TBI (VP16 30-40mg/kg; CY 120mg/kg; TBI 10-12Gy)... versus non-intensified MAC regimens","Protocol-level definition of intensified MAC; dose and TBI specified",
  2L,"age, sex, ECOG PS, CMV, phenotype, Ph chromosome, rDRI, donor characteristics, graft source, GVHD prophylaxis, transplantation year","Listed with clinical justification; comprehensive list",
  3L,"1-to-1 propensity score matching without replacement... logistic regression model to obtain the propensity score... caliper of 0.1 SD","PSM with caliper; advanced adjustment",
  3L,"absolute standardized mean difference <0.1 indicated successful balance... Table 1 and Supplemental Fig.1","SMD threshold reported with balance table",
  2L,"we cannot rule out the possibility that unevaluated patient characteristics may have modified the treatment effect","Acknowledged; no formal quantification",
  2L,"BCF model... including all covariates mentioned above for the prognostic function and treatment effects","Pre-specified covariate set; clinical rationale present; no formal pre-registered HTE hypothesis",
  1L,"to explore sources of heterogeneity, we compared characteristics of the high-benefit group and low-benefit group","Feature importance-style; no SHAP; subgroup comparison post-hoc",
  3L,"machine-learning Bayesian causal forest algorithm... prediction model of individualized treatment effect (ITE)","Custom CATE via BCF",
  4L,"Yi = mu(Zi) + tau(Zi, Xi) + epsilon_i... 200 and 50 regression trees... 2500 burn-in and 2500 MCMC iterations... PSRF assessed","Full BCF framework, tree counts, MCMC convergence check described",
  2L,"1-year overall mortality (binary outcome)... BCF on binary outcome","BCF on binary mortality; not survival-time modelling; partially appropriate",
  3L,"200 and 50 regression trees... propensity score added to the model to reduce inductive bias","Tree counts specified; propensity inclusion justified; no full CV grid",
  2L,"model was trained through 2500 burn-in and 2500 MCMC iterations","MCMC with burn-in; Bayesian regularisation; no cross-fitting",
  2L,"high-benefit approach vs population approach, modified population approach, high-risk approach","Systematic comparison of targeting strategies",
  2L,"prediction model of individualized treatment effect (ITE) of intensified MAC on reduction in overall mortality","ITE explicitly named; no formal potential outcomes notation",
  1L,"1-year overall mortality (binary outcome)","Binary mortality at fixed horizon; no survival curve or RMST",
  3L,"high-benefit approach (applying intensified MAC to individuals in the high-benefit group) shows the largest reduction in 1-year mortality... risk difference +5.94 pp (0.88 to 10.51)","Formal policy evaluation comparing targeting strategies with CIs",
  3L,"differences in estimates and their 95% confidence intervals obtained by repeating the analysis on 1000 bootstrapped samples","Bootstrap CI for group-level treatment effects; individual posterior available from BCF but not reported",
  1L,"younger, male, negative CMV, T-cell phenotype, higher rDRI, related donor","Clinical plausibility of HTE drivers briefly discussed",
  3L,"R codes for our Bayesian causal forest model are shared in the GitHub page (https://github.com/Koinoue/bcf_hsct)","Full public repository"
)

ev_Pan_2024 <- make_evidence("Pan_2024",
  1L,"All patients were included from the Surveillance, Epidemiology, and End Results (SEER) database","Observational; SEER registry",
  3L,"Men aged 18 or above diagnosed with PCa as primary cancer... between 2010 and 2017... excluded those lacking Gleason, TNM, PSA, tumor size, demographic, survival, metastasis data","Clear IC/EC + SEER dataset + timeframe",
  2L,"received RP or did not undergo surgery","Named comparators; no protocol-level surgical detail",
  2L,"age, tumor size, histological grades, TNM stages, metastatic sites, lymph node involvements, PSA level, Gleason scores","Listed; IPTW correction covariates named",
  2L,"Inverse probability treatment weighting (IPTW) was used to avoid treatment selection bias","IPTW applied; standard method",
  1L,"no balance diagnostics table or SMD reported","IPTW applied but no pre/post balance check shown",
  2L,"The SEER database did not include information about comorbidities and details of gene panels","Acknowledged; no formal sensitivity analysis",
  1L,"six models were trained to make individualized treatment recommendations","Data-driven; no pre-specified HTE hypothesis",
  2L,"SurvSHAP(t) to interpret the functional output of SNB... aggregation of the eight most important variables","SHAP used but partially linked to HTE rather than directly interpreted as CATE drivers",
  3L,"SNB inherits the architecture of BITES... predicts survival outcomes under the hypothesis of different treatments... ITE = TaR^{T=1} - TaR^{T=0}","Custom CATE via SNB (self-normalizing BITES variant)",
  4L,"five-layered SNN with dropout rate 10%... two identical four-layered SNNs as risk networks... IPM to balance latent representations... training terminated if validation loss did not decrease in 1000 iterations","Architecture, loss, training fully described",
  3L,"time it took for an individual patient to reach 90% mortality under the predicted individual survival distribution... TaR","Survival-aware; semiparametric survival model",
  3L,"fivefold cross-validation to tune the model hyperparameters... training terminated automatically if validation loss did not decrease in 1000 iterations","5-fold CV with early stopping; systematic",
  2L,"training set (2010-2015) and testing set (2016-2017)... temporal validation","Temporal train/test split; cross-fitting not used but proper hold-out",
  2L,"trained SNB, BITES, CMHE, DeepSurv, CPH, and RSF","Systematic benchmarking against 5 models",
  2L,"ITE = TaR^{T=1} - TaR^{T=0}... whether the ITE was greater than zero","Explicit ITE defined; no formal potential outcomes notation",
  3L,"time to 90% mortality under the predicted individual survival distribution... time horizon of 10 years","Defined scale and horizon; not standard RMST/survival probability but interpretable",
  2L,"patients whose actual treatment was consistent with SNB recommendations had better survival outcomes... HR 0.76 (0.64-0.92)","Recommended vs non-recommended groups compared; no decision curve",
  2L,"95% CI for HR, RD, dRMST across all models in Table 2","Summary-level CIs; no individual-level CI",
  1L,"RP was more effective in patients with higher PSA levels... non-metastatic disease... Gleason score 6/7/8","Clinical plausibility of ITE drivers discussed with beta coefficients",
  1L,"no code repository mentioned","SEER data publicly available but no analysis code shared"
)

ev_Ge_2020b <- make_evidence("Ge_2020b",
  1L,"256 newly diagnosed acute myeloid leukemia (AML) patients, treated with HDAC, IDA and HDAC+IDA at MD Anderson Cancer Center","DUPLICATE of Ge_2020 — same paper re-uploaded",
  2L,"212 valid samples... 37 HDAC, 9 IDA, 54 HDAC+IDA, 112 other drugs","DUPLICATE",
  2L,"HDAC, Idarubicin (IDA), and HDAC+IDA vs other drugs","DUPLICATE",
  1L,"we ignore unobserved confounders, unmeasured variables that affect both patients medical prescription and their outcome","DUPLICATE",
  1L,"ignorability assumption: conditional on X, potential outcomes and treatment T are independent","DUPLICATE — no actual adjustment method; assumption only",
  1L,"no balance diagnostics reported","DUPLICATE",
  1L,"Overlooking the presence of unobserved confounders may lead to biased results","DUPLICATE",
  1L,"sparse techniques will be employed to select biomarkers for prediction of treatment effects","DUPLICATE — data-driven",
  0L,"no posthoc effect mod","DUPLICATE",
  3L,"MGANITE (modified GANITE)... estimate individualized effects of any types of treatments","DUPLICATE",
  3L,"generator consists of seven layers of feedforward neural network... batch size 16... learning rates 0.0001 and 0.001","DUPLICATE",
  1L,"response status (response or no response) is used as the outcome","DUPLICATE — binary non-survival outcome",
  2L,"total number of batches was 1,000,000... Adam Optimizer... 20% dropout","DUPLICATE",
  1L,"no cross-fitting or sample splitting described","DUPLICATE",
  2L,"compare MGANITE with LR, LogR, SVM, KNN, BLR, RF(C), RF(R)","DUPLICATE",
  2L,"pairwise treatment effect xi_jk = Y(T_j) - Y(T_k)... average pairwise treatment effect","DUPLICATE",
  1L,"response or no response is used as outcome... no survival estimand","DUPLICATE — non-survival",
  1L,"MGANITE is applied to 256 newly diagnosed AML patients","DUPLICATE",
  1L,"K-L divergence between distributions of ITE for in-sample and out-of-samples","DUPLICATE",
  0L,"biomarkers identified by LASSO explain 36.82% of treatment effect variation","DUPLICATE — not discussed in oncology plausibility terms",
  2L,"program for implementing the proposed MGANITE can be downloaded from our website https://sph.uth.edu/research/centers/hgc/software/xiong/","DUPLICATE — partial public code"
)

ev_Dusseldorp_2016 <- make_evidence("Dusseldorp_2016",
  2L,"randomized controlled trial... clients randomly assigned to one out of (at least) two treatments","RCT; BCRP trial; 3-arm (nutrition, education, control); 2-arm comparison used",
  2L,"younger women with early stage breast cancer who previously underwent a lumpectomy and received combined radiation and chemotherapy","Named dataset and population; IC/EC not fully detailed in this paper",
  2L,"nutrition intervention (n=85), education intervention (n=83)","Named; no dose/protocol detail",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  2L,"nine patient characteristics... dispositional optimism, unmitigated communion, negative social interaction, demographic, treatment severity","Pre-specified covariate list; clinical rationale present; no formal HTE hypothesis",
  0L,"QUINT tree identifies qualitative interactions; no SHAP or feature importance","Tree-based subgroup identification; not SHAP or HTE in causal ML sense",
  2L,"QUINT... identify subgroups of clients who differ in which treatment alternative is best for them","Outcome modelling / subgroup identification; not custom CATE estimator",
  3L,"sequential partitioning algorithm... maximizing criterion C... bootstrap-based bias correction (B=25)... one standard error rule for pruning","Algorithm described with flowchart; partial description of splitting criterion formula",
  1L,"outcome variable... change scores from baseline to follow-up [depression, physical functioning]","Non-survival outcome; change score in QoL/depression; not TTE",
  2L,"dmin=0.30 (default)... B=25 bootstrap samples... quint.control function allows user to change parameters","Parameters described but no CV-based selection; user-specified defaults",
  1L,"bootstrap-based bias correction procedure... B bootstrap samples drawn from original data","Bootstrap pruning used but no train/test split for ITE estimation",
  1L,"overview... of related methods: STIMA, Interaction Trees, Model-based recursive partitioning, Virtual Twins, SIDES","Literature review only; no head-to-head in this dataset",
  1L,"identify subgroups for whom Treatment A is better than B, and vice versa","Implicit ITE concept; no formal potential outcomes notation",
  1L,"change in depression score, change in physical functioning","No survival estimand; non-oncology-survival outcome",
  1L,"for which subgroup of women is nutrition more effective... for which does the reverse hold","Subgroups described; no formal policy evaluation or recommendation rule",
  1L,"95% confidence interval of the effect size displayed in leaves of tree","Leaf-level CIs for subgroup ATE; no individual-level UQ",
  0L,"dispositional optimism... negative social interaction... comorbidity","Not discussed in oncological/biological plausibility terms",
  2L,"R package quint... can be installed from the CRAN repository","Partial public code via CRAN package (method only, not analysis scripts)"
)

## ── BATCH 3 evidence blocks (3 new papers) ──────────────────────────────

## ── Lopez_2023 ─────────────────────────────────────────────────────────
# IPD meta-analysis; linear mixed models; exercise moderators; prostate cancer
# NOT a causal ML / ITE paper — moderator analysis via LMM
# method_type=1 (prediction only; no CATE estimator)
# survival dims scored: outcome_method_alignment=1 (non-survival; lean mass etc.)
# causal_estimand=1 (no formal ITE; moderator interaction term only)
# survival_estimand=1 (non-survival outcomes)
ev_Lopez_2023 <- make_evidence("Lopez_2023",
  # study_design
  2L,
  "Present IPD meta-analysis is a secondary report of the Predicting Optimal Cancer Rehabilitation and Supportive care (POLARIS) study... including data from RCTs examining the effects of supervised resistance-based exercise interventions",
  "RCT IPD meta-analysis; 7 RCTs pooled; exercise vs control",
  # patient_population
  3L,
  "560 patients with prostate cancer (age: 69.5 +/- 7.8 yrs)... previously or currently treated with ADT... trials included did not have any age limit as part of the exclusion criteria",
  "Clear IC/EC + dataset + timeframe; multi-trial pooling; well-characterised ADT population",
  # comparators
  3L,
  "supervised resistance-based exercise interventions (i.e., interventions including resistance training as one of the components)... prescribed two to three times per week for ~60 min per session... duration ranged from 12 to 48 weeks",
  "Intervention well-defined at programme level; dose and frequency described; no single protocol",
  # confounders — NA (RCT)
  NA_integer_,NA_character_,"RCT IPD meta-analysis — confounding dims NA",
  NA_integer_,NA_character_,"RCT IPD meta-analysis — confounding dims NA",
  NA_integer_,NA_character_,"RCT IPD meta-analysis — confounding dims NA",
  NA_integer_,NA_character_,"RCT IPD meta-analysis — confounding dims NA",
  # predefined_effect_mod
  3L,
  "Potential moderators of exercise response included age... baseline values of outcomes... body mass index... low skeletal muscle index... time since diagnosis... ADT duration... exercise type... total number of exercise sessions",
  "Pre-specified moderator list with clinical rationale; pre-registered under PROSPERO CRD42013003805",
  # posthoc_effect_mod
  1L,
  "Stratified analyses were undertaken if the interaction terms were statistically significant (P<=0.05) or approaching statistical significance",
  "Interaction-term-driven stratification; not SHAP or causal ML HTE exploration",
  # method_type
  1L,
  "Linear mixed model analyses with a two-level structure... effects were evaluated by regressing the study group on the post-intervention value of the outcome adjusted for the baseline value",
  "Standard LMM moderator analysis; no CATE estimator; prediction only / subgroup identification",
  # method_clarity
  3L,
  "One-step complete-case IPD meta-analyses... linear mixed model analyses with a two-level structure... clustering of patients within studies by using a random intercept on the study level... Within- and between-trial interactions were separated by centring the individual value of the covariate around the mean study value",
  "LMM approach fully described including centering strategy to reduce ecological bias; one-step IPD",
  # outcome_method_alignment
  1L,
  "whole-body and appendicular lean mass, skeletal muscle index, physical function, and muscle strength",
  "Non-survival outcomes; lean mass, strength, physical function; LMM appropriate for these but irrelevant to TTE ITE scoring",
  # hyperparameter_tuning
  2L,
  "All analyses were conducted in R Core Team (2013) using the package lme4",
  "Standard LMM; no hyperparameter tuning required; appropriate for method but not ML tuning",
  # sample_splitting
  1L,
  "No sample splitting or cross-fitting described",
  "One-step complete-case IPD; no train/test or cross-fitting; not applicable for LMM",
  # multi_model_comparison
  1L,
  "Only linear mixed models used; no comparison to other moderator analysis methods",
  "Single modelling approach; no systematic comparison to alternative HTE methods",
  # causal_estimand
  1L,
  "effects were evaluated by regressing the study group (intervention vs. control group) on the post-intervention value of the outcome adjusted for the baseline value... potential moderators were examined by adding the moderator and its interaction term",
  "Moderator interaction term only; no formal ITE/CATE definition; implicit effect heterogeneity concept",
  # survival_estimand
  1L,
  "whole-body lean mass... appendicular lean mass... skeletal muscle index... upper- and lower-limb relative muscle strength... 400-m walk... chair rise... 6-m fast walk... 6-m backwards tandem walk",
  "No survival estimand; non-TTE outcomes; lean mass and functional tests",
  # clinical_decision_readiness
  2L,
  "resistance-based exercise programs can improve lean mass in patients regardless of demographic and clinical characteristics while specific subgroups of patients such as those younger and presenting with lower baseline levels of physical function respond more favourably",
  "Subgroup-level recommendations made with clinical framing; no formal targeting policy evaluation",
  # uncertainty_quantification
  2L,
  "regression coefficients (beta) and 95% confidence intervals (95% CI) of the intervention effect for each subgroup... likelihood ratio test used to compare models with and without interaction terms",
  "Subgroup-level CIs and LRT p-values; no individual-level UQ",
  # effect_mod_plausibility
  1L,
  "younger patients experienced greater effects (<=70 yrs.: beta = 0.35 kg.kg-1, 95% CI: 0.22 to 0.48)... patients presenting with lower baseline levels deriving greater exercise effects on 400-m walk",
  "Clinical plausibility of age and baseline-level moderation briefly discussed; principle of window of adaptation invoked",
  # code_availability
  1L,
  "All analyses were conducted in R Core Team (2013) using the package lme4",
  "Standard package referenced but no analysis scripts or data shared publicly"
)

## ── Ma_2018 ────────────────────────────────────────────────────────────
# Obs (TCGA propensity-matched); BPFT; Lung LUSC; n=116
# Genomic signatures + Bayesian predictive failure time model
# Custom CATE: predicts P(t>T|D,j) per patient, assigns optimal treatment
ev_Ma_2018 <- make_evidence("Ma_2018",
  # study_design
  1L,
  "We applied the proposed methods to the publicly available data of LUSC from The Cancer Genome Atlas Data Portal... we matched the data with the baseline covariates of gender, age, tumor stage and initial year of pathological diagnosis",
  "Observational (TCGA registry); propensity-matched pairs; n=116 matched patients",
  # patient_population
  2L,
  "We focused on a subset of patients who received two therapeutic regimes of targeted (n=60) and non-targeted (n=188) treatments... matched 58 pairs of patients with the 30-day landmark",
  "Named dataset (TCGA LUSC); IC/EC described at matching level; eligibility criteria limited; 30-day landmark applied",
  # comparators
  2L,
  "targeted (n=60) and non-targeted (n=188) treatments... The longest follow-up time was 11 years",
  "Targeted vs non-targeted therapy; no dose or protocol detail; treatment regimes not precisely defined",
  # confounders_identified
  2L,
  "we matched the data with the baseline covariates of gender, age, tumor stage and initial year of pathological diagnosis (IYPD)",
  "Four confounders identified and used for matching; limited set for genomic study; clinical justification implicit",
  # confounding_adjustment
  3L,
  "we matched 58 pairs of patients with the 30-day landmark using the R package of MatchIt (with the default settings)... all standardized mean differences were less than 0.25",
  "Propensity score matching via MatchIt; caliper-based; SMD threshold applied; advanced adjustment for observational oncology",
  # balance_diagnostics
  2L,
  "the resultant standardized differences were -0.037, 0.212, 0.000, and 0.028 for gender, age, tumor stage and IYPD, respectively. All standardized mean differences were less than 0.25",
  "SMD reported for all matching variables; threshold criterion stated; no visual balance plot",
  # unmeasured_confounding
  2L,
  "Since TCGA data are generally observational, to avoid potentially biased estimates of the treatment effects, we matched the data... the clinical utilities of these predictive genomic signatures need to be further validated prior to their use in clinical practice",
  "Acknowledged; PSM used as mitigation; no formal sensitivity analysis for unmeasured confounding",
  # predefined_effect_mod
  1L,
  "we follow the same procedure as described in Section 3.3 and include the genes with the highest marginal association with the clinical outcome as a signature for data analysis",
  "Data-driven signature selection based on marginal gene-treatment interaction p-values; no pre-specified HTE hypothesis",
  # posthoc_effect_mod
  1L,
  "we evaluated the predictive performance of BFPT and its competing approaches by comparing treatment effects among the stratified subgroups defined by each method",
  "Subgroup comparison post-hoc based on recommendation concordance; no SHAP or formal HTE exploration",
  # method_type
  3L,
  "Bayesian predictive framework for optimal treatment selection... the extent to which a patient contributes to the outcome prediction of another is determined by the extent to which their tumors exhibit molecular similarity... power prior model",
  "Custom CATE via Bayesian predictive failure time model with nonexchangeable power prior",
  # method_clarity
  3L,
  "p(theta_j|D_k, t_k, delta_k) proportional to f(t_k|theta_j)^delta_k [1-F(t_k|theta_j)]^{1-delta_k} prod_i f(t_i|theta_j)^{delta_i} [1-F(t_i|theta_j)]^{1-delta_i}^{S_{ik}} g(theta_j)... exponential distribution assumed... Gamma(alpha, beta) prior... closed-form predictive probability derived in Appendix B",
  "Mathematical framework fully stated; power prior derivation in appendix; exponential + Gamma conjugate gives closed form; clustering described",
  # outcome_method_alignment
  3L,
  "We consider time-to-failure endpoints with treatment allocation strategies that endeavor to prolong the patient's duration from treatment to disease progression/recurrence or death... survival and density functions... exponential survival model",
  "Survival-aware; time-to-failure endpoints; exponential model with censoring handled via likelihood",
  # hyperparameter_tuning
  2L,
  "we explored all signatures with all clustering methods with ranks of 2-15... we implemented the proposed BPFT approach by first selecting the optimal number of clusters (rank) via evaluating the 5-year restricted mean survival times (RMSTs) on the training data with one patient excluded",
  "Rank (cluster number) selected via LOOCV RMST on training data; hyperparameters alpha=beta=0.01 with sensitivity analysis; systematic but limited grid",
  # sample_splitting
  2L,
  "we conducted leave-one-out cross-validation (LOOCV) analyses... the patient cohort that is used to train the statistical model and select an optimal treatment excludes the patient for which the prediction is taking place",
  "LOOCV used throughout; reflects actual clinical practice; no cross-fitting of nuisance models",
  # multi_model_comparison
  2L,
  "we evaluate the performance of a simplified version of our Bayesian predictive modeling approach where all observations are considered exchangeable (naive method)... BPFT-e... RAFT... OTR... Performance for all methods compared using various sampling models",
  "Systematic comparison: BPFT vs naive, BPFT-e, RAFT, OTR; multiple scenarios; simulation + real data",
  # causal_estimand
  2L,
  "the treatment with the highest predicted probability, p(t_k > T, delta_k=0 | D_k, j), will be recommended... T is the longest observed follow-up duration",
  "Predictive probability of prolonged survival as treatment selection criterion; implicit ITE via comparative prediction; no formal potential outcomes notation",
  # survival_estimand
  3L,
  "progression free survival (PFS) durations... restricted mean survival time (RMST)... the 3-year RMST... p(t_k > T, delta_k=0 | D_k, j) is used as the treatment selection criterion",
  "PFS with RMST evaluation; T-year survival probability as treatment selection metric; 3-yr RMST as primary comparison; well-defined if not fully formalised",
  # clinical_decision_readiness
  2L,
  "the best result of the 3-year RMST was 2.58 (95% CI, 2.36 - 2.80) years, which was obtained from Topi50 using the Bayesian predictive method with PAM. This represents, on average, a 19% prolonged 3-year RMST compared to those obtained from the alternative treatment assignment strategy",
  "Recommendation-vs-non-recommendation survival comparison with CIs; RMST benefit quantified; not a full decision curve analysis",
  # uncertainty_quantification
  2L,
  "3-year RMST... 0.95 CI... (2.36-2.80)... we used the R package survRM2 to obtain the resulting 95% confidence intervals",
  "Group-level RMST CIs via survRM2; no individual-level predictive intervals for BPFT probabilities",
  # effect_mod_plausibility
  1L,
  "The combination of our Bayesian approach with these genomic signatures and those reported by Kaufman et al. revealed the presence of treatment-by-gene interaction effects that elucidate subgroups of patients who might benefit from the targeted/non-targeted regimes",
  "Treatment-by-gene interactions mentioned but not discussed in terms of biological mechanism; clinical plausibility minimal",
  # code_availability
  1L,
  "no code repository mentioned... The authors thank the authors of Wang et al. (2014) for sharing their code",
  "No public code; external code acknowledged; TCGA data publicly available but analysis not reproducible"
)

## ── Roblin_2025b ───────────────────────────────────────────────────────
# arXiv:2506.12277; methods evaluation paper; CoxCC/CoxTime/IF vs ALASSO
# Two breast cancer RCT datasets; extensive simulation study
# Different from Roblin_2025 (EJC) — this is the preprint methods paper
ev_Roblin_2025b <- make_evidence("Roblin_2025b",
  # study_design
  2L,
  "We apply 2 strategies for the feedforward neural networks (FNNs) based on a specific loss function in a continuous time framework (CoxCC and CoxTime), and Interaction Forests (IF)... We apply the methods to gene expression data from a meta-analysis of neoadjuvant trials that included 614 breast cancer patients... and data from an RCT including 1,574 patients",
  "RCT application (taxane meta-analysis n=614; trastuzumab RCT n=1574); plus simulation study; methods evaluation paper",
  # patient_population
  3L,
  "614 breast cancer patients treated by anthracyclines alone or anthracyclines plus taxanes... 1,574 patients, which evaluates the effect of adding trastuzumab to adjuvant chemotherapy... disease-free survival in early breast cancer patients in Her2+ breast cancer",
  "Named datasets with trial references; clear IC/EC implied by RCT design; patient-level details limited in preprint",
  # comparators
  3L,
  "anthracycline-based chemotherapy with (n=507) or without (n=107) taxane... chemotherapy (n=795) vs chemotherapy and trastuzumab (n=779)",
  "RCT comparators clearly defined; protocol-level doses not restated in preprint but from source RCTs",
  # confounders — NA (RCT)
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  # predefined_effect_mod
  2L,
  "We apply the methods to gene expression and clinical data from 2 breast cancer studies... p=1,689 genes for taxane dataset; p=462 genes plus clinicopathological variables for trastuzumab",
  "Input covariates pre-specified by gene expression + clinical variables from source datasets; no explicit HTE hypothesis pre-registered",
  # posthoc_effect_mod
  1L,
  "Further work could focus on the relative contribution of the input variables... For the IF, we could evaluate the Effect Importance Measure",
  "No SHAP or feature importance reported in current paper; mentioned as future work only",
  # method_type
  3L,
  "CoxCC that uses a loss function based on a case-control approximation... CoxTime, that is not constrained by the proportionality assumption... Interaction Forests (IF), a type of random survival forest specifically designed to model quantitative and qualitative interaction effects in bivariate splits",
  "Custom CATE via three survival ML methods (CoxCC, CoxTime, IF); each produces individual survival probability and benefit prediction",
  # method_clarity
  4L,
  "LCoxCC = 1/n sum_{i:Di=1} log(sum_{j in R~i} exp[phi(Xj) - phi(Xi)])... LCoxTime = 1/n sum_{i:Di=1} log(sum_{j in R~i} exp[phi(ti, Xj) - phi(ti, Xi)])... Tree-Parzen algorithm... 200 hyperparameter sets sampled... Table 7 lists search space",
  "Loss functions fully specified for CoxCC and CoxTime; IF reference cited; hyperparameter search space in Table 7; architecture described",
  # outcome_method_alignment
  3L,
  "survival models based on neural networks (CoxCC and CoxTime) and random survival forests (Interaction Forests)... time-to-event outcomes... right-censored... G(t) = P(C>t) censoring survival function defined",
  "Survival-aware; all three methods handle censoring; TTE framework throughout",
  # hyperparameter_tuning
  3L,
  "Tree-Parzen algorithm... 200 times... 5-fold CV applied to the training set... for the application to two patient data sets, we perform a double 5-fold CV on the entire dataset",
  "Systematic hyperparameter search with TPE; double 5-fold CV for real data; well-documented",
  # sample_splitting
  2L,
  "First, the real patient cohort is split into five folds: this is the outer loop. Then, we select one of the five folds as a test set and perform a 5-fold CV on the remaining data for each hyperparameter set: this is the inner loop",
  "Double 5-fold CV (nested CV) for real data; Bayesian posterior for simulations; no formal cross-fitting of nuisance models",
  # multi_model_comparison
  2L,
  "We compare survival models based on neural networks (CoxCC and CoxTime) and random survival forests (Interaction Forests). A Cox model, including an adaptive LASSO penalty, is used as a benchmark",
  "Systematic head-to-head: CoxCC, CoxTime, IF, ALASSO; simulation + two real datasets; comprehensive evaluation",
  # causal_estimand
  2L,
  "In an RCT, assuming that Y(1) and Y(0) are independent from tau|X, the treatment effect is defined as: E(Y(1)-Y(0)|X) = E(Y|tau=1,X) - E(Y|tau=0,X)... theta_hat_{u,v}(t) = [Su(t|tau=1,Xu) - Su(t|tau=0,Xu)]/2 + ...",
  "ITE defined as survival probability difference at fixed time point; counterfactual framework referenced; matched-pair approach for observed benefit",
  # survival_estimand
  3L,
  "predicted benefit theta_hat is defined as the difference between the individual survival probability at a given timepoint with the treatment option being tested minus the probability with the control... computed at t=2 and t=5 years",
  "Absolute survival probability difference at defined time points (2yr, 5yr); DFS outcome; well-specified",
  # clinical_decision_readiness
  1L,
  "The machine learning methods performed well in data generation process 1... They can be used to evaluate individualized treatment effects from randomized trials when nonlinear and interaction effects are expected to be present",
  "Methods paper; no clinical recommendation framework; no targeting strategy evaluation; academic methods comparison only",
  # uncertainty_quantification
  3L,
  "M=200 bootstrap sets are sampled with replacement from the training set... The percentile method is then used to obtain confidence intervals at level 1-theta... CI_{1-theta} = [q_{theta/2}(S_hat_i(t)), q_{1-theta/2}(S_hat_i(t))]",
  "Individual-level bootstrap CIs for survival predictions described and illustrated for two example patients; not reported at population level",
  # effect_mod_plausibility
  1L,
  "In this data set, the machine learning methods seem better able to capture the biomarker-by-treatment interactions in the data, which could highlight the existence of high-order interactions and nonlinear effects",
  "Interaction effects mentioned but not interpreted clinically; no biological plausibility discussion of specific biomarkers",
  # code_availability
  1L,
  "No code repository mentioned in preprint",
  "arXiv preprint; biospear R package referenced for taxane data; no analysis code shared"
)

# ============================================================
# 4. COMBINE ALL EVIDENCE
# ============================================================

evidence <- bind_rows(
  # Batch 1
  ev_Saad_2025, ev_Pryce_2025, ev_Ge_2020, ev_Roblin_2025,
  ev_Zhang_2025, ev_Zhu_2023, ev_Zhu_2024, ev_Schrod_2022,
  ev_Tabib_2020, ev_Sauerbrei_2022,
  # Batch 2
  ev_Hu_2021, ev_Zhang_2012, ev_Shen_2018, ev_Jo_2024,
  ev_Pan_2024, ev_Ge_2020b, ev_Dusseldorp_2016,
  # Batch 3 (new)
  ev_Lopez_2023, ev_Ma_2018, ev_Roblin_2025b
)

# ============================================================
# 5. SAVE
# ============================================================

review <- list(
  papers   = papers,
  scores   = scores,
  evidence = evidence
)

saveRDS(review, "causal_ml_review.rds")

cat("Saved causal_ml_review.rds\n")
cat("papers:  ", nrow(papers),   "rows x", ncol(papers),   "cols\n")
cat("scores:  ", nrow(scores),   "rows x", ncol(scores),   "cols\n")
cat("evidence:", nrow(evidence), "rows x", ncol(evidence), "cols\n")
