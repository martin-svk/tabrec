'use strict'

# ======================================
# @author Martin Toma
#
# Main background script.
# Will initiate whole application,
# instantiate logger, recognizers, etc.
# ======================================

# Defining constants
# ======================================
# API_URL = 'http://tabber.fiit.stuba.sk'
API_URL = 'http://localhost:9292'
DEBUG_MODE = false
BATCH_SIZE = 50

# Run entire session in unique user context
# ======================================
connection = new Connection(API_URL, DEBUG_MODE)
user = new User(connection)

user.in_context((user_id, session_id) ->
  # Modules initialization
  usage_logger = new UsageLogger(connection, BATCH_SIZE, user_id, session_id, DEBUG_MODE)
  usage_logger.start()
)
