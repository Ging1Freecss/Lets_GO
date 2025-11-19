# watch-logs.nu

# Initialize an environment variable to track the number of lines we've already processed.
# We use an environment variable so it can be modified inside the `watch` block.
$env.LINES_PROCESSED = 0

print "Watching output.jsonl for new log entries..."

# The `watch` command runs its code block every time the file changes.
watch output.jsonl {
    # Get all the lines from the file and skip the ones we've already seen.
    let new_lines = (open output.jsonl | lines | skip $env.LINES_PROCESSED)

    # Check if there are actually any new lines to process.
    if not ($new_lines | is-empty) {
        # --- YOUR LOGIC GOES HERE ---
        # For each new line, parse it from JSON.
        # This will print the parsed output as a table.
        $new_lines | each { |line| $line | from json }
        
        # You could add more logic here, for example:
        # let critical_alerts = ($new_lines | each { from json } | where level == "ERROR")
        # if not ($critical_alerts | is-empty) {
        #   # send a notification...
        # }

        # --- UPDATE THE COUNTER ---
        # IMPORTANT: Update our counter to the new total line count in the file,
        # so we don't re-process these lines on the next change.
        $env.LINES_PROCESSED = (open output.jsonl | lines | length)
    }
}