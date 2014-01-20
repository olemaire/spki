[Perl]:	http://www.perl.org/
[Bash]: http://www.gnu.org/software/bash/
[OpenSSL]: http://www.openssl.org/

# Simple Public Key Infrastructure - SPKI

**SPKI** is a simple and stupid (but yet useful) *Public* Key Infrastrucure using [OpenSSL].

* **Simple**: delivers only the most basic functions - in fact the functions I needed for personnal usage (user, servers and services certificates).
* **Stupid** : well... in fact will deliver X.509 Digital Certificates (and associated keys and CRL) but not built the way IETF PKIX nor SPKI RFCs indicate to follow. Loosely coded: just works, but not bullet proof at all (use at your own risks and perils...).
* **Key Infrastructure**: Certificates are X.509 PKIX compliant (or at least seems to be). I personnally use these certificates for a *Private* purpose, as most users does with PKIs... But you can use it for *Public* purpose (certificates for your web sites, to encrypt/decrypt mails within your colleagues, ...). 

**SPKI** comes in two flavors: made in [Bash] or [Perl], both using [OpenSSL] as cryptographic engine.

It's up to you to select the flavor that fits you best: both are released under BSD revised license.

# Installation & Configuration
See related flavor ([Bash] and [Perl]) Installation pages: browse the associated direction and have a look at their README file.

**SPKI** is designed to ease operations and you will need to configure the default options/fields you want to use in operation mode: this won't last longer than editing a file anyway, and will have to be done once at initialisation time.

During this installation and initialisation phase, you will have to decide for the mode you want to run **SPKI**:

* **Automated** mode: no passphrase to protect your keys, perfect to run as an automation within a broader {eco,info}system. You will have to make sure to install **SPKI** in a safe place where no regular user can have access to.
* **Manual** mode (not automated): passphrase to protect keys, default fields will still need to be validated by human interaction (text mode). Perfect to play around and discover the PKI. You will still have to make sure to install **SPKI** in a safe place where no regular user can have access to.

# Usage
No matter the mode you are running on, the same CLI is provided, and pretty self explanatory:

    Copyright (C) Senso-Rezo - SPKI (http://github.com/olemaire/spki)
    
    Usage: spki <option> (<subject>) 
    
    Available options are:
    --init                           Initialize a new Certiciate Authority.
    --server <fqdn>                  Generate a Server certificate.
    --user <email>                   Generate an User certificate.
    --verify <email,fqdn>            Verify a given certificate.
    --renew <email,fqdn>             Renew a given certificate.
    --revoke <email,fqdn> (reason)   Revoke a given certificate.
    --crl                            Generate a Certificate Revocation List.
    --info <email,fqdn,ca,crl>       Will display human readable infos on certificate/CRL
    --status                         Will give information on the SPKI status.
    --help                           Display this short help message.

For now, two types of certificates are delivered:

1. **server** certificates: for machines SSL/TLS connections. Examples: HTTPS servers, OpenSSL gateways, ...
2. **user** certificates: for authentication and mail protection (signing, encrypting). Example: <john.doe@mail.com> :)

## Automatic mode
In Automated mode, the usage is pretty straight and forward, and assume you know what you want to and want it done at light speed, even from a external script (for **SPKI** integration in broader system). 

The first step, after configuration, is to initialise the Certificate Authorithy:


## The Manual Way

# Credits
Thank's to ... tons of folks I did meet the last 15 years around the PKI(X most of the time) subject :)

If you are new to the PKI world, an excellent tutorial on implementing a real-world PKI with the [OpenSSL] toolkit can be found there: [http://pki-tutorial.readthedocs.org](http://pki-tutorial.readthedocs.org "")
