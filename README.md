<p><img src="ClaRa\Resources\Images\ClaRa-Logo.png" width="100"<\p>

# ClaRa-official

https://www.claralib.com/

Thank you for choosing the ClaRa library for your simulation purposes!

The open-source Modelica library ClaRa provides its users with the capability to proficiently tackle tasks in the disciplines of thermal hydraulics and instrumentation and control pertaining to power plants and other kind of energy systems.

Licensed by the ClaRa development team under the 3-clause BSD License.

Copyright  2013-2023, ClaRa development team.

The ClaRa development team consists of the following partners: 
* TLK-Thermo GmbH (Braunschweig, Germany)
* XRG Simulation GmbH (Hamburg, Germany).

Contents published in ClaRa have been contributed by different authors and institutions. Please see model documentation for detailed information on original authorship and copyrights.

Please read the following steps for a successful usage.



Installation:
******************************

1. Copy the unzipped library files to your preferred folder

Currently, only DYMOLA provides full suppport of ClaRa. The development team has tested all models carefully using DYMOLA 2023x Refresh 1 which we therefore recommend to use. For other tools' support please contact us via mail at info@powerplantsimulation.com.  


2. Get Access to the Library from DYMOLA
----------------------------------------

### Alternative A: Installation

#### 1 Set Environmental Variable in Windows
In Windows add an Environment Variable with the following properties:
Variable name:	ModelicaPath
Variable value:	path of the directory where ClaRa is located

How to do this on Windows 7:
→ click "Start" 
→ rigth click on "Computer" 
→ choose "Properties" option
→ in the "System" window click on "Advanced system settings" 
→ in the "System Properties" window select the "Advanced" tab 
	and click on "Environmental Variables"
→ now create a  new variable "ModelicaPath" either in "System variables" (this makes your definition accessible for all users) or in "User variables for %your user name%" (this makes your definition only accessible for you and programs executed by yourself)
→ give the variable as value the path of the directory where ClaRa is located on your computer
→ click "OK" button 
→ click "OK" button in "Environmental Variables"
→ click "OK" button in "System Properties Window"
→ close "System" window

#### 2 Open Dymola
Now open Dymola and ClaRa will be automatically opened. Additional libraries used by ClaRa will be automatically loaded once you open a ClaRa model using components from those libraries. 

### Alternative B: Open Manually

If you don not want install ClaRa on your computer then you can open the required libraries manually (in DYMOLA via the graphic menu: File → Open and File → Load, respectively). The libraries require are the following:
* TILMedia (for the calculation of media data)
* ClaRa ("Simulation fo Clausius Rankine Cycles")
* SMArtIInt ("for usage of (trained) TensorFlow models from within Modelica.")
* ClaRa_Obsolete (if you have already Power Plant models that you want to use with the new version of ClaRa then there might be some models that are deprecated)

### Alternative C: Run an Start-Up Script
You can also perform the steps named in alternative B automatically by running the ClaRa_StartUpDymola.mos located in ClaRa/Resources/Scripts.

	
Contact:	
******************************
	info@powerplantsimulation.com
