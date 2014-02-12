/*
 * SPKI - Simple Public Key Infrastructure
 *
 *  Copyright © 2014 Senso-Rezo
 *  All rigths reserved.
 *
 * See LICENSE file for licensing information.
 * See http://github/olemaire/spki for more information.
 */

fn main() {
  Usage();
}

fn Usage() {
  let message = "Copyright (C) Senso-Rezo - SPKI (http://github.com/olemaire/spki)

Usage: spki <option> (<subject>) 

Available options are:
    --initialize                     Initialize a new Certificate Authority
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

Exemples:
        spki --issue server www.senso-rezo.org
        spki --issue user olivier.lemaire@senso-rezo.org
        spki --info www.senso-rezo.org
        spki --revoke ldap.senso-rezo.org
        spki --revoke www.senso-rezo.org keyCompromise
        spki --renew olivier.lemaire@senso-rezo.org
        spki --crl
        spki --print crl

";
  println(message);
}


/* This Is The End */
