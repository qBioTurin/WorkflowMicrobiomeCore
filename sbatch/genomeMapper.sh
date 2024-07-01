#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
#SBATCH --reservation=microbiome
srun /opt/adw/bin/adw run -i qbioturin/genomemapper:0.2 -c "/bin/bash -c '{{streamflow_command}}'"
