'use strict'

# ======================================
# @author Martin Toma
#
# Main background script.
# Will initiate whole application,
# instantiate recognizers, etc.
# ======================================

API_URL = 'http://tabber.fiit.stuba.sk'

connection = new Connection(API_URL)
usage_logger = new UsageLogger(connection)
logger = new Logger(connection)
#rec = new Recognizer
#notifier = new Notifier

#rec.recognize()
#notifier.notify("Something happened!")

connection.get_user(1)
connection.get_events()

usage_logger.start()
logger.start()
