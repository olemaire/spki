[Bash Return Codes]: http://tldp.org/LDP/abs/html/exitcodes.html
[syslog Facility and Severity levels]: http://en.wikipedia.org/wiki/Syslog

# SPKI return codes

**SPKI** return codes are meaningful:

Return Code | Meaning                           | Observations
:----------:| :-------------------------------- | :-----
0           | command was perfomed with success | 
1-2         | Bash reserved                     | See [Bash Return Codes] 
10          | Operation Aborted by user         | ex: answering no to a confirmation and exiting
11          | CA not initialized                | ex: trying an operation before the CA has been initalized
12          | Illegal function call             | ex: calling SPKI with unknown function
66          | OpenSSL error                     | ex: OpenSSL misused or cannot perform
126-165     | Bash reserved                     | See [Bash Return Codes]
255         | Bash reserved                     | See [Bash Return Codes]

Note for contributors: if you engage on hacking **SPKI** I strongly suggest you to avoid using [Bash Return Codes] for **SPKI** functions (so avoiding 1-2, 126-165 and 255 - Of course, use them to trap Bash related errors).

The same return codes will be used for the Bash and the Perl flavors of **SPKI**.

# SPKI Logging (syslog) facility and severity levels

**SPKI** will log its actions (and potentials errors) to syslog, using the regular [syslog Facility and Severity levels].

Severity Level | Meaning | Observations
:------------- | :------ | :------------ 
emerg          | | Panic condition that need immediate action from the staff.
*alert*          | | **Not Used**. alert that need immediate action.
crit           | | Critical failure that need immediate action.
*err(or)*        | | **Not Used**. non urgent failure.
warn(ing)      | | Not an error, but action required to check everything is okay.
notice         | | Unusual condition, have to be reported to admin and/or developers to spot potential problems. No immediate action required.
info           | | Normal operation message, no action requiered.
*debug*          | | **Not Used***. Debug level message.

Note that syslog severity levels *alert*, *err(or)* and *debug* are not used by **SPKI**.

The same return facility and severity levels will be used for the Bash and the Perl flavors of **SPKI**.