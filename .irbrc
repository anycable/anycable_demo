# frozen_string_literal: true

require "irb/completion"

IRB.conf[:AUTO_INDENT]  = true
IRB.conf[:SAVE_HISTORY] = 1_000
IRB.conf[:HISTORY_FILE] = File.join(__dir__, "log", ".irb_history")
