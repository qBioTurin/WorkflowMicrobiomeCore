#!/bin/bash
#SBATCH --partition=broadwell-booked
#SBATCH -N 1 
#SBATCH --reservation=microbiome
srun /opt/adw/bin/adw run -i biobakery/humann:3.9 -c "/bin/bash -c '{{streamflow_command}}'"
