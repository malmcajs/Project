**Semi-automatic Workflow for the Quality Evaluation-Based Simulation Selection (QEBSS)**

QEBSS is a tool that generates and evaluates a diverse set of molecular dynamics simulations based on various starting structures and force fields. The simulations are evaluated against NMR relaxation times (R1, R2) and heteronuclear NOE (hetNOE). This helps identify the best simulations for intrinsically disordered proteins (IDPs) or partially disordered proteins. The analysis includes ensemble visualization, radius of gyration landscape, contact maps, distance maps, secondary structure propensity, and backbone correlation maps, which could help understand the dynamic nature of different IDPs and their roles in biological processes.


For running these simulations you need access to a supercomputer like Mahti or Lumi. Depending on the platform you are gonna use download and extract the right recipitory named Automation_tool_scripts_*. 


The first step is to generate the initial conformers. Go to https://idpconformergenerator.readthedocs.io/en/latest/installation.html or follow the installation steps below: 
 
`cd Automation_tool_scripts_**/Idpconfgenerator_automation`

`git clone https://github.com/julie-forman-kay-lab/IDPConformerGenerator` 

`cd IDPConformerGenerator` 

`conda env create -f requirements.yml` 

`cd ..`


Copy your fasta file to Automation_tool_scripts_*/Idpconfgenerator_automation directory and generate replicas by running: 

`conda activate idpconfgen` 

`./create_replicas.sh` (Choose the number of your fasta file) 

This step will generate five initial structures that you can find in the folder Automation_tool_scripts_*/Unst_prot

You need to change line #SBATCH --account=project in file simulation_scripts/run_dir/md_prep_snakemake.sh manually!
Also change simulation specifications such as ion type, concentration, simulation length, tempreature etc. in Unst_prot/specifics.yaml.

Copy Unst_prot, MD_parameter_files, simulation_scripts and env.yml to your project scratch in MAHTI/LUMI.

Go to the folder where you copied all the folders and add your experimental data there. Make sure to add the first line with the magnetic field strength in MHz. Any missing data should type "n". 
Name the file Unst_prot_exp_data.txt. 

An example of what it should look like can be seen in the file Unst_alphasynuclein_exp_data.txt

You can also copy relaxation times T1, T2 and hetNOE from https://bmrb.io/ and run `create_exp.py` to automatically create the file. OBS! Copy only the data, skipping the initial text.


Set up the environment:
 
`module purge`
`module load tykky`
`mkdir env`
`conda-containerize new --prefix env env.yml`


You can select the project you want to use resources from when running the scripts. 


Go to simulation_scripts/run_dir and run scripts in order:

`sbatch run_prep_snakemake.sh` 

`sh run_batch_md.sh` 

`sh run_analysis.sh` 


OBS! Before you run the next script, you must ensure the previous step was finished. When running the run_batch_md.sh, the simulation will continue where it stopped based on the *cpt file.
