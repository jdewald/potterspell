# potterspell
UI for displaying magic spells and calling endpoints to act on recognized spells

This is essentially just a naked commit of the code that I created as part of my daughter's Harry Potter-themed birthday party.
There is a good chance that it no longer compiles as-is, but feel free to use it as you see fit.

Description of the project can be found here: https://quay.wordpress.com/2021/08/14/how-i-built-some-magic-wands/

I would be happy to work with anyone who is interested in using or adapting this code and is unable to get what's here working for them.

The PennyPincher implementation is based on that of https://github.com/fe9lix/PennyPincher, but modified as necessary

The key files:
* https://github.com/jdewald/potterspell/blob/main/Potterspell/SpellView.m - renders the gesture/spell as it comes in
* https://github.com/jdewald/potterspell/blob/main/Potterspell/PennyPincher.swift - implementation of PennyPincher that handles actual spell recognition
* https://github.com/jdewald/potterspell/blob/main/Potterspell/AppDelegate.m - makes connection to the WiiMote. I'm fairly sure that this won't work on modern MacOS now


