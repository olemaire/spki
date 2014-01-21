[Bash]: http://www.gnu.org/software/bash/
[OpenSSL]: http://www.openssl.org/

# SPKI - the Bash flavor

Here is the [Bash] source code for **SPKI**. You will need [OpenSSL]
to make it run, and as both are installed by default on any decent Operating System, you can start generating certificates in few minutes.


This [Bash] flavor has been tested on OSX 10.9 with [OpenSSL] 0.9.8y, and Linux kernel 2.6.32 with [OpenSSL] 1.0.1c. 

It can handle thousands certificates without issue, even if it's more a beast of burden than a racehorse: better run it on a Core i7 than a Raspberry Pi (even if the Raspberry Pi will still perform not that bad).


# Let's use it
## Installation
TODO


## Configuration
TODO

## Usage

# Tips and Tricks
TODO

# Playin'around
## Big Guys need huge volume of certificates...
**SPKI** can handle thousands of certificates like a charm, but how does it cope with millions? The correct answer is - so far I dunno :)

More seriousely, actually, this [Bash] flavor has been tested with up to around 22.000 certificates, but no real tweaking has been done to see how far it can goes, and how we can steamlined its operation to cope with **huge** volume. 

As far as I can see:

* generating a certificate takes from 0.2 second to 0.9 second, depending on the arch you are using. Revoking a certificate takes around 0.05 to 0.1 second, and seems to be less impacted by your arch.
* the [OpenSSL] index file has to be loaded in memory each time [OpenSSL] is used, which means having some RAM on your system for big databaes: 400 KB index file for 3.500 certificates, 1.7 MB index file for 15.000 certificates, and ended up with 2.5 MB for 22.271 certificates.
* numerous files - and so inodes - taken to deal with files (Certificates, CSR, configurations, ...) of small sizes: this will have impact on your file system usage (or settings).
* As there is lots of read/write operations on disk ([OpenSSL] index, **SPKI** storing certificates and associated files), selecting a efficient drive helps alot (SSD for extreme boys...)

This means that handling thousands of certificates can still be done on a Raspberry Pi if needed, but for millions of certificates some real bench should be envisaged to select the best hardware (or Virtual Machine tier at Amazon, Google or VPS.me...)


