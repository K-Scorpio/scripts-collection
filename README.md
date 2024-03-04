# scripts-collection

This is a repository for all the scripts I'll find useful while I'm learning scripting with Bash, PowerShell and Python

## icecast.py (CVE-2004-1561)

The original script is available here: https://github.com/ivanitlearning/CVE-2004-1561/blob/master/icecast.py

I had to modify it to make it work for Python3
* I modified lines 49 and 50 to fix bytes concatenation
* I modified line 54 to remove encoding
