#!/bin/bash
#SBATCH --partition=broadwell-booked
#SBATCH -N 1 
#SBATCH --reservation=microbiome
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err 
srun /opt/adw/bin/adw run -i qbioturin/metaphlan4:0.3 -c "/bin/bash -c '{{streamflow_command}}'"
