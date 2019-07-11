# frozen_string_literal: true

Pry.config.history.should_save = true
Pry.config.history.file = File.join(__dir__, "log", ".pry_history")
