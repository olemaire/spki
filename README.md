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

* **Automated** mode: no passphrase to protect your keys, perfect to run as an automation within a broader {eco,info}system.
* **Manual** mode (not automated): passphrase to protect keys, default fields will still need to be validated by human interaction (text mode). Perfect to play around and discover the PKI.

In both cases, you will have to make sure to install **SPKI** in a safe place where no regular user can have access to.


# Usages
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

Ok, your PKI is ready to deliver certificates...

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
       
Ok, we now have some certificates as we can see:

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

And if you need more information a given certificate, just ask some more infos:

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

A certificate is considered VALID if not revoked nor expired, and if it has been delivered by **SPKI** (signed by your Certificate Authority more precisely). In expired, or revoked (or a foreign - to your PKI - certificate), it will be considered INVALID.

To verify a given certificate, just issue the *--verify* command:

    me@localhost:~/github/spki/bash$ ./spki --verify openvpn.pki.me
    Certificate for openvpn.pki.me is VALID
    me@localhost:~/github/spki/bash$ echo $?
    0
    me@localhost:~/github/spki/bash$
    

Let's revoke a cerficate this certificate:
    
    me@localhost:~/github/spki/bash$ ./spki --revoke openvpn.pki.me
    ----> Revoking certificate for openvpn.pki.me (reason = unspecified):
    ---->  - Certificate for subject openvpn.pki.me has been revoked for reason unspecified.
    ----> Certificate for subject openvpn.pki.me has been revoked and a new CRL has been generated.
    me@localhost:~/github/spki/bash$

Then, try to verify again this certificate: 

    me@localhost:~/github/spki/bash$ ./spki --verify openvpn.pki.me
    Certificate for openvpn.pki.me is INVALID
    me@localhost:~/github/spki/bash$ echo $?
    100
    me@localhost:~/github/spki/bash$
     
As the *openvpn.pki.me* certificate has been revoked, and a new CRL generated, this certificate is not anymore checked as VALID.

Please note that the return code is "0" if the certificate is VALID, and "100" if INVALID. This may helps if you want to test the validity of certificates from your scripts or any external (to **SPKI**) system.

### And what about renewing some certificates?
As you'll see, it...

    me@localhost:~/github/spki/bash$ ./spki --renew openvpn.pki.me
    renew openvpn.pki.me - Not Implemented yet
    me@localhost:~/github/spki/bash$

... not implemented yet, but I'm working on it :)

### Some more informations?
You can use the *--info* option to grab more infos about the CA certificate and the CRL. 

    me@localhost:~/github/spki/bash$ ./spki --infos ca
    Printing certificate information for ca:
    Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            9f:06:02:4e:fc:36:55:af
        Signature Algorithm: sha1WithRSAEncryption
        Issuer: C=US, O=Senso-Rezo, OU=Senso-Rezo Security Services, CN=Senso-Rezo Root CA
        Validity
            Not Before: Jan 20 22:36:15 2014 GMT
            Not After : Jan 21 22:36:15 2034 GMT
        Subject: C=US, O=Senso-Rezo, OU=Senso-Rezo Security Services, CN=Senso-Rezo Root CA
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
            RSA Public Key: (2048 bit)
                Modulus (2048 bit):
                    00:a4:ea:80:b0:1c:3f:e5:ef:83:0e:a5:81:b4:07:
                    3f:42:e1:8e:ce:82:86:c9:90:d8:8a:7e:e7:c4:1d:
                    a5:a0:f3:d6:07:eb:63:55:78:f1:5a:e9:62:84:47:
                    85:d5:2e:e4:9f:bc:ea:60:38:a2:a5:cd:03:52:db:
                    8c:de:94:c3:e5:f3:57:e2:2c:1d:70:33:95:99:85:
                    b7:db:59:5d:bf:10:01:53:b7:43:9e:31:cf:75:db:
                    3e:06:bf:e6:48:ed:74:81:ab:c6:be:3a:60:0d:b0:
                    f7:f6:6e:29:65:af:0b:64:7f:d2:e2:e5:68:b2:4c:
                    10:69:45:30:49:06:61:0e:b1:a2:22:b4:53:44:58:
                    70:39:5d:23:ee:1b:2e:5d:0d:d9:26:cb:e0:9f:8a:
                    ff:89:f1:2b:e2:40:d8:08:78:09:dc:e3:7a:58:92:
                    b3:ca:52:14:0f:bf:f3:87:b7:25:2a:02:9b:0e:a2:
                    54:02:1d:6c:2d:46:b2:90:23:f6:24:e4:0b:93:e2:
                    b8:66:3d:0f:29:33:ce:3e:a4:07:e8:8c:c9:8a:01:
                    a3:1c:2e:69:9c:ea:0a:d3:52:6c:87:1a:40:5f:45:
                    5d:be:68:19:aa:aa:a0:55:fa:93:af:b5:b0:a8:ec:
                    e3:ee:dd:ad:78:ea:a3:07:60:7c:dd:a2:86:d6:23:
                    13:e3
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Subject Key Identifier: 
                76:EC:2D:07:D8:14:17:1F:0D:C7:98:1A:0E:E9:AA:3A:D8:0D:84:7C
            X509v3 Key Usage: critical
                Certificate Sign, CRL Sign
            X509v3 Authority Key Identifier: 
                keyid:76:EC:2D:07:D8:14:17:1F:0D:C7:98:1A:0E:E9:AA:3A:D8:0D:84:7C
                DirName:/C=US/O=Senso-Rezo/OU=Senso-Rezo Security Services/CN=Senso-Rezo Root CA
                serial:9F:06:02:4E:FC:36:55:AF

            Netscape Cert Type: 
                SSL CA, S/MIME CA, Object Signing CA
            Netscape Comment: 
                SPKI Senso-Rezo Root CA Certificate
    Signature Algorithm: sha1WithRSAEncryption
        35:5e:e0:49:a1:e7:ba:91:b4:70:e5:9d:c2:9d:5f:18:66:e3:
        d8:f2:32:35:e9:c6:c4:c7:a6:82:26:8a:94:73:e0:4b:54:21:
        73:59:12:ba:10:35:83:50:a1:ab:89:fa:b2:cc:ba:c1:f9:6b:
        ac:46:59:ff:8f:bd:ca:9f:44:3e:78:11:c7:ed:e7:ff:b8:4e:
        b7:39:84:db:9f:29:45:16:84:c3:29:1e:85:25:9c:33:d5:1a:
        16:6d:8f:33:21:48:54:5a:6b:08:67:1b:af:27:6e:27:2a:8e:
        b2:71:12:93:e5:88:47:97:83:77:78:c9:2f:24:bd:fb:a5:a0:
        07:25:f5:02:56:81:10:f0:85:65:ce:58:ea:87:e1:85:12:06:
        7b:1b:68:5b:17:f5:0b:b8:54:10:5a:2c:58:26:a5:d4:8e:1d:
        3f:e9:45:9b:1f:11:4c:39:aa:1d:af:74:71:2f:f8:fb:82:42:
        d0:34:98:3a:95:9e:8e:c6:ab:23:31:82:33:80:6a:85:78:79:
        e3:cb:2b:97:6a:61:a3:4a:cd:f8:bd:83:b6:7c:d6:84:d8:77:
        ef:88:af:8a:b3:25:92:c3:84:01:5d:06:d3:e5:29:35:39:76:
        c4:c0:b1:5c:7f:25:c3:29:68:3d:7c:88:1e:19:37:ca:7f:ce:
        a2:13:96:c4

    me@localhost:~/github/spki/bash$ ./spki --info crl
    Printing current CRL informations:
    Certificate Revocation List (CRL):
        Version 2 (0x1)
        Signature Algorithm: sha1WithRSAEncryption
        Issuer: /C=US/O=Senso-Rezo/OU=Senso-Rezo Security Services/CN=Senso-Rezo Root CA
        Last Update: Jan 20 23:14:13 2014 GMT
        Next Update: Feb 20 23:14:13 2014 GMT
        CRL extensions:
            X509v3 CRL Number: 
                4
    Revoked Certificates:
    Serial Number: 01
        Revocation Date: Jan 20 22:50:29 2014 GMT
        CRL entry extensions:
            X509v3 CRL Reason Code: 
                Unspecified
    Serial Number: 02
        Revocation Date: Jan 20 23:13:05 2014 GMT
        CRL entry extensions:
            X509v3 CRL Reason Code: 
                Unspecified
    Serial Number: 04
        Revocation Date: Jan 20 23:14:13 2014 GMT
        CRL entry extensions:
            X509v3 CRL Reason Code: 
                Key Compromise
    Signature Algorithm: sha1WithRSAEncryption
        87:ee:41:40:f4:8c:f4:ba:25:12:f9:de:e5:9a:15:f7:8c:a2:
        b4:0e:cd:b5:74:dc:cb:23:d0:9c:3b:6e:f4:3c:2d:db:d5:36:
        e9:eb:89:7b:70:1a:6f:66:38:94:a7:7a:8b:0f:cf:9e:b9:53:
        2e:23:c1:7d:01:62:5e:72:96:9d:da:c0:56:e9:b4:b4:03:13:
        9b:cd:b4:4a:c5:cf:77:e7:4f:41:07:02:2c:fc:89:5f:42:52:
        36:78:00:6e:0c:7e:b4:75:94:0f:87:c0:eb:64:c2:a0:f6:a5:
        c5:fe:3e:ad:3d:97:e5:33:4c:36:ae:6a:2e:85:39:be:f7:c0:
        4b:cb:ee:90:97:c7:7d:40:4b:ff:61:93:b6:66:22:1a:39:11:
        46:6a:22:52:fe:db:5b:87:e8:47:ec:98:46:81:d7:02:ed:40:
        fb:a3:2f:d2:4c:d2:9a:9b:91:f5:48:b8:b8:53:c9:5a:34:0a:
        9f:de:0e:d9:e7:ce:ad:6e:0a:dd:2a:ad:16:b0:7f:32:67:e6:
        e3:ab:46:46:f0:8d:4a:de:4a:cb:4c:9a:e6:7b:b0:9b:da:0e:
        af:bc:49:1f:66:50:20:a7:ec:79:95:e5:97:e5:67:1a:d4:6e:
        d0:eb:8d:0b:a3:bf:8d:5d:d7:fb:aa:fe:5f:f7:69:39:35:f5:
        12:b0:f2:0e
    me@localhost:~/github/spki/bash$

Option *--info* used without subject will give you more information regarding your **SPKI** Certificate Authority:

    me@localhost:~/github/spki/bash$ ./spki --info
    General info on the Certificate Authority:
    ------------------------------------------
    Cryptographic Engine:                       OpenSSL 0.9.8y 5 Feb 2013
    Certificate Authority DN:                   C=US/O=Senso-Rezo/OU=Senso-Rezo Security Services/CN=Senso-Rezo Root CA
    Start Validity on:                          Jan 20 22:36:15 2014 GMT
    End Validity on:                            Jan 21 22:36:15 2034 GMT
    Issued certificates Valid/Revoked/Expired:  1 / 3 / 0
    Last CRL produced on:                       Jan 20 23:14:13 2014 GMT
    Next CRL to be produced on:                 Feb 20 23:14:13 2014 GMT
    Current Status:                             OK

And of course you can use *--info* to look for information on a given certificate:

    me@localhost:~/github/spki/bash$ ./spki --info john.doe@pki.me
    Printing certificate information for john.doe@pki.me:
    Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 1 (0x1)
        Signature Algorithm: sha1WithRSAEncryption
        Issuer: C=US, O=Senso-Rezo, OU=Senso-Rezo Security Services, CN=Senso-Rezo Root CA
        Validity
            Not Before: Jan 20 22:36:22 2014 GMT
            Not After : Feb 20 22:36:22 2015 GMT
        Subject: C=US, O=Senso-Rezo, OU=Operational Unit, CN=john.doe@pki.me/emailAddress=john.doe@pki.me
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
            RSA Public Key: (2048 bit)
                Modulus (2048 bit):
                    00:9f:2d:39:30:69:6e:b4:26:c9:51:8e:40:33:47:
                    32:9a:07:d5:29:3f:3a:ae:6e:be:07:92:b8:71:f7:
                    a6:35:27:f6:12:02:58:8d:bc:74:c9:f0:0e:96:8c:
                    8e:dd:14:e0:d1:cc:b0:69:11:0f:bc:6c:2a:e7:bd:
                    5e:78:fc:7f:13:eb:6d:bf:aa:ed:f5:88:e1:81:12:
                    ac:a7:2e:1b:87:22:74:95:0a:34:fd:1a:a4:5e:50:
                    66:1a:d3:c3:79:8e:15:b2:b5:05:90:52:49:53:8d:
                    f2:75:7f:a9:de:e6:34:ac:e7:12:6e:0e:f2:23:a8:
                    14:af:b5:fd:13:47:e5:10:4d:ea:72:f3:e6:7a:84:
                    3b:29:a4:6a:92:0e:33:f9:ea:87:01:35:04:af:96:
                    a4:62:a9:a1:38:5a:2d:bc:47:4f:0c:84:47:75:f6:
                    30:e0:0d:a8:46:ab:10:f8:c4:20:85:4f:9d:6e:ce:
                    bd:f3:e4:e6:d4:52:53:c4:dc:1c:13:27:bf:3a:ac:
                    1f:62:a0:45:34:65:cd:f7:8e:aa:bd:a2:64:5b:52:
                    9b:0d:1e:a8:3b:f7:d7:ba:a9:a9:bd:b0:94:68:b7:
                    c0:fd:b2:c4:34:26:78:98:e2:d9:c5:21:4e:b0:eb:
                    53:80:d0:a5:6f:60:27:23:94:b5:b2:45:5d:d2:93:
                    f0:3d
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Alternative Name: 
                email:john.doe@pki.me
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Authority Key Identifier: 
                keyid:76:EC:2D:07:D8:14:17:1F:0D:C7:98:1A:0E:E9:AA:3A:D8:0D:84:7C

            X509v3 Extended Key Usage: 
                TLS Web Client Authentication, E-mail Protection
            Netscape Comment: 
                SPKI Senso-Rezo User Certificate
    Signature Algorithm: sha1WithRSAEncryption
        8b:ac:24:94:e3:52:0e:31:7f:c8:f3:31:26:14:65:f0:ee:fa:
        dc:71:f8:4d:ad:cb:2d:42:6b:ca:77:30:2c:0f:c7:6e:5a:75:
        f5:e2:97:8e:ce:15:96:24:dd:e1:d5:f2:67:5d:68:17:d0:b4:
        fa:2f:61:b8:6d:6b:57:0b:47:cd:56:15:cd:b4:e6:4f:7e:63:
        ff:b1:59:14:47:c3:57:f2:5c:96:6a:19:6c:4b:ae:97:02:a3:
        e6:3f:39:5e:40:f2:95:99:bf:a9:97:65:ea:1f:bc:0b:26:31:
        fe:4e:41:93:7b:e0:39:37:f5:17:23:0d:c6:0a:73:95:4a:54:
        8c:05:ab:87:c0:2f:6c:60:a3:06:fc:cf:32:15:21:dd:e5:61:
        5e:6d:49:67:0d:3a:66:f6:95:b7:e0:4d:f5:64:24:5f:f5:2b:
        13:e7:60:d0:84:cf:67:12:9e:37:fa:48:d7:69:fd:a4:4d:5e:
        a5:9d:f2:22:68:8d:0c:4e:1c:4f:ad:51:88:79:03:41:d6:d6:
        33:7d:e8:87:9e:11:32:b5:08:f4:dc:ab:60:2c:62:dc:93:d5:
        7f:02:0f:66:a1:dc:f3:bf:ac:e1:8d:f6:60:0c:ed:13:1b:ed:
        62:56:60:bd:d5:bb:76:a6:26:4e:cf:18:f9:65:81:70:15:2b:
        19:83:7b:10
    me@localhost:~/github/spki/bash$ ./spki --info www.pki.me
    Printing certificate information for www.pki.me:
    Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 3 (0x3)
        Signature Algorithm: sha1WithRSAEncryption
        Issuer: C=US, O=Senso-Rezo, OU=Senso-Rezo Security Services, CN=Senso-Rezo Root CA
        Validity
            Not Before: Jan 20 22:41:52 2014 GMT
            Not After : Jan 21 22:41:52 2034 GMT
        Subject: C=US, O=Senso-Rezo, OU=Operational Unit, CN=www.pki.me/emailAddress=sysadm@senso-rezo.org
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
            RSA Public Key: (2048 bit)
                Modulus (2048 bit):
                    00:e7:dc:26:16:4e:f3:a3:ed:13:ca:a5:a3:2d:5b:
                    72:28:4d:8c:2f:82:b2:ea:86:28:7e:4a:2c:1a:81:
                    92:06:fe:77:52:e8:52:59:63:18:d4:1b:c4:ea:cf:
                    10:ab:1c:0a:34:e0:ee:f1:a6:2d:7e:a8:2c:62:96:
                    29:8b:61:fa:d3:0f:76:b1:ab:af:15:d5:24:c9:c5:
                    86:7e:2b:a7:06:1f:05:7f:af:a5:bf:01:b6:2a:d0:
                    dc:f7:0e:25:cd:d1:5c:f1:0e:c9:70:ba:ea:d5:57:
                    6a:ec:94:55:da:08:5e:79:fd:b0:19:cb:d5:c9:f6:
                    cb:1c:c8:70:ee:b0:32:80:7f:4e:c0:5e:a9:35:98:
                    df:84:7c:ad:d0:77:71:ad:2e:09:af:5d:4a:0d:8d:
                    7d:30:48:89:e5:36:b7:a0:03:89:f8:98:3f:eb:f2:
                    d9:69:16:0a:a7:87:0e:da:bc:c0:0d:cb:93:8d:30:
                    52:56:5b:c3:89:6a:bd:18:90:52:7a:aa:e4:67:5d:
                    83:42:34:9c:1c:55:7a:0c:13:0e:90:c8:2a:92:b3:
                    03:7a:9a:3a:09:a9:5d:f2:30:49:81:37:13:cf:e9:
                    98:70:1c:68:92:cd:c6:c8:15:98:56:35:18:3e:70:
                    8d:69:76:71:5f:2f:f2:b5:3c:2e:e2:fc:24:99:05:
                    86:87
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Key Identifier: 
                A7:D5:9A:C5:75:F1:F8:A8:EC:40:9F:87:5A:3A:90:17:FA:8C:7A:4C
            X509v3 Authority Key Identifier: 
                keyid:76:EC:2D:07:D8:14:17:1F:0D:C7:98:1A:0E:E9:AA:3A:D8:0D:84:7C

            X509v3 Extended Key Usage: 
                TLS Web Server Authentication, TLS Web Client Authentication, Microsoft Server Gated Crypto, Netscape Server Gated Crypto
            X509v3 Basic Constraints: critical
                CA:FALSE
            Netscape Comment: 
                SPKI Senso-Rezo Server Certificate
    Signature Algorithm: sha1WithRSAEncryption
        7c:b1:0d:7c:ac:dc:53:f7:1f:32:43:46:19:d5:cd:a4:9f:a0:
        11:a8:23:67:c6:ef:8c:ee:29:a1:dc:19:07:03:59:e7:0e:b4:
        af:1e:55:4c:9a:b7:ed:c4:dc:cf:cb:bd:16:52:15:2b:9c:ff:
        41:c2:d3:c9:23:2e:31:93:05:ad:8d:a4:5d:72:80:99:53:b9:
        2a:74:6d:9b:96:1a:0e:f9:84:a6:51:e7:99:33:cf:51:3e:39:
        55:12:90:8e:7b:2a:c9:e5:18:b1:e2:da:4a:c5:91:e6:55:05:
        cd:36:ef:b3:93:33:3a:d2:f3:c6:da:96:c5:de:99:7c:4d:d6:
        1c:98:8a:c9:67:e3:e6:fd:f9:01:81:49:ce:9a:fc:1c:72:d1:
        80:70:37:d1:3d:55:15:a8:69:8e:be:20:79:51:ba:82:89:e6:
        44:2e:58:3d:c3:1c:60:8a:c1:65:3f:2d:9b:3a:35:a0:de:61:
        e7:b9:0b:80:00:6b:b3:51:a2:db:54:dc:4d:3b:cb:58:c0:d6:
        c7:d6:b3:d5:fb:76:47:12:2c:a1:82:bb:7f:b6:d4:46:de:d0:
        7d:d3:b1:1d:66:6e:6e:d5:c1:dd:44:5c:92:68:ff:ad:6a:c7:
        fb:27:d0:41:02:7e:ca:8d:a2:2e:72:ab:03:74:fa:19:58:5a:
        dd:5f:0b:1c
        
### But sometimes, things can go weird...
{:toc}
This is a test TOC entry
        
## The Manual Way

# Credits
Thank's to ... tons of folks I did meet the last 15 years around the PKI(X most of the time) subject :)

If you are new to the PKI world, an excellent tutorial on implementing a real-world PKI with the [OpenSSL] toolkit can be found there: [http://pki-tutorial.readthedocs.org](http://pki-tutorial.readthedocs.org "")
