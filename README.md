SpencerianGuidelines
====================

Simple Prawn-powered ruby script for generating guidelines for Spencerian and Coppeplate penmanship

I'm putting this out AS IS, and while it could use several improvements, I don't have much time for it at the moment.

In order to use it you need a working ruby installation, as well as the Prawn gem to generate PDF files.

The examples folder contains a few pre-generated sheets, in case you don't have a ruby installation handy.

Call as:
    ./spencerian_guidelines {s|c} x_height slant

 For example:
    ./spencerian_guidelines s 4 52

 will produce Spencerian guidelines with a 4mm x-height and 52 degree slant.

    ./spencerian_guidelines c 6 55

will produce Copperplate-style guidelines with 6mm x-height and 55 degree slant.
