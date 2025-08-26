#!/bin/bash
#SBATCH --partition=broadwell-booked
#SBATCH --reservation=microbiome
#SBATCH -N 1 
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err 
srun /opt/adw/bin/adw run -i franky2204/humann:3.9.1  -c "/bin/bash -c 'time {{streamflow_command}}'"
