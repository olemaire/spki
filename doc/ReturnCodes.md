[Bash Return Codes]: http://tldp.org/LDP/abs/html/exitcodes.html

# SPKI return codes

**SPKI** return codes are meaningful:

Return Code | Meaning                           | Observations
:----------:| :-------------------------------- | :-----
0           | command was perfomed with success | 
1-2         | Bash reserved                     | See [Bash Return Codes] 
10          | Operation Aborted by user         | ex: answering no to a confirmation and exiting
66          | OpenSSL error                     | ex: OpenSSL misused or cannot perform
126-165     | Bash reserved                     | See [Bash Return Codes]
255         | Bash reserved                     | See [Bash Return Codes]

Note for contributors: if you engage on hacking **SPKI** I strongly suggest you to avoid using [Bash Return Codes] for **SPKI** functions (so avoiding 1-2, 126-165 and 255). Of course, use them for to trap Bash related errors.

The same return codes will be used for the Bash and the Perl flavors.
