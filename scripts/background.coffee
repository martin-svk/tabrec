'use strict'

# ======================================
# @author Martin Toma
#
# Main background script.
# Will initiate whole application,
# instantiate recognizers, etc.
# ======================================

API_URL = 'http://tabber.fiit.stuba.sk'

rec = new Recognizer
notifier = new Notifier
logger = new Logger(API_URL)

rec.recognize()
notifier.notify("Something happened!")
logger.log("Logging this")

logger.getUser(1)
