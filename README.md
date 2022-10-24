# comparativeanalysis
This is the implementation of our work titled "Voice Spoofing Countermeasures: Taxonomy, State-of-the-art, experimental analysis of generalizability, open challenges, and the way forward," which was available on arxiv at "https://arxiv.org/abs/2210.00417".

We are using the audio signals from distinct datasets (ASVspoof2019, ASVspoof2021, and VSDC) as input and perform feature extraction with different classifiers (SVM, GMM, CNN, CNN-GRU). We performed cross-corpus evaluation for generalized countermeasures for better discrimination of genuine samples from fake ones.

The datasets can be downloaded from the following links:
ASVspoof: https://www.asvspoof.org/
VSDC: https://www.secs.oakland.edu/~mahmood/datasets/audiospoof.html


Feature Extraction: 
First we have to extract the features using the file All_features.m. This file contains the feature extraction references for the state-of-the-art countermeasures. 

Classification:
For the classification, we used python notebooks and Matlab codes for baseline countermeasures classification. The notebook files comprise the SVM and cross-corpus SVM evaluation. For the Matlab based ASVspoof baseline classification, uncompress the ASVspoof_baseline_GMM folder. It contains the ASVspoof2019 and ASVspoof2021 evaluation files. Replace the training and testing files with the disntint datasets for cross-corpus evaluation.
