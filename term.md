# Handling TERM, TERMINFO, COLORTERM, etc.

## References:

* Control sequences:
  * xterm: https://invisible-island.net/xterm/ctlseqs/ctlseqs.html
  * xterm.js: https://xtermjs.org/docs/api/vtfeatures/
  * kitty: https://sw.kovidgoyal.net/kitty/protocol-extensions/
  * mintty: https://github.com/mintty/mintty/wiki/CtrlSeqs#progress-bar
  * terminal-wg: https://gitlab.freedesktop.org/terminal-wg/specifications/-/issues?scope=all&state=all
* terminfo capabilities
  * terminfo: https://man7.org/linux/man-pages/man5/terminfo.5.html
  * tmux terminfo extensions: https://man7.org/linux/man-pages/man1/tmux.1.html#TERMINFO_EXTENSIONS
* Querying terminals
  * Why not query instead of terminfo? https://unix.stackexchange.com/a/390362
  * POSIX shell script for DECRQM:     https://unix.stackexchange.com/a/615911
* 24bit RGB "truecolor"
  * Thomas Dickey's reluctance to add two tier colors to terminfo:
    * Why is 24bit RGB so broken? https://invisible-island.net/ncurses/ncurses.faq.html#xterm_16MegaColors
    * Not his finest moment 😦 https://lists.gnu.org/archive/html/bug-ncurses/2016-08/msg00036.html
  * https://github.com/termstandard/colors
  * foot RGB vs Tc: https://codeberg.org/dnkl/foot/issues/615
  * kitty: https://github.com/kovidgoyal/kitty/issues/1141
  * kitty: commit comments discuss drawbacks of `RGB`: https://github.com/kovidgoyal/kitty/commit/18fe2e8dfa34038aabd5c3a2fdb3624e2b27932a
  * emacs adds support for `Tc`: https://debbugs.gnu.org/cgi/bugreport.cgi?bug=44950#20
* Misc
  * "The Trouble with Terminals" from 2010: https://gist.github.com/KevinGoodsell/744284/717b220f7c168725748781d58609dce5d7cf8603

## Background

Okay... I'm probably not handling this correctly.  With apologies to those
involved where I've inevitably misrepresented the situation:

But honestly the whole terminal capabilities ecosystem seems like a bit of a
mess.  Many apps either hardcode escape sequences to roughly (but incompletely)
match xterm, or they contain their own internal "terminfo database" of sorts.
Sometimes, applications simply look for simple prefixes, such as "xterm*".  And,
knowing this, many terminals gave up on their own `TERM` name and incorrectly
identify as xterm-*.  For simple widely-supported features like ANSI colors
that's often Good Enough.

Additionally, static `TERM` names aren't really suitable for progressively
updated software terminal emulators (IMO).  The terminfo capabilities for a
`TERM` name can evolve separately from the capabilities of the specific version
of the terminal emulator that is being used.  This has been partially mitigated
by suffixes, e.g. "xterm" vs "xterm-16color" vs "xterm-256color", etc.  But that
would lead to an explosion of terminfo entries, a new entry for each new version
of the software that updates capabilities.  In practice, terminfo entries often
contain capabilities which are not supported by every version of the terminal
emulator that uses that entry.

Compounding this, the capabilities listed in the terminfo database have not been
defined by a consortium or a standards body (e.g. like the IETF RFC process or
the W3c, etc), but it has primarily evolved under the maintenance of a small
number of individuals with primary responsibility only to a single terminal
emulator (xterm) and a single library (ncurses).  This leads to issues when
other terminal emulators or libraries would like to go in a different direction
from xterm and ncurses.  Rather than facilitate a vibrant ecosystem of
applications, libraries, and terminal emulators, many applications and libraries
wind up ignoring or bypassing the terminfo DB.  E.g. when terminals and
applications wanted 24bit RGB colors, they forged ahead on a different path from
the official terminfo database.  😦

E.g: For reasons that aren't entirely clear to me, the official approach to
24bit RGB colors uses new `*-direct` `TERM` names (that seems fine so far) with
`colors` increased to `0x1000000` (maybe still good?) and a boolean `RGB`
capability (seems fine?)... but it then interprets `colors#0x1000000` + `RGB` to
require backwards incompatible versions of `setaf` and `setab`, wrecking
applications that need to support both 24bit RGB as well as ANSI 8/16/266
colors.  Every other terminal emulator and library seems to have settled on
adding a `Tc` boolean (for "truecolor") and new `setrgbf`/`setrgbb`, while
leaving `colors#0x100` and `setaf`/`setab` the same, for backwards
compatibility.  And because the official terminfo DB won't include `Tc`,
`setrgbf`, or `setrgbb`, the most common workaround seems to be to use an
exising `*-256colors` `TERM` (to signify compatibility with 8/16/256 color
escape sequences) plus `COLORTERM=truecolor` (or `COLORTERM=24bit`) to signify
`Tc`/`setrgbf`/`setrgbb` compatibility.

## Theoretical solutions

IMO: Ideally apps would just query for nearly all terminal capabilities during
initialization, e.g. using DECRQSS, XTGETTCAP, etc.  Using capabilities
announcements and queries is how most long-lived network protocols behave.
Unfortunately, even this isn't well-supported by all terminals, nor is it as
simple as it might be.  😦

        exec 3<&1 1>/dev/tty
        stty -icanon -echo 2>/dev/null
        printf '\e[?%s$p' $modeNum; result=$(dd count=1 2>/dev/null)
        stty icanon echo 2>/dev/null
        exec 1>&3 3>&-

The next best thing, IMO, would be to encode the capabilities themselves (not
merely a name) into an environment variable.  Fortunately, ncurses 6.1+
supports using `TERMINFO` for this purpose.  Unfortunately, that's not widely
supported (yet) and it won't usually survive across ssh connections or into
terminal multiplexers.

Placing a path into `TERMINFO` is more widely supported (and this is what kitty
does by default).  But unfortunately that requires still more effort to maintain
across ssh: both ensuring the file exists and setting the `TERMINFO` environment
variable.

A fourth option is to maintain an up-to-date terminfo DB in `$HOME/.terminfo`,
preferrably with patched entries to support unofficial extensions such as `Tc`,
`setrgbf`, and `setrgbb` (etc).  That DB still needs to be copied to each system
for it to work across SSH.  And this only partially helps with terminals that
refuse to use their own `TERM` name (looking at you, gnome-terminal aka
"xterm-256color").

Rather than deal with this mess, many applications *only* look for  the
`COLORTERM` env var to denote RGB color support with the CSI 48 2 R G B m
sequence.  That still doesn't survive across ssh, but it is at least a simple
lookup for applications and libraries.  However, as a result, we now need to
ensure that environment var is set correctly in addition to `TERM` (and maybe
`TERMINFO`)!

And then, of course, many apps gave up detecting certain features and rely on
the user to add the correct app-specific config.  This can get tricky if
you're using multiple terminals with the same app config.  And it doesn't
scale beyond a few important apps.  But it's worth it for a handful of
important apps, e.g.  vim, tmux, or emacs.

Some apps, like vim, will use terminfo/termcap for some capabilities and attempt
to query the terminal to set *some* capabilities, including some that aren't
officially supported terminfo capabilities, but... vim won't do all of its
automatic queries unless `TERM` starts with `xterm`!

## The pragmatic approach taken here

For better or for worse, my basic approach is as follows:

1) Maintain a up-to-date terminfo entries for terminals I use in `~/.terminfo`.
   I'll use a script to update with a recent version of the ncurses terminfo DB,
   but give priority to terminfo provided by the terminal emulators themselves,
   e.g. kitty.  Additionally, I'll add `Tc`/`setrgbf`/`setrgbb` to entries.
   It's unlikely I'll be using a terminal that doesn't support 24bit RGB color
   in 2022!
2) Although I'd prefer to use an *appropriate* TERM variable for each terminal
   emulator, e.g: not `xterm-*`, I can't deny that many applications use
   `xterm*` to prefill some capabilities that aren't well supported by terminfo.
   Although, I could reconfigure some terminals to be more honest about their
   identity, I'll probable mostly just use what the original terminal reports.
3) As a fallback for apps that don't (or can't) honor terminfo, use COLORTERM.
   Nearly all 24bit RGB direct color terminals set this already... but it can
   be lost by tmux or ssh (etc).  When it's missing
   3a) by querying the terminal... only in interactive mode!
   3b) by guessing based on TERM name.  😦

Unfortunately, the primary terminfo DB maintainer has been reluctant to
accomodate certain new extensions, even though they have achieved widespread
support elsewhere among terminal emulator implementations.  Most notably:
24bit RGB support via Tc, rgb, setrgbf, and setrgbb.  And for whatever reason,
people often just skip terminfo/termcap and hardcode anyway.  So, instead of
using terminfo, many programs look at the $TERM and $COLORTERM environment
variables.

So we'll also set a matching COLORTERM, for compatibility:
1) always set $COLORTERM in supporting terminals (easy)
2) always send $COLORTERM through SSH (not always possible)
3) If we can trust our terminfo DB, we can use `tput colors` to set COLORTERM

