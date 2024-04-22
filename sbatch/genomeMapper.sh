#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
#SBATCH --reservation=container_test
srun /opt/adw/bin/adw run -i qbioturin/genomemapper -c "/bin/bash -c '{{streamflow_command}}'"
