<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h3 align="center">THIS IS YOUR MOUSE ON DRUGS (Working Title)</h3>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#prerequisites">Prerequisites</a></li>
    <li><a href="#installation">Installation</a></li>
    </li>
    <li><a href="#generate-raw-manuscript-figures">Generate Raw Manuscript Figures</a></li>
    <li><a href="#implement-in-your-lab">Implement in Your Lab</a></li>
    <ul>
            <li><a href="#hardware-setup">Hardware Setup</a></li>
            <li><a href="#med-software-setup">MED Software Setup</a></li>
            <li><a href="#matlab-software-setup">MATLAB Software Setup</a></li>
            <li><a href="#detailed-behavior-protocol">Detailed Behavior Protocol</a></li>
          </ul>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project
This GitHub repository contains the code neccessary to generate the figures presented in PUBLICATION INFORMATION

This repository also contains a comprehensive guide for setting up oral fentanyl self-administration and using the accompanying software to analyse the data in a flexible and user friendly manor.

<!-- Prerequisites -->
## Prerequisites
Implementation of the full behavioral pipeline requires Med-PC 4.0 or later (Med-Associates)    

The analysis code has been tested on MATLAB 2024a and later

Required MATLAB Toolboxes:
>Curve Fitting Toolbox™   
>Statistics and Machine Learning Toolbox™

Required External Packages:
>https://github.com/piermorel/gramm

## Installation

This Github Repository can be cloned manually, through GitHub Desktop, or through git commands

   ```sh
   git clone https://github.com/schleuf/CoffeyBehavior_MouseEdition
   ```

<!-- USAGE EXAMPLES -->
## Generate Raw Manuscript Figures
Open MATLAB and Navigate to the parent directory for this repository

Run:

   ```sh
   main_MouseSABehavior
   ```

## Implement in Your Lab
### Hardware Setup
#### Single Chambe Parts List
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

#### Chamber Wiring
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

#### Top Down Chamber View
![Image](https://github.com/user-attachments/assets/2a773dc3-c9aa-4b2a-94b2-d0cb32a875b6)

### MED Software Setup
### MATLAB Software Setup
### Detailed Behaivor Protocol

[![CC BY-NC-ND 4.0][cc-by-nc-nd-shield]][cc-by-nc-nd]   

This work is licensed under a
[Creative Commons Attribution-NonCommercial-NoDerivs 4.0 International License][cc-by-nc-nd].

[cc-by-nc-nd]: http://creativecommons.org/licenses/by-nc-nd/4.0/
[cc-by-nc-nd-shield]: https://img.shields.io/badge/License-CC%20BY--NC--ND%204.0-lightgrey.svg
