---
title: "Tutorial for NetBIDShiny online server"
layout: default
nav_order: 3
permalink: /docs/tutorial4Online
---

# Tutorial for NetBIDshiny online server

The purpose of NetBIDshiny online server: 

**provide pre-generated network files from TCGA, TARGET and GTEx for quick start of NetBID2 analysis and demo datasets for quick familiar of diverse types of NetBID2 result visualization**.

The public online version of NetBIDshiny can be found here [NetBIDshiny_forMR](https://yulab-stjude.shinyapps.io/NetBIDshiny_forMR) and [NetBIDshiny_forVis](https://yulab-stjude.shinyapps.io/NetBIDshiny_forVis). 

----------
## Quick Navigation

- [NetBIDshiny_forMR: pre-generated network files and demo usage](#)

- [NetBIDshiny_forVis: demo datasets and usage](#)

----------

## NetBIDshiny_forMR: pre-generated network files and demo usage

### GTEx

- Original transcriptome dataset from [GTEx](https://www.genome.gov/Funded-Programs-Projects/Genotype-Tissue-Expression-Project)

- We have pre-generated 96 networks from 48 tissues with each tissue has one TF network and one SIG network. 

- The original sample information could be obtained from [GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt](https://storage.googleapis.com/gtex_analysis_v8/annotations/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt)

- The original gene expression profile could be obtained from [GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_reads.gct.gz](https://storage.googleapis.com/gtex_analysis_v8/rna_seq_data/GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_reads.gct.gz)

| Tissue Type  | Sample Size | No. of hubs (TF) | No. of hubs (SIG) | No. of total genes | No. of edges | Link to QC html                                                                                       |
|---------------------------------------|-------------|------------------|-------------------|--------------------|--------------|-------------------------------------------------------------------------------------------------------|
| Adipose_Subcutaneous                  | 763         | 1898             | 8482              | 32006              | 748106       | [Adipose_Subcutaneous](tutorial4Online/GTEx_network_QC/Adipose_SubcutaneousnetQC.html)                                   |
| Adipose_Visceral_Omentum              | 564         | 1880             | 8407              | 30679              | 527263       | [Adipose_Visceral_Omentum](tutorial4Online/GTEx_network_QC/Adipose_Visceral_OmentumnetQC.html)                           |
| Adrenal_Gland                         | 275         | 1880             | 8427              | 31202              | 741880       | [Adrenal_Gland](tutorial4Online/GTEx_network_QC/Adrenal_GlandnetQC.html)                                                 |
| Artery_Aorta                          | 450         | 1890             | 8440              | 31975              | 847886       | [Artery_Aorta](tutorial4Online/GTEx_network_QC/Artery_AortanetQC.html)                                                   |
| Artery_Coronary                       | 253         | 1891             | 8463              | 31946              | 953909       | [Artery_Coronary](tutorial4Online/GTEx_network_QC/Artery_CoronarynetQC.html)                                             |
| Artery_Tibial                         | 770         | 1887             | 8404              | 31357              | 792675       | [Artery_Tibial](tutorial4Online/GTEx_network_QC/Artery_TibialnetQC.html)                                                 |
| Brain_Amygdala                        | 177         | 1898             | 8395              | 30473              | 577441       | [Brain_Amygdala](tutorial4Online/GTEx_network_QC/Brain_AmygdalanetQC.html)                                               |
| Brain_Anterior_cingulate_cortex_BA24  | 213         | 1891             | 8283              | 29992              | 541470       | [Brain_Anterior_cingulate_cortex_BA24](tutorial4Online/GTEx_network_QC/Brain_Anterior_cingulate_cortex_BA24netQC.html)   |
| Brain_Caudate_basal_ganglia           | 291         | 1879             | 8168              | 29343              | 487432       | [Brain_Caudate_basal_ganglia](tutorial4Online/GTEx_network_QC/Brain_Caudate_basal_ganglianetQC.html)                     |
| Brain_Cerebellar_Hemisphere           | 263         | 1899             | 8421              | 31435              | 549276       | [Brain_Cerebellar_Hemisphere](tutorial4Online/GTEx_network_QC/Brain_Cerebellar_HemispherenetQC.html)                     |
| Brain_Cerebellum                      | 298         | 1896             | 8453              | 32346              | 559565       | [Brain_Cerebellum](tutorial4Online/GTEx_network_QC/Brain_CerebellumnetQC.html)                                           |
| Brain_Cortex                          | 325         | 1901             | 8421              | 30940              | 564814       | [Brain_Cortex](tutorial4Online/GTEx_network_QC/Brain_CortexnetQC.html)                                                   |
| Brain_Frontal_Cortex_BA9              | 425         | 1902             | 8405              | 30615              | 557345       | [Brain_Frontal_Cortex_BA9](tutorial4Online/GTEx_network_QC/Brain_Frontal_Cortex_BA9netQC.html)                           |
| Brain_Hippocampus                     | 243         | 1900             | 8336              | 30066              | 572179       | [Brain_Hippocampus](tutorial4Online/GTEx_network_QC/Brain_HippocampusnetQC.html)                                         |
| Brain_Hypothalamus                    | 236         | 1916             | 8412              | 30493              | 561057       | [Brain_Hypothalamus](tutorial4Online/GTEx_network_QC/Brain_HypothalamusnetQC.html)                                       |
| Brain_Nucleus_accumbens_basal_ganglia | 277         | 1887             | 8194              | 29520              | 511001       | [Brain_Nucleus_accumbens_basal_ganglia](tutorial4Online/GTEx_network_QC/Brain_Nucleus_accumbens_basal_ganglianetQC.html) |
| Brain_Putamen_basal_ganglia           | 232         | 1881             | 8096              | 28782              | 463706       | [Brain_Putamen_basal_ganglia](tutorial4Online/GTEx_network_QC/Brain_Putamen_basal_ganglianetQC.html)                     |
| Brain_Spinal_cord_cervical_c_1        | 182         | 1905             | 8448              | 30470              | 588439       | [Brain_Spinal_cord_cervical_c_1](tutorial4Online/GTEx_network_QC/Brain_Spinal_cord_cervical_c_1netQC.html)               |
| Brain_Substantia_nigra                | 164         | 1903             | 8445              | 30519              | 549376       | [Brain_Substantia_nigra](tutorial4Online/GTEx_network_QC/Brain_Substantia_nigranetQC.html)                               |
| Breast_Mammary_Tissue                 | 480         | 1902             | 8440              | 31452              | 570403       | [Breast_Mammary_Tissue](tutorial4Online/GTEx_network_QC/Breast_Mammary_TissuenetQC.html)                                 |
| Cells_EBV_transformed_lymphocytes     | 192         | 1881             | 8478              | 32226              | 970419       | [Cells_EBV_transformed_lymphocytes](tutorial4Online/GTEx_network_QC/Cells_EBV_transformed_lymphocytesnetQC.html)         |
| Cells_Transformed_fibroblasts         | 217         | 1854             | 8162              | 29528              | 395354       | [Cells_Transformed_fibroblasts](tutorial4Online/GTEx_network_QC/Cells_Transformed_fibroblastsnetQC.html)                 |
| Colon_Sigmoid                         | 389         | 1896             | 8492              | 31695              | 845675       | [Colon_Sigmoid](tutorial4Online/GTEx_network_QC/Colon_SigmoidnetQC.html)                                                 |
| Colon_Transverse                      | 432         | 1881             | 8281              | 30004              | 426845       | [Colon_Transverse](tutorial4Online/GTEx_network_QC/Colon_TransversenetQC.html)                                           |
| Esophagus_Gastroesophageal_Junction   | 401         | 1886             | 8456              | 31360              | 747937       | [Esophagus_Gastroesophageal_Junction](tutorial4Online/GTEx_network_QC/Esophagus_Gastroesophageal_JunctionnetQC.html)     |
| Esophagus_Mucosa                      | 622         | 1878             | 8409              | 30835              | 523176       | [Esophagus_Mucosa](tutorial4Online/GTEx_network_QC/Esophagus_MucosanetQC.html)                                           |
| Esophagus_Muscularis                  | 559         | 1878             | 8463              | 31255              | 644457       | [Esophagus_Muscularis](tutorial4Online/GTEx_network_QC/Esophagus_MuscularisnetQC.html)                                   |
| Heart_Atrial_Appendage                | 452         | 1868             | 8343              | 29946              | 549378       | [Heart_Atrial_Appendage](tutorial4Online/GTEx_network_QC/Heart_Atrial_AppendagenetQC.html)                               |
| Heart_Left_Ventricle                  | 689         | 1833             | 8005              | 27771              | 402611       | [Heart_Left_Ventricle](tutorial4Online/GTEx_network_QC/Heart_Left_VentriclenetQC.html)                                   |
| Liver                                 | 251         | 1840             | 8353              | 29931              | 685787       | [Liver](tutorial4Online/GTEx_network_QC/LivernetQC.html)                                                                 |
| Lung                                  | 867         | 1895             | 8559              | 32694              | 674020       | [Lung](tutorial4Online/GTEx_network_QC/LungnetQC.html)                                                                   |
| Minor_Salivary_Gland                  | 181         | 1894             | 8522              | 31892              | 706291       | [Minor_Salivary_Gland](tutorial4Online/GTEx_network_QC/Minor_Salivary_GlandnetQC.html)                                   |
| Muscle_Skeletal                       | 1132        | 1871             | 8253              | 29314              | 455219       | [Muscle_Skeletal](tutorial4Online/GTEx_network_QC/Muscle_SkeletalnetQC.html)                                             |
| Nerve_Tibial                          | 722         | 1897             | 8561              | 33487              | 716865       | [Nerve_Tibial](tutorial4Online/GTEx_network_QC/Nerve_TibialnetQC.html)                                                   |
| Ovary                                 | 195         | 1892             | 8503              | 32811              | 987284       | [Ovary](tutorial4Online/GTEx_network_QC/OvarynetQC.html)                                                                 |
| Pancreas                              | 360         | 1859             | 8316              | 29285              | 465621       | [Pancreas](tutorial4Online/GTEx_network_QC/PancreasnetQC.html)                                                           |
| Pituitary                             | 301         | 1911             | 8590              | 33284              | 846479       | [Pituitary](tutorial4Online/GTEx_network_QC/PituitarynetQC.html)                                                         |
| Prostate                              | 262         | 1910             | 8623              | 32798              | 847158       | [Prostate](tutorial4Online/GTEx_network_QC/ProstatenetQC.html)                                                           |
| Skin_Not_Sun_Exposed_Suprapubic       | 638         | 1907             | 8540              | 32304              | 718220       | [Skin_Not_Sun_Exposed_Suprapubic](tutorial4Online/GTEx_network_QC/Skin_Not_Sun_Exposed_SuprapubicnetQC.html)             |
| Skin_Sun_Exposed_Lower_leg            | 849         | 1905             | 8543              | 32263              | 630414       | [Skin_Sun_Exposed_Lower_leg](tutorial4Online/GTEx_network_QC/Skin_Sun_Exposed_Lower_legnetQC.html)                       |
| Small_Intestine_Terminal_Ileum        | 193         | 1902             | 8407              | 31013              | 502693       | [Small_Intestine_Terminal_Ileum](tutorial4Online/GTEx_network_QC/Small_Intestine_Terminal_IleumnetQC.html)               |
| Spleen                                | 260         | 1874             | 8550              | 32725              | 762506       | [Spleen](tutorial4Online/GTEx_network_QC/SpleennetQC.html)                                                               |
| Stomach                               | 381         | 1842             | 8216              | 29404              | 465055       | [Stomach](tutorial4Online/GTEx_network_QC/StomachnetQC.html)                                                             |
| Testis                                | 406         | 1956             | 9028              | 38136              | 598255       | [Testis](tutorial4Online/GTEx_network_QC/TestisnetQC.html)                                                               |
| Thyroid                               | 812         | 1902             | 8544              | 33244              | 739934       | [Thyroid](tutorial4Online/GTEx_network_QC/ThyroidnetQC.html)                                                             |
| Uterus                                | 166         | 1889             | 8512              | 32544              | 924647       | [Uterus](tutorial4Online/GTEx_network_QC/UterusnetQC.html)                                                               |
| Vagina                                | 173         | 1897             | 8548              | 32558              | 707535       | [Vagina](tutorial4Online/GTEx_network_QC/VaginanetQC.html)                                                               |
| Whole_Blood                           | 3288        | 1773             | 7869              | 27351              | 307150       | [Whole_Blood](tutorial4Online/GTEx_network_QC/Whole_BloodnetQC.html)                                                     |

### TARGET

- Original transcriptome dataset from [TARGET](https://portal.gdc.cancer.gov/)

- We have pre-generated 102 networks from 51 cell lines with each cell line has one TF network and one SIG network.

| File Name| Sample Size | No. of hubs (TF) | No. of hubs (SIG) | No. of total genes | No. of edges | Link to QC html                                                                                        |
|-----------------------------------------------------|-------------|------------------|-------------------|--------------------|--------------|--------------------------------------------------------------------------------------------------------|
| ALL_log2TP50M.185_all_21659_21659_185               | 185         | 1643             | 6247              | 29545              | 830213       | [ALL-all](tutorial4Online/tutorial4Online/TARGET_network_QC/ALL_log2TP50M.185_all_21659_21659_185netQC.html)                              |
| ALL_log2TP50M.185_D_21585_21585_126                 | 126         | 1639             | 6277              | 29499              | 899561       | [ALL-D](tutorial4Online/TARGET_network_QC/ALL_log2TP50M.185_D_21585_21585_126netQC.html)                                  |
| ALL_log2TP50M.185_ETV6-RUNX1_21783_21783_19         | 19          | 1679             | 6436              | 29897              | 1542021      | [ALL-ETV6-RUNX1](tutorial4Online/TARGET_network_QC/ALL_log2TP50M.185_ETV6-RUNX1_21783_21783_19netQC.html)                 |
| ALL_log2TP50M.185_Hyperdiploid_21802_21802_22       | 22          | 1650             | 6294              | 29737              | 977288       | [ALL-Hyperdiploid](tutorial4Online/TARGET_network_QC/ALL_log2TP50M.185_Hyperdiploid_21802_21802_22netQC.html)             |
| ALL_log2TP50M.185_NoneOfKnownSubType_21519_21519_88 | 88          | 1644             | 6263              | 29424              | 797609       | [ALL-NoneOfKnownSubType](tutorial4Online/TARGET_network_QC/ALL_log2TP50M.185_NoneOfKnownSubType_21519_21519_88netQC.html) |
| ALL_log2TP50M.185_R_21299_21299_59                  | 59          | 1639             | 6199              | 29135              | 696241       | [ALL-R](tutorial4Online/TARGET_network_QC/ALL_log2TP50M.185_R_21299_21299_59netQC.html)                                   |
| ALL_log2TP50M.185_TCF3.fusion_21489_21489_20        | 20          | 1633             | 6259              | 29361              | 1436612      | [ALL-TCF3.fusion](tutorial4Online/TARGET_network_QC/ALL_log2TP50M.185_TCF3.fusion_21489_21489_20netQC.html)               |
| ALL_log2TP50M.185_TrisomyChr4_10_21944_21944_19     | 19          | 1651             | 6433              | 30025              | 1173781      | [ALL-TrisomyChr4-10](tutorial4Online/TARGET_network_QC/ALL_log2TP50M.185_TrisomyChr4_10_21944_21944_19netQC.html)         |
| AML_log2TP50M.202_all_20615_20615_202               | 202         | 1565             | 5886              | 28047              | 739275       | [AML-all](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_all_20615_20615_202netQC.html)                              |
| AML_log2TP50M.202_D_20573_20573_157                 | 157         | 1557             | 5856              | 27964              | 738591       | [AML-D](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_D_20573_20573_157netQC.html)                                  |
| AML_log2TP50M.202_HighRisk_20606_20606_14           | 14          | 1541             | 5843              | 27989              | 10295917     | [AML-HighRisk](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_HighRisk_20606_20606_14netQC.html)                     |
| AML_log2TP50M.202_Inv_16_20301_20301_34             | 34          | 1483             | 5616              | 27306              | 573949       | [AML-Inv-16](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_Inv_16_20301_20301_34netQC.html)                         |
| AML_log2TP50M.202_LowRisk_20414_20414_80            | 80          | 1530             | 5788              | 27721              | 706094       | [AML-LowRisk](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_LowRisk_20414_20414_80netQC.html)                       |
| AML_log2TP50M.202_M1_20624_20624_49                 | 49          | 1568             | 5946              | 28134              | 760174       | [AML-M1](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_M1_20624_20624_49netQC.html)                                 |
| AML_log2TP50M.202_M1_20772_20772_23                 | 23          | 1582             | 5936              | 28266              | 788584       | [AML-M1](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_M1_20772_20772_23netQC.html)                                 |
| AML_log2TP50M.202_M2_20624_20624_49                 | 49          | 1568             | 5946              | 28134              | 760174       | [AML-M2](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_M2_20624_20624_49netQC.html)                                 |
| AML_log2TP50M.202_M4_21055_21055_57                 | 57          | 1529             | 5755              | 28315              | 728678       | [AML-M4](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_M4_21055_21055_57netQC.html)                                 |
| AML_log2TP50M.202_M5_20649_20649_36                 | 36          | 1577             | 5904              | 28118              | 607962       | [AML-M5](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_M5_20649_20649_36netQC.html)                                 |
| AML_log2TP50M.202_MLL_20716_20716_39                | 39          | 1576             | 5912              | 28187              | 580075       | [AML-MLL](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_MLL_20716_20716_39netQC.html)                               |
| AML_log2TP50M.202_NormalCytogenetic_20682_20682_38  | 38          | 1582             | 5928              | 28177              | 610264       | [AML-NormalCytogenetic](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_NormalCytogenetic_20682_20682_38netQC.html)   |
| AML_log2TP50M.202_OtherCytogenetic_20730_20730_46   | 46          | 1581             | 5955              | 28260              | 697323       | [AML-OtherCytogenetic](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_OtherCytogenetic_20730_20730_46netQC.html)     |
| AML_log2TP50M.202_R_21425_21425_45                  | 45          | 1588             | 6004              | 29017              | 715123       | [AML-R](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_R_21425_21425_45netQC.html)                                   |
| AML_log2TP50M.202_StandardRisk_20772_20772_96       | 96          | 1589             | 5961              | 28321              | 785297       | [AML-StandardRisk](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_StandardRisk_20772_20772_96netQC.html)             |
| AML_log2TP50M.202_t_8to21_21352_21352_28            | 28          | 1557             | 5916              | 28792              | 711192       | [AML-t-8to21](tutorial4Online/TARGET_network_QC/AML_log2TP50M.202_t_8to21_21352_21352_28netQC.html)                       |
| CCSK_log2TP50M.13_all_22209_22209_13                | 13          | 1675             | 6242              | 30126              | 6201442      | [CCSK-all](tutorial4Online/TARGET_network_QC/CCSK_log2TP50M.13_all_22209_22209_13netQC.html)                              |
| NBL_log2TP50M.167_all_22031_22031_167               | 167         | 1691             | 6321              | 30030              | 864162       | [NBL-all](tutorial4Online/TARGET_network_QC/NBL_log2TP50M.167_all_22031_22031_167netQC.html)                              |
| NBL_log2TP50M.167_Diagnosis_22052_22052_158         | 158         | 1691             | 6318              | 30055              | 914270       | [NBL-Diagnosis](tutorial4Online/TARGET_network_QC/NBL_log2TP50M.167_Diagnosis_22052_22052_158netQC.html)                  |
| NBL_log2TP50M.167_MKI_High_22135_22135_35           | 35          | 1684             | 6286              | 30087              | 641363       | [NBL-MKI-High](tutorial4Online/TARGET_network_QC/NBL_log2TP50M.167_MKI_High_22135_22135_35netQC.html)                     |
| NBL_log2TP50M.167_MKI_Intermediate_23049_23049_48   | 48          | 1702             | 6398              | 31144              | 776178       | [NBL-MKI-Intermediate](tutorial4Online/TARGET_network_QC/NBL_log2TP50M.167_MKI_Intermediate_23049_23049_48netQC.html)     |
| NBL_log2TP50M.167_MKI_Low_22479_22479_52            | 52          | 1681             | 6309              | 30451              | 826050       | [NBL-MKI-Low](tutorial4Online/TARGET_network_QC/NBL_log2TP50M.167_MKI_Low_22479_22479_52netQC.html)                       |
| NBL_log2TP50M.167_MYCN_Amp_22417_22417_36           | 36          | 1691             | 6292              | 30370              | 654906       | [NBL-MYCN-Amp](tutorial4Online/TARGET_network_QC/NBL_log2TP50M.167_MYCN_Amp_22417_22417_36netQC.html)                     |
| NBL_log2TP50M.167_MYCN_NonAmp_22979_22979_130       | 130         | 1691             | 6326              | 30990              | 934672       | [NBL-MYCN-NonAmp](tutorial4Online/TARGET_network_QC/NBL_log2TP50M.167_MYCN_NonAmp_22979_22979_130netQC.html)              |
| OS_log2TP50M.76_all_25328_25328_76                  | 76          | 1513             | 5929              | 32770              | 1125398      | [OS-all](tutorial4Online/TARGET_network_QC/OS_log2TP50M.76_all_25328_25328_76netQC.html)                                  |
| OS_log2TP50M.76_Metastatic_23065_23065_18           | 18          | 1566             | 6092              | 30723              | 1527570      | [OS-Metastatic](tutorial4Online/TARGET_network_QC/OS_log2TP50M.76_Metastatic_23065_23065_18netQC.html)                    |
| OS_log2TP50M.76_NonMetastatic_25600_25600_57        | 57          | 1529             | 6048              | 33177              | 905869       | [OS-NonMetastatic](tutorial4Online/TARGET_network_QC/OS_log2TP50M.76_NonMetastatic_25600_25600_57netQC.html)              |
| TALL_log2TP50M.261_all_27218_27218_261              | 261         | 1653             | 6271              | 35102              | 1068228      | [TALL-all](tutorial4Online/TARGET_network_QC/TALL_log2TP50M.261_all_27218_27218_261netQC.html)                            |
| TALL_log2TP50M.261_LMO2_LYL1_26382_26382_18         | 18          | 1653             | 6271              | 34306              | 1923168      | [TALL-LMO2-LYL1](tutorial4Online/TARGET_network_QC/TALL_log2TP50M.261_LMO2_LYL1_26382_26382_18netQC.html)                 |
| TALL_log2TP50M.261_TAL1_2_27164_27164_95            | 95          | 1653             | 6271              | 35088              | 1031057      | [TALL-TAL1-2](tutorial4Online/TARGET_network_QC/TALL_log2TP50M.261_TAL1_2_27164_27164_95netQC.html)                       |
| TALL_log2TP50M.261_TAL1_27169_27169_87              | 87          | 1653             | 6271              | 35092              | 1032180      | [TALL-TAL1](tutorial4Online/TARGET_network_QC/TALL_log2TP50M.261_TAL1_27169_27169_87netQC.html)                           |
| TALL_log2TP50M.261_TLX1_3_27189_27189_70            | 70          | 1653             | 6271              | 35113              | 950515       | [TALL-TLX1-3](tutorial4Online/TARGET_network_QC/TALL_log2TP50M.261_TLX1_3_27189_27189_70netQC.html)                       |
| TALL_log2TP50M.261_TLX1_3_HOXA_27202_27202_102      | 102         | 1653             | 6271              | 35125              | 1145757      | [TALL-TLX1-3-HOXA](tutorial4Online/TARGET_network_QC/TALL_log2TP50M.261_TLX1_3_HOXA_27202_27202_102netQC.html)            |
| TALL_log2TP50M.261_USP7.MU_26972_26972_33           | 33          | 1653             | 6271              | 34894              | 776229       | [TALL-USP7.MU](tutorial4Online/TARGET_network_QC/TALL_log2TP50M.261_USP7.MU_26972_26972_33netQC.html)                     |
| TALL_log2TP50M.261_USP7.WT_27220_27220_227          | 227         | 1653             | 6271              | 35125              | 1089701      | [TALL-USP7.WT](tutorial4Online/TARGET_network_QC/TALL_log2TP50M.261_USP7.WT_27220_27220_227netQC.html)                    |
| WT_log2TP50M.124_all_22067_22067_124                | 124         | 1692             | 6309              | 30068              | 1188700      | [WT-all](tutorial4Online/TARGET_network_QC/WT_log2TP50M.124_all_22067_22067_124netQC.html)                                |
| WT_log2TP50M.124_D_22064_22064_118                  | 118         | 1690             | 6298              | 30049              | 1153750      | [WT-D](tutorial4Online/TARGET_network_QC/WT_log2TP50M.124_D_22064_22064_118netQC.html)                                    |
| WT_log2TP50M.124_DAWT_21818_21818_38                | 38          | 1693             | 6274              | 29778              | 563191       | [WT-DAWT](tutorial4Online/TARGET_network_QC/WT_log2TP50M.124_DAWT_21818_21818_38netQC.html)                               |
| WT_log2TP50M.124_FHWT_22093_22093_86                | 86          | 1693             | 6308              | 30093              | 1031527      | [WT-FHWT](tutorial4Online/TARGET_network_QC/WT_log2TP50M.124_FHWT_22093_22093_86netQC.html)                               |
| WT_log2TP50M.124_StageI_21998_21998_16              | 16          | 1690             | 6324              | 30012              | 2111918      | [WT-StageI](tutorial4Online/TARGET_network_QC/WT_log2TP50M.124_StageI_21998_21998_16netQC.html)                           |
| WT_log2TP50M.124_StageII_22037_22037_53             | 53          | 1692             | 6305              | 30029              | 699740       | [WT-StageII](tutorial4Online/TARGET_network_QC/WT_log2TP50M.124_StageII_22037_22037_53netQC.html)                         |
| WT_log2TP50M.124_StageIII_21969_21969_36            | 36          | 1700             | 6325              | 29991              | 612622       | [WT-StageIII](tutorial4Online/TARGET_network_QC/WT_log2TP50M.124_StageIII_21969_21969_36netQC.html)                       |
| WT_log2TP50M.124_StageIV_V_21965_21965_19           | 19          | 1689             | 6281              | 29931              | 822950       | [WT-StageIV-V](tutorial4Online/TARGET_network_QC/WT_log2TP50M.124_StageIV_V_21965_21965_19netQC.html)                     |

### TCGA

- Original transcriptome dataset from [TCGA](https://portal.gdc.cancer.gov/)

- We have pre-generated 92 networks from 46 tumor types with each has one TF network and one SIG network.


| File Name| Sample Size | No. of hubs (TF) | No. of hubs (SIG) | No. of total genes | No. of edges | Link to QC html                                                 |
|----------------------------|-------------|------------------|-------------------|--------------------|--------------|-----------------------------------------------------------------|
| ACC.T_33753_15879_77       | 77          | 15727            | 15727             | 47181              | 1042640      | [ACC.T](tutorial4Online/TCGA_network_QC/ACC.T_33753_15879_77netQC.html)            |
| BLCA.T_34890_16552_348     | 348         | 1654             | 6152              | 24310              | 1153515      | [BLCA.T](tutorial4Online/TCGA_network_QC/BLCA.T_34890_16552_348netQC.html)         |
| BRCA.N_35169_16784_109     | 109         | 1650             | 6231              | 24664              | 1410937      | [BRCA.N](tutorial4Online/TCGA_network_QC/BRCA.N_35169_16784_109netQC.html)         |
| BRCA.T_35306_16556_1058    | 1058        | 1654             | 6110              | 24080              | 701060       | [BRCA.T](tutorial4Online/TCGA_network_QC/BRCA.T_35306_16556_1058netQC.html)        |
| CESC.T_34635_16448_241     | 241         | 1651             | 6130              | 24215              | 1495925      | [CESC.T](tutorial4Online/TCGA_network_QC/CESC.T_34635_16448_241netQC.html)         |
| CHOL.T_34535_16625_35      | 35          | 1642             | 6113              | 24306              | 595519       | [CHOL.T](tutorial4Online/TCGA_network_QC/CHOL.T_34535_16625_35netQC.html)          |
| COADREAD.N_34500_16548_50  | 50          | 1638             | 6174              | 24341              | 965465       | [COADREAD.N](tutorial4Online/TCGA_network_QC/COADREAD.N_34500_16548_50netQC.html)  |
| COADREAD.T_34941_16029_568 | 568         | 1640             | 5887              | 22976              | 568255       | [COADREAD.T](tutorial4Online/TCGA_network_QC/COADREAD.T_34941_16029_568netQC.html) |
| DLBC.T_34146_15754_45      | 45          | 1639             | 5978              | 23265              | 610360       | [DLBC.T](tutorial4Online/TCGA_network_QC/DLBC.T_34146_15754_45netQC.html)          |
| ESCA.T_36407_17732_70      | 70          | 1693             | 6373              | 25796              | 1728755      | [ESCA.T](tutorial4Online/TCGA_network_QC/ESCA.T_36407_17732_70netQC.html)          |
| GBM.T_35189_16907_116      | 116         | 1675             | 6191              | 24773              | 2081008      | [GBM.T](tutorial4Online/TCGA_network_QC/GBM.T_35189_16907_116netQC.html)           |
| HNSC.N_34287_16805_41      | 41          | 1654             | 6133              | 24557              | 952649       | [HNSC.N](tutorial4Online/TCGA_network_QC/HNSC.N_34287_16805_41netQC.html)          |
| HNSC.T_35077_16623_477     | 477         | 1657             | 6117              | 24280              | 993816       | [HNSC.T](tutorial4Online/TCGA_network_QC/HNSC.T_35077_16623_477netQC.html)         |
| KICH.N_34695_16995_25      | 25          | 1654             | 6194              | 24790              | 836699       | [KICH.N](tutorial4Online/TCGA_network_QC/KICH.N_34695_16995_25netQC.html)          |
| KICH.T_34369_16307_66      | 66          | 1623             | 6091              | 24017              | 1218200      | [KICH.T](tutorial4Online/TCGA_network_QC/KICH.T_34369_16307_66netQC.html)          |
| KIRC.N_34806_16840_72      | 72          | 1642             | 6216              | 24691              | 1291690      | [KIRC.N](tutorial4Online/TCGA_network_QC/KIRC.N_34806_16840_72netQC.html)          |
| KIRC.T_35436_16605_512     | 512         | 1646             | 6108              | 24075              | 725352       | [KIRC.T](tutorial4Online/TCGA_network_QC/KIRC.T_35436_16605_512netQC.html)         |
| KIRP.N_34657_16795_32      | 32          | 1637             | 6162              | 24531              | 740083       | [KIRP.N](tutorial4Online/TCGA_network_QC/KIRP.N_34657_16795_32netQC.html)          |
| KIRP.T_34670_16163_281     | 281         | 1621             | 6033              | 23544              | 780254       | [KIRP.T](tutorial4Online/TCGA_network_QC/KIRP.T_34670_16163_281netQC.html)         |
| LAML.T_33701_16232_130     | 130         | 1563             | 5951              | 23746              | 2011399      | [LAML.T](tutorial4Online/TCGA_network_QC/LAML.T_33701_16232_130netQC.html)         |
| LGG.T_35181_16688_505      | 505         | 1666             | 6093              | 24281              | 798548       | [LGG.T](tutorial4Online/TCGA_network_QC/LGG.T_35181_16688_505netQC.html)           |
| LIHC.N_32688_15698_48      | 48          | 1551             | 5933              | 23158              | 918499       | [LIHC.N](tutorial4Online/TCGA_network_QC/LIHC.N_32688_15698_48netQC.html)          |
| LIHC.T_34138_16137_255     | 255         | 1610             | 6080              | 23794              | 1162974      | [LIHC.T](tutorial4Online/TCGA_network_QC/LIHC.T_34138_16137_255netQC.html)         |
| LUAD.N_34391_16621_58      | 58          | 1618             | 6133              | 24365              | 1213383      | [LUAD.N](tutorial4Online/TCGA_network_QC/LUAD.N_34391_16621_58netQC.html)          |
| LUAD.T_35321_16788_493     | 493         | 1661             | 6198              | 24618              | 1069901      | [LUAD.T](tutorial4Online/TCGA_network_QC/LUAD.T_35321_16788_493netQC.html)         |
| LUSC.N_35008_16941_47      | 47          | 1637             | 6205              | 24754              | 1034058      | [LUSC.N](tutorial4Online/TCGA_network_QC/LUSC.N_35008_16941_47netQC.html)          |
| LUSC.T_35519_17032_498     | 498         | 1674             | 6246              | 24949              | 1511084      | [LUSC.T](tutorial4Online/TCGA_network_QC/LUSC.T_35519_17032_498netQC.html)         |
| MESO.T_34729_16696_82      | 82          | 1664             | 6139              | 24499              | 1750719      | [MESO.T](tutorial4Online/TCGA_network_QC/MESO.T_34729_16696_82netQC.html)          |
| OV.T_35775_17075_403       | 403         | 1666             | 6243              | 24950              | 1171973      | [OV.T](tutorial4Online/TCGA_network_QC/OV.T_35775_17075_403netQC.html)             |
| PAAD.T_35229_16763_176     | 176         | 1661             | 6252              | 24668              | 1299578      | [PAAD.T](tutorial4Online/TCGA_network_QC/PAAD.T_35229_16763_176netQC.html)         |
| PCPG.T_34539_16173_170     | 170         | 1653             | 6072              | 23828              | 1047047      | [PCPG.T](tutorial4Online/TCGA_network_QC/PCPG.T_34539_16173_170netQC.html)         |
| PRAD.N_34860_16629_52      | 52          | 1662             | 6207              | 24477              | 1037788      | [PRAD.N](tutorial4Online/TCGA_network_QC/PRAD.N_34860_16629_52netQC.html)          |
| PRAD.T_34895_16552_469     | 469         | 1653             | 5983              | 23597              | 565336       | [PRAD.T](tutorial4Online/TCGA_network_QC/PRAD.T_34895_16552_469netQC.html)         |
| SARC.T_35040_16566_249     | 249         | 1665             | 6139              | 24341              | 1358015      | [SARC.T](tutorial4Online/TCGA_network_QC/SARC.T_35040_16566_249netQC.html)         |
| SKCM.M_34930_16593_355     | 355         | 1656             | 6133              | 24372              | 1537624      | [SKCM.M](tutorial4Online/TCGA_network_QC/SKCM.M_34930_16593_355netQC.html)         |
| SKCM.T_34695_16581_96      | 96          | 1653             | 6125              | 24355              | 1617019      | [SKCM.T](tutorial4Online/TCGA_network_QC/SKCM.T_34695_16581_96netQC.html)          |
| STAD.N_35194_16921_22      | 22          | 1654             | 6214              | 24756              | 2686623      | [STAD.N](tutorial4Online/TCGA_network_QC/STAD.N_35194_16921_22netQC.html)          |
| STAD.T_36385_17413_247     | 247         | 1682             | 6344              | 25437              | 1826747      | [STAD.T](tutorial4Online/TCGA_network_QC/STAD.T_36385_17413_247netQC.html)         |
| TGCT.T_36008_17274_144     | 144         | 1716             | 6389              | 25358              | 1208686      | [TGCT.T](tutorial4Online/TCGA_network_QC/TGCT.T_36008_17274_144netQC.html)         |
| THCA.N_34727_16599_57      | 57          | 1635             | 6158              | 24379              | 1135046      | [THCA.N](tutorial4Online/TCGA_network_QC/THCA.N_34727_16599_57netQC.html)          |
| THCA.T_34492_16400_489     | 489         | 1619             | 5954              | 23567              | 648107       | [THCA.T](tutorial4Online/TCGA_network_QC/THCA.T_34492_16400_489netQC.html)         |
| THYM.T_34883_16290_111     | 111         | 1652             | 6151              | 23952              | 857301       | [THYM.T](tutorial4Online/TCGA_network_QC/THYM.T_34883_16290_111netQC.html)         |
| UCEC.N_35024_16794_35      | 35          | 1632             | 6108              | 24434              | 760476       | [UCEC.N](tutorial4Online/TCGA_network_QC/UCEC.N_35024_16794_35netQC.html)          |
| UCEC.T_35791_16480_529     | 529         | 1675             | 6126              | 24018              | 822108       | [UCEC.T](tutorial4Online/TCGA_network_QC/UCEC.T_35791_16480_529netQC.html)         |
| UCS.T_35280_16963_55       | 55          | 1695             | 6281              | 24931              | 1022125      | [UCS.T](tutorial4Online/TCGA_network_QC/UCS.T_35280_16963_55netQC.html)            |
| UVM.T_33177_15751_76       | 76          | 1612             | 5892              | 23244              | 1144831      | [UVM.T](tutorial4Online/TCGA_network_QC/UVM.T_33177_15751_76netQC.html)            |


## NetBIDshiny_forVis: demo datasets and usage

Two demo datasets are available at the online version.

1. the human MB (medulloblastoma) demo dataset from GEO database as in NetBID2: [GSE116028](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE116028), with network files generated by using the same dataset. The task was to find drivers in Group4 (G4) vs others. 

2. the mouse BPD (bronchopulmonary dysplasia) demo dataset from GEO database [GSE25286](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE25286), with network files generated by using normal human lung tissue from GTEx (human). The Task was to find drivers in BPD vs normal in P14. 





