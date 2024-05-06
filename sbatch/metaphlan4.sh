#!/bin/bash
#SBATCH --partition=broadwell
#SBATCH -N 1 
#SBATCH --reservation=container_test
srun /opt/adw/bin/adw run -i qbioturin/metaphlan4:0.1 -c "/bin/bash -c '{{streamflow_command}}'"
