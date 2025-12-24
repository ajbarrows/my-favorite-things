# My Favorite Things

## Raindrops on roses

`beets/`

Configuration for a brilliant bit of software called [beets](https://beets.io) that tags and organizes music files.

## Whiskers on kittens

`vscode-tunnel/`

This is all a bit bespoke. The general idea is that using remote development features of VSCode spawn lot of subprocesses on the remote machine. University HPC clusters generally don't like you spawning lots of processes on login nodes, and you often need a bit more resources than what a login node has to offer. So, on the cluster -- assuming your cluster uses SLURM -- add

```
alias vscodejob="srun --partition={partition_name} -t 08:00:00 --cups-per-task=2 --ntasks=1 --mem=16G --pty bash -i"
```

to your `.bashrc`

install `get_compute_node.sh` in your home directory of your cluster, and `vscode-ssh.sh` on your local machine. Change SSH variables as necessary. 

Running `vscode-ssh.sh` on your local machine will use your initial SSH connection to your cluster to instantiate an `srun` interactive job, then pass the name of the node to which your job is assigned back to your local machine, which will then write an alternative to `~/.ssh/config` called `~/.ssh/vscodeconfig`. Make sure VSCode uses this SSH configuration file ("remote.SSH.configFile" in `settings.json`). 

I'm sure there's a more elegant way. But this works. And if you alias `vscode-ssh.sh`, it's only a single command.

There are times when your interactive job will take more than a second to deploy, and this may cause your local `~/.ssh/vscodeconfig` to mis-specify the appropriate node. If this happens, go figure out what node your job is running on and modify the file accordingly. 

Good luck. 

