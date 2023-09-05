# RaspberryPi_QuickConnect
For quickly connecting to any Raspberry Pi on the network

- Start with no args to SSH 
- Start with -f to use SFTP
- Start with -fr to use SFTP with Recursive mode on
- Start with -a to use alt ip addresses, if available (alt addresses marked with *)
- Add script to $PATH for easy access (you can remove the .sh from script name)

You will have to replace example Pis with your own, then add to marked list before use
Don't use spaces in any of the Pi info strings or the table formatting won't work correctly
Alternative IP addreses and Pi Info are optional (alt IP addresses are useful if you
regularly connect via eth and wlan, or via a VPN that provides its own IP)

Note: As this script is just issuing shell commands, it made sense to write it
      in Bash. However, Bash turned out to be much more fiddly than I hoped,
      so even though the script works, it would probably make even a 
      moderately-competent coder weep. I'll improve it as I learn more.