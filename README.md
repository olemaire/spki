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

### First: Initialize your Certificate Authority

The first step, after configuration, is to initialise the Certificate Authorithy:

    me@localhost:~/github/spki/bash$ ./spki --init
    ##### Initializing Root Certificate Authority for Senso-Rezo:
    ----> Automated mode is ON...
    ----> Initializing Random Bits...
    ----> Generating the Certificate Authority private Key...
    ----> Self-signing the Certificate Authority Certificate...
    ----> Initializing user environment (directories and indexes)...
    ----> Generating a new CRL...
    ##### Senso-Rezo Root Certificate Authority initialized successfully.
    me@localhost:~/github/spki/bash$
    
Congratulations, you PKI si ready to serve. To make sure:

    me@localhost:~/github/spki/bash$ ./spki --status
    OK
    me@localhost:~/github/spki/bash$ echo $?
    0
    me@localhost:~/github/spki/bash$
    
Ok, feel good, but what about that PKI? Just ask:

    me@localhost:~/github/spki/bash$ ./spki --info
    General info on the Certificate Authority:
    ------------------------------------------
    Cryptographic Engine:                       OpenSSL 0.9.8y 5 Feb 2013
    Certificate Authority DN:                   C=US/O=Senso-Rezo/OU=Senso-Rezo Security Services/CN=Senso-Rezo Root CA
    Start Validity on:                          Jan 20 22:23:28 2014 GMT
    End Validity on:                            Jan 21 22:23:28 2034 GMT
    Issued certificates Valid/Revoked/Expired:  0 / 0 / 0
    Last CRL produced on:                       Jan 20 22:23:28 2014 GMT
    Next CRL to be produced on:                 Feb 20 22:23:28 2014 GMT
    Current Status:                             OK
    
    me@localhost:~/github/spki/bash$

Ok, you've got a PKI ready to deliver certificates...

### Then, let's create some Certificates

To generate a certificate, just ask the correct type: **server** or **user** are the only type managed so far. To generate somes:

    me@localhost:~/github/spki/bash$ ./spki --user john.doe@pki.me
    ----> Certificate (user) generated for john.doe@pki.me:
    ---->  - CA certificate: /Users/me/github/spki/bash/certs/ca.pem
    ---->  - Subject certificate: /Users/me/github/spki/bash/certs/john.doe@pki.me.pem
    ---->  - Subject private key: /Users/me/github/spki/bash/keys/john.doe@pki.me.key
    ----> Have a nice day.
    me@localhost:~/github/spki/bash$ ./spki --user jane.did@pki.me
    ----> Certificate (user) generated for jane.did@pki.me:
    ---->  - CA certificate: /Users/me/github/spki/bash/certs/ca.pem
    ---->  - Subject certificate: /Users/me/github/spki/bash/certs/jane.did@pki.me.pem
    ---->  - Subject private key: /Users/me/github/spki/bash/keys/jane.did@pki.me.key
    ----> Have a nice day.
    me@localhost:~/github/spki/bash$ ./spki server www.pki.me
    ----> Certificate (server) generated for www.pki.me:
    ---->  - CA certificate: /Users/me/github/spki/bash/certs/ca.pem
    ---->  - Subject certificate: /Users/me/github/spki/bash/certs/www.pki.me.pem
    ---->  - Subject private key: /Users/me/github/spki/bash/keys/www.pki.me.key
    ----> Have a nice day.
    me@localhost:~/github/spki/bash$ ./spki server openvpn.pki.me
    ----> Certificate (server) generated for openvpn.pki.me:
    ---->  - CA certificate: /Users/me/github/spki/bash/certs/ca.pem
    ---->  - Subject certificate: /Users/me/github/spki/bash/certs/openvpn.pki.me.pem
    ---->  - Subject private key: /Users/me/github/spki/bash/keys/openvpn.pki.me.key
    ----> Have a nice day.
    me@localhost:~/github/spki/bash$
       
Ok, we now have some cerficiates as we can see:

    me@localhost:~/github/spki/bash$ ./spki --info
    General info on the Certificate Authority:
    ------------------------------------------
    Cryptographic Engine:                       OpenSSL 0.9.8y 5 Feb 2013
    Certificate Authority DN:                   C=US/O=Senso-Rezo/OU=Senso-Rezo Security Services/CN=Senso-Rezo Root CA
    Start Validity on:                          Jan 20 22:36:15 2014 GMT
    End Validity on:                            Jan 21 22:36:15 2034 GMT
    Issued certificates Valid/Revoked/Expired:  4 / 0 / 0
    Last CRL produced on:                       Jan 20 22:36:15 2014 GMT
    Next CRL to be produced on:                 Feb 20 22:36:15 2014 GMT
    Current Status:                             OK

And if you need more information a given certificate, it's pretty simple too:

    me@localhost:~/github/spki/bash$ ./spki --info openvpn.pki.me
    Printing certificate information for openvpn.pki.me:
    Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 4 (0x4)
        Signature Algorithm: sha1WithRSAEncryption
        Issuer: C=US, O=Senso-Rezo, OU=Senso-Rezo Security Services, CN=Senso-Rezo Root CA
        Validity
            Not Before: Jan 20 22:42:23 2014 GMT
            Not After : Jan 21 22:42:23 2034 GMT
        Subject: C=US, O=Senso-Rezo, OU=Operational Unit, CN=openvpn.pki.me/emailAddress=sysadm@senso-rezo.org
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
            RSA Public Key: (2048 bit)
                Modulus (2048 bit):
                    00:b6:08:58:8d:ac:94:cb:24:e4:0a:6c:6a:f2:63:
                    bd:1e:50:e4:4d:eb:48:49:75:07:06:53:10:b9:27:
                    ef:84:de:fd:8c:f2:54:a7:3c:21:b4:b1:36:e4:31:
                    fd:80:e5:cf:4e:78:c3:b8:03:02:21:08:5f:bc:1f:
                    da:eb:92:6c:f6:4e:58:78:37:42:cc:03:51:c7:5b:
                    23:cd:05:10:05:8e:f4:f9:95:dc:67:b4:d0:04:4c:
                    5f:1a:3b:03:72:30:49:d1:24:c9:f9:33:c1:48:ab:
                    00:df:61:49:d6:cb:0f:a8:4f:b7:3c:5b:6f:73:65:
                    4b:e7:d3:f3:4e:f2:f3:d6:d4:5c:98:4b:ab:ba:8e:
                    a2:38:66:98:96:03:4d:d8:77:2d:a2:7c:a8:fb:c6:
                    c7:c7:37:2b:32:2a:f9:81:28:9f:ce:dc:42:23:6a:
                    02:fb:16:f5:7d:00:6e:28:6f:bc:66:52:8a:9c:f8:
                    d8:e4:02:e3:d6:45:b7:80:31:20:c9:cd:6f:a6:70:
                    f9:b7:fc:60:d9:53:73:69:8e:a1:c5:97:5d:8e:85:
                    bb:ae:4a:7e:ac:cd:2a:6b:06:6b:88:25:ae:39:77:
                    91:6d:bf:62:d4:7c:a1:9b:a6:ce:8b:19:a1:2c:91:
                    ed:f1:0b:6f:ae:2c:2d:3b:04:70:e5:20:2a:f4:57:
                    85:39
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Key Identifier: 
                75:DB:1E:67:B7:59:FA:DF:E6:1B:38:4A:75:B1:FD:79:45:81:65:95
            X509v3 Authority Key Identifier: 
                keyid:76:EC:2D:07:D8:14:17:1F:0D:C7:98:1A:0E:E9:AA:3A:D8:0D:84:7C

            X509v3 Extended Key Usage: 
                TLS Web Server Authentication, TLS Web Client Authentication, Microsoft Server Gated Crypto, Netscape Server Gated Crypto
            X509v3 Basic Constraints: critical
                CA:FALSE
            Netscape Comment: 
                SPKI Senso-Rezo Server Certificate
    Signature Algorithm: sha1WithRSAEncryption
        48:36:39:3e:70:f8:ce:cc:3d:0d:3d:32:72:5f:a7:e2:c7:3d:
        77:0a:37:ee:a4:59:11:f3:85:5d:72:30:a9:6e:9d:6f:c4:7e:
        76:8e:4a:a6:fe:c1:c9:a0:96:2e:4c:0e:0e:07:32:c6:23:2a:
        84:b0:59:e5:a7:3b:aa:9a:80:93:ae:5c:73:49:50:b2:b3:5d:
        b1:ed:d7:73:c4:90:08:d5:f5:ae:cf:fd:aa:34:fe:49:60:88:
        4e:fd:30:9f:19:d2:49:00:f7:41:4e:56:b8:c1:29:2f:38:2f:
        64:a8:6b:ad:38:50:7f:34:c8:78:ff:be:cd:2f:17:a0:42:17:
        9a:17:ec:c8:e0:66:9e:53:5a:55:f5:ac:de:c2:25:2c:ea:eb:
        59:1b:b7:12:da:bd:61:28:59:5d:f1:02:ec:1d:83:5b:e4:f1:
        c4:94:c1:80:08:21:a4:bf:a2:1e:13:93:4f:23:53:39:62:7e:
        ee:54:6c:5b:11:f2:81:0f:4c:84:ce:9c:df:db:5a:df:c6:bb:
        71:3d:ca:39:0d:ae:9d:c1:8f:76:d1:6e:0e:b2:6f:3f:93:b8:
        24:86:f7:2b:a7:86:ab:e4:32:92:ae:bb:78:16:82:f4:90:99:
        6d:6a:9e:1a:16:ab:85:c9:a1:15:c7:67:f2:12:56:bd:3e:6d:
        b1:80:35:ac
    me@localhost:~/github/spki/bash$
    
### Let's verify and revoke somes...

To verify a given certificate, just issue the *--verify* command:

    me@localhost:~/github/spki/bash$ ./spki --verify openvpn.pki.me
    Certificate for openvpn.pki.me is VALID
    me@localhost:~/github/spki/bash$

Let's revoke a cerficate or two:

    me@localhost:~/github/spki/bash$ ./spki --revoke jane.did@pki.me
    ----> Revoking certificate for jane.did@pki.me (reason = unspecified):
    ---->  - Certificate for subject jane.did@pki.me has been revoked for reason unspecified.
    ----> Certificate for subject jane.did@pki.me has been revoked and a new CRL has been generated.
    me@localhost:~/github/spki/bash$
    
You can of course give reason when revoking a certificate:
    
    me@localhost:~/github/spki/bash$ ./spki --revoke openvpn.pki.me keyCompromise
    ----> Revoking certificate for openvpn.pki.me (reason = keyCompromise):
    ---->  - Certificate for subject openvpn.pki.me has been revoked for reason keyCompromise.
    ----> Certificate for subject openvpn.pki.me has been revoked and a new CRL has been generated.
    me@localhost:~/github/spki/bash$

Then, try to verify again this certificate: 

    me@localhost:~/github/spki/bash$ ./spki --verify openvpn.pki.me
    Certificate for openvpn.pki.me is INVALID
    
As the *openvpn.pki.me* certificate has been revoked, and a new CRL generated, this certificate is not anymore checked as VALID.

## The Manual Way

# Credits
Thank's to ... tons of folks I did meet the last 15 years around the PKI(X most of the time) subject :)

If you are new to the PKI world, an excellent tutorial on implementing a real-world PKI with the [OpenSSL] toolkit can be found there: [http://pki-tutorial.readthedocs.org](http://pki-tutorial.readthedocs.org "")
