TabRec changelog
---

0.9.5-iitsrc
----

* Add three new patterns detection with no advice action for detection accuracy evaluation :
  * refresh pattern (when user update specific tab for content updates),
  * compare pattern (when user compare content of two tabs),
  * multi close pattern (when user finished some task and is closing all related tabs).
* Change after recommendation timeout to 10 seconds.

0.9.4
----

* Improve sorting for URLs with subdomains.
* Fix issue in actions reverting.

0.9.3
----

* Fix broken package. Add missing folder.

0.9.2
----

* Added new version of activate pattern.
* Improved running average handling.
* Added reverted actions to popup stats.
* Improved handling of recommended actions execution.

0.9.1
----

* Real-time calculated running average is now used in pattern recognition process.
* Add prevention to not trigger activate pattern when focusing adjacent tabs (e.g. CTRL-TAB switching).

0.9.0
----

* Add possibility to revert recommended action.
* Add timeout after accepting recommendation to prevent unexpected triggering.

0.8.0
----

* First pattern implemented and ready for recommendation (currently only interactive mode is supported).
* More statistics in popup window.
* Changed default values in settings.

0.7.3
----

* Fix API url due to server changes.

0.7.2
----

* Replace included self maintained SHA1 script with popular jshashes library.

0.7.1
----

* Proper user recreation.
* Code refactoring.

0.7.0
----

* Update to reflect API changes.
* Fix usage logs loosing bug.

0.6.0
----

* Various small fixes.

0.5.0
----

* Reworked popup window
  * Added basic browsing stats
  * Added settings button
* Updated default icon
