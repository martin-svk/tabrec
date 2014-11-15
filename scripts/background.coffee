'use strict'

# ======================================
# @author Martin Toma
#
# Main background script.
# Will initiate whole application,
# instantiate recognizers, etc.
# ======================================

# Defining constants
# ======================================
#API_URL = 'http://tabber.fiit.stuba.sk'
API_URL = 'http://localhost:9292'
DEBUG_MODE = false
BATCH_SIZE = 50

# Run entire session in unique user context
# ======================================
connection = new Connection(API_URL, DEBUG_MODE)

user = new User
user.in_context(connection, (user_id) ->
  # Modules initialization
  # ======================================
  usage_logger = new UsageLogger(connection, BATCH_SIZE, user_id, DEBUG_MODE)

  # Modules running
  # ======================================
  usage_logger.start()
)
