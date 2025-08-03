# CALACD

**CALACD** is a lightweight R utility package for processing wrist-worn accelerometer data, particularly suitable for 24-hour summaries derived from UK Biobank-style devices (e.g., Axivity AX3). It supports batch computation of key circadian rhythm metrics such as M10, L5, and Relative Amplitude (RA).

---

## Features

- ⚙️ Clean calculation of:
  - M10: Most active 10-hour window
  - L5: Least active 5-hour window
  - RA: Relative amplitude = (M10 - L5) / (M10 + L5)
  - LPA: Light Physical Activity (30–125 mg)
  - MPA: Moderate Physical Activity (>125–400 mg)
  - VPA: Vigorous Physical Activity (>400 mg)
- 📦 Designed for datasets with 24-hour activity columns per participant
- 🧩 Modular functions with Roxygen2 documentation
- 📊 Ideal for epidemiological studies involving rest-activity rhythms

---

## Contact
If you have any question, please feel free to contact:  
nanh302311@gmail.com
