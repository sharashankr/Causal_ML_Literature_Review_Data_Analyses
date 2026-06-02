## ============================================================
##  BUILD_20_PAPERS.R
##  Causal ML in Oncology — Systematic Review
##  20 papers × 21 dimensions = 420 evidence rows
##  Updated: 2026-05 (batch 3: 3 new papers added)
##  New papers: Lopez_2023, Ma_2018, Roblin_2025b
## ============================================================

library(tibble)
library(writexl)
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
  "NSCLC",          "USA", 141L,
  "J Immunother Cancer",
  "Causal AI-based clinical and radiomic analysis for optimizing patient selection in combined immunotherapy and SABR in early-stage NSCLC: a secondary analysis of the phase II I-SABR trial",
  "10.1136/jitc-2025-013074",
  "Maliazurina B Saad, et al.",
  "RCT reanalysis; CPH meta-learner; primary trial I-SABR",

  "Pryce_2025",     "Pryce",        2025,  2L,
  "Breast",         "German Data",           686L,
  "Biometrics",
  "Causal machine learning for heterogeneous treatment effects in the presence of missing outcome data",
  "10.1093/biomtc/ujaf098",
  "Matthew Pryce, Karla Diaz-Ordaz, Ruth H. Keogh, Stijn Vansteelandt",
  "Methods paper proposing mDR-learner and mEP-learner for CATE with missing outcome data; simulations plus GBSG2 breast cancer RCT application",

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

  "Zhang_2025", "Zhang", 2025, 1L,
  "HNSCC", "USA", 7376L,
  "Frontiers in Medicine",
  "Individualized treatment recommendations for patients with locally advanced head and neck squamous cell carcinoma utilizing deep learning",
  "10.3389/fmed.2024.1478842",
  "Linmei Zhang, Enzhao Zhu, Jiaying Shi, Xiao Wu, Shaokang Cao, Sining Huang, Zisheng Ai, Jiansheng Su",
  "Population-based retrospective SEER cohort; locally advanced HNSCC; BITES/CMHE/DeepSurv/CPH/RSF treatment recommendation; phase 1 CRT vs surgery plus RT/CRT and phase 2 surgery plus RT vs surgery plus CRT; OS/RST-based ITE.",
 
  "Zhu_2023", "Zhu", 2023, 1L,
"LGG", "USA", 2840L,
"Cancer Medicine",
"Reasoning and causal inference regarding surgical options for patients with low-grade gliomas using machine learning: a SEER-based study",
"10.1002/cam4.6666",
"Enzhao Zhu, Weizhong Shi, Zhihao Chen, Jiayi Wang, Pu Ai, Xiao Wang, Min Zhu, Ziqin Xu, Lingxiao Xu, Xueyi Sun, Jingyu Liu, Xuetong Xu, Dan Shan",
"Observational SEER cohort; WHO grade 2 low-grade glioma; BSL/BITES-LassoNet for ITE and treatment recommendation; compares gross-total resection vs subtotal resection; BCSS survival outcome.",

  "Zhu_2024", "Zhu", 2024, 1L,
"Breast (elderly)", "China/USA", 5352L,
"Breast Cancer Research and Treatment",
"Deep learning-guided adjuvant chemotherapy selection for elderly patients with breast cancer",
"10.1007/s10549-023-07237-y",
"Enzhao Zhu, Linmei Zhang, Jiayi Wang, Chunyu Hu, Huiqing Pan, Weizhong Shi, Ziqin Xu, Pu Ai, Dan Shan, Zisheng Ai",
"Observational SEER cohort; elderly female breast cancer patients age >70 after mastectomy; BITES/CMHE/DeepSurv/CPH/RSF/causal forest treatment recommendation; chemotherapy vs no chemotherapy; OS/RST-based ITE.",
  
  "Schrod_2022", "Schrod", 2022, 1L,
"Breast", "Germany / Netherlands", 2231L,
"Bioinformatics",
"BITES: balanced individual treatment effect for survival data",
"10.1093/bioinformatics/btac221",
"S. Schrod, A. Schäfer, S. Solbrig, R. Lohmayer, W. Gronwald, P. J. Oefner, T. Beißbarth, R. Spang, H. U. Zacharias, M. Altenbuchinger",
"Methods paper introducing BITES; simulations plus breast cancer application; trained on Rotterdam Tumour Bank n=1545 and validated on randomized GBSG Trial 2 n=686; estimates benefit of adding hormone therapy to chemotherapy using RFS time-to-event outcomes.",

  "Hu_2021b", "Hu", 2021, 1L,
"Prostate", "USA", 7730L,
"Statistics in Medicine",
"Estimating heterogeneous survival treatment effect in observational data using machine learning",
"10.1002/sim.9090",
"Liangyuan Hu, Jiayi Ji, Fan Li",
"Methods paper with simulation study plus NCDB observational prostate cancer case study; compares machine-learning survival HTE estimators including AFT-BART-NP, AFT-BART-NP-PS, AFT-BART-SP, RSF, DeepSurv, DR-DL, BJ-DL, TSHEE, GAPH, AFT, and Cox; case study estimates heterogeneous survival effects of EBRT + AD versus EBRT + brachytherapy ± AD in high-risk localized prostate cancer.",

 "Sauerbrei_2022", "Sauerbrei", 2022, 2L,
"Breast", "Multi-country", 5727L,
"BMC Medical Research Methodology",
"Investigating treatment-effect modification by a continuous covariate in IPD meta-analysis: an approach using fractional polynomials",
"10.1186/s12874-022-01516-w",
"Willi Sauerbrei, Patrick Royston",
"RCT IPD meta-analysis methods paper; eight breast cancer randomized trials from Breast Cancer DataMart; metaTEF/MFPI approach; chemotherapy vs no chemotherapy among tamoxifen-treated patients; investigates ER as continuous treatment-effect modifier for DFS/log-HR.",

  # ── BATCH 2 (7 papers) ──────────────────────────────────

  "Hu_2021", "Hu", 2021, 2L,
"Lung", "USA", 50062L,
"Annals of Epidemiology",
"Estimating heterogeneous survival treatment effects of lung cancer screening approaches: A causal machine learning analysis",
"10.1016/j.annepidem.2021.06.008",
"Liangyuan Hu, Jung-Yi (Joyce) Lin, Keith Sigel, Minal Kale",
"RCT-based as-treated NLST analysis; AFT-BART causal machine learning; LDCT versus CXR lung cancer screening; estimates ITE/TEH for lung cancer-specific survival and overall survival.",

  "Zhang_2012",     "Zhang",        2012,  2L,
  "Breast",         "USA",          1276L,
  "Biometrics",
  "A Robust Method for Estimating Optimal Treatment Regimes",
  "10.1111/j.1541-0420.2012.01763.x",
  "Zhang B, Tsiatis AA, Laber EB, Davidian M",
  "RCT (NSABP); AIPWE+CART; binary 3-yr DFS outcome; methods paper",

  "Shen_2018", "Shen", 2018, 1L,
"Prostate", "USA", 3540L,
"Journal of Biopharmaceutical Statistics",
"Estimating the Optimal Personalized Treatment Strategy Based on Selected Variables to Prolong Survival via Random Survival Forest with Weighted Bootstrap",
"10.1080/10543406.2017.1380036",
"Jincheng Shen, Lu Wang, Stephanie Daignault, Daniel E. Spratt, Todd M. Morgan, Jeremy M. G. Taylor",
"Observational prostate cancer cohort; RSFWB method for optimal personalized treatment strategy; surgery versus radiation therapy; right-censored time-to-clinical-failure outcome; optimal regime estimated by maximizing restricted mean survival time.",

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
  "Breast",         "Meta Analysis",       2188L,
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
  3L, 2L,
  3L, 4L, 3L,
  3L, 2L,
  2L,
  3L, 3L,
  3L, 2L,
  1L, 3L,

  "Pryce_2025",
  2L, 3L, 3L,
  NA, NA, NA, NA,
  1L, 2L,
  3L, 4L, 3L,
  4L, 2L,
  2L,
  3L, 3L,
  1L, 3L,
  1L, 3L,

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
  1L, 3L, 3L,
  2L, 2L, 1L, 2L,
  1L, 2L,
  3L, 4L, 3L,
  2L, 2L,
  2L,
  3L, 3L,
  3L, 2L,
  1L, 1L,

  "Zhu_2024",
  1L, 3L, 3L,
  2L, 2L, 1L, 2L,
  1L, 2L,
  3L, 4L, 3L,
  2L, 2L,
  2L,
  3L, 3L,
  3L, 2L,
  1L, 1L,

  "Schrod_2022",
  1L, 3L, 3L,
  2L, 2L, 1L, 1L,
  1L, 2L,
  3L, 4L, 3L,
  3L, 2L,
  2L,
  3L, 3L,
  2L, 1L,
  1L, 3L,

 "Hu_2021b",
  1L, 3L, 3L,
  2L, 2L, 1L, 2L,
  1L, 3L,
  3L, 4L, 3L,
  2L, 1L,
  2L,
  3L, 3L,
  2L, 3L,
  1L, 3L,

  "Sauerbrei_2022",
  2L, 3L, 3L,
  NA, NA, NA, NA,
  3L, 3L,
  1L, 4L, 3L,
  3L, 1L,
  2L,
  2L, 3L,
  2L, 2L,
  1L, 3L,
  
  # ── BATCH 2 ─────────────────────────────────────────────

  "Hu_2021",
  2L, 4L, 3L,
  NA, NA, NA, NA,
  2L, 3L,
  3L, 4L, 3L,
  3L, 1L,
  1L,
  3L, 3L,
  2L, 3L,
  1L, 1L,

  "Zhang_2012",
  2L, 2L, 2L,
  NA, NA, NA, NA,
  1L, 3L,
  3L, 4L, 1L,
  2L, 1L,
  2L,
  3L, 1L,
  3L, 2L,
  1L, 1L,

  "Shen_2018",
  1L, 3L, 3L,
  2L, 3L, 1L, 2L,
  2L, 3L,
  3L, 4L, 3L,
  3L, 2L,
  2L,
  3L, 3L,
  3L, 2L,
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
  4L,"patients with early-stage/inoperable NSCLC from I-SABR, with clinical variables including ECOG, stage, tumor size, etc.", "Clear trial population; full IC/EC mainly inherited from parent trial/supplement",
  4L,"SABR alone vs SABR + immunotherapy / I-SABR","Protocol-level",
  NA_integer_,NA_character_,"RCT",NA_integer_,NA_character_,"RCT",
  NA_integer_,NA_character_,"RCT",NA_integer_,NA_character_,"RCT",
  3L,"Pre-specified clinical predictors from trial protocol + radiomic features","Pre-specified with clinical rationale",
  2L,"SHAP - feature importance,  used to describe heterogeneity","Feature importance only",
  3L,"Counterfactual reasoning with Meta Learner (two Cox proportional hazards) model was used to estimate individualized treatment effect by contrasting predicted risk under I-SABR versus SABR.","Custom CATE",
  4L,"Two separately trained CPH models (meta learner) were used to estimate counterfactual outcomes under I-SABR and SABR; ITE was computed by contrasting model-predicted risks, and treatment with lower predicted risk was recommended.","Fully described",
  3L,"survival outcomes modelled with Cox regression; censoring accounted for","Survival-aware",
  3L,"They used repeated CV, bootstrapping, ensemble learning, and gray wolf optimizer-based feature selection","CV + bootstrapping + feature selection",
  2L,"via repeated cross-validation and an external validation cohort, not “honesty” or formal cross-fitting","No Cross-fitting",
  1L,"CPH meta-learner compared to Kaplan-Meier stratified analysis","Limited comparison",
  3L,"ITE defined as: ITE = (predicted risk under SABR alone - predicted risk under I-SABR) / predicted risk under SABR alone (observed & counterfactual)","Explicit ITE defined",
  3L,"Restricted mean survival time difference (RMSTD) was calculated at the median follow-­ up time, which is 33 months. EFS","Defined outcomes with horizon",
  3L,"Patients were classified into IO-benefit and IO-spare groups to guide whether immunotherapy should be added to SABR; the paper also reported ARR, NNT, and net benefit for model-guided selection.","Recommended vs non-recommended groups",
  3L,"Bootstrapping and repeated cross-validation were used to improve robustness and mitigate small-sample bias, but individual-level uncertainty intervals for ITE were not clearly reported in the main text.","No ITE",
  1L,"Radiomic features, ECOG performance status, smoking status, tumor size, and radiation dose were interpreted as treatment moderators associated with benefit from adding immunotherapy.","Briefly discussed",
  3L,"code available on GitHub","Public repository"
)
ev_Saad_2025$page_ref <- c(
  "p.1–2",  # study_design
  "p.2–3",  # patient_population
  "p.1, p.4",  # comparators
  NA, NA, NA, NA,
  "p.2–4. Start at I-SABR-SELECT: treatment decisions for individual patients",  # predefined_effect_mod
  "p.6 and p.8. Interpretation and reasoning behind I-SABR-SELECT",  # posthoc_effect_mod
  "p.4",    # method_type
  "p.4",    # method_clarity
  "p.4–5",  # outcome_method_alignment
  "p.4–5",  # hyperparameter_tuning
  "p.4",    # sample_splitting
  "p.5",    # multi_model_comparison
  "p.4–5",  # causal_estimand
  "p.4–5",  # survival_estimand
  "p.5–7",  # clinical_decision_readiness
  "p.5, p.10", # uncertainty_quantification
  "p.6, p.10", # effect_mod_plausibility
  "p.1"     # code_availability
)

ev_Pryce_2025 <- make_evidence("Pryce_2025",
  2L,"Methods paper with simulation study and applied example using the GBSG 2 randomized trial","RCT",
  3L,"GBSG2 breast cancer trial patients after surgery; baseline covariates included demographics, medical history, and disease progression, with missing outcome data due to loss to follow-up before 3 years.","detailed original GBSG2 IC/EC would require citing Schumacher et al. 1994",
  3L,"Hormonal therapy versus no hormonal therapy after surgery","Defined; missing full dosing timing",
  NA_integer_,NA_character_,"RCT",NA_integer_,NA_character_,"RCT",
  NA_integer_,NA_character_,"RCT",NA_integer_,NA_character_,"RCT",
  1L,"Methods study using the GBSG2 trial to demonstrate mDR/mEP learners; the paper estimates CATEs using baseline covariates and progesterone receptor levels but does not present a pre-specified clinical effect-modifier plan.","-",
  2L,"Model-derived CATE estimates were plotted by progesterone receptor level and summarized across progesterone receptor groups in the GBSG2 application.","Post-hoc/model-derived CATE heterogeneity; no SHAP",
  3L,"Modified DR-learner and EP-learner estimators were proposed for CATE estimation with missing outcome data, using nuisance models and pseudo-outcome regression with IPCW adjustment.","Custom CATE",
  4L,"The mDR-learner and mEP-learner are described with identification assumptions, nuisance functions, EIF-based pseudo-outcomes, sample splitting/cross-fitting, implementation steps, and algorithm diagrams","Fully described methods paper",
  3L,"GBSG2 used a binary fixed-horizon outcome: recurrence or death within 3 years; mDR/mEP handled missing outcomes, but this was not full survival/TTE modeling.","Not Survival-aware",
  2L,"Choices include - Super Learner, 10-fold cross-fitting, repeated sample-splitting seeds, sieve choices, and bootstrap/random forests","Robust implementation/tuning framework described",
  2L,"All estimators were implemented using 10-fold cross-fitting; the paper also discusses repeated sample-splitting seeds for stability.","Cross-fitting used",
  2L,"mDR-learner and mEP-learner were compared against DR-learner, EP-learner, T-learner, IPTW-IPCW learner, available-case analyses, and imputed-outcome versions in simulations and the GBSG2 application.","Robust comparison",
  3L,"CATE was explicitly defined as the contrast in potential outcomes under treatment versus control conditional on covariates: E[Y(1)|X=x] - E[Y(0)|X=x].","Explicit ITE/CATE",
  3L,"The GBSG2 application used a binary fixed-horizon outcome: breast cancer recurrence or death within 3 years of surgery; this is clinically time-indexed but not full survival/TTE modeling.","Defined with horizon",
  1L,"GBSG2 application did not implement a clinical treatment recommendation rule or recommended-versus-not-recommended groups.","No implementation policy results",
  3L,"The paper discusses half-sample bootstrap confidence intervals for non-parametric CATE estimates and evaluates conditional CI coverage in simulations/supplementary analyses.","uncertainity reported. Limitation noted",
  1L,"Progesterone receptor level was used to display treatment-effect heterogeneity in the GBSG2 application","Very Limited",
  3L,"code available","public repo"
)
ev_Pryce_2025$page_ref <- c(
  "p.1, p.8",     # study_design
  "p.8",          # patient_population
  "p.8",          # comparators
  NA,             # confounders_identified
  NA,             # confounding_adjustment
  NA,             # balance_diagnostics
  NA,             # unmeasured_confounding
  "p.8",          # predefined_effect_mod
  "p.9",          # posthoc_effect_mod
  "p.1, p.3–5",   # method_type
  "p.3–6",        # method_clarity
  "p.8",          # outcome_method_alignment
  "p.5–8",        # hyperparameter_tuning
  "p.5, p.8–9",   # sample_splitting
  "p.7–9",        # multi_model_comparison
  "p.1–2",        # causal_estimand
  "p.8",          # survival_estimand
  "p.1, p.10",    # clinical_decision_readiness
  "p.6, p.8, p.10", # uncertainty_quantification
  "p.8–9",        # effect_mod_plausibility
  "p.10"          # code_availability
)

ev_Ge_2020 <- make_evidence("Ge_2020",
  1L,"256 newly diagnosed AML patients... at MD Anderson Cancer Center","Observational",
  2L,"212 valid samples, 85 useable features","Only some IC/EC - being conservative",
  2L,"HDAC, Idarubicin, HDAC+IDA vs other drugs","Named only",
  1L,"The method assumes ignorability/no unmeasured confounding conditional on features X; the AML application used 85 usable features including protein/phosphoprotein and clinical/geographical variables.","Not justified",
  1L,"ignorability assumption only; no actual adjustment","None",
  1L,"no balance diagnostics (they assume that there is confounding/imbalance)","None",
  2L,"Overlooking the presence of unobserved confounders may lead to biased results","Acknowledged",
  1L,"sparse techniques for selection of biomarkers","weak",
  3L,"LASSO and Garson’s algorithm were used after MGANITE estimation to identify biomarkers associated with treatment-effect variation and optimal treatment selection; the top 30 biomarkers explained 36.82% of HDAC/HDAC+IDA treatment-effect variation","Linked to HTE partially",
  3L,"MGANITE estimates ITE of any treatment type including binary, categorical, continuous","Custom CATE",
  3L,"MGANITE is described with potential-outcome notation, generator/discriminator architecture, imputation and ITE blocks, loss functions, training parameters, Adam optimizer, dropout, and LASSO-based biomarker selection.","Very Comprehensive",
  1L,"The AML application used binary response status as the outcome; no survival-time, censoring, or time-to-event outcome was modeled.","Inappropriate for TTE",
  2L,"Training settings were reported, including batch size 16, discriminator/generator learning rates, exponential learning-rate decay, 1,000,000 batches, Adam optimizer, and 20% dropout.","Done but unclear",
  2L,"The AML dataset was split into an in-sample dataset of 190 samples for initial parameter estimation/model selection and an out-of-sample dataset of 22 samples for evaluating ITE estimation.","No",
  2L,"MGANITE was compared with LR, LogR, SVM, KNN, BLR, RF(C), and RF(R) in simulations and AML real-data analyses.","Systematic benchmarking",
  3L,"pairwise ITE xi_jk = Y(T_j) - Y(T_k)","Explicit ITE",
  1L,"binary response; no survival estimand","Not defined",
  2L,"MGANITE applied to AML; optimal treatment identified","Decent decision readiness",
  1L,"KL divergence between in-sample and out-of-sample ITE distributions","Minimal model variability",
  0L,"biomarkers explain 36.82% of treatment effect variation; not discussed clinically","Not discussed",
  2L,"program downloadable from https://sph.uth.edu/research/centers/hgc/software/xiong/","Program available; reproducibility details limited"
)

ev_Ge_2020$page_ref <- c(
  "p.7",        # study_design
  "p.7",        # patient_population
  "p.7, p.11–12", # comparators
  "p.4, p.7",   # confounders_identified
  "p.4, p.7",   # confounding_adjustment
  "p.4",        # balance_diagnostics
  "p.4",        # unmeasured_confounding
  "p.2, p.6",   # predefined_effect_mod
  "p.6, p.11",  # posthoc_effect_mod
  "p.3–6",      # method_type
  "p.3–6",      # method_clarity
  "p.11",       # outcome_method_alignment
  "p.6",        # hyperparameter_tuning
  "p.11",       # sample_splitting
  "p.8, p.11",  # multi_model_comparison
  "p.3–4",      # causal_estimand
  "p.11",       # survival_estimand
  "p.11–12",    # clinical_decision_readiness
  "p.11",       # uncertainty_quantification
  "p.11",       # effect_mod_plausibility
  "p.3"         # code_availability
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
  3L,
"Patients with HNSCC from oral cavity, sinonasal cavity, pharynx, and larynx, diagnosed as stage III to IVa from 1 January 2004 to 31 December 2015, and treated with definitive CRT or radical resection plus postoperative RT/CRT were included.",
"Clear dataset, timeframe, cancer sites, stage, treatments, and exclusion criteria",

3L,
"Treatment recommendations were evaluated in two phases: phase one compared definitive CRT versus surgery plus postoperative RT/CRT; phase two compared surgery plus postoperative RT versus surgery plus postoperative CRT.",
"Comparators clearly defined; dose-level protocol details unavailable"
                               2L,"age, sex, race, tumour site, T/N stage, grade, marital status, insurance listed","Listed and justified",
  2L,
"Ethnicity, sex, marital status, age, histological grade, laterality, tumor site, TNM stage, tumor size, lymph-node variables, and lymph-node surgery were included as efficacy-related variables.",
"Confounders/prognostic variables listed with clinical rationale",

2L,
"IPTW was used to reduce selection bias and adjust potential baseline imbalance between recommendation-consistent and recommendation-inconsistent groups.",
"Standard IPTW adjustment",

1L,
"No covariate balance diagnostics such as standardized mean differences before/after IPTW were reported in the main text.",
"No main-text balance diagnostics",
  
                               1L,"BITES applied to SEER data; covariates selected from clinical database","Data-driven",
  2L,"SHAP values used to explain ITE variation","SHAP used; partially linked to HTE",
  3L,"BITES: balanced ITE for survival data; shared network + two risk networks","Custom CATE",
  4L,
"BITES architecture was described as a shared network with IPM balancing and two risk networks; the paper also defined RST-based ITE calculation, train/test split, five-fold CV, grid-search hyperparameter tuning, and recommendation evaluation.",
"Fully described survival ITE/recommendation pipeline",

3L,
"The model estimated survival distributions and 5-year restricted survival time differences; OS, HR, DRMST, ARR, IBS, and censoring-aware survival evaluation were used.",
"Survival-aware and aligned with OS/RST treatment benefit",

3L,
"Five-fold cross-validation and grid search were used to tune predefined hyperparameter ranges including learning rate, mini-batch size, dropout, number of layers, nodes, regularization strength, number of trees, and tree depth.",
"Grid search with five-fold CV; reasonably detailed",
  2L,
"Patients were randomly allocated to a 70% training set and 30% testing set; five-fold cross-validation was used within the training set for hyperparameter tuning.",
"Train/test split plus internal CV used",

2L,
"Five models were trained and compared: BITES, CMHE, DeepSurv, CPH, and RSF; NCCN guideline recommendations were also compared in the phase one analysis.",
"Systematic model and guideline comparison",

3L,
"ITE was defined using 5-year restricted survival time: the difference between the area under predicted survival curves under two treatment options.",
"Explicit counterfactual survival ITE estimand",
  3L,
"Overall survival was used as the outcome; ITE was defined as the 5-year restricted survival time difference between predicted survival curves under two treatment options.",
"Defined survival estimand using OS and 5-year RST difference",

3L,
"Patients were divided into recommendation-consistent and recommendation-inconsistent groups, and model recommendations were evaluated using IPTW-adjusted HR, 5-year ARR, DRMST, KM curves, and comparison with NCCN guidelines.",
"Treatment recommendation groups with decision-relevant validation metrics",

2L,
"Confidence intervals were reported for model-level and subgroup-level HR, ARR, and DRMST comparisons, but individual-level ITE uncertainty intervals were not reported.",
"Summary-level uncertainty; no individual ITE intervals",
  1L,"tumour site and stage associated with differential benefit","Briefly discussed",
  1L,"no code repository mentioned","None"
)

ev_Zhang_2025$page_ref <- c(
  "p.2, p.5",      # study_design
  "p.2",           # patient_population
  "p.2–3",         # comparators
  "p.2",           # confounders_identified
  "p.3, p.5–7",    # confounding_adjustment
  "p.3, p.5–7",    # balance_diagnostics
  "p.3, p.5–7",    # unmeasured_confounding
  "p.2–3",         # predefined_effect_mod
  "p.3, p.7–10",   # posthoc_effect_mod
  "p.3",           # method_type
  "p.3",           # method_clarity
  "p.2–6",         # outcome_method_alignment
  "p.3",           # hyperparameter_tuning
  "p.3",           # sample_splitting
  "p.3, p.5–6",    # multi_model_comparison
  "p.2–3",         # causal_estimand
  "p.2–3, p.5–6",  # survival_estimand
  "p.3, p.5–7",    # clinical_decision_readiness
  "p.5–8",         # uncertainty_quantification
  "p.7–11",        # effect_mod_plausibility
  "p.11"           # code_availability
)


ev_Zhu_2023 <- make_evidence("Zhu_2023",
  1L,
"Retrospective cohort study using SEER data; 2,840 patients with WHO grade 2 low-grade glioma were included.",
"Observational SEER cohort",

3L,
"Patients diagnosed with WHO Grade 2 gliomas from 2010–2015 were included if treated with subtotal resection or gross-total resection, with defined histologies and exclusion criteria.",
"Clear dataset, timeframe, IC/EC, and treatment eligibility",

3L,
"Comparators were subtotal resection (SEER code 21) versus gross-total resection (SEER code 30).",
"Comparators clearly defined using SEER surgery codes",

2L,
"Predictor variables included sex, age, marital status, living area, economic status, reporting state, tumor location, laterality, extension, and histology.",
"Covariates listed; limited causal justification",
  2L,
"IPTW was used to reduce treatment selection bias and estimate adjusted hazard ratios; DRL was also used to obtain adjusted odds ratios for GTR versus STR.",
"Standard IPTW plus DRL adjustment",

1L,
"IPTW-adjusted analyses were reported, but no main-text standardized mean difference or balance table was clearly shown.",
"No main-text balance diagnostics; use 2 only if supplement confirms SMD",

2L,
"The authors acknowledged important unmeasured variables, including IDH mutation, 1p/19q codeletion, cranial imaging, quality of life, surgeon preference, and family support.",
"Unmeasured confounding/data limitations acknowledged",

1L,
"BSL/BITES-LassoNet was applied using SEER-derived covariates, but the paper did not present a pre-specified clinical effect-modifier plan.",
"Data-driven covariates; no pre-specified modifier plan",
 2L,
"SurvSHAP(t) and linear SHAP were used to interpret BSL outputs and recommendation behavior, identifying variables related to treatment heterogeneity.",
"SHAP interpretation partially linked to treatment-effect heterogeneity",

3L,
"BSL was developed by adapting BITES with LassoNet risk networks to estimate individualized treatment effects for survival data.",
"Custom survival CATE/ITE method",

4L,
"The paper describes T-learners, BITES, BSL architecture with shared network/IPM and LassoNet risk networks, ITE definition, training/testing split, cross-validation, survival evaluation metrics, SHAP interpretation, and recommendation interface.",
"Fully described survival ITE recommendation pipeline",
  3L,
"Models were evaluated using brain cancer-specific survival, C-index, integrated Brier score, DRMST, HR, KM curves, and predicted survival curves.",
"Survival-aware",

2L,
"Threefold cross-validation was used during training, but detailed hyperparameter search ranges were not fully reported.",
"CV used; tuning details limited",

2L,
"Patients were split into 75% training and 25% testing sets; threefold cross-validation was used within the training set.",
"Train/test split plus internal CV",

2L,
"BSL was compared with BSLa, BSLb, BITES, DeepSurv, CPH, RSF, Rcoxnet, and DART on the testing set.",
"Systematic model comparison",
  3L,
"ITE was explicitly defined as Yi(Xi | T = 1) - Yi(Xi | T = 0), where T = 1 indicates GTR and T = 0 indicates STR; the model recommendation was determined from the ITE value.",
"Explicit counterfactual individual treatment-effect estimand",

3L,
"Brain cancer-specific survival was the outcome; treatment benefit was evaluated using time to 50% mortality, 5-year RMST/DRMST, HR, C-index, IBS, and KM curves.",
"Defined survival estimand using BCSS and RMST/DRMST",

3L,
"The model generated STR/GTR recommendations, evaluated Consis. versus In-consis. groups using HR, DRMST, KM curves, and included a user-friendly interface showing counterfactual survival curves and ITE information.",
"Decision-ready treatment recommendation system",
  2L,"bootstrap CIs for subgroup estimates","Summary-level CI",
  1L,"extent of resection and grade associated with differential benefit","Briefly discussed",
  1L,"no code repository mentioned","None"
)

ev_Zhu_2023$page_ref <- c(
  "p.2, p.5",      # study_design
  "p.2–3",         # patient_population
  "p.2",           # comparators
  "p.2–3",         # confounders_identified
  "p.3, p.6, p.8", # confounding_adjustment
  "p.6, p.8",      # balance_diagnostics
  "p.9, p.12",     # unmeasured_confounding
  "p.2–3",         # predefined_effect_mod
  "p.5, p.7–11",   # posthoc_effect_mod
  "p.3–4",         # method_type
  "p.3–5",         # method_clarity
  "p.3–6",         # outcome_method_alignment
  "p.3",           # hyperparameter_tuning
  "p.3",           # sample_splitting
  "p.3, p.5–6",    # multi_model_comparison
  "p.3–4",         # causal_estimand
  "p.2–6",         # survival_estimand
  "p.5–6, p.11",   # clinical_decision_readiness
  "p.5–7",         # uncertainty_quantification
  "p.7–12",        # effect_mod_plausibility
  "p.12"           # code_availability
)

ev_Zhu_2024 <- make_evidence("Zhu_2024",
  1L,
"Population-based retrospective cohort study using SEER 18 data; 5,352 elderly breast cancer patients were included.",
"Observational SEER cohort",

3L,
"Elderly female patients older than 70 years with ductal, lobular, or ductal-lobular breast carcinoma diagnosed from 2010 to 2017 after mastectomy were included, with detailed exclusion criteria.",
"Clear dataset, timeframe, age threshold, treatment scope, and IC/EC",

3L,
"Comparators were adjuvant chemotherapy versus no chemotherapy/control.",
"Comparators clearly defined; regimen-level chemotherapy details unavailable",

2L,
"Baseline variables included age, tumor size, lymph-node status, race, income, grade, tumor location, T/N/M/TNM stage, metastasis sites, surgery type, reconstruction, ER/PR/HER2 status, radiotherapy, and follow-up.",
"Covariates listed; limited causal justification",
  2L,
"IPTW was used to reduce selection bias when comparing patients whose actual treatment was consistent versus inconsistent with model recommendations.",
"Standard IPTW adjustment",

1L,
"IPTW-adjusted analyses were reported, but no main-text standardized mean difference or covariate balance table was clearly shown.",
"No main-text balance diagnostics",

2L,
"The authors acknowledged missing prognostic factors such as BRCA mutation and complications, which may affect recommendation performance.",
"Unmeasured confounding/data limitations acknowledged",

1L,
"BITES was applied using SEER-derived clinical covariates, but the paper did not present a pre-specified clinical effect-modifier plan.",
"Data-driven covariates; no pre-specified modifier plan",
 2L,
"Linear regression, IPTW-adjusted risk differences, and SurvSHAP(t) were used to interpret treatment recommendation behavior and features associated with chemotherapy benefit.",
"Post-hoc interpretation partially linked to treatment-effect heterogeneity",

3L,
"BITES estimated individualized treatment effects for survival data by comparing predicted 10-year restricted survival time under chemotherapy versus no chemotherapy.",
"Custom survival ITE/CATE method",

4L,
"The paper defines RST-based ITE, describes six trained models, train/test split, fivefold CV, BITES recommendation evaluation, IPTW adjustment, and interpretation using linear regression, IPTW-adjusted RD, and SurvSHAP(t).",
"Fully described survival ITE recommendation pipeline",

3L,
"Overall survival was modeled using survival distributions, 10-year restricted survival time, HR, RD, dRMST, IBS, KM curves, and IPTW-adjusted survival comparisons.",
"Survival-aware and aligned with OS/RST treatment benefit",
  2L,
"Fivefold cross-validation was used during training to tune model hyperparameters, but detailed hyperparameter search ranges were not fully reported.",
"CV used; tuning details limited",

2L,
"Patients were randomly allocated to a 65% training set and a 35% testing set; fivefold cross-validation was used within the training set.",
"Train/test split plus internal CV",

2L,
"Six models were trained and compared: BITES, CMHE, DeepSurv, CPH, RSF, and causal forest; NCCN guideline recommendations were also compared.",
"Systematic model and guideline comparison",

3L,
"ITE was defined using 10-year restricted survival time: the difference between predicted survival distributions under chemotherapy versus no chemotherapy.",
"Explicit counterfactual survival ITE estimand",
  3L,
"Overall survival was the outcome; ITE was defined using 10-year restricted survival time difference between predicted survival curves under chemotherapy versus no chemotherapy.",
"Defined survival estimand using OS and 10-year RST difference",

3L,
"Patients were divided into recommendation-consistent and recommendation-inconsistent groups, and BITES recommendations were evaluated using HR, IPTW-adjusted HR, RD, IPTW-adjusted RD, dRMST, KM curves, and comparison with NCCN guidelines.",
"Decision-ready treatment recommendation evaluation",

2L,
"Confidence intervals were reported for HR, RD, dRMST, integrated Brier scores, and subgroup/treatment-heterogeneity comparisons, but individual-level ITE uncertainty intervals were not reported.",
"Summary-level uncertainty; no individual ITE intervals",

1L,
"Treatment-benefit patterns were discussed for clinically plausible factors including breast cancer subtype, tumor size, positive lymph nodes, TNM stage, histological grade, immediate breast reconstruction, and contralateral prophylactic mastectomy.",
"Clinical plausibility briefly discussed for selected recommendation drivers",

1L,
"No code repository was reported; the study used publicly available SEER data.",
"No study-specific code repository reported"
)

ev_Zhu_2024$page_ref <- c(
  "p.2–3",          # study_design
  "p.2–3",          # patient_population
  "p.2–3",          # comparators
  "p.2, p.4–5",     # confounders_identified
  "p.3, p.5–6",     # confounding_adjustment
  "p.3, p.5–6",     # balance_diagnostics
  "p.9–10",         # unmeasured_confounding
  "p.2–4",          # predefined_effect_mod
  "p.6–8",          # posthoc_effect_mod
  "p.2–3",          # method_type
  "p.2–3, p.6–8",   # method_clarity
  "p.2–7",          # outcome_method_alignment
  "p.2–3",          # hyperparameter_tuning
  "p.2–3",          # sample_splitting
  "p.2–5",          # multi_model_comparison
  "p.2",            # causal_estimand
  "p.2–6",          # survival_estimand
  "p.3, p.5–6, p.8–9", # clinical_decision_readiness
  "p.5–7",          # uncertainty_quantification
  "p.6–9",          # effect_mod_plausibility
  "p.10"            # code_availability
)

ev_Schrod_2022 <- make_evidence("Schrod_2022",
  1L,
"Methods paper introducing BITES; simulations plus breast cancer application trained on Rotterdam Tumour Bank data and validated on GBSG Trial 2.",
"Methods paper with observational training cohort and randomized validation cohort",

3L,
"The breast cancer application used 1,545 node-positive breast cancer patients from the Rotterdam Tumour Bank for training and 686 patients from GBSG Trial 2 for independent validation; available variables included age, menopausal status, number of positive lymph nodes, tumor grade, progesterone receptor status, and estrogen receptor status.",
"Named cohorts with clear variables; limited full IC/EC detail",

3L,
"Treatment comparison was chemotherapy plus hormone therapy versus chemotherapy only.",
"Comparators clearly defined; regimen-level protocol details limited",

2L,
"The paper defines covariates and states strong ignorability, including unconfoundedness and overlap assumptions, as required for ITE identification.",
"Confounding assumptions stated; covariates defined",

2L,
"BITES regularizes latent representations using Integral Probability Metrics/Sinkhorn divergence to balance treated and non-treated patient distributions and reduce treatment-selection imbalance.",
"Representation balancing; not IPTW or matching",
  1L,
"No formal balance diagnostics such as standardized mean differences, overlap plots, or post-balancing covariate tables were reported.",
"No balance diagnostics",

1L,
"The paper relies on strong ignorability and notes that caution is needed when analyzing heavily confounded observational data; no sensitivity analysis for unmeasured confounding was performed.",
"Assumption acknowledged; no sensitivity analysis",

1L,
"BITES was applied using routine breast cancer variables from the Rotterdam and GBSG datasets, but no pre-specified clinical effect-modifier plan was presented.",
"Data-driven routine covariates; no pre-specified modifier plan",

2L,
"SHAP values were used to interpret the selected BITES model under no hormone treatment and hormone treatment, highlighting variables such as positive lymph nodes, menopausal status, and tumor grade.",
"SHAP-based post-hoc model interpretation partially linked to treatment heterogeneity",

3L,
"BITES combines Cox survival modeling, counterfactual reasoning, treatment-specific outcome heads, and IPM/Sinkhorn representation balancing to estimate individualized treatment effects from survival data.",
"Original custom survival ITE/CATE method",
  4L,
"BITES is fully specified with Cox proportional hazards loss, counterfactual potential-outcome framing, IPM/Sinkhorn representation balancing, treatment-specific outcome heads, implementation details, and treatment recommendation rules.",
"Fully described original BITES method",

3L,
"BITES was designed for right-censored time-to-event data using Cox survival loss, treatment-specific baseline hazards, RFS outcome, C-index, and Kaplan-Meier recommendation evaluation.",
"Survival-aware",

3L,
"Hyperparameter tuning was performed, and the implementation includes scheduled hyperparameter optimization using ray[tune].",
"Systematic hyperparameter optimization described",

2L,
"BITES was trained on Rotterdam Tumour Bank data and evaluated on the independent GBSG Trial 2 validation cohort.",
"Independent external validation cohort used",

2L,
"BITES was compared against Cox regression, DeepSurv, treatment-specific DeepSurv, random survival forests, SurvITE, and ITES in simulations and/or breast cancer validation.",
"Systematic model comparison",
 3L,
"ITE was explicitly defined under the potential-outcome framework as the difference between predicted outcomes under treatment versus control: Y(T=1)(x) - Y(T=0)(x).",
"Explicit potential-outcome ITE estimand",

3L,
"The breast cancer application used recurrence-free survival; BITES estimated time-dependent ITEs and assigned treatment based on survival probability/time-to-event predictions.",
"Defined survival/time-to-event treatment-benefit estimand",

2L,
"BITES produced treatment recommendations, and patients whose actual treatment matched the recommendation were compared with anti-recommended patients using Kaplan-Meier curves and log-rank p-values.",
"Recommendation groups evaluated, but not prospectively clinical-ready",

1L,
"The paper reports simulation variability, C-index, PEHE/correct assignment in simulations, KM curves, and p-values, but no individual-level ITE confidence intervals or bootstrap uncertainty intervals were reported.",
"Limited uncertainty reporting; no individual ITE intervals",

1L,
"SHAP interpretation suggested hormone treatment may mitigate menopause-related risk and that high tumor grade may reduce hormone-treatment benefit, with brief comparison to prior literature.",
"Clinical plausibility briefly discussed",

3L,
"BITES was provided as an easy-to-use Python implementation on GitHub with scheduled hyperparameter optimization.",
"Public code repository"
)

ev_Schrod_2022$page_ref <- c(
  "p.1, p.5–6",      # study_design
  "p.5",             # patient_population
  "p.5",             # comparators
  "p.2–3",           # confounders_identified
  "p.3–4",           # confounding_adjustment
  "p.3–4",           # balance_diagnostics
  "p.3, p.7",        # unmeasured_confounding
  "p.5–6",           # predefined_effect_mod
  "p.6",             # posthoc_effect_mod
  "p.2–4",           # method_type
  "p.2–4",           # method_clarity
  "p.2–6",           # outcome_method_alignment
  "p.1, p.4–5",      # hyperparameter_tuning
  "p.5–6",           # sample_splitting
  "p.4–6",           # multi_model_comparison
  "p.2–3",           # causal_estimand
  "p.2–6",           # survival_estimand
  "p.5–6",           # clinical_decision_readiness
  "p.4–6",           # uncertainty_quantification
  "p.6",             # effect_mod_plausibility
  "p.1, p.4"         # code_availability
)

ev_Hu_2021b <- make_evidence("Tabib_2020",
  1L,
"Methods paper with simulation study plus an observational NCDB case study of high-risk localized prostate cancer patients.",
"Methods paper with observational case study",

3L,
"The case study used 7,730 high-risk localized prostate cancer patients from NCDB diagnosed between 2004 and 2013 who received either EBRT + AD or EBRT + brachytherapy ± AD with at least 7920 cGy EBRT dose.",
"Clear dataset, disease setting, timeframe, treatment eligibility, and cohort definition",

3L,
"Comparators were EBRT plus androgen deprivation versus EBRT plus brachytherapy with or without androgen deprivation.",
"Comparators clearly defined",

2L,
"Pretreatment confounders included age, PSA, clinical T stage, Charlson-Deyo score, biopsy Gleason score, year of diagnosis, insurance, income, education, race, and ethnicity.",
"Confounders listed with clinical relevance",

2L,
"The methods use counterfactual survival modeling under weak unconfoundedness and positivity; AFT-BART-NP-PS additionally includes a Super Learner-estimated propensity score as a covariate to improve robustness and efficiency.",
"Propensity-score-informed causal outcome modeling",

1L,
"The main text notes baseline imbalance and discusses propensity score overlap, but no main-text standardized mean difference balance table is clearly reported.",
"No main-text SMD balance diagnostics",
  2L,
"The paper states weak unconfoundedness/no unmeasured confounders as a required causal assumption and conducts an exploratory sensitivity analysis by removing confounders in simulations.",
"Unmeasured confounding explicitly assessed in sensitivity analysis",

1L,
"The case study used clinically relevant pretreatment covariates, but no specific clinical effect-modifier plan or pre-specified modifier hypotheses were presented.",
"Data-driven covariates; no pre-specified modifier plan",

3L,
"The paper estimates individual survival treatment effects and examines treatment-effect heterogeneity by subgroups/quantiles of estimated benefit in the prostate cancer case study.",
"Post-hoc HTE subgroup analysis linked to ISTE",

3L,
"The paper evaluates multiple machine-learning estimators for individual survival treatment effects, including AFT-BART-NP, AFT-BART-NP-PS, AFT-BART-SP, RSF, DeepSurv, DR-DL, BJ-DL, TSHEE, and GAPH.",
"Custom survival ITE/HTE methods",

4L,
"The paper clearly defines causal assumptions, counterfactual survival estimand, ISTE based on median survival time, model-specific survival curve estimation, simulation settings, performance metrics, uncertainty coverage, and the NCDB prostate cancer case study.",
"Fully described methods comparison paper",

3L,
"The estimand and methods are explicitly designed for right-censored time-to-event outcomes using counterfactual survival curves and individual median survival-time contrasts.",
"Survival-aware",
  2L,
"Implementation details were reported for the compared methods, including BART, RSF, DeepSurv, TSHEE, DR-DL/BJ-DL, GAPH, AFT, and Cox models, but systematic hyperparameter tuning was not uniformly detailed for the case study.",
"Implementation details reported; tuning not uniformly detailed",

1L,
"No formal sample splitting, honesty, or cross-fitting was clearly described for the prostate cancer case study; repeated simulations were used for method evaluation.",
"No case-study sample splitting/cross-fitting",

2L,
"The paper compared multiple survival HTE estimators, including AFT-BART-NP, AFT-BART-NP-PS, AFT-BART-SP, RSF, DeepSurv, DR-DL, BJ-DL, TSHEE, GAPH, parametric AFT, and Cox models.",
"Comprehensive multi-method comparison",

3L,
"Individual survival treatment effect was explicitly defined in the counterfactual framework as the difference between median survival time under treatment and control conditional on covariates.",
"Explicit counterfactual ISTE estimand",

3L,
"The survival estimand was the individual/conditional survival treatment effect based on the difference in counterfactual median survival times, with right-censoring handled through survival outcome models.",
"Defined median-survival treatment-effect estimand",

2L,
"The paper links estimated ISTE to individualized treatment rules and expected regret, and applies the methods to prostate cancer treatment comparisons, but does not implement a prospective or deployable clinical decision rule.",
"ITE-informed treatment-rule evaluation; not clinically deployed",
  3L,
"AFT-BART-NP naturally produced posterior credible intervals for individual survival treatment effects, and the paper evaluated empirical/frequentist coverage of these intervals in simulations.",
"Individual-level uncertainty via Bayesian credible intervals",

1L,
"The case study examined survival treatment-effect heterogeneity across clinically relevant prostate cancer covariates, but detailed clinical plausibility of specific modifiers was limited.",
"Clinically relevant covariates discussed; limited modifier interpretation",

3L,
"Example code to replicate the simulation studies was provided on the first author's GitHub page.",
"Public GitHub code available"
)

ev_Hu_2021b$page_ref <- c(
  "p.1, p.3–4, p.18",   # study_design
  "p.18",               # patient_population
  "p.18",               # comparators
  "p.18",               # confounders_identified
  "p.4–7, p.18",        # confounding_adjustment
  "p.4, p.18",          # balance_diagnostics
  "p.4, p.18",          # unmeasured_confounding
  "p.18",               # predefined_effect_mod
  "p.18–22",            # posthoc_effect_mod
  "p.3–11",             # method_type
  "p.4–15, p.18–22",    # method_clarity
  "p.4–15",             # outcome_method_alignment
  "p.12–13",            # hyperparameter_tuning
  "p.12–15, p.18–22",   # sample_splitting
  "p.3, p.12–16",       # multi_model_comparison
  "p.4–5",              # causal_estimand
  "p.5",                # survival_estimand
  "p.14, p.18–22",      # clinical_decision_readiness
  "p.15–17",            # uncertainty_quantification
  "p.18–22",            # effect_mod_plausibility
  "p.13"                # code_availability
)

ev_Sauerbrei_2022 <- make_evidence("Sauerbrei_2022",
  2L,
"Individual participant data meta-analysis using eight randomized breast cancer trials from Breast Cancer DataMart; 5,727 tamoxifen-treated patients with estrogen receptor data were analyzed.",
"RCT IPD meta-analysis",

3L,
"Tamoxifen-treated early breast cancer patients from eight randomized trials were included; the paper reports patient/event counts by trial and ER distributions, but full trial-level eligibility criteria are not reproduced.",
"Clear RCT datasets and analysis population; full IC/EC not reproduced",

3L,
"Comparator was chemotherapy versus no chemotherapy among tamoxifen-treated patients, with disease-free survival analyzed by treatment group.",
"Comparators clearly defined; regimen-level protocol details not provided",
,
  NA_integer_,NA_character_,"RCT",NA_integer_,NA_character_,"RCT",
  NA_integer_,NA_character_,"RCT",NA_integer_,NA_character_,"RCT",
  3L,
"The study specifically investigated estrogen receptor value as a continuous treatment-effect modifier for chemotherapy benefit, motivated by prior breast cancer literature and concerns about categorizing continuous ER values.",
"Pre-specified continuous effect modifier with clinical rationale",

3L,
"The paper performed additional subgroup checks and sensitivity analyses, including ER subgroup analyses, studywise and pooled FP1/FP2 treatment-effect functions, and fixed versus random effects metaTEF comparisons.",
"Post-hoc/sensitivity effect-modification analyses linked to TEF",

1L,
"MFPI/metaTEF estimates a population-level treatment-effect function over estrogen receptor values; it does not estimate individual-level ITE/CATE.",
"Population-level treatment-effect function, not ITE/CATE",

4L,
"MFPI and metaTEF are fully described, including fractional polynomial transformations, treatment-effect function estimation, studywise TEFs, pointwise weighted meta-analysis, and fixed/random effects sensitivity analyses.",
"Fully described methods paper",

3L,
"The method is aligned with the survival outcome because DFS was analyzed using Cox/log-HR treatment-effect functions over continuous ER values, although the estimand is population/subgroup-level rather than individual ITE.",
"Survival-aware TEF; not individualized ITE",
  3L,
"Fractional-polynomial model selection was performed systematically using FP1/FP2 choices and flex variants, with FP2 and fixed/random effects metaTEF analyses used as sensitivity checks.",
"Systematic FP model selection and sensitivity analysis; not ML CV",

1L,
"No sample splitting, train/test validation, or cross-fitting was used; this was an IPD meta-analysis methods application rather than a prediction model.",
"No sample splitting",

2L,
"The paper compared studywise subgroup analyses, FP1 and FP2 treatment-effect functions, fixed and random effects metaTEF, and discussed metaTEF relative to meta-STEPP.",
"Limited method/sensitivity comparison",

2L,
"The estimand was an explicit treatment-effect function: the log-hazard ratio for chemotherapy versus no chemotherapy as a continuous function of estrogen receptor values.",
"Explicit population-level TEF; not individual ITE/CATE",

3L,
"Disease-free survival was the outcome, and treatment effects were estimated using Cox/log-hazard-ratio treatment-effect functions over continuous estrogen receptor values.",
"Defined survival TEF using DFS/log-HR",
 2L,
"The metaTEF identifies how chemotherapy benefit varies across continuous ER values and can inform subgroup/cutpoint discussions, but it does not implement a clinical treatment recommendation rule.",
"TEF can inform decisions; no explicit recommendation rule",

2L,
"Pointwise variances, weights, and 95% confidence intervals were reported for treatment-effect functions/metaTEF estimates.",
"TEF-level uncertainty reported",

1L,
"The clinical plausibility of ER as a chemotherapy effect modifier is discussed using prior breast cancer literature, but detailed biological interpretation is limited.",
"ER plausibility briefly discussed",

3L,
"The Stata program metatef is available on the SSC archive, and an annotated Stata do-file creating Figure 3 is provided in the appendix.",
"Public Stata code/tool available"
                                  )

ev_Sauerbrei_2022$page_ref <- c(
  "p.1, p.3–5",      # study_design
  "p.3–5",           # patient_population
  "p.3–5",           # comparators
  NA,                # confounders_identified
  NA,                # confounding_adjustment
  NA,                # balance_diagnostics
  NA,                # unmeasured_confounding
  "p.1–3, p.5",      # predefined_effect_mod
  "p.7–9",           # posthoc_effect_mod
  "p.6–8",           # method_type
  "p.6–10",          # method_clarity
  "p.3–8",           # outcome_method_alignment
  "p.6–9",           # hyperparameter_tuning
  "p.6–9",           # sample_splitting
  "p.7–11",          # multi_model_comparison
  "p.3, p.6–8",      # causal_estimand
  "p.3–8",           # survival_estimand
  "p.9–12",          # clinical_decision_readiness
  "p.7–9",           # uncertainty_quantification
  "p.3, p.5, p.9–10",# effect_mod_plausibility
  "p.12"             # code_availability
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
  3L,
"Posterior mean ITEs from AFT-BART were analyzed using a stepwise CART 'fit-the-fit' strategy to identify subgroups with enhanced or reduced LDCT versus CXR treatment effects.",
"CART subgroup discovery directly linked to ITE/HTE",
                            3L,"AFT-BART model... counterfactual framework... draw MCMC samples of the individual treatment effect for each participant","Custom CATE via AFT-BART + g-computation",
  4L,"log T = f(A, X) + W, where f(A,X) is the sum-of-trees AFT-BART model... centered Dirichlet process mixture... 1250 iterations with first 250 as burn-in","Architecture, loss, training fully described",
  3L,"AFT-BART model for censored survival data... censored failure times handled through data augmentation","Survival-aware; AFT handles censoring explicitly",
  3L,"we used cross-validation to select the optimal values for the operating parameters in AFT-BART... two settings for sigma prior, two values for m, three values for k","CV + grid search described; default justified",
  1L,
"No train/test split, cross-fitting, or external validation was reported; posterior MCMC sampling was used for uncertainty estimation, not sample splitting.",
"No sample splitting/cross-fitting",
  1L,"The BART model has been shown to have better prediction performance than many alternative ML techniques","References to prior comparisons but no head-to-head in this paper",
  3L,
"ATE and ITE were formally defined in a potential-outcomes framework using counterfactual failure times under LDCT versus CXR, with ITE defined as T_i(1) / T_i(0) and estimated by g-computation.",
"Formal potential-outcomes survival ITE estimand",

3L,
"The survival estimand was a ratio of counterfactual failure times comparing LDCT versus CXR, estimated separately for lung cancer-specific survival and overall survival.",
"Fully specified AFT/failure-time ratio estimand",

2L,
"The model identified subgroups, especially Asian and Black participants, with potentially enhanced overall survival benefit from LDCT, and the authors discuss implications for targeted trials and individualized screening, but no formal clinical decision rule was implemented.",
"Subgroup decision insight; no formal policy evaluation",

3L,
"Posterior distributions of ITE were obtained from MCMC counterfactual failure-time draws, with individual-level credible intervals plotted for lung cancer-specific and overall survival.",
"Individual-level Bayesian credible intervals",
                            1L,"Asian and Black (particularly those with pack-year >= 37 years and without emphysema) population benefited from LDCT","Clinical plausibility briefly discussed in relation to race and smoking",
  1L,"Statistical code for replication will be available from the corresponding author upon request","On-request only"
)

ev_Hu_2021$page_ref <- c(
  "p.3, p.12",          # study_design
  "p.3, p.12, p.16",   # patient_population
  "p.1, p.3",          # comparators
  NA,                  # confounders_identified
  NA,                  # confounding_adjustment
  NA,                  # balance_diagnostics
  NA,                  # unmeasured_confounding
  "p.3, p.16",         # predefined_effect_mod
  "p.5–6, p.13–15",    # posthoc_effect_mod
  "p.4–5",             # method_type
  "p.4–6",             # method_clarity
  "p.4–5",             # outcome_method_alignment
  "p.5",               # hyperparameter_tuning
  "p.4–6",             # sample_splitting
  "p.3",               # multi_model_comparison
  "p.4–5",             # causal_estimand
  "p.3–6, p.13",       # survival_estimand
  "p.6–8, p.14–15",    # clinical_decision_readiness
  "p.4–6, p.13–15",    # uncertainty_quantification
  "p.6–8, p.14–15",    # effect_mod_plausibility
  "p.1"                # code_availability
)

ev_Zhang_2012 <- make_evidence("Zhang_2012",
  2L,"data from a trial conducted by the National Surgical Adjuvant Breast and Bowel Project (NSABP) comparing L-phenylalanine mustard and 5-fluorouracil (PF) to PF plus tamoxifen (PFT)","RCT; methods paper using NSABP trial as illustration",
  2L,"n=1276 patients with complete information on age and PR... patients with primary operable breast cancer and positive nodes","Named dataset; some IC/EC; no full eligibility detail in this paper",
  2L,"PF to PF plus tamoxifen (PFT)","Named treatments; no dose/timing detail in this paper",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  NA_integer_,NA_character_,"RCT — confounding dims NA",
  1L,
"Age and progesterone receptor level were used based on prior NSABP findings of heterogeneity in response to PFT, but the paper does not present a new pre-specified HTE hypothesis or modifier plan.",
"Prior clinical/statistical motivation; not pre-specified in this paper",

3L,
"The NSABP application estimated optimal treatment-regime boundaries using age and progesterone receptor level, comparing regression, IPWE, AIPWE, and prior Gail-Simon/Fisher rules.",
"Treatment-rule/effect-modification analysis directly linked to optimal regime",

3L,
"The paper proposes a robust AIPWE/IPWE method for estimating the optimal treatment regime within a specified class of regimes under the potential-outcomes framework.",
"Custom causal optimal treatment-regime method",

4L,
"The paper formally defines treatment regimes, potential outcomes, the optimal regime estimand, IPWE and AIPWE estimators, double robustness, optimization strategy, simulations, and the NSABP application.",
"Fully described causal methods paper",

1L,
"The application used a binary endpoint: Y = 1 if the patient survived disease-free to 3 years and Y = 0 otherwise; it does not model survival time or censoring.",
"Binary fixed-time DFS outcome; not survival/TTE-aware",
                               2L,
"The paper describes optimization of IPWE/AIPWE over regime parameters using grid search and a genetic algorithm via the R package rgenoud, but no predictive hyperparameter tuning or cross-validation was used in the NSABP application.",
"Optimization described; no ML-style tuning/CV",

1L,
"No sample splitting, external validation, or cross-fitting was described for the NSABP application.",
"No sample splitting/cross-fitting",

2L,
"The paper compared regression-based regimes, IPWE, AIPWE, correct and misspecified outcome/propensity models in simulations, and compared estimated NSABP regimes with prior Fisher/Gail-Simon rules.",
"Systematic estimator/regime comparison",

3L,
"The causal estimand was the optimal treatment regime/value: the regime g that maximizes E[Y*(g)] under the potential-outcomes framework.",
"Explicit optimal treatment-regime causal estimand",

1L,
"The NSABP application used a binary fixed-time endpoint: Y = 1 if the patient survived disease-free to 3 years and Y = 0 otherwise; no survival time or censoring model was used.",
"Binary 3-year DFS endpoint; not survival/TTE-aware",
                              3L,
"The NSABP application derived explicit optimal treatment rules using age and progesterone receptor level, compared regression/IPWE/AIPWE rules with prior Fisher/Gail-Simon rules, and estimated the expected 3-year disease-free survival under each regime.",
"Explicit treatment rule with estimated policy value",

2L,
"The paper reported 95% confidence intervals for the estimated mean outcome under treatment regimes, including IPWE/AIPWE-based rules, but did not report individual-level treatment-effect uncertainty.",
"Regime-level uncertainty; no individual-level UQ",

1L,
"Age and progesterone receptor level were motivated by prior NSABP/Gail-Simon findings on heterogeneity in response to PFT, but detailed clinical or biological plausibility discussion was limited.",
"Prior clinical motivation; limited plausibility discussion",

1L,
"No public code repository or software implementation was mentioned.",
"No code repository""
)

ev_Zhang_2012$page_ref <- c(
  "p.1–2, p.9",       # study_design
  "p.2, p.9",         # patient_population
  "p.1–2, p.9",       # comparators
  NA,                 # confounders_identified
  NA,                 # confounding_adjustment
  NA,                 # balance_diagnostics
  NA,                 # unmeasured_confounding
  "p.1–2, p.9–10",    # predefined_effect_mod
  "p.9–10, p.15",     # posthoc_effect_mod
  "p.2–5",            # method_type
  "p.2–10",           # method_clarity
  "p.9–10",           # outcome_method_alignment
  "p.6–7, p.9–10",    # hyperparameter_tuning / optimization
  "p.9–10",           # sample_splitting
  "p.6–10, p.13–17",  # multi_model_comparison
  "p.2–5",            # causal_estimand
  "p.9–10",           # survival_estimand
  "p.9–10, p.15",     # clinical_decision_readiness
  "p.5, p.7–10, p.16–17", # uncertainty_quantification
  "p.1–2, p.9–10",    # effect_mod_plausibility
  "p.11–12"           # code_availability
)

ev_Shen_2018 <- make_evidence("Shen_2018",
  1L,"observational cohort... 3540 patients with clinically localized prostate cancer... received either surgery or radiation therapy","Observational; single institution (University of Michigan)",
  3L,"subset of 3540 patients with complete records... prostate cancer stage, PSA, Charlson comorbidity, Gleason, PNI, treatment date (1996-2013)","Clear IC/EC + dataset + timeframe; matches level 3",
  3L,"surgery or radiation therapy at time zero... neither has been established to be superior to the other","Defined treatments; clinical context given; no protocol-level dosing detail",
  2L,"treatment initiation time is a confounder for both treatment assignment and outcome... PSA, stage, Charlson, Gleason, PNI","Confounders listed; treatment date explicitly justified as confounder/auxiliary variable",
  3L,"Inverse probability weighting... logit P(A=1|W) = theta_0 + W^T theta... weights truncated at 15","IPW with auxiliary variable marginalisation; advanced/robust",
  1L,
"Table 3 reports baseline differences between surgery and radiation groups, but no formal post-weighting balance diagnostics such as standardized mean differences or overlap plots are reported.",
"Baseline imbalance described; no formal balance diagnostics",

2L,
"The method assumes no unmeasured confounders, and the authors acknowledge uncertainty in whether observed treatment-selection patterns are optimal; no formal unmeasured-confounding sensitivity analysis is performed.",
"NUCA assumption; no formal sensitivity analysis",

2L,
"The optimal regime was based on a selected set of clinically relevant variables, including age, PSA, stage, Charlson comorbidity score, Gleason grade, and PNI, while treatment date was handled as an auxiliary variable.",
"Selected clinical covariate set with rationale",

3L,
"Post-hoc displays of the estimated optimal regime showed treatment recommendation heterogeneity across age, PSA, PNI, and estimated restricted-mean-survival-time benefit.",
"Subgroup/regime visualization directly linked to HTE",

3L,
"RSFWB models treatment-specific counterfactual survival curves using inverse-probability weighted random survival forests and assigns treatment using g_opt(X) = I{mu1(X) > mu0(X)}.",
"Custom counterfactual survival optimal-regime method",
                               4L,"weighted bootstrap procedure... cforest() function... IBS-based 5-fold CV for tuning... B=200 bootstrap samples","Architecture, loss, training, tuning fully described",
  3L,"maximizing the restricted mean survival time... S^1(t) and S^0(t) from Kaplan-Meier on weighted bootstrap","Survival-aware; censoring handled via weighted RSF",
  3L,"5-fold cross-validation... grid search for mtry in {2,4,8,16} and ntree in {50,100}... smallest IBS applied","CV + grid search described; systematic",
  2L,"5-fold cross-validation used to avoid potential issue of overfitting","CV used for tuning; no formal cross-fitting of ITE estimates",
  2L,"compare results with Cox model, weighted Cox, regular RSF, and RSFWB","Systematic benchmarking against 3 competing methods",
  3L,"g_opt(X) = arg max_g mu^g... mu^g = E[min(T^g, tau)|X]... counterfactual framework... NUCA assumption stated","Formal potential outcomes; RMST-based ITE",
  3L,
"The optimal regime was formally defined in a counterfactual framework as the treatment rule maximizing restricted mean survival time: g_opt(X) = arg max_g mu_g, with mu_g based on E[min(T^g, tau)].",
"Formal potential-outcomes RMST optimal-regime estimand",

3L,
"The survival estimand was restricted mean survival time to clinical failure, using tau = 12 years in the prostate application and comparing mu1(X) versus mu0(X).",
"Fully specified RMST survival estimand",

3L,
"The prostate application produced an explicit treatment recommendation rule, including a 0.1-year minimum RMST-gain threshold for switching treatment, and estimated how many observed radiation and surgery patients would switch.",
"Explicit treatment-switch recommendation rule",
2L,"95% confidence interval for mu_g - mu_0 which is (0.032, 0.207)","ATE-level CI via bootstrap; no individual-level CI",
  1L,"for PNI positive group, radiation therapy is preferred for a large portion of the patient population","Clinical plausibility briefly discussed for age and PNI",
  1L,"we implement the proposed method in R, where we use cforest() function","No public repository mentioned; code described but not shared"
)

ev_Shen_2018$page_ref <- c(
  "p.1, p.10–11",       # study_design
  "p.10–11",            # patient_population
  "p.10–11",            # comparators
  "p.3–5, p.10–11",     # confounders_identified
  "p.4–6, p.11",        # confounding_adjustment
  "p.10–11",            # balance_diagnostics
  "p.3, p.11–13",       # unmeasured_confounding
  "p.3, p.10–11",       # predefined_effect_mod
  "p.11–12",            # posthoc_effect_mod
  "p.3–7",              # method_type
  "p.5–7, p.18",        # method_clarity
  "p.3–7, p.10–12",     # outcome_method_alignment
  "p.6, p.18",          # hyperparameter_tuning
  "p.6, p.18",          # sample_splitting
  "p.7–10, p.18–19",    # multi_model_comparison
  "p.3, p.7",           # causal_estimand
  "p.7, p.10–12",       # survival_estimand
  "p.11–12",            # clinical_decision_readiness
  "p.12",               # uncertainty_quantification
  "p.11–12",            # effect_mod_plausibility
  "p.6, p.13"           # code_availability
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
  "2 strategies for the feedforward neural networks (FNNs) based on a specific loss function in a continuous time framework (CoxCC and CoxTime), and Interaction Forests (IF)... We apply the methods to gene expression data from a meta-analysis of neoadjuvant trials that included 614 breast cancer patients... and data from an RCT including 1,574 patients",
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
  "Application of the methods to gene expression and clinical data from 2 breast cancer studies... p=1,689 genes for taxane dataset; p=462 genes plus clinicopathological variables for trastuzumab",
  "Input covariates pre-specified by gene expression + clinical variables from source datasets; no explicit HTE hypothesis pre-registered",
  # posthoc_effect_mod
  0L,
  "Feature importance or relative variable contribution was not reported; the paper states that future work could evaluate input-variable contributions and Effect Importance Measures.",
  "No SHAP or feature importance reported in current paper; mentioned as future work only",
  # method_type
  3L,
  "CoxCC that uses a loss function based on a case-control approximation... CoxTime, that is not constrained by the proportionality assumption... Interaction Forests (IF), a type of random survival forest specifically designed to model quantitative and qualitative interaction effects in bivariate splits",
  "Custom survival ITE/treatment-benefit modeling",
  # method_clarity
  4L,
  "LCoxCC = 1/n sum_{i:Di=1} log(sum_{j in R~i} exp[phi(Xj) - phi(Xi)])... LCoxTime = 1/n sum_{i:Di=1} log(sum_{j in R~i} exp[phi(ti, Xj) - phi(ti, Xi)])... Tree-Parzen algorithm... 200 hyperparameter sets sampled... Table 7 lists search space",
  "Loss functions fully specified for CoxCC and CoxTime; IF reference cited; hyperparameter search space in Table 7; architecture described",
  # outcome_method_alignment
  3L,
  "survival models based on neural networks (CoxCC and CoxTime) and random survival forests (Interaction Forests)... time-to-event outcomes... right-censored... G(t) = P(C>t) censoring survival function defined",
  "Survival-aware; all three methods handle censoring; TTE framework throughout",
  # hyperparameter_tuning
  4L,
  "Tree-Parzen hyperparameter search was performed with 200 sampled configurations using 5-fold CV on the training set; real patient datasets used double 5-fold CV to select hyperparameters and mimic external testing.",
  "Systematic TPE hyperparameter search with nested/double CV",
  # sample_splitting
  2L,
  "First, the real patient cohort is split into five folds: this is the outer loop. Then, we select one of the five folds as a test set and perform a 5-fold CV on the remaining data for each hyperparameter set: this is the inner loop",
  "Double 5-fold CV (nested CV) for real data; Bayesian posterior for simulations; no formal cross-fitting of nuisance models",
  # multi_model_comparison
  3L,
  "They compare survival models based on neural networks (CoxCC and CoxTime) and random survival forests (Interaction Forests). A Cox model, including an adaptive LASSO penalty, is used as a benchmark",
  "Systematic head-to-head: CoxCC, CoxTime, IF, ALASSO; simulation + two real datasets; comprehensive evaluation",
  # causal_estimand
  2L,
  "Treatment benefit was explicitly defined in a counterfactual framework as the difference in survival probability at a fixed time point under treatment versus control for the same patient.",
  "Explicit individualized counterfactual survival-benefit estimand",
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
  "The paper discusses biomarker-by-treatment interactions and suggests that machine-learning methods may capture nonlinear/high-order interactions, but specific biological plausibility of identified modifiers is not substantively interpreted",
  "Interaction effects mentioned but not interpreted clinically; no biological plausibility discussion of specific biomarkers",
  # code_availability
  1L,
  "No code repository mentioned in preprint",
  "arXiv preprint; biospear R package referenced for taxane data; no analysis code shared"
)

ev_Roblin_2025b$page_ref <- c(
  "p.1, p.6–7",      # study_design
  "p.6–7",           # patient_population
  "p.6–7",           # comparators
  NA,                # confounders_identified
  NA,                # confounding_adjustment
  NA,                # balance_diagnostics
  NA,                # unmeasured_confounding
  "p.4, p.6–7",      # predefined_effect_mod
  "p.13",            # posthoc_effect_mod
  "p.1, p.3–4, p.7–9", # method_type
  "p.3–4",           # method_clarity
  "p.2–4, p.7–9",    # outcome_method_alignment
  "p.4",             # hyperparameter_tuning
  "p.4",             # sample_splitting
  "p.1, p.3–4, p.9–12", # multi_model_comparison
  "p.1, p.7–9",      # causal_estimand
  "p.7–9, p.11–12",  # survival_estimand
  "p.1, p.12–13",    # clinical_decision_readiness
  "p.9, p.11–12",    # uncertainty_quantification
  "p.4, p.11–13",    # effect_mod_plausibility
  "p.6, p.13"        # code_availability
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
