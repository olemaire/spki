[Bash]: http://www.gnu.org/software/bash/
[OpenSSL]: http://www.openssl.org/
[HomePage]: https://github.com/olemaire/spki
[Daniel Pocock Blog]: http://danielpocock.com/rsa-key-sizes-2048-or-4096-bits

# SPKI - the Bash flavor

Here is the [Bash] source code for **SPKI**. You will need [OpenSSL]
to make it run, and as both are installed by default on any decent Operating System, you can start generating certificates in few minutes.


This [Bash] flavor has been tested on OSX 10.9 with [OpenSSL] 0.9.8y, and Linux kernel 2.6.32 with [OpenSSL] 1.0.1c. 

It can handle thousands certificates without issue, even if it's more a beast of burden than a racehorse: better run it on a Core i7 than a Raspberry Pi (even if the Raspberry Pi will still perform not that bad).


# Let's use it
## Installation
Installation of the **SPKI** [Bash] flavor is pretty simple and straightforward:

1. create a directory where you want to host your PKI: 
2. copy into that directory the `spki` executable script you can find in the **SPKI** Github repository
3. make sure rights are ok, and that only the user you want to manipulate **SPKI** has access (read/write) this zone.

For example, if I want the user *glamorous* to be the **SPKI** administrator, installing it in `/opt/PKI` you should:

    root@scalde:~# mkdir /opt/PKI
    root@scalde:~# wget https://raw.github.com/olemaire/spki/master/bash/spki -O /opt/PKI/spki
    --2014-01-21 12:11:33--  https://raw.github.com/olemaire/spki/master/bash/spki
    Resolving raw.github.com (raw.github.com)... 199.27.72.133
    Connecting to raw.github.com (raw.github.com)|199.27.72.133|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 32419 (32K) [text/plain]
    Saving to: '/opt/PKI/spki'
    
    100%   [======================================================>] 32,419      --.-K/s   in 0.02s   
    
    2014-01-21 12:11:33 (1.48 MB/s) - '/opt/PKI/spki' saved [32419/32419]

    root@scalde:~# chown +wx /opt/PKI/spki       
    root@scalde:~# chown -R glamorous /opt/PKI && chmod go= /opt/PKI 
    

## Configuration

Once installed, you need to configure:

1. the mode of operation of your **SPKI**: Automated or not.
2. the default fields you want **SPKI** to apply/propose.

As user *glamorous*, create and edit the `/opt/PKI/spki.conf` new file and modify the following values accordingly to your needs. Here is an example with self explanatory comments:

    ## SPKI configuration file
    #  will override default values if used
    #  Please handle with care and DO NOT CHANGE WHEN THE CA HAS BEEN INIALIZED
    #  (else you'll kill you PKI...)
    #
    #  Syntax:
    #    KEY=VALUE
    #  or KEY="VALUE"
    #  Please no space nor tabs between KEY/VALUE and "=" 
    
    ## user/context variables - have to be changed depending on user/context
    # Country Code you want to registrer the PKI to (must be 2 letter country code)
    COUNTRY="US"
    # Domain name that will appear by default: change it by your company domain name
    DOMAIN="acme.com"
    # Company name that will appear by default: change it by your company name
    COMPANY="ACME"
    # The Support Email address used for server certiciates (DOMAIN will be prepended to with @)
    supportmail="support"
    # Random bits used (between 1024 and 4096)
    BITS=2048
    # Certificate Authority certificate will be valid for this period (just over 20 years...)
    CACERT_DAYS=7306
    # Server certificate will be issued (new, renewed) for this period (just over 10 years...)
    SERVER_DAYS=3653
    # User certificates will be issued (new, renewed) for this period (just over 13 months...)
    USER_DAYS=396
    # Days between each CRL is due (a new CRL *MUST* be regenerated before this delay)
    CRL_DAYS=31
    
    ## user/context automation mode - have to be changed depending on user context
    # Define if SPKI must be full automated or not (yes/not)
    automated="yes"
    # Activate/Desactivate the debug mode (yes/no) - default no
    debugmode="no"
    # Activate a specific logfile (yes/no) - default no (using syslog)
    specificlogfile="yes"
    # If specificlogfile is activated, then which is the log file to use
    logtofile="/tmp/spki.log"
    
    ## - This Is The End


To select the Automated mode, make sure *yes* is the value for the "automated" variable (default configuration). If you prefer the manual mode, then enter *no* instead.

    # Default is no
    automated="yes"
    
To configure the default fields of your PKI, modify the following variables to best suit your need (see the "Tips and Tricks"" section of this document for some more infos). For example:

    COUNTRY="US"
    DOMAIN="acme.com"
    COMPANY="ACME"
    supportmail="support"
    BITS=2048
    CACERT_DAYS=7306
    SERVER_DAYS=3653
    USER_DAYS=396
    CRL_DAYS=31

Note that BITS cannot be under 1024 nor greater than 4096 - as can cause issue to some SSL clients if not in this range. Default value of 2048 is ok.

Once done, you can unflag the write attibute of the `/opt/PKI/spki` file to make sure not to modify it later on

    glamorous@scalde:/opt/PKI$ chmod -w spki 

Let's then initialize your **SPKI** instance:

    glamorous@scalde:/opt/PKI$ ./spki --init
    ##### Initializing Root Certificate Authority for ACME:
    ----> Automated mode is ON...
    ----> Initializing Random Bits...
    ----> Generating the Certificate Authority private Key...
    ----> Self-signing the Certificate Authority Certificate...
    ----> Initializing user environment (directories and indexes)...
    ##### ACME Root Certificate Authority initialized successfully.
    glamorous@scalde:/opt/PKI$ 


Your **SPKI** is ready to serve:

    glamorous@scalde:/opt/PKI$ ./spki --info
    General info on the Certificate Authority:
    ------------------------------------------
    Host running SPKI:                          scalde
    Operating System:                           Linux
    Cryptographic Engine:                       OpenSSL 1.0.1c 10 May 2012
     - CA Distinguished Name:                   C=US/O=ACME/OU=ACME Security Services/CN=ACME Root CA
     - Start Validity on:                       Jan 21 17:41:23 2014 GMT
     - End Validity on:                         Jan 22 17:41:23 2034 GMT
    
    Issued certificates:
     - Valid:                                   0
     - Revoked:                                 0
     - Expired:                                 0
    
    CRL infos:
     - Last CRL produced on:                    Jan 21 17:41:23 2014 GMT
     - Next CRL to be produced on:              Feb 21 17:41:23 2014 GMT
    
    Current Status:                             OK

    glamorous@scalde:/opt/PKI$ 

You can now start using your **SPKI** to manage certificates :)

# Usage
Please consult the main Github Repository [HomePage] for how to use **SPKI**, as no matter the flavor you prefer, the usage and commands are the same.

# Tips and Tricks
## Size of private keys
By default, **SPKI** will use keys of 2048 bits. If you want another size, just change the "BITS" variable to your key size preference. This option must be done **before** the first initalization of **SPKI**

    BITS=2048                        # Random bits used

There is no "best and fits all" solution for key size: have a look at [Daniel Pocock Blog] page on this topic.

Anyway, **SPKI** will force you to use BITS within the range 1024 to 4096 - to make sure no issues with all known OpenSSL clients.
## Renewal time
By default, **SPKI** will issue:

* *user* certificate for 13 months - then you will need to renew them
* *server* certiticates for just over 10 years (! yes :) - then you will need to renew them.
* *CRL* that last for 31 days before needing generation of a new *CRL* (of course you are free to deliver new *CRL* before this date).
* *CA* certificate for 20 years (yes !) - then you will need to renew the CA certificate (a not automated process - yet)

You can of course set your own duration, using the following variables:

    CACERT_DAYS=7306                 # Certificate Authority certificate will be valid for this period (just over 20 years...)
    SERVER_DAYS=3653                 # Server certificate will be issued (new, renewed) for this period (just over 10 years...)
    USER_DAYS=396                    # User certificates will be issued (new, renewed) for this period (just over 13 months...)
    CRL_DAYS=31                      # Days between each CRL is due (a new CRL *MUST* be regenerated before this delay)


As for key size, there is no "best and fits all" (nor best practice anyway) regarding the duration to use for certificate issuing - as it really depends on your specific needs and organisation.

Have a look at [Daniel Pocock Blog] page on this topic to help you find your best answer.


# Playin'around
## File organization
As you will have understood within minutes, **SPKI** rely on using a specific file organisation, explained hereafter:

    <SPKI_Install_Dir>/ 
       |-- spki executable (Bash script)
       |-- spki.conf (User configuration file )
       |
       |--private/ where SPKI store the Certificate Authority private stuff
       |         |-- ca.key: the CA private key (MUST NOT BE DISTRIBUTED)
       |         \-- root_ca.conf: the CA OpenSSL configuration file
       |
       |--datas/ where SPKI store index, serials and databases
       |       |-- random_bits: pseudo-Random bytes used for OpenSSL entropy
       |       |-- index(.old): index of all certificates (and last action backup)
       |       |-- serial_cert(.old): next certificate serial (and...)
       |       |-- serial_crl(.old): next CRL serial to be used
       |       \--certs/ directory containing all certificates
       |
       |--csr/ where all Cerfiticate Signing Request are stored - with associated OpenSSL configuration
       |
       |--crl/ where the current CRL is generated, and hashed to be used for certificate verification
       |
       |--keys/ where all delivered certificate private keys are stored (MUST NOT BE DISTRIBUTED)
       |
       \--certs/ where all public certs are published (may be publicly available)
       

## Big Guys need Big Certs... 
**SPKI** can handle thousands of certificates like a charm, but how does it cope with millions? The correct answer is - so far I dunno :)

More seriousely, actually, this [Bash] flavor has been tested with up to around 22.000 certificates, but no real tweaking has been done to see how far it can goes, and how we can steamlined its operation to cope with **huge** volume. 

As far as I can see:

* numerous files - and so **inodes** - taken to deal with files (Certificates, CSR, configurations, ...) of small sizes: this will have impact on your file system usage (or settings), and so you must careful select (and configure) it for this usage.
* generating a certificate takes from 0.2 second to 0.9 second, depending on the arch you are using. Revoking a certificate takes around 0.05 to 0.1 second, and seems to be less impacted by your arch.
* the [OpenSSL] index file has to be loaded in memory each time [OpenSSL] is used, which means having some RAM on your system for big databaes: 400 KB index file for 3.500 certificates, 1.7 MB index file for 15.000 certificates, and ended up with 2.5 MB for 22.271 certificates.
* As there is lots of read/write operations on disk ([OpenSSL] index, **SPKI** storing certificates and associated files), selecting a efficient drive helps alot (SSD for extreme boys...)

This means that handling thousands of certificates can still be done on a Raspberry Pi if needed, but for millions of certificates some real bench should be envisaged to select the best hardware (or Virtual Machine tier...) and file system type and options (XFS?).


