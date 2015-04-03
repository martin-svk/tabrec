'use strict'

# ======================================
# @author Martin Toma
#
# Main background script.
# Will initiate whole application,
# instantiate user, recognizer, etc.
# ======================================

# Run entire session in unique user context
# ======================================
user = new User()

user.in_context((user_id, session_id) ->
  if Constants.usage_logging_on()
    usage_logger = new UsageLogger(user_id, session_id)
    usage_logger.start()

  recognizer = new Recognizer(user_id, session_id)
  recognizer.start()
)
