# Add a new Infrastructure Type

Disclaimer: These instructions are only applicable to use cases where an infrastructure category of a specific street with more lanes than currently configured is needed. For example a
10-lane one-way street with a bus/bicycle lane on one side and a separate bicycle lane on the sidepath. If completely new infrastructure categories should be added, also a change in the [infrastructure_logic.lua](/import/flex/infrastructure_logic.lua) needed.

1. Add the new infrastructure category to the [infrastructure_types.lua](/import/flex/infrastructure_types.lua)
2. Run the SQL database initialization file generator script: `lua sql_initdb_generator.lua`
3. Recreate and restart the application stack and perform the processing again
