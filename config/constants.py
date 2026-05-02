# =============================================================================
# DocBot Configuration Constants
# =============================================================================
# These values are used throughout the application. Edit them here to change
# system-wide behavior without modifying view code.
# =============================================================================

# Number of days after a completed appointment during which the doctor
# can still view the patient's information.
DOCTOR_PATIENT_ACCESS_DAYS = 14

# Number of days after a completed appointment during which the patient
# can book a follow-up appointment (if the doctor has allowed it).
FOLLOWUP_BOOKING_WINDOW_DAYS = 30

# Number of weeks ahead to generate time slots when a doctor schedule
# is created/updated, or when the generate_slots management command runs.
SLOT_GENERATION_WEEKS = 8
