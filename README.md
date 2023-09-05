# RaspberryPi_QuickConnect
For quickly connecting to any Raspberry Pi on the network

Start with no args to SSH
Start with -f to use SFTP
Start with -fr to use SFTP with Recursive mode on

Add script to $PATH for easy access (you can remove the .sh from script name)

Note: As this script is just issuing shell commands, it made sense to write it
      in Bash. However, Bash turned out to be much more fiddly than I hoped,
      so even though the script works, it would probably make even a 
      moderately-competent coder weep. I'll improve it as I learn more.