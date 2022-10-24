# comparativeanalysis
This is the implementation of our work titled "Voice Spoofing Countermeasures: Taxonomy, State-of-the-art, experimental analysis of generalizability, open challenges, and the way forward," which was available on arxiv at "https://arxiv.org/abs/2210.00417".

We conduct feature extraction using several classifiers employing audio signals from three different datasets (ASVspoof2019, ASVspoof2021, and VSDC) as input (SVM, GMM, CNN, CNN-GRU). We tested broad countermeasures with different classfiers (SVM, GMM, CNN, CNN-GRU) and across corpora to improve the classification of real samples from spoof ones. 

We are using the audio signals from distinct datasets (ASVspoof2019, ASVspoof2021, and VSDC) as input and perform feature extraction with different classifiers (SVM, GMM, CNN, CNN-GRU). We performed cross-corpus evaluation for generalized countermeasures for better discrimination of genuine samples from fake ones.

The datasets can be downloaded from the following links:
ASVspoof: https://www.asvspoof.org/
VSDC: https://www.secs.oakland.edu/~mahmood/datasets/audiospoof.html


Feature Extraction: 
The All_features.m file would be used to extract the hand-crafted features. The reference calling for each feature whose code is stored in the compressed directory "Feature_Extraction" is provided in the file All_features.m.

We have to extract the features using the file All_features.m. The file ALL_features.m includes the reference calling for each feature whose code is available in the compressed directory "Feature Extraction". This file contains the feature extraction references for the state-of-the-art countermeasures. 

Matlab Configuration: 
The following folders must be added to the paths before the features can be extracted: bosaris_toolkit and CQCC_v1.0. 

Classification:
We utilized Matlab scripts and Python notebooks for the categorization of baseline countermeasures. The SVM and cross-corpus SVM evaluation are included in the notebook files. Uncompress the "ASVspoof_baseline_GMM" folder for the Matlab-based ASVspoof baseline classification. It contains the ASVspoof2019 and ASVspoof2021 evaluation files.  With cross-corpus evaluation, swap out the training and test files for the disntint datasets.

Installation of the Python Environment:
Before categorization, we must install the requirement.txt file in order to configure the environment for python notebook files.

CNN & CNN-GRU classification:
For CNN and CNN-GRU classification, we utilized the "https://github.com/Jungjee/ASVspoof PA" repository. The provided link contains all setup and prerequisite information needed to configure the environment. 
