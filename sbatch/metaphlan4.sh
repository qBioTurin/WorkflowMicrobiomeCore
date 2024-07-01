#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
#SBATCH --reservation=microbiome
srun /opt/adw/bin/adw run -i qbioturin/metaphlan4:0.2.1 -c "/bin/bash -c '{{streamflow_command}}'"
