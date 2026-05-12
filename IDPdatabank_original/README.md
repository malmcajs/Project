This is preliminary repository for databank of IDP simulations developed in the FAIRMD project.

This works in the same way a the [NMRlipids databank](https://github.com/NMRLipids/Databank)

AddData creates README files where proteins are defined using FASTA sequence

CalcProperties currently calculates contact, distance and backbone correlation maps, radius of gyration distributions, dynamic landscapes and spin relaxation times.


STEP BY STEP:

Load your systems to the databank from Zenodo by running IDPdatabank/Scripts/BuildDatabank/generate_yaml.sh in the folder IDPdatabank/Data/info_files. This script creates separate folders for each system and generates a .yaml file specified to your systems force field. 

OBS! The Zenodo ID needs to be changed to correspond your simulations. If forcefields are missing or you dont have 5 replicas this could easily be canged in the script too.

To set up the simulation run:

PYTHONPATH=/home/$USER/IDPdatabank/Scripts python /home/$USER/IDPdatabank/Scripts/BuildDatabank/AddData.py -f replica_0*_*_md_2000ns.yaml

This moves the trajectory to a folder inside IDPdatabank/Data/Simulations

To analyze the system run:

PYTHONPATH=/home/$USER/IDPdatabank/Scripts python /home/$USER/IDPdatabank/Scripts/AnalyzeDatabank/calcProperties.py inside the folder where the trejectory was transferred.
