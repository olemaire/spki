[Bash Return Codes]: http://tldp.org/LDP/abs/html/exitcodes.html
[syslog Facility and Severity levels]: http://en.wikipedia.org/wiki/Syslog

Usefull documentation to better understand the **SPKI** internals.

**Table of Contents**

- [Certificate Authority and CRL status](#certificate-authority-and-crl-status)
- [Certificate validity status](#certificate-validity-status)
- [Return Codes](#return-codes)
- [Logging (syslog) facility and severity levels](#logging-syslog-facility-and-severity-levels)
- [Sample logs messages](#Sample-logs)



# Certificate Authority and CRL status
The CA and the CRL can be given the following status:

Status | Meaning | Return Code
:----: | :------ | :------------
OK     | Everything is okay, **SPKI** ready to serve, CRL is valid | 0
NOT OK | Something is wrong, **SPKI** is NOT operationnal | depends on the cause 

Before any action excepted the basics (printing help message), **SPKI** will self check to be sure to be in operational condition. If not an Error Message with meaningful Return Code will be provided (see later on the dedicated paragraph on Return Codes)

# Certificate validity status
**spki** certificaets may be of the following status:

Status  | Meaning | Associated Return code
:-----: | :------ | :-----------------
VALID   | Certificate is operational | 0
EXPIRED | Certificate is not anymore valid because of expiration | 102
REVOKED | Certificat has been revoked by the CA | 101
UNKNOWN | Impossible to determine the certificate status. To be considered invalid as long as status not perfectly determined | 100

A certificate status "UNKNOWN" means that the **SPKI** cannot determine the exact status of validity of the considered certificate : **It's an anormal condition** and the situation must be looked after by the staff. Meanwhile, the certificate is to be considered invalid for this unknown reason.

Return codes as the one returned by the `spki --verify <subject of certificate>` command (see dedicated paragraph).

# Return Codes

**SPKI** return codes are meaningful:

Severity Level  | Return Code | Meaning                           | Observations
:--------------:|:----------:| :-------------------------------- | :-----------------
none  | 0       | command was perfomed with success     | ex: Generating a new certificate with success
crit  | 1-2     | Bash reserved                         | See [Bash Return Codes] 
emerg | 9       | Illegal configuration parameter       | ex: configuring with an unsupported automated mode
info  | 10      | Operation Aborted by user             | ex: answering NO to a confirmation and exiting
info  | 11      | CA not initialized                    | ex: trying an operation before the CA has been initalized
warn  | 12      | Illegal function call                 | ex: calling SPKI with unknown function
debug | 13      | Element does not exists               | ex: trying to revoke a non existent certificate
debug | 14      | Element already exists                | ex: trying to generate a certificate that already exists and is valid
alert | 15      | Attempt to modify a Protected Element | ex: trying to generate a certificate for subject "ca" or "crl"
alert | 15      | CRL has Expired                       | Will immediately generate a new one
emerg | 66      | OpenSSL error                         | ex: OpenSSL misused or cannot perform
emerg | 67      | CA Certificate is NOT VALID           | ex: CA certificate expired or file corrupted
none  | 100     | Certificate is Invalid                | ex: verifying an invalid certificate
none  | 101     | Certificate is Revoked                | ex: verifying a revoked certificate
none  | 102     | Certificate is Expired                | ex: verifying an expired certificate
warn  | 103     | Certificate status is Unknown         | cannot determine certificate status
crit  | 126-165 | Bash reserved                         | See [Bash Return Codes]
crit  | 255     | Bash reserved                         | See [Bash Return Codes]

Note for contributors: if you engage on hacking **SPKI** I strongly suggest you to avoid using [Bash Return Codes] for **SPKI** functions (so avoiding 1-2, 126-165 and 255 - Of course, use them to trap Bash related errors).

Note that the Return Code 100 is somewhat unusual: if **SPKI** returns 100 while trying to verify a given certificate, this mean that the verification operation was a success (so Return Code should be 0) but found the certificate to be INVALID. As external tools can use **SPKI** to check for certificates, this is a tweak used to ease external tools operations. None of these Return Codes will be submitted for logging (not even debug).


The same return codes will be used for the Bash and the Perl flavors of **SPKI**.

# Logging (syslog) facility and severity levels

**SPKI** will log its actions (and potentials errors) to syslog, using the regular [syslog Facility and Severity levels].

Severity Level | Meaning | Examples
:------------- | :------ | :------------ 
**emerg**      | Panic condition that need immediate action from the staff. | **SPKI** is not operational.
**alert**      | Alert that need immediate action. | Modifying (or trying to) modify CA elements.
**crit**       | Critical failure that need immediate action. | Legal operation fails. Need administrative intervention.
*err(or)*      | *Non urgent failure* | *Not Used*
**warn(ing)**  | Not an error, but action required to check everything is okay. | Unusual action that need to be reported to staff.
*notice*       | Unusual condition, have to be reported to admin and/or developers to spot potential problems. No immediate action required. | *Not Used*
**info**       | Normal operation message, no action requiered. | Normal operation performed (result seen by the user).
**debug**      | Debug level message. | Normal internal functions operations. Seen only if debugmode activited (disabled by default).

Note that syslog severity levels *err(or)*, *notice* are not used by **SPKI**, and *debug* is not logged unless debugmode is activated (disabled by default). Anyway, *debug* message are still seen by user form the CLI.

The same return facility and severity levels will be used for the Bash and the Perl flavors of **SPKI**.

# Sample logs
Here are some syslog example messages:

    Feb 11 14:58:27 scalde SPKI: alert - Initialization of a Certificate Authority triggered
    Feb 11 14:58:27 scalde SPKI: alert - Initializing Root Certificate Authority for ACME:
    Feb 11 14:58:29 scalde SPKI: alert - ACME Root Certificate Authority is initialized.
    Feb 11 15:00:38 scalde SPKI: alert - Initialization of a Certificate Authority triggered
    Feb 11 15:00:38 scalde SPKI: alert - Initializing Root Certificate Authority for ACME:
    Feb 11 15:00:40 scalde SPKI: alert - ACME Root Certificate Authority is initialized.
    Feb 11 15:08:32 scalde SPKI: info - A new CRL has been generated and CRL directory rehashed
    Feb 11 15:23:23 scalde SPKI: warn - GenerateCert cannot generate a user certificate for invalid EMAIL (servername.acme.com)
    Feb 11 15:47:48 scalde SPKI: info - A new CRL has been generated and CRL directory rehashed
    Feb 11 18:05:30 scalde SPKI: warn - SPKI invalid function call --init (try --help)
    
And here are some sample specific log file messages:

    Tue Feb 11 10:48:07 UTC 2014 : SPKI-debug : ParseConfigFile: logtofile overrided with legal value (/tmp/spki.log)
    Tue Feb 11 10:48:07 UTC 2014 : SPKI-debug : CheckEnv: CRL Expiry verification
    Tue Feb 11 10:48:07 UTC 2014 : SPKI-debug : CheckEnv: CRL Expiry verification is OK
    Tue Feb 11 10:48:07 UTC 2014 : SPKI-debug : CheckEnv: CRL Expiry verification
    Tue Feb 11 10:48:07 UTC 2014 : SPKI-debug : CheckEnv: CA Certificate validy verification is OK
    Tue Feb 11 10:48:07 UTC 2014 : SPKI-debug : CheckEnv: Openssl updating its index database
    Tue Feb 11 10:48:12 UTC 2014 : SPKI-debug : ParseConfigFile: logtofile overrided with legal value (/tmp/spki.log)
    Tue Feb 11 10:48:12 UTC 2014 : SPKI-debug : CheckEnv: CRL Expiry verification
    Tue Feb 11 10:48:12 UTC 2014 : SPKI-debug : CheckEnv: CRL Expiry verification is OK
    Tue Feb 11 10:48:12 UTC 2014 : SPKI-debug : CheckEnv: CRL Expiry verification
    Tue Feb 11 10:48:12 UTC 2014 : SPKI-debug : CheckEnv: CA Certificate validy verification is OK
    Tue Feb 11 10:48:12 UTC 2014 : SPKI-debug : CheckEnv: Openssl updating its index database
    Tue Feb 11 10:48:12 UTC 2014 : SPKI-debug : CheckEnv: CRL Expiry verification



