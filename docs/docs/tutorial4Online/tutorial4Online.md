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



### TARGET

- Original transcriptome dataset from [TARGET](https://portal.gdc.cancer.gov/)

- We have pre-generated 102 networks from 51 cell lines with each cell line has one TF network and one SIG network.

| Tissue Type                                         | Sample Size | No. of hubs (TF) | No. of hubs (SIG) | No. of total genes | No. of edges | Link to QC html                                                              |
|-----------------------------------------------------|-------------|------------------|-------------------|--------------------|--------------|------------------------------------------------------------------------------|
| ALL_log2TP50M.185_all_21659_21659_185               | 185         | 1643             | 6247              | 29545              | 830213       | TARGET_network_QC/ALL_log2TP50M.185_all_21659_21659_185QC.html               |
| ALL_log2TP50M.185_D_21585_21585_126                 | 126         | 1639             | 6277              | 29499              | 899561       | TARGET_network_QC/ALL_log2TP50M.185_D_21585_21585_126QC.html                 |
| ALL_log2TP50M.185_ETV6-RUNX1_21783_21783_19         | 19          | 1679             | 6436              | 29897              | 1542021      | TARGET_network_QC/ALL_log2TP50M.185_ETV6-RUNX1_21783_21783_19QC.html         |
| ALL_log2TP50M.185_Hyperdiploid_21802_21802_22       | 22          | 1650             | 6294              | 29737              | 977288       | TARGET_network_QC/ALL_log2TP50M.185_Hyperdiploid_21802_21802_22QC.html       |
| ALL_log2TP50M.185_NoneOfKnownSubType_21519_21519_88 | 88          | 1644             | 6263              | 29424              | 797609       | TARGET_network_QC/ALL_log2TP50M.185_NoneOfKnownSubType_21519_21519_88QC.html |
| ALL_log2TP50M.185_R_21299_21299_59                  | 59          | 1639             | 6199              | 29135              | 696241       | TARGET_network_QC/ALL_log2TP50M.185_R_21299_21299_59QC.html                  |
| ALL_log2TP50M.185_TCF3.fusion_21489_21489_20        | 20          | 1633             | 6259              | 29361              | 1436612      | TARGET_network_QC/ALL_log2TP50M.185_TCF3.fusion_21489_21489_20QC.html        |
| ALL_log2TP50M.185_TrisomyChr4_10_21944_21944_19     | 19          | 1651             | 6433              | 30025              | 1173781      | TARGET_network_QC/ALL_log2TP50M.185_TrisomyChr4_10_21944_21944_19QC.html     |
| AML_log2TP50M.202_all_20615_20615_202               | 202         | 1565             | 5886              | 28047              | 739275       | TARGET_network_QC/AML_log2TP50M.202_all_20615_20615_202QC.html               |
| AML_log2TP50M.202_D_20573_20573_157                 | 157         | 1557             | 5856              | 27964              | 738591       | TARGET_network_QC/AML_log2TP50M.202_D_20573_20573_157QC.html                 |
| AML_log2TP50M.202_HighRisk_20606_20606_14           | 14          | 1541             | 5843              | 27989              | 10295917     | TARGET_network_QC/AML_log2TP50M.202_HighRisk_20606_20606_14QC.html           |
| AML_log2TP50M.202_Inv_16_20301_20301_34             | 34          | 1483             | 5616              | 27306              | 573949       | TARGET_network_QC/AML_log2TP50M.202_Inv_16_20301_20301_34QC.html             |
| AML_log2TP50M.202_LowRisk_20414_20414_80            | 80          | 1530             | 5788              | 27721              | 706094       | TARGET_network_QC/AML_log2TP50M.202_LowRisk_20414_20414_80QC.html            |
| AML_log2TP50M.202_M1_20624_20624_49                 | 49          | 1568             | 5946              | 28134              | 760174       | TARGET_network_QC/AML_log2TP50M.202_M1_20624_20624_49QC.html                 |
| AML_log2TP50M.202_M1_20772_20772_23                 | 23          | 1582             | 5936              | 28266              | 788584       | TARGET_network_QC/AML_log2TP50M.202_M1_20772_20772_23QC.html                 |
| AML_log2TP50M.202_M2_20624_20624_49                 | 49          | 1568             | 5946              | 28134              | 760174       | TARGET_network_QC/AML_log2TP50M.202_M2_20624_20624_49QC.html                 |
| AML_log2TP50M.202_M4_21055_21055_57                 | 57          | 1529             | 5755              | 28315              | 728678       | TARGET_network_QC/AML_log2TP50M.202_M4_21055_21055_57QC.html                 |
| AML_log2TP50M.202_M5_20649_20649_36                 | 36          | 1577             | 5904              | 28118              | 607962       | TARGET_network_QC/AML_log2TP50M.202_M5_20649_20649_36QC.html                 |
| AML_log2TP50M.202_MLL_20716_20716_39                | 39          | 1576             | 5912              | 28187              | 580075       | TARGET_network_QC/AML_log2TP50M.202_MLL_20716_20716_39QC.html                |
| AML_log2TP50M.202_NormalCytogenetic_20682_20682_38  | 38          | 1582             | 5928              | 28177              | 610264       | TARGET_network_QC/AML_log2TP50M.202_NormalCytogenetic_20682_20682_38QC.html  |
| AML_log2TP50M.202_OtherCytogenetic_20730_20730_46   | 46          | 1581             | 5955              | 28260              | 697323       | TARGET_network_QC/AML_log2TP50M.202_OtherCytogenetic_20730_20730_46QC.html   |
| AML_log2TP50M.202_R_21425_21425_45                  | 45          | 1588             | 6004              | 29017              | 715123       | TARGET_network_QC/AML_log2TP50M.202_R_21425_21425_45QC.html                  |
| AML_log2TP50M.202_StandardRisk_20772_20772_96       | 96          | 1589             | 5961              | 28321              | 785297       | TARGET_network_QC/AML_log2TP50M.202_StandardRisk_20772_20772_96QC.html       |
| AML_log2TP50M.202_t_8to21_21352_21352_28            | 28          | 1557             | 5916              | 28792              | 711192       | TARGET_network_QC/AML_log2TP50M.202_t_8to21_21352_21352_28QC.html            |
| CCSK_log2TP50M.13_all_22209_22209_13                | 13          | 1675             | 6242              | 30126              | 6201442      | TARGET_network_QC/CCSK_log2TP50M.13_all_22209_22209_13QC.html                |
| NBL_log2TP50M.167_all_22031_22031_167               | 167         | 1691             | 6321              | 30030              | 864162       | TARGET_network_QC/NBL_log2TP50M.167_all_22031_22031_167QC.html               |
| NBL_log2TP50M.167_Diagnosis_22052_22052_158         | 158         | 1691             | 6318              | 30055              | 914270       | TARGET_network_QC/NBL_log2TP50M.167_Diagnosis_22052_22052_158QC.html         |
| NBL_log2TP50M.167_MKI_High_22135_22135_35           | 35          | 1684             | 6286              | 30087              | 641363       | TARGET_network_QC/NBL_log2TP50M.167_MKI_High_22135_22135_35QC.html           |
| NBL_log2TP50M.167_MKI_Intermediate_23049_23049_48   | 48          | 1702             | 6398              | 31144              | 776178       | TARGET_network_QC/NBL_log2TP50M.167_MKI_Intermediate_23049_23049_48QC.html   |
| NBL_log2TP50M.167_MKI_Low_22479_22479_52            | 52          | 1681             | 6309              | 30451              | 826050       | TARGET_network_QC/NBL_log2TP50M.167_MKI_Low_22479_22479_52QC.html            |
| NBL_log2TP50M.167_MYCN_Amp_22417_22417_36           | 36          | 1691             | 6292              | 30370              | 654906       | TARGET_network_QC/NBL_log2TP50M.167_MYCN_Amp_22417_22417_36QC.html           |
| NBL_log2TP50M.167_MYCN_NonAmp_22979_22979_130       | 130         | 1691             | 6326              | 30990              | 934672       | TARGET_network_QC/NBL_log2TP50M.167_MYCN_NonAmp_22979_22979_130QC.html       |
| OS_log2TP50M.76_all_25328_25328_76                  | 76          | 1513             | 5929              | 32770              | 1125398      | TARGET_network_QC/OS_log2TP50M.76_all_25328_25328_76QC.html                  |
| OS_log2TP50M.76_Metastatic_23065_23065_18           | 18          | 1566             | 6092              | 30723              | 1527570      | TARGET_network_QC/OS_log2TP50M.76_Metastatic_23065_23065_18QC.html           |
| OS_log2TP50M.76_NonMetastatic_25600_25600_57        | 57          | 1529             | 6048              | 33177              | 905869       | TARGET_network_QC/OS_log2TP50M.76_NonMetastatic_25600_25600_57QC.html        |
| TALL_log2TP50M.261_all_27218_27218_261              | 261         | 1653             | 6271              | 35102              | 1068228      | TARGET_network_QC/TALL_log2TP50M.261_all_27218_27218_261QC.html              |
| TALL_log2TP50M.261_LMO2_LYL1_26382_26382_18         | 18          | 1653             | 6271              | 34306              | 1923168      | TARGET_network_QC/TALL_log2TP50M.261_LMO2_LYL1_26382_26382_18QC.html         |
| TALL_log2TP50M.261_TAL1_2_27164_27164_95            | 95          | 1653             | 6271              | 35088              | 1031057      | TARGET_network_QC/TALL_log2TP50M.261_TAL1_2_27164_27164_95QC.html            |
| TALL_log2TP50M.261_TAL1_27169_27169_87              | 87          | 1653             | 6271              | 35092              | 1032180      | TARGET_network_QC/TALL_log2TP50M.261_TAL1_27169_27169_87QC.html              |
| TALL_log2TP50M.261_TLX1_3_27189_27189_70            | 70          | 1653             | 6271              | 35113              | 950515       | TARGET_network_QC/TALL_log2TP50M.261_TLX1_3_27189_27189_70QC.html            |
| TALL_log2TP50M.261_TLX1_3_HOXA_27202_27202_102      | 102         | 1653             | 6271              | 35125              | 1145757      | TARGET_network_QC/TALL_log2TP50M.261_TLX1_3_HOXA_27202_27202_102QC.html      |
| TALL_log2TP50M.261_USP7.MU_26972_26972_33           | 33          | 1653             | 6271              | 34894              | 776229       | TARGET_network_QC/TALL_log2TP50M.261_USP7.MU_26972_26972_33QC.html           |
| TALL_log2TP50M.261_USP7.WT_27220_27220_227          | 227         | 1653             | 6271              | 35125              | 1089701      | TARGET_network_QC/TALL_log2TP50M.261_USP7.WT_27220_27220_227QC.html          |
| WT_log2TP50M.124_all_22067_22067_124                | 124         | 1692             | 6309              | 30068              | 1188700      | TARGET_network_QC/WT_log2TP50M.124_all_22067_22067_124QC.html                |
| WT_log2TP50M.124_D_22064_22064_118                  | 118         | 1690             | 6298              | 30049              | 1153750      | TARGET_network_QC/WT_log2TP50M.124_D_22064_22064_118QC.html                  |
| WT_log2TP50M.124_DAWT_21818_21818_38                | 38          | 1693             | 6274              | 29778              | 563191       | TARGET_network_QC/WT_log2TP50M.124_DAWT_21818_21818_38QC.html                |
| WT_log2TP50M.124_FHWT_22093_22093_86                | 86          | 1693             | 6308              | 30093              | 1031527      | TARGET_network_QC/WT_log2TP50M.124_FHWT_22093_22093_86QC.html                |
| WT_log2TP50M.124_StageI_21998_21998_16              | 16          | 1690             | 6324              | 30012              | 2111918      | TARGET_network_QC/WT_log2TP50M.124_StageI_21998_21998_16QC.html              |
| WT_log2TP50M.124_StageII_22037_22037_53             | 53          | 1692             | 6305              | 30029              | 699740       | TARGET_network_QC/WT_log2TP50M.124_StageII_22037_22037_53QC.html             |
| WT_log2TP50M.124_StageIII_21969_21969_36            | 36          | 1700             | 6325              | 29991              | 612622       | TARGET_network_QC/WT_log2TP50M.124_StageIII_21969_21969_36QC.html            |
| WT_log2TP50M.124_StageIV_V_21965_21965_19           | 19          | 1689             | 6281              | 29931              | 822950       | TARGET_network_QC/WT_log2TP50M.124_StageIV_V_21965_21965_19QC.html           |


### TCGA

- Original transcriptome dataset from [TCGA](https://portal.gdc.cancer.gov/)

- We have pre-generated 92 networks from 46 tumor types with each has one TF network and one SIG network.


| Tissue Type                | Sample Size | No. of hubs (TF) | No. of hubs (SIG) | No. of total genes | No. of edges | Link to QC html                                   |
|----------------------------|-------------|------------------|-------------------|--------------------|--------------|---------------------------------------------------|
| ACC.T_33753_15879_77       | 77          | 15727            | 15727             | 47181              | 1042640      | TCGA_network_QC/ACC.T_33753_15879_77QC.html       |
| BLCA.T_34890_16552_348     | 348         | 1654             | 6152              | 24310              | 1153515      | TCGA_network_QC/BLCA.T_34890_16552_348QC.html     |
| BRCA.N_35169_16784_109     | 109         | 1650             | 6231              | 24664              | 1410937      | TCGA_network_QC/BRCA.N_35169_16784_109QC.html     |
| BRCA.T_35306_16556_1058    | 1058        | 1654             | 6110              | 24080              | 701060       | TCGA_network_QC/BRCA.T_35306_16556_1058QC.html    |
| CESC.T_34635_16448_241     | 241         | 1651             | 6130              | 24215              | 1495925      | TCGA_network_QC/CESC.T_34635_16448_241QC.html     |
| CHOL.T_34535_16625_35      | 35          | 1642             | 6113              | 24306              | 595519       | TCGA_network_QC/CHOL.T_34535_16625_35QC.html      |
| COADREAD.N_34500_16548_50  | 50          | 1638             | 6174              | 24341              | 965465       | TCGA_network_QC/COADREAD.N_34500_16548_50QC.html  |
| COADREAD.T_34941_16029_568 | 568         | 1640             | 5887              | 22976              | 568255       | TCGA_network_QC/COADREAD.T_34941_16029_568QC.html |
| DLBC.T_34146_15754_45      | 45          | 1639             | 5978              | 23265              | 610360       | TCGA_network_QC/DLBC.T_34146_15754_45QC.html      |
| ESCA.T_36407_17732_70      | 70          | 1693             | 6373              | 25796              | 1728755      | TCGA_network_QC/ESCA.T_36407_17732_70QC.html      |
| GBM.T_35189_16907_116      | 116         | 1675             | 6191              | 24773              | 2081008      | TCGA_network_QC/GBM.T_35189_16907_116QC.html      |
| HNSC.N_34287_16805_41      | 41          | 1654             | 6133              | 24557              | 952649       | TCGA_network_QC/HNSC.N_34287_16805_41QC.html      |
| HNSC.T_35077_16623_477     | 477         | 1657             | 6117              | 24280              | 993816       | TCGA_network_QC/HNSC.T_35077_16623_477QC.html     |
| KICH.N_34695_16995_25      | 25          | 1654             | 6194              | 24790              | 836699       | TCGA_network_QC/KICH.N_34695_16995_25QC.html      |
| KICH.T_34369_16307_66      | 66          | 1623             | 6091              | 24017              | 1218200      | TCGA_network_QC/KICH.T_34369_16307_66QC.html      |
| KIRC.N_34806_16840_72      | 72          | 1642             | 6216              | 24691              | 1291690      | TCGA_network_QC/KIRC.N_34806_16840_72QC.html      |
| KIRC.T_35436_16605_512     | 512         | 1646             | 6108              | 24075              | 725352       | TCGA_network_QC/KIRC.T_35436_16605_512QC.html     |
| KIRP.N_34657_16795_32      | 32          | 1637             | 6162              | 24531              | 740083       | TCGA_network_QC/KIRP.N_34657_16795_32QC.html      |
| KIRP.T_34670_16163_281     | 281         | 1621             | 6033              | 23544              | 780254       | TCGA_network_QC/KIRP.T_34670_16163_281QC.html     |
| LAML.T_33701_16232_130     | 130         | 1563             | 5951              | 23746              | 2011399      | TCGA_network_QC/LAML.T_33701_16232_130QC.html     |
| LGG.T_35181_16688_505      | 505         | 1666             | 6093              | 24281              | 798548       | TCGA_network_QC/LGG.T_35181_16688_505QC.html      |
| LIHC.N_32688_15698_48      | 48          | 1551             | 5933              | 23158              | 918499       | TCGA_network_QC/LIHC.N_32688_15698_48QC.html      |
| LIHC.T_34138_16137_255     | 255         | 1610             | 6080              | 23794              | 1162974      | TCGA_network_QC/LIHC.T_34138_16137_255QC.html     |
| LUAD.N_34391_16621_58      | 58          | 1618             | 6133              | 24365              | 1213383      | TCGA_network_QC/LUAD.N_34391_16621_58QC.html      |
| LUAD.T_35321_16788_493     | 493         | 1661             | 6198              | 24618              | 1069901      | TCGA_network_QC/LUAD.T_35321_16788_493QC.html     |
| LUSC.N_35008_16941_47      | 47          | 1637             | 6205              | 24754              | 1034058      | TCGA_network_QC/LUSC.N_35008_16941_47QC.html      |
| LUSC.T_35519_17032_498     | 498         | 1674             | 6246              | 24949              | 1511084      | TCGA_network_QC/LUSC.T_35519_17032_498QC.html     |
| MESO.T_34729_16696_82      | 82          | 1664             | 6139              | 24499              | 1750719      | TCGA_network_QC/MESO.T_34729_16696_82QC.html      |
| OV.T_35775_17075_403       | 403         | 1666             | 6243              | 24950              | 1171973      | TCGA_network_QC/OV.T_35775_17075_403QC.html       |
| PAAD.T_35229_16763_176     | 176         | 1661             | 6252              | 24668              | 1299578      | TCGA_network_QC/PAAD.T_35229_16763_176QC.html     |
| PCPG.T_34539_16173_170     | 170         | 1653             | 6072              | 23828              | 1047047      | TCGA_network_QC/PCPG.T_34539_16173_170QC.html     |
| PRAD.N_34860_16629_52      | 52          | 1662             | 6207              | 24477              | 1037788      | TCGA_network_QC/PRAD.N_34860_16629_52QC.html      |
| PRAD.T_34895_16552_469     | 469         | 1653             | 5983              | 23597              | 565336       | TCGA_network_QC/PRAD.T_34895_16552_469QC.html     |
| SARC.T_35040_16566_249     | 249         | 1665             | 6139              | 24341              | 1358015      | TCGA_network_QC/SARC.T_35040_16566_249QC.html     |
| SKCM.M_34930_16593_355     | 355         | 1656             | 6133              | 24372              | 1537624      | TCGA_network_QC/SKCM.M_34930_16593_355QC.html     |
| SKCM.T_34695_16581_96      | 96          | 1653             | 6125              | 24355              | 1617019      | TCGA_network_QC/SKCM.T_34695_16581_96QC.html      |
| STAD.N_35194_16921_22      | 22          | 1654             | 6214              | 24756              | 2686623      | TCGA_network_QC/STAD.N_35194_16921_22QC.html      |
| STAD.T_36385_17413_247     | 247         | 1682             | 6344              | 25437              | 1826747      | TCGA_network_QC/STAD.T_36385_17413_247QC.html     |
| TGCT.T_36008_17274_144     | 144         | 1716             | 6389              | 25358              | 1208686      | TCGA_network_QC/TGCT.T_36008_17274_144QC.html     |
| THCA.N_34727_16599_57      | 57          | 1635             | 6158              | 24379              | 1135046      | TCGA_network_QC/THCA.N_34727_16599_57QC.html      |
| THCA.T_34492_16400_489     | 489         | 1619             | 5954              | 23567              | 648107       | TCGA_network_QC/THCA.T_34492_16400_489QC.html     |
| THYM.T_34883_16290_111     | 111         | 1652             | 6151              | 23952              | 857301       | TCGA_network_QC/THYM.T_34883_16290_111QC.html     |
| UCEC.N_35024_16794_35      | 35          | 1632             | 6108              | 24434              | 760476       | TCGA_network_QC/UCEC.N_35024_16794_35QC.html      |
| UCEC.T_35791_16480_529     | 529         | 1675             | 6126              | 24018              | 822108       | TCGA_network_QC/UCEC.T_35791_16480_529QC.html     |
| UCS.T_35280_16963_55       | 55          | 1695             | 6281              | 24931              | 1022125      | TCGA_network_QC/UCS.T_35280_16963_55QC.html       |
| UVM.T_33177_15751_76       | 76          | 1612             | 5892              | 23244              | 1144831      | TCGA_network_QC/UVM.T_33177_15751_76QC.html       |


## NetBIDshiny_forVis: demo datasets and usage

Two demo datasets are available at the online version.

1. the human MB (medulloblastoma) demo dataset from GEO database as in NetBID2: [GSE116028](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE116028), with network files generated by using the same dataset. The task was to find drivers in Group4 (G4) vs others. 

2. the mouse BPD (bronchopulmonary dysplasia) demo dataset from GEO database [GSE25286](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE25286), with network files generated by using normal human lung tissue from GTEx (human). The Task was to find drivers in BPD vs normal in P14. 





