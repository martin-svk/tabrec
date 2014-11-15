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
DEBUG_MODE = true
BATCH_SIZE = 50

# Run entire session in unique user context
# ======================================

user = new User
user.in_context( (user_id) ->
  # Modules initialization
  # ======================================
  connection = new Connection(API_URL, DEBUG_MODE)
  usage_logger = new UsageLogger(connection, BATCH_SIZE, user_id, DEBUG_MODE)

  # Modules running
  # ======================================
  usage_logger.start()
)
