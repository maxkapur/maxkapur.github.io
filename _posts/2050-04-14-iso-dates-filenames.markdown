---
layout:     post
title:      "Why I put ISO dates in filenames"
---

I am one of those obnoxious people who begins his filenames with an ISO date,
like `2024-03-06_blog_post_idea.md`. I know that file metadata already tracks
creation and revision dates, but I don't like those. The creation date is
misleading when you duplicate a file to reuse its format or content. And the
revision date is all but meaningless because modern software modifies files on
disk in all kinds of spurious ways. I put an ISO date in my filenames
to assign them a *canonical* date. The canonical date means something like “the
last date at which this file underwent a significant change,” and I alone (not
software) can determine what that means.<!--more-->[^spurious]

[^spurious]: An example of the spurious ways in which modern software modifies files on disk: If you open a Microsoft Excel worksheet, adjust the zoom, and try to close Excel, it will issue a “Do you want to save your changes?” warning. I’m not sure why the zoom level is stored in the .xlsx file at all. In Word (as far as I can tell), the zoom level, like scroll position, belongs to your <em>session</em> state and will thus be remembered separately for different viewers of the document.

    I have had some funny moments in client meetings where I pulled up an Excel sheet and it loaded at an illegible 50% because my last edit was to finalize the layout. 100% is the default for a reason!

And yes, at work, I often duplicate a file before making big changes despite
knowing I can roll things back in our sync software (OneDrive), because I have
essentially unlimited storage space, and visiting the web UI means leaving the
comfort of my local file manager for a terrible, laggy web app. But this
practice is not just a matter of personal preference; it’s also a crucial
mitigation against the version-control issues wrought by the collaboration
features of the “modern office tech stack.” See, I have colleagues who, at the
end of their work day, leave their computer on with all their Office files
open.[^logoff] A few hours later, their VPN session expires, which disconnects
OneDrive. So, if I log in before them in the morning and make some edits, their
version of the file goes out of date, but their OneDrive is powerless to detect
it or show them my changes. This results in an instant version conflict when
they come back online, make an edit, and reflexively press
<kbd>Ctrl</kbd>+<kbd>s</kbd>. I magnanimously prevent this problem by copying
each file and advancing the ISO date before making edits so that everyone can
see that my version is the newest.

[^logoff]: When I sign off for the day, I like to shut my computer all the way down to purge <a href="https://en.wikipedia.org/wiki/Daemon_(computing)">the demons</a>. But I can’t fault others for not doing so, because cold-booting Windows with all the bloat, reopening all your files and email, and logging into Workday and so on is a fifteen-minute process *at best.*

Ironically, the VPN/OneDrive fight would never arise on an old-school NAS or
“S:// drive,” because (assuming the shared drive is behind the VPN), when the
VPN lease expires, the `~$whatever.docx` lock file (a hidden file that indicates
when a file is being edited, and is completely ignored by OneDrive) would stay
on the NAS, and I would be *forced* to make my edits on a copy of the file
instead of the original—as I already do, manually.
