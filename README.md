[Perl]:	http://www.perl.org/
[OpenSSL]: http://www.openssl.org/

# Simple Perl Key Infrastructure - SPKI

**SPKI** is a simple and stupid (but yet useful) *Public* Key Infrastrucure made in [Perl], using [OpenSSL].

* **Simple**: delivers only the most basic functions - in fact the functions I needed for personnal usage (user, servers and services certificates).
* **Stupid** : well... in fact will deliver X.509 Digital Certificates (and associated keys and CRL) but build the way IETF PKIX nor SPKI RFCs indicate to follow. Loosely coded: just works, but not bullet proof at all (use at your own risks and perils...).
* **Key Infrastructure**: Certificates are X.509 PKIX compliant (or at least seems to be). I personnally use these certificates for a *Private* purpose, as most users does with PKIs... But you can use it for *Public* purpose (certificates for your web sites, to encrypt/decrypt mails within your colleagues, ...). 

To use it, you just need [Perl] and [OpenSSL] (both installed most of the time on any decent Operating System) - and an Internet access during installation phase (as you will probably need some additional Perl modules, not delivered in your Operating System base installation bundle.

# Installation
TODD

# Usage
TODO

# Credits
Thank's to ... tons of folks I did meet the last 15 years around the PKI(X most of the time) subject :)
