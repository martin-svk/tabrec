What is TabRec?
---
TabRec is a personalized tab actions recommender for Google Chrome. The purpose of TabRec is to help understand
how people use browser tabs and to utilize this information by providing appropriate recommendations based on
their browser usage.

How to install TabRec?
---
The fastest way is to install TabRec from [Google Chrome store](http://tabber.fiit.stuba.sk:9292).

Current state
---
TabRec is currently capable of real-time pattern detection and action recommendation. Currently only one pattern
is supported but more are planned in later releases.

TabRec is also used for parallel browsing mechanisms analysis.
We focus on events like creating, navigation, closing and moving (rearranging) tabs in one or more windows.
We care strongly about privacy, so we don't collect any personal information about the users.
All URLs are encrypted before they are sent and stored.

You can see detailed list of changes for each version [here](CHANGELOG.md).

Feature list
---

* Browser usage logging
* Real-time pattern recognition
* Recommendation providing
* Personal statistics

Credits
---
TabRec is being developed as a part of my master thesis project at
[Slovak Technical University in Bratislava, Slovakia](http://www.fiit.stuba.sk). Thank You all for your participation!

License
--

THE MIT LICENSE (MIT) Copyright © 2015 Martin Toma, martin.toma.svk@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
