#!/bin/bash
#SBATCH --partition=broadwell-booked
#SBATCH -N 1 
#SBATCH --reservation=microbiome
srun /opt/adw/bin/adw run -i qbioturin/genomemapper:0.5.1 -c "/bin/bash -c '{{streamflow_command}}'"
