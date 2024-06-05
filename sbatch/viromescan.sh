#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
#SBATCH --reservation=assembly_test3
srun /opt/adw/bin/adw run -i qbioturin/viromescan:0.1 -c "/bin/bash -c '{{streamflow_command}}'"
