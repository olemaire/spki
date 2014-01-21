[Bash]: http://www.gnu.org/software/bash/
[OpenSSL]: http://www.openssl.org/

# SPKI - the Bash flavor

Here is the [Bash] source code for **SPKI**. You will need [OpenSSL]
to make it run, and as both are installed by default on any decent Operating System, you can start generating certificates in few minutes as you can see:

* <a href="#Installation">Installation</a>, <a href="#Configuration">Configuration</a> and <a href="#Usage">Usage</a>
* <a href="#Tips">Tips and Tricks</a>
* <a href="#Playing">Playin'around</a>

This [Bash] flavor has been tested on OSX 10.9 with [OpenSSL] 0.9.8y, and Linux kernel 2.6.32 with [OpenSSL] 1.0.1c. It can handle thousands certificates without issue, even if it's more a beast of burden than a racehorse :

* generating/revoking a certificate takes from FIXME seconds to FIXME seconds, depending on the volumetry of certificates your **SPKI** manage.
* the [OpenSSL] index file has to be loaded in memory each time [OpenSSL] is used, which means having some spare RAM on your system for big databaes: 400 KB index file for 3.500 certificates, 1.7 MB index file for 15.000 certificates... 500.000 certificates = FIXME MB of index file)
* numerous files - and so inodes - taken to deal with files (Certificates, CSR, configurations, ...) of small sizes: this will have impact on your file system usage.

Actually, this [Bash] flavor has been tested with up to FIXME certificates, but no real tweaking has been done to see how far it can goes, and how we can steamlined its operation to cope with **huge** volume.

# Let's use it
## <a id="Installation">Installation</a>
TODO


## <a id="Configuration">Configuration</a>
TODO

## <a id="Usage">Usage</a>

# <a id="Tips">Tips and Tricks</a>
TODO

# <a id="Playing">Playin'around</a>
TODO
