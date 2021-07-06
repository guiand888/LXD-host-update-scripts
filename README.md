# LXD host update scripts  

## Description
Maintenance scripts to routinely update all containers on a LXD host  
Composed of an application script and a cron script, to run all commands in a screen session and be able to monitor progress if needed  
Mitigate silent fails with Healthchecks.io
  
## Variants: 
- Ubuntu
- Alpine

## Setup
1. Host scripts go into `/usr/local/bin`  
        Edit HEALTHCHECK variable  
        Make sure `( $6 == "ubuntu" )` matches with the corresponding fields for that OS under `lxc list -cn,image.os`  
        Or see further below  
2. Containers' local scripts go into `/usr/local/bin/` as well  
        Typically: `/usr/local/bin/localupdate.sh`  
3. Copy the cron file into `/etc/cron.weekly`  
        Edit the variable `SCRIPT_NAME`  
4. Make sure all scripts and cron are executable  


## Assumptions
### LXD path
We assume LXD is installed with snap.  
If LXD is installed from source or binaries, the path might need to be edited in the scrips.  
  
Check LXC path:  

```
> $ which lxc                                                                                                                                                                              
/snap/bin/lxc
```

Then edit:  

```
...
LXC="/snap/bin/lxc"
...
```

### image.os field
Update scripts rely on it filter containers based on the image.os field available in LXD, to avoid running unnecessarily on all containers and snapshoting containers multiple times.  

Run: `lxc list -cn,image.os`  
For any empty field, run: `lxc exec $container -- cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f2`  
And declare the OS in the containers config: `lxc config set $container image.os $ImageOS`  
  
For instance with `container1`, before:  
```
> $ lxc list -cn,image.os
+---------------------+-------------+
|        NAME         |  IMAGE OS   |
+---------------------+-------------+
| container1          |             |
+---------------------+-------------+
```
  
And after:  
```
> $ lxc config set container1 image.os ubuntu
> $ lxc list -cn,image.os                                                                  
+---------------------+-------------+
|        NAME         |  IMAGE OS   |
+---------------------+-------------+
| container1          | ubuntu      |
+---------------------+-------------+
```
  
### Containers local updates
We also execute any `localupdate.sh` script that would be on the container's `/usr/local/bin` directory.  
This is primarily used to update non-repoed softwares - docker containers, pihole, etc. - together with the rest of the system.
