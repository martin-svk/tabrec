'use strict'

# ======================================
# @author Martin Toma
#
# Main background script.
# Will initiate whole application,
# instantiate logger, recognizers, etc.
# ======================================

# Run entire session in unique user context
# ======================================
connection = new Connection(Constants.get_api_url(),Constants.get_batch_size())
user = new User(connection)

user.in_context((user_id, session_id) ->
  # Modules initialization
  usage_logger = new UsageLogger(connection, Constants.get_batch_size(), user_id, session_id, Constants.is_debug_mode())
  usage_logger.start()
)
