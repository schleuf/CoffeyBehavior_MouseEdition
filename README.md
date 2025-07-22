<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h3 align="center">THIS IS YOUR MOUSE ON DRUGS (Working Title)</h3>
</div>

<!-- ABOUT THE PROJECT -->
<!-- TOC -->
- [About The Project](#about-the-project)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Generate Raw Manuscript Figures](#generate-raw-manuscript-figures)
- [Custom Implementations](#custom-implementations)
    - [Hardware Setup](#hardware-setup)
    - [MED Software Setup](#med-software-setup)
    - [MATLAB Software Setup](#matlab-software-setup)
- [Detailed Behaivor Protocol](#detailed-behaivor-protocol)
    - [Before Running Behavior](#before-running-behavior)
    - [Running Behavior](#running-behavior)
    - [Planning Cohorts & Ordering Animals](#planning-cohorts--ordering-animals)
    - [Week 0](#week-0)
    - [Week 1](#week-1)
    - [Weeks 2 & 3 Self-Administration](#weeks-2--3-self-administration)
    - [Week 4 & 5 Extinction](#week-4--5-extinction)
    - [Week 6 Reinstatement](#week-6-reinstatement)
    - [Alternative Week 4 Behavioral Economics](#alternative-week-4-behavioral-economics)
<!-- /TOC -->

# About The Project
This GitHub repository contains the code neccessary to generate the figures presented in PUBLICATION INFORMATION

This repository also contains a comprehensive guide for setting up oral fentanyl self-administration and using the accompanying software to analyse the data in a flexible and user friendly manor.

<!-- Prerequisites -->
# Prerequisites
Implementation of the full behavioral pipeline requires Med-PC 4.0 or later (Med-Associates)    

The analysis code has been tested on MATLAB 2024a and later

Required MATLAB Toolboxes:
   ```sh
Curve Fitting Toolbox™   
Statistics and Machine Learning Toolbox™
   ```

Required External Packages:
>https://github.com/piermorel/gramm

# Installation

This Github Repository can be cloned manually, through GitHub Desktop, or through git commands

   ```sh
   git clone https://github.com/schleuf/CoffeyBehavior_MouseEdition
   ```

<!-- USAGE EXAMPLES -->
# Generate Raw Manuscript Figures
Open MATLAB and Navigate to the parent directory for this repository

Run:

   ```sh
   main_MouseSABehavior
   ```

# Custom Implementations
## Hardware Setup
### Single Chamber Parts List  
|     Description       |     Manufacturer    |     Part #    |
|---|---|---|
|     Outer Cabinet   (1 chamber)    |     SUNCAST    |     BMCCPD3000    |
|     Outer Cabinet   (3 chamber)    |     SUNCAST    |     BMCCPD8004    |
|     Acoustic Isolation   Foam    |     Auralex    |     PYRAMIDCHA    |
|     Camera    |     Arducam    |     B0506    |
|     Microphone    |     Pettersson   Elektronik    |     M500-384    |
|     Modular Test   Chamber Mouse    |     Med-Associates    |     ENV-307A    |
|     Stainless Steel Floor    |     Med-Associates    |     ENV-307A-GFW    |
|     House Light   (classic)    |     Med-Associates    |     ENV-315M-LED    |
|     House Light (red)    |     Med-Associates    |     ENV-315M-LED    |
|     Retractable   Lever (classic) x2    |     Med-Associates    |     ENV-312-3M    |
|     Stimulus   Light (classic) x2    |     Med-Associates    |     ENV-321M-LED    |
|     Liquid   Delivery Receptacle (tall)    |     Med-Associates    |     ENV-303LPHD-4.25    |
|     Syringe Pump   (3.33RPM)    |     Med-Associates    |     PHM-200    |
|     Head Entry   Detector    |     Med-Associates    |     ENV-254-FB    |
|     SmartCtrl   Card    |     Med-Associates    |     DIG-716P1    |
|     SmartCtrl Panel    |     Med-Associates    |     SG-716B    |
|     Tone Generator    |     Med-Associates    |     ENV-323AM    |
|     Angled Top    |     3D Printed    |     \3D Printed   Parts    |

### Chamber Wiring
 |     Med-PC #     |     Description    |     Note    |
|---|---|---|
|     Output 1    |     Left Lever Out    |     Active Lever    |
|     Output 2    |     Right Lever Out     |     Optional (Not used in our setup)    |
|     Output 3    |     House Light On    |     Optional   (Not used in our setup)    |
|     Output 4    |     Red House Light On    |     Optional   (Not used in our setup)    |
|     Output 5    |     Left Lever Light    |     Active Lever Stimulus Light    |
|     Output 6    |     Tone On    |     Active   Lever Press Stimulus Tone    |
|     Output 7    |     Right Lever Light    |     Optional   (Not used in our setup)    |
|     Output 8    |     Pump On    |     Liquid Delivery Pump    |
|     Input 1    |     Left Lever In    |     Active Laver    |
|     Input 2    |     Right Lever In    |     Optional (Not used in our setup)    |
|     Input 3    |     Inactive Lever In    |     Non-Retractable Inactive Lever    |
|     Input 4    |     Beam Break In    |     Head Entry Detector for Liquid   Port    |

### Top Down Chamber View
![Image](https://github.com/user-attachments/assets/2a773dc3-c9aa-4b2a-94b2-d0cb32a875b6)

## MED Software Setup
Med-PC Code is available in the folder below and must be compiled prior to use. Inputs and Outputs are defined near the top of the code and may be customezed. Variables for session length, cue timing, pump duration, etc. may be modified in the code or through the Macro.
>./MedPC/MPC/Golden_Liq_SelfAdmin.MPC

   ```sh
   # Editable Inputs, Outputs, and Variable Examples

#  Outputs
    ^LeftLevOut     = 1 
    ^RightLevOut    = 2 
    ^HouseLt        = 3
    ^HouseLtRed     = 4 
    ^LeftLevLt      = 5
    ^RightLevLt     = 7 
    ^Tone           = 6
    ^LiquidDel      = 8
    ^Fan            = 16

#  Inputs
    ^LeftLevIn        = 1 
    ^RightLevIn       = 2 
    ^InactiveIn       = 3
    ^HeadEntry        = 4

# Default setup and trial timing
S.S.1,     
   S1,
     0": ON^Fan;
         SET A(2)  = 180;    \Session length (min)
         SET A(3)  = 4;      \Liquid delivery duration (sec)
         SET A(4)  = 0;      \Lev light delay (sec)
         SET A(5)  = 5;      \Lev light duration (sec)
         SET A(6)  = 0;      \Tone delay (sec)
         SET A(7)  = 5;      \Tone duration (sec)
         SET A(8)  = 0;      \Mag light delay (sec)
         SET A(9)  = 0;      \Mag light duration (sec)
         SET A(10) = 1;      \Active Lev (0:Right 1:Left)
         SET A(11) = 0;      \Liquid delivery delay (sec)
         SET A(12) = 10;     \Total timeout time - time liquid unavailable (sec)
         SET A(16) = 320;    \Maximum Infusions before syringe is empty
         SET A(13) = 180;    \Auto drug delivered (sec) MUST BE SET WITH MACRO IF THIS IS COMMENTED OUT
   ```

Example Med-PC Macros are also available to define subject details, start experiments, and administer shaping rewards through K-Pulses 
>./MedPC/Macro/Golden_Liq_SelfAdmin.MAC

   ```sh
   # Example Macro Text

   TEXTINPUTBOX "Subject in Box 1" "Enter Subject ID:" "S1" #SubB1 
NUMERICINPUTBOX "Weight for Box 1" "Enter weight (grams):" "25" #WeightB1 
NUMERICINPUTBOX "Self-Administration Session" "Enter Training Day:" "1" #SessionB1 
NUMERICINPUTBOX "Auto Shaping Timer" "Enter time between automatic rewards (s)" "60" #ShapeTimeB1
LOAD BOX 1 SUBJ #SubB1 EXPT OralFentSA GROUP One PROGRAM Golden_Liq_SelfAdmin
SET A(13) VALUE #ShapeTimeB1 MAINBOX 1 BOXES 1
SET A(14) VALUE #WeightB1 MAINBOX 1 BOXES 1
SET A(15) VALUE #SessionB1 MAINBOX 1 BOXES 1
   ```
   
## MATLAB Software Setup
The provided MATLAB code can be flexibly modified to run new data generated by your version of Liq_SelfAdmin.MPC
> ./main_MouseSABehavior.m

### Minimal Requirements
- Behavior data  in ./All Behavior
- Experiment Key File: "Experiment Key.xlsx" with following variables (See example)
  - "Run" (number)
  - "Experiment" (categorical: ER, BE, SA)
  - "Date" (Datetime)  - Session (number)
  - "Session Type" (categorical: PreTraining, Training, Extinction, Reinstatement, BehavioralEconomics)
  - "Fentanyl Concentration (ug/ml)" (number)
  - "Volume per dose (mL)" (number)

- Subject Key File: "Subject Key.xlsx" with the following variables (See example, adding extra variables is ok)
  - "Tag Number" (Categorical)
  - "Run" (Number)
  - "Strain" (Categorical)
  - "SelfAdministration" (Logical)
  - "Extinction" (Logical)
  - "Reinstatement" (Logical)
  - "BehavioralEconimics" (Logical)
  - "InlcludeBehavior" (Logical)
  - "RemoveSession" {Cell of Numbers}

### All User Editable Variables are available and described in the first block of code.
   ```sh
# USER EDITABLE SETTINGS
runNum = 'all'; # options: 'all' or desired runs separated by underscores. Must match numbers in Experiment Key (e.g. '1', '1_3_4', '3_2')
runType = 'all'; # options: 'ER' (SA & Extinction & Reinstatement), 'BE' (Behavioral Economics), 'SA' (Self Administration), 'all' (All run seperately)
createNewMasterTable = true; # true: generates & saves a new master table from medPC files in datapath. false: reads mT in from masterTable_flnm if set to false, otherwise 
firstHour = true; # true: acquire data from the first-hour of data and analyze in addition to the full sessions (Important for camparing behavior to 1h reinstatement session).
excludeData = true; # true: excludes data based on the 'RemoveSession' column of Subject Key
acquisition_thresh = 10; # to be labeled as "Acquire", animal must achieve an average number of infusions in Training sessions greater than this threshold
acquisition_testPeriod = {'Training', 'last', 10}; # determines sessions to average infusions across before applying acquisition_thresh. second value can be 'all', 'first', or 'last'. if 'first' or 'last', there should be a 3rd value giving the number of days to average across, or it will default to 1. 
maxLatency = 360; # maximum time in seconds between an active lever press and head entry to be factored into latency calculations
pAcq = true; # true: plot aquisition histogram to choose threshold 
interpWeights = false; # true: interpolate daily weights from weekly weights
interpWeight_sessions = [1,6,11,16,21]; # [sessions with true weights for interpolation]
addROI = true; #true: append master table with ROI data - Requires ROI data sheets with "TagNumber" column and "Video" Column
run_BE_analysis = true; # Run Behavioral Economics analysis?
run_withinSession_analysis = true; # Run within-sessions analysis?
run_individualSusceptibility_analysis = true; # Run individual risk analysis?

# FIGURE OPTIONS
# Currently, if figures are generated they are also saved. 
saveTabs = true; # true: save matlab tables of analyzed datasets
dailyFigs = true; # true: generate daily figures from dailySAFigures.m
pubFigs = true; # true: generate publication figures from pubSAFigures.m
indivIntake_figs = false; # true: generate figures for individual animal behavior across & within sessions (useful for troubleshooting but produces a lot of figures)
groupIntake_figs = true; # true: generate figures grouped by sex, strain, etc. for animal behavior across & within sessions
severity_figs = true; # true: generate severity figures
figsave_type = {'.png','.fig'}; # file types for figure outputs. May be any MATLAB standard image or figure type

# color settings chosen for publication figures. See GRAMM documentation for HLC Color formatting
gramm_C57_Sex_colors = {'hue_range',[40 310],'lightness_range',[95 65],'chroma_range',[50 90]};
gramm_CD1_Sex_colors = {'hue_range',[85 -200],'lightness_range',[85 75],'chroma_range',[75 90]};
gramm_Strain_Acq_colors = {'hue_range',[25 385],'lightness_range',[95 60],'chroma_range',[50 70]};
col_M_c57 = [0, 0.7333, 0.5647]; # Hard code color for c57 Males
col_F_c57 = [1, 0.4196, 0.2902]; # Hard code color for c57 Females
col_M_CD1 = [0.6392, 0.5373, 1]; # Hard code color for CD1 Males
col_F_CD1 = [0.7765, 0.5922, 0]; # Hard code color for CD1 Females
   ```

# Detailed Behaivor Protocol
## Before Running Behavior
### Animal Handling
Consistent handling is important to running delicate behaviors. Animals should be handled for at least 5m each daily in the week prior to starting SA. Researchers should complete Animal Handling Basics courses before physically handling animals.

### Changing Bedding (Mondays)

Every Monday, before running behavior, new bedding must be added to each of the chambers.

### Weighing Animals (Mondays)

Every Monday, animals must be weighed BEFORE running behavior. Weigh and write down the weight for each animal before putting them into their chamber.

### Update the Macro (Daily)

On Monday update the MedPC macro file with each animal’s weekly weight. Every other day, update the macro with the running session. If this is incorrect it may be fixed while running the macro (in question dialog) and it will additionally be checked by the final analysis code against the experiment key.

### Cleaning Chambers (Fridays)

After closing behavior on Friday, dump bedding into the trash, and clean chambers. Wash off any excess bedding from the removable bedding holders in the sink and use clidox to clean the bedding holders and the floors/walls of the MedPC chambers. Clean well!

## Running Behavior

### Loading MedPC Macros & Initializing MedPC Sessions

These instructions assume you are using OBS to record from multiple USB cameras. Generally, up to 6 cameras can be recorded at the same time on one computer. OBS can record all 6 videos to 1 file to be split later, or it can record each individually with “Source Record”. Instruction for setting up OBS with “SourceRecord” can be found here: <https://obsproject.com/forum/resources/source-record.1285/>

### Starting A Session

Hint: Use a macro pad to signal both pieces of software, and a USB splitter if on 2 computers.

1. Load MedPC Macros and Initialize session.
    1. Example Macro files are included in the Github Repository.
2. Open OBS and check cameras are functioning and ‘source record’ is ready
3. Use a Macro pad to signal both pieces of software to start (example “Alt+f11” is run for both)
4. Check that the session is running and your cameras are recording

### Closing A Session

1. Check that the session is closed on MedPC
2. Use a Macro pad to turn off video on OBS (Alternatively set max recording length)

## Planning Cohorts & Ordering Animals

Note: The first day of your experiments (magazine training) will always be on a Friday.

Acceptable age range of experimental mice, day one of experiment: 7-8 weeks old. Some experiments use mice between 7-10 weeks old, but so far, all animals we have used started experiments at 7 weeks old.

## Week 0

### Ear Tagging & Behavior Master Key

On Friday, a week before your magazine training, animals should be given unique identifiers (ear tags or snips) and added to the ‘Master Key’ excel spreadsheet. Example in the GitHub Repo

### Handling

The week leading up to magazine training, each animal should be handled daily for 5min to get them used to researcher intervention and a novel hand picking them up/entering their home cage.

Why do we do this? Mice, in nature, are prey to many species that pick them up or move fast towards them from above. In handling these mice, a week before regularly picking them up, we mitigate any unnecessary stress that could be introduced by a fast-moving object picking them up from above. Be aware that unhandled mice may be fearful of your hand entering their cage and picking them up in a similar way that their hunters do in nature. NOTE: This is a general best practice for mouse related research, and it’s important to know that the stress related affects that could occur from unhandled mice may result in lower acquisition. Also note that these mice will be put into MedPC chambers later in the week, which will be a completely novel environment to them – reducing the number of novelties can help reduce the time to acquisition, and general acquisition rates in each cohort.

### Saccharin Pre-Exposure (Magazine Training)

Saccharin is a non-nutritive, zero calorie sweetener that’s much sweeter than sugar. The sweetness of this reward helps the mice learn the cue-reward response and being non-nutritive/non-caloric is important to maintain the health of these animals and ensures that any future fentanyl related behaviors cannot be attributed to differences in saccharin intake.

Magazine Training is a one-hour session where the animals are run under normal training conditions (i.e. can lever press for reward and receive reward), while simultaneously receiving an automatic reward each minute (separate from any active lever mediated rewards). Since these chambers are novel environments, the constant automatic rewards help expedite their ability to learn that there are cues (tone and lever light) associated with the delivery of a liquid in the hopper. The sweetness of the saccharin is used to drive the animals desire to consume and seek the dispensed liquid (NOTE: these animals are not water deprived).

### Making Saccharin Solution

During saccharin pre-exposure, we use a mixture of 0.1% saccharin in Hydro pack H<sub>2</sub>O. For 8 chambers we use 250ml of H<sub>2</sub>O and 0.25g saccharin.

## Week 1

### Saccharin Fade

Purpose: Use saccharin to enforce reward seeking while simultaneously weaning animals off saccharin. This shows that any persistent reward seeking is due to fentanyl seeking as opposed to saccharin seeking. 3hr sessions each day.

Saccharin Solution: Use hydropack solution with saccharin (0.1, 0.08, 0.06, 0.04, 0.02, 0.00%) and fentanyl (70ug/ml). NOTE: Each day your solution must be diluted using a hydropack solution with 0% saccharin and fentanyl (70ug/ml).

### Shaping

Automatic reward timer: Automatic rewards are administered to each medpc chamber every 10, 20, 30, 40, 50 mins, depending on the training session (1/2/3/4/5). The automatic reward timer can be set in the medpc macro text file, or via the medpc input boxes displayed on macro playback.

Manual Shaping schedule: Each day has unique start times and procedures for shaping. Refer to the list of days below for specifics. The keys to shaping are to reward successive approximations of a lever press, and to be a sparing as possible. You don’t want animals to become reliant on manual rewards. Shaping must be done consistently and within a very tight time window around behavior. The best way to do this is to have a shaping macro key pad that signals a K-Pulse to Med PC. Shape the macro pad identically to the video window to facilitate watching multiple animals with precision and speed.

### Monday

Start: 10min after session start

Do: administer rewards on **active lever approach** and **region adjacency**. NOTE: make sure the animals head is oriented towards the active lever and not the hopper.

Active lever approach = anytime the animal is moving towards and looking at the active lever.

Region adjacency = if the animal is grooming adjacent to the active lever (or hopper), administer a reward anytime they look at the active lever. Also administer rewards anytime a body part of theirs (particularly forepaw or hindpaw) contacts the lever. Provide no more than 15 manual rewards.

### Tuesday

Start: 20min after session start

Focus: Continue to administer rewards on active lever approach and region adjacency. Aim for rewarding further successive approximations of a lever press. Only shape animals with less than 5 active lever presses. Provide no more than 15 manual rewards.

### Wednesday

Start: 30min after session start

Continue to administer rewards on active lever approach and region adjacency for slow learning animals. Reward lever contacts that don’t complete a press. Focus on snout or paw contact. Aim for rewarding further successive approximations of a lever press. Try not to go backwards to adjacency. Only shape animals with less than 7 active lever presses. Provide no more than 15 manual rewards.

### Thursday

Start: 40min after session start

Reward lever contacts that don’t complete a press. Focus on snout or paw contact. Aim for rewarding further successive approximations of a lever press. Try not to go backwards to adjacency. Only shape animals with less than 10 active lever presses. Provide no more than 15 manual rewards.

### Friday

Start: 1hrs after session start

Reward lever contacts that don’t complete a press. Focus on snout or paw contact. Aim for rewarding further successive approximations of a lever press. Try not to go backwards to adjacency. Only shape animals with less than 10 active lever presses. Provide no more than 15 manual rewards.

## Weeks 2 & 3 (Self-Administration)

Self-administration: 70ug/ml fent in hydropack water. Rewards administered exclusively by the animal. Generally, no manual training or automatic reward. Set automatic reward time to 1000000 in macro (any number longer than the session in seconds). Animals run for 3hrs.

## Week 4 & 5 (Extinction)

Two weeks of 3hr long behavior sessions. Active lever is accessible, but no tone, lever light, or reward are administered after an active lever press. Use \_EXT MED-PC code.

## Week 6 (Reinstatement)

Animals run for a single day, where the tone and lever light return and follow every active lever press. Liquid rewards are not administered (remove the syringe). Sessions only run for 60 minutes to allow for perfusions within the immediate early gene expression window.

## Alternative Week 4 (Behavioral Economics)

Self-administration with a decreasing concentration of fentanyl per reward each day (222, 125, 70, 40, 22ug/ml). Quantifies consumption/price relationship for each animal’s reward seeking behavior (read [this paper](https://www.nature.com/articles/npp2008195) for review). We expect self-administering (/reward seeking) animals to change their consumption relative to the concentration of fentanyl administered. In particular, we expect an increased amount of lever pressing at lower concentrations of fentanyl and decreased (or the same) levels of lever pressing at higher concentrations of fentanyl (depending on the animal’s tolerance). It is essential to measure the fentanyl intake manually in case fentanyl is not consumed. Measure the syringe volume before the session, and after the session retract the remaining fentanyl from the dish and measure the final volume.

[![CC BY-NC-ND 4.0][cc-by-nc-nd-shield]][cc-by-nc-nd]   

This work is licensed under a
[Creative Commons Attribution-NonCommercial-NoDerivs 4.0 International License][cc-by-nc-nd].

[cc-by-nc-nd]: http://creativecommons.org/licenses/by-nc-nd/4.0/
[cc-by-nc-nd-shield]: https://img.shields.io/badge/License-CC%20BY--NC--ND%204.0-lightgrey.svg
