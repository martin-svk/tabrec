'use strict'

# ======================================
# @author Martin Toma
#
# Main background script.
# Will initiate whole application,
# instantiate recognizers, etc.
# ======================================

rec = new Recognizer
notifier = new Notifier

rec.recognize()
notifier.notify("Something happened!")
