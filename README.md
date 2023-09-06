# RaspberryPi_QuickConnect
For quickly connecting to any Raspberry Pi on the network.
Can also be run to quickly show the online status of each Pi.
Multiple starting arguments can be used (see below).
Further instructions will be added when complete.

- Start with no args to SSH (for shell access)
- Start with -f to use SFTP (for file transfers)
- Start with -fr to use SFTP with Recursive mode on (for folder transfers)
- Start with -a to use alt ip addresses, if available (alt addresses marked with *)
- Start with -q to use quick mode (doesn't wait for Pi online status checks)
- Start with -c to use compact mode (limited table info, good for small screens)
- Add script to $PATH for easy access (you can remove the .sh from script name)

You will have to replace the example Pis with your own, then add them to marked list before use.
Don't use spaces in any of the Pi info strings or the table formatting won't work correctly.
Alternative IP addreses and Pi Info are optional (alt IP addresses are useful if you
regularly connect via eth and wlan, or via a VPN that provides its own IP).
Compact mode can be useful if viewing on a screen with liited width, such as a phone.

Note: As this script is just issuing shell commands, it made sense to write it
      in Bash. However, Bash turned out to be much more fiddly than I hoped,
      so even though the script works, it would probably make even a 
      moderately-competent coder weep. I'll improve it as I learn more.