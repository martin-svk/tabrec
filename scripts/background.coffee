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
user = new User()
user.in_context((user_id, session_id) ->
  # Modules initialization
  usage_logger = new UsageLogger(user_id, session_id)
  usage_logger.start()
)
