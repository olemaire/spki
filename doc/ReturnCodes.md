[Bash Return Codes]: http://tldp.org/LDP/abs/html/exitcodes.html
[syslog Facility and Severity levels]: http://en.wikipedia.org/wiki/Syslog

# SPKI return codes

**SPKI** return codes are meaningful:

Return Code | Meaning                           | Observations
:----------:| :-------------------------------- | :-----
0           | command was perfomed with success | ex: Generating a new certificate with success
1-2         | Bash reserved                     | See [Bash Return Codes] 
10          | Operation Aborted by user         | ex: answering no to a confirmation and exiting
11          | CA not initialized                | ex: trying an operation before the CA has been initalized
12          | Illegal function call             | ex: calling SPKI with unknown function
13          | Element does not exists           | ex: trying to revoke a non existent certificate
14          | Element already exists            | ex: trying to generate a certificate that already exists (and have not been revoked yet)
66          | OpenSSL error                     | ex: OpenSSL misused or cannot perform
100         | Certificate is Invalid            | ex: verifying an invalid certificate
126-165     | Bash reserved                     | See [Bash Return Codes]
255         | Bash reserved                     | See [Bash Return Codes]

Note for contributors: if you engage on hacking **SPKI** I strongly suggest you to avoid using [Bash Return Codes] for **SPKI** functions (so avoiding 1-2, 126-165 and 255 - Of course, use them to trap Bash related errors).

Note that the Return Code 100 is somewhat unusual: if **SPKI** returns 100 while trying to verify a given certificate, this mean that the verification operation was a success (so Return Code should be 0) but found the certificate to be INVALID. As external tools can use **SPKI** to check for certificates, this is a tweak used to ease external tools operations.

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