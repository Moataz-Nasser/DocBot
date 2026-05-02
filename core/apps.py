from django.apps import AppConfig
import threading
import time
import os

class CoreConfig(AppConfig):
    name = 'core'

    def ready(self):
        # We only want to start the thread in the main process, not the reloader process
        # Django runserver sets RUN_MAIN=true in the child process
        if os.environ.get('RUN_MAIN') == 'true':
            thread = threading.Thread(target=self.run_reminder_engine, daemon=True)
            thread.start()

    def run_reminder_engine(self):
        from django.core.management import call_command
        # Wait a few seconds for the server to fully start
        time.sleep(5)
        while True:
            try:
                # This runs the management command we created earlier
                call_command('send_medication_notifications')
            except Exception as e:
                # Silently fail if something goes wrong to avoid crashing the main thread
                pass
            # Check every 60 seconds
            time.sleep(60)
