[Rust]: http://www.rust-lang.org/
[Perl]:	http://www.perl.org/
[Bash]: http://www.gnu.org/software/bash/
[OpenSSL]: http://www.openssl.org/
[FQDN]: https://en.wikipedia.org/wiki/Fully_qualified_domain_name
# Simple Public Key Infrastructure - SPKI

**SPKI** is a simple and stupid (but yet useful) *Public* Key Infrastrucure using [OpenSSL].

* **Simple**: delivers only the most basic functions - in fact the functions I needed for personnal usage (user, servers and services certificates).
* **Stupid** : well... in fact will deliver X.509 Digital Certificates (and associated keys and CRL) but not built the way IETF PKIX nor SPKI RFCs indicate to follow. Loosely coded: just works, but not bullet proof at all (use at your own risks and perils...).
* **Key Infrastructure**: Certificates are X.509 PKIX compliant (or at least seems to be). I personnally use these certificates for a *Private* purpose, as most users does with PKIs... But you can use it for *Public* purpose (certificates for your web sites, to encrypt/decrypt mails within your colleagues, ...). 

**SPKI** comes in multiple flavors: made in [Bash], [Perl] or [Rust], all flavors using [OpenSSL] as cryptographic engine.

It's up to you to select the flavor that fits you best: both are released under BSD revised license.


**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Installation & Configuration](#installation--configuration)
- [Usages](#usages)
- [Howto use SPKI](#howto-use-spki)
	- [Automatic mode](#automatic-mode)
		- [First: Initialize your Certificate Authority](#first-initialize-your-certificate-authority)
		- [Then, let's create some Certificates](#then-lets-create-some-certificates)
		- [Let's verify and revoke somes...](#lets-verify-and-revoke-somes)
		- [And what about renewing some certificates?](#and-what-about-renewing-some-certificates)
		- [Some more informations?](#some-more-informations)
		- [But sometimes, things can go weird...](#but-sometimes-things-can-go-weird)
	- [The Manual Way](#the-manual-way)
- [Credits](#credits)


# Installation & Configuration
**SPKI** is designed to ease operations and you will need to configure the default options/fields you want to use in operation mode: this won't take longer than creating and editing a file anyway, and will have to be done only once at initialisation time.

During this installation and initialisation phase, you will have to decide for the mode you want to run **SPKI**:

* **Automated** mode: no passphrase to protect your keys, perfect to run as an automation within a broader {eco,info}system.
* **Manual** mode (not automated): passphrase to protect keys, default fields will still need to be validated by human interaction (text mode). Perfect to play around and discover the PKI.

Then, you will have to indicate some default values you want for your PKI: Country, Domains, emails, duration of certificates validity, ...

See related flavor Installation pages: browse the associated directory and have a look at their README.md file for more informations.

Here a sample configuration file for a [Bash] flavor **SPKI**, used in the scope of the present manual/howto:

    ## My SPKI configuration file
    country="US"
    domain="acme.com"
    company="ACME"
    supportmail="helpdesk"
    
    bits=2048
    cacert_days=7306
    server_days=3653
    user_days=396
    crl_days=31
    
    automated="yes"
    debugmode="no"
    specificlogfile="no"
    logtofile="/tmp/spki.log"

    ## - This Is The End

In any cases, you will have to make sure to install **SPKI** in a safe place where no regular user can have access to.

# Usages
No matter the mode you are running on, the same CLI is provided, and pretty self explanatory:

    Copyright (C) Senso-Rezo - SPKI (http://github.com/olemaire/spki)
    
    Usage: spki <option> (<subject>) 
    
    Available options are:
        --initialize                     Initialize a new Certiciate Authority
        --issue <type> <subject>         Issue a certificate of <type> for <subject>
                server <fqdn>              issue a Server certificate
                user <email>               issue an User certificate
        --verify <email,fqdn>            Verify a given certificate
        --renew <email,fqdn> (reason)    Renew a given certificate
        --revoke <email,fqdn> (reason)   Revoke a given certificate
        --crl                            Generate a Certificate Revocation List
        --print <email,fqdn,ca,crl>      Will display a raw print of certificate/CRL
        --info (email,fqdn,ca,crl)       Will give human readable information on SPKI certificate/CA/CRL
        --status                         Will give an overall status of operatin of SPKI
        --help                           Display this short help message

For now, two types of certificates are delivered:

1. **server** certificates: for machines SSL/TLS connections, associated with a [FQDN].

    They need to be **delivered for a DNS machine name** (ie: host.domain.tld)
    
    They can be used for the following x509 operations: TLS Web Server Authentication, TLS Web Client Authentication, Microsoft Server Gated Crypto, Netscape Server Gated Crypto.
    
    Common usage: HTTPS servers, OpenVPN gateways, ...
    
2. **user** certificates: for authentication and mail protection. 

    They need to be **delivered for a Email** (ie: user@domain.tld)
    
    They can be used for the following x509 operations: TLS Web Client Authentication, E-mail Protection.
    
    Common usage: Mail certificate, HTTPS authentification certificate, OpenVPN user certificate, ...

# Howto use **SPKI**
## Automatic mode
In Automated mode, the usage is pretty straight and forward, and assume you know what you want to, and want it done at light speed, even from a external system (for **SPKI** integration in broader system). 


### First: Initialize your Certificate Authority

The first step, after configuration, is to start in the directory you installed you **SPKI**. For example:

    glamorous@scalde:~/SPKI$ pwd
    /home/glamorous/SPKI
    glamorous@scalde:~/SPKI$ ls -l
    total 68
    -rwxrwxr-x 1 glamorous glamorous 63320 Feb 11 14:57 spki
    -rw-rw-r-- 1 glamorous glamorous   271 Feb 11 14:58 spki.conf
    glamorous@scalde:~/SPKI$ 

Then, let's first initialise the Certificate Authorithy:

    glamorous@scalde:~/SPKI$ ./spki --initialize
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !!!!! Initializing Root Certificate Authority for ACME:
    ----> Automated mode is ON...
    ----> Initializing Random Bits...
    ----> Generating the Certificate Authority private Key...
    ----> Self-signing the Certificate Authority Certificate...
    ----> Initializing user environment (directories and indexes)...
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !!!!! ACME Root Certificate Authority is initialized.
    ----> SPKI ready for service
    
    General info on the Certificate Authority:
    ------------------------------------------
    Host running SPKI:                          scalde
    Operating System:                           Linux
    Cryptographic Engine:                       OpenSSL 1.0.1c 10 May 2012
     - CA Distinguished Name:                   CN=ACME Root CA,OU=ACME Security Services,O=ACME,C=US
     - Start Validity on:                       Feb 11 20:00:40 2014 GMT
     - End Validity on:                         Feb 12 20:00:40 2034 GMT
    
    Issued certificates:
     - Valid:                                   0
     - Revoked:                                 0
     - Expired:                                 0
    
    CRL infos:
     - Last CRL produced on:                    Feb 11 20:00:40 2014 GMT
     - Next CRL to be produced on:              Mar 14 20:00:40 2014 GMT
    
    Current Status:                             OK
    
    glamorous@scalde:~/SPKI$ 

    
Congratulations, you PKI si ready to serve. To make sure:

    glamorous@scalde:~/SPKI$ ./spki --status
    OK
    glamorous@scalde:~/SPKI$ echo $?
    0
    glamorous@scalde:~/SPKI$
    
Ok, feel good, but what about that PKI? Just ask:

    glamorous@scalde:~/SPKI$ ./spki --info  
    General info on the Certificate Authority:
    ------------------------------------------
    Host running SPKI:                          scalde
    Operating System:                           Linux
    Cryptographic Engine:                       OpenSSL 1.0.1c 10 May 2012
     - CA Distinguished Name:                   CN=ACME Root CA,OU=ACME Security Services,O=ACME,C=US
     - Start Validity on:                       Feb 11 20:00:40 2014 GMT
     - End Validity on:                         Feb 12 20:00:40 2034 GMT
    
    Issued certificates:
     - Valid:                                   0
     - Revoked:                                 0
     - Expired:                                 0
    
    CRL infos:
     - Last CRL produced on:                    Feb 11 20:00:40 2014 GMT
     - Next CRL to be produced on:              Mar 14 20:00:40 2014 GMT
    
    Current Status:                             OK
    
    glamorous@scalde:~/SPKI$ 


Ok, your PKI is ready to deliver certificates :)

### Then, let's create some Certificates

To generate a certificate, just ask the correct type: **server** or **user** are the only type managed so far. To generate somes:

    glamorous@scalde:~/SPKI$ ./spki --issue user john.doe@acme.com
    ----> Certificate (user) generated for john.doe@acme.com:
    ---->  - CA certificate: /home/glamorous/SPKI/certs/ca.pem
    ---->  - Subject certificate: /home/glamorous/SPKI/certs/john.doe@acme.com.pem
    ---->  - Subject private key: /home/glamorous/SPKI/keys/john.doe@acme.com.key
    ----> Have a nice day.
    glamorous@scalde:~/SPKI$ ./spki --issue user jane.did@acme.com
    ----> Certificate (user) generated for jane.did@acme.com:
    ---->  - CA certificate: /home/glamorous/SPKI/certs/ca.pem
    ---->  - Subject certificate: /home/glamorous/SPKI/certs/jane.did@acme.com.pem
    ---->  - Subject private key: /home/glamorous/SPKI/keys/jane.did@acme.com.key
    ----> Have a nice day.
    glamorous@scalde:~/SPKI$ ./spki --issue server www.acme.com   
    ----> Certificate (server) generated for www.acme.com:
    ---->  - CA certificate: /home/glamorous/SPKI/certs/ca.pem
    ---->  - Subject certificate: /home/glamorous/SPKI/certs/www.acme.com.pem
    ---->  - Subject private key: /home/glamorous/SPKI/keys/www.acme.com.key
    ----> Have a nice day.
    glamorous@scalde:~/SPKI$ ./spki --issue server openvpn.acme.com
    ----> Certificate (server) generated for openvpn.acme.com:
    ---->  - CA certificate: /home/glamorous/SPKI/certs/ca.pem
    ---->  - Subject certificate: /home/glamorous/SPKI/certs/openvpn.acme.com.pem
    ---->  - Subject private key: /home/glamorous/SPKI/keys/openvpn.acme.com.key
    ----> Have a nice day.
    glamorous@scalde:~/SPKI$ 

       
Ok, we now have some certificates as we can see:

    glamorous@scalde:~/SPKI$ ./spki --info
    General info on the Certificate Authority:
    ------------------------------------------
    Host running SPKI:                          scalde
    Operating System:                           Linux
    Cryptographic Engine:                       OpenSSL 1.0.1c 10 May 2012
     - CA Distinguished Name:                   CN=ACME Root CA,OU=ACME Security Services,O=ACME,C=US
     - Start Validity on:                       Feb 11 20:00:40 2014 GMT
     - End Validity on:                         Feb 12 20:00:40 2034 GMT
    
    Issued certificates:
     - Valid:                                   4
     - Revoked:                                 0
     - Expired:                                 0
    
    CRL infos:
     - Last CRL produced on:                    Feb 11 20:00:40 2014 GMT
     - Next CRL to be produced on:              Mar 14 20:00:40 2014 GMT
    
    Current Status:                             OK
    
    glamorous@scalde:~/SPKI$ 


    
### Let's verify and revoke somes...

A certificate is considered VALID if not revoked nor expired, and if it has been delivered by **SPKI** (signed by your Certificate Authority more precisely). If expired, or revoked (or a foreign - to your PKI - certificate), it will be considered INVALID - and for both case the exact status (REVOKED/EXPIRED) will be displayed.

To verify a given certificate, just issue the `--verify` command:

    glamorous@scalde:~/SPKI$ ./spki --verify www.acme.com
    Certificate for www.acme.com is: VALID
    glamorous@scalde:~/SPKI$ echo $?
    0
    glamorous@scalde:~/SPKI$ 
    

Let's revoke this certificate with the `--revoke` command:
    
    glamorous@scalde:~/SPKI$ ./spki --revoke www.acme.com
    ----> Revoking certificate for www.acme.com (reason = unspecified):
    ---->  - Certificate for subject www.acme.com has been revoked for reason unspecified.
    ---->  - Generating a new CRL...
    ----> Certificate for subject www.acme.com has been revoked and a new CRL has been generated.
    glamorous@scalde:~/SPKI$ 

Then, try to verify again this certificate: 

    glamorous@scalde:~/SPKI$ ./spki --verify www.acme.com
    Certificate for www.acme.com is: REVOKED
    glamorous@scalde:~/SPKI$ echo $?
    101
    glamorous@scalde:~/SPKI$ 

     
As the *www.acme.com* certificate has been revoked, and a new CRL generated, this certificate is not anymore checked as VALID.

Please note that the return code is "0" if the certificate is VALID, and 100+ if INVALID (101 for REVOKED in the above example). This may helps if you want to test the validity of certificates from your scripts or any external (to **SPKI**) system. See Documentation on Return Codes (`doc/` directory of this github repository) for more information.

### And what about renewing some certificates?
Ok, let renew the certificate for *wwww.acme.com* :

    glamorous@scalde:~/SPKI$ ./spki --renew www.acme.com
    ----> Renewing Certificate (type: server) for www.acme.com with reason superseded:
    ---->  - a certificate for www.acme.com have already been revoked, so no reason to revoke now
    ---->  - Generating a new certificate (type: server) for www.acme.com...
    ---->  - A New Certificate (server) generated for www.acme.com at:
    ---->  - /home/glamorous/SPKI/certs/www.acme.com.pem
    ----> Have a nice day.
    glamorous@scalde:~/SPKI$ 
    
Renewed means that the certificate for *www.acme.com* should now be valid:

    glamorous@scalde:~/SPKI$ ./spki --verify www.acme.com
    Certificate for www.acme.com is: VALID
    glamorous@scalde:~/SPKI$ 

That means that some certificates were revoked, and new one created, as we can observe in the overall information of the **SPKI** Certificate Authority:

    glamorous@scalde:~/SPKI$ ./spki --info               
    General info on the Certificate Authority:
    ------------------------------------------
    Host running SPKI:                          scalde
    Operating System:                           Linux
    Cryptographic Engine:                       OpenSSL 1.0.1c 10 May 2012
     - CA Distinguished Name:                   CN=ACME Root CA,OU=ACME Security Services,O=ACME,C=US
     - Start Validity on:                       Feb 11 20:00:40 2014 GMT
     - End Validity on:                         Feb 12 20:00:40 2034 GMT
    
    Issued certificates:
     - Valid:                                   4
     - Revoked:                                 1
     - Expired:                                 0
    
    CRL infos:
     - Last CRL produced on:                    Feb 11 20:08:32 2014 GMT
     - Next CRL to be produced on:              Mar 14 20:08:32 2014 GMT
    
    Current Status:                             OK
    
    glamorous@scalde:~/SPKI$ 

### Some more informations?
You can use the `--info` option to grab more infos about the CA certificate and the CRL. 

    glamorous@scalde:~/SPKI$ ./spki --info ca
    General info on the Certificate Authority:
    ------------------------------------------
    Host running SPKI:                          scalde
    Operating System:                           Linux
    Cryptographic Engine:                       OpenSSL 1.0.1c 10 May 2012
     - CA Distinguished Name:                   CN=ACME Root CA,OU=ACME Security Services,O=ACME,C=US
     - Start Validity on:                       Feb 11 20:00:40 2014 GMT
     - End Validity on:                         Feb 12 20:00:40 2034 GMT
    
    Issued certificates:
     - Valid:                                   4
     - Revoked:                                 1
     - Expired:                                 0
    
    CRL infos:
     - Last CRL produced on:                    Feb 11 20:08:32 2014 GMT
     - Next CRL to be produced on:              Mar 14 20:08:32 2014 GMT
    
    Current Status:                             OK
    
    glamorous@scalde:~/SPKI$ ./spki --info crl
    Certificate Revocation List (CRL) info:
    ---------------------------------------
    Certificate Authority that issued:          CN=ACME Root CA,OU=ACME Security Services,O=ACME,C=US
    Current CRL:
     - CRL serial number:                       2 (hex: 02) 
     - CRL produced on:                         Feb 11 20:08:32 2014 GMT
     - CRL next update on (at max):             Mar 14 20:08:32 2014 GMT
    
    Number of Revoked Certificates:             1
    
    Current Status:                             OK
    
    glamorous@scalde:~/SPKI$ 

Option `--info` used without subject will give you more information regarding your **SPKI** Certificate Authority (a short way to issue `--info ca` in fact).


And of course, you probably guessed it, you can use `--info` to look for information on a given certificate:

    glamorous@scalde:~/SPKI$ ./spki --info www.acme.com
    Certificate usefull informations:
    ---------------------------------
    Certificate issed for subject:                www.acme.com
     - Delivered by:                              CN=ACME Root CA,OU=ACME Security Services,O=ACME,C=US
     - for subject DN:                            emailAddress=helpdesk@acme.com,CN=www.acme.com,OU=Operational Unit,O=ACME,C=US
     - Certificate serial number:                 5 (hex: 05)
    
    Certificate Type:                             SERVER certificate
     - Capacities:                                serverAuth,clientAuth,msSGC,nsSGC
     - Attached to email:                         helpdesk@acme.com
     - Alias:                                     <No Alias>
    
    Certificate Validity:
     - valid from:                                Feb 11 20:11:43 2014 GMT
               to:                                Feb 12 20:11:43 2024 GMT
    
    Current Status:                               VALID
    
    glamorous@scalde:~/SPKI$ ./spki --info john.doe@acme.com
    Certificate usefull informations:
    ---------------------------------
    Certificate issed for subject:                john.doe@acme.com
     - Delivered by:                              CN=ACME Root CA,OU=ACME Security Services,O=ACME,C=US
     - for subject DN:                            emailAddress=john.doe@acme.com,CN=john.doe@acme.com,OU=Operational Unit,O=ACME,C=US
     - Certificate serial number:                 1 (hex: 01)
    
    Certificate Type:                             USER certificate
     - Capacities:                                clientAuth,emailProtection
     - Attached to email:                         john.doe@acme.com
     - Alias:                                     <No Alias>
    
    Certificate Validity:
     - valid from:                                Feb 11 20:04:04 2014 GMT
               to:                                Mar 14 20:04:04 2015 GMT
    
    Current Status:                               VALID
    
    glamorous@scalde:~/SPKI$ 
    
You can also use the `--print` option to have some raw information on certificates (CA, CRL, user and server certificates). 

If lost, remember to use `--help` option for a quick reminder.
        
### But sometimes, things can go weird...
**SPKI** will try to detect most typo errors and make sure the operation you are asking for are safe before proceeding. If not, you will exit, printing an Error Code with an helping message and casting a Return Code equal to the Error Code:

    glamorous@scalde:~/SPKI$ ./spki --issue user jane.did@acme.com
    ----> GenerateCert: Trying to generate a user certificate which already exists (jane.did@acme.com)
    ----> Exiting with Error Code 14 (GenerateCert: Trying to generate a user certificate which already exists (jane.did@acme.com))...
    glamorous@scalde:~/SPKI$ echo $?
    14
    glamorous@scalde:~/SPKI$ 

or...

    glamorous@scalde:~/SPKI$ ./spki --info darth.vader@acme.com
    ----> PrintCertInfo: Subject darth.vader@acme.com does not exists!
    ----> Exiting with Error Code 13 (PrintCertInfo: Subject darth.vader@acme.com does not exists!)...
    glamorous@scalde:~/SPKI$ echo $?
    13
    glamorous@scalde:~/SPKI$ 
    
**SPKI** will also make sure your operation are valid before proceeding:

    glamorous@scalde:~/SPKI$ ./spki --issue user servername.acme.com
    ##### GenerateCert cannot generate a user certificate for invalid EMAIL (servername.acme.com)
    ----> Exiting with Error Code 12 (GenerateCert cannot generate a user certificate for invalid EMAIL (servername.acme.com))...
    glamorous@scalde:~/SPKI$ ./spki --issue user super@man
    ##### GenerateCert cannot generate a user certificate for invalid EMAIL (super@man)
    ----> Exiting with Error Code 12 (GenerateCert cannot generate a user certificate for invalid EMAIL (super@man))...
    glamorous@scalde:~/SPKI$ ./spki --issue server julia.robert@acme.com
    ##### GenerateCert cannot generate a server certificate for invalid FQDN (julia.robert@acme.com)
    ----> Exiting with Error Code 12 (GenerateCert cannot generate a server certificate for invalid FQDN (julia.robert@acme.com))...
    glamorous@scalde:~/SPKI$ echo $?
    12
    glamorous@scalde:~/SPKI$ 

    
**SPKI** Error Codes are presented in the `doc/` section of this present Github repository.

        
## The Manual Way
The manual way is not de default mode for **SPKI** and so need to be specified by configuration file (file `spki.conf` - see your prefered flavor documentation):

    automated="no"
    
Once done, **SPKI** will:

* allow to use passphrase to protect private keys
* allow you to modify any certificate fields (email, names, countries...) at generation time
* will be more verbose, displaying OpenSSL outputs when called.

You can selectively switch mode after **SPKI** initialization, but the choice for the CA private key passphrase protection is done only once: at initialization phase, and if you had selected the manual way (remember, not be default mode).

Running **SPKI** full automated as a base rule, and sometimes in manual mode for selected certificates operations can grant more flexibility on the certificate type you whish to deliver (for example, for a company issueing certificates for occasional subcontractors).

# Credits
Thank's to ... all folks I did meet last years around the (S)PKI(X) subject(s) :)

If you are new to the PKI world, an excellent tutorial on implementing a real-world PKI with the [OpenSSL] toolkit can be found there: [http://pki-tutorial.readthedocs.org](http://pki-tutorial.readthedocs.org "")
