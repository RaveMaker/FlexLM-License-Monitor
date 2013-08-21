FlexLM LMGRD License Monitor
============================

Runs a FlexLM licenses test on multiple servers and ports.

Sends a report in case of an expired/malfunctioned license.

### Installation

1. Clone this script from github or copy the files manually to your prefered directory.

2. Create licesne-check.lst from the included licesne-check.example,

        cp licesne-check.lst.example licesne-check.lst

    and fill it with your servers list (one in a row):

        AppName port@hostname

    for example (leave a blank line in the end of the file):

        Cadence 2000@LicServer
        
by [RaveMaker][RaveMaker].
[RaveMaker]: http://ravemaker.net
