#!/bin/bash
#SBATCH --partition=broadwell-booked
#SBATCH --reservation=microbiome
#SBATCH -N 1 
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err 
srun /opt/adw/bin/adw run -i qbioturin/humann3:0.0.3  -c "/bin/bash -c 'time {{streamflow_command}}'"
