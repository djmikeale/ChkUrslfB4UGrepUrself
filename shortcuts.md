# other

- https://github.com/junegunn/fzf/blob/master/ADVANCED.md
- https://github.com/sharkdp/bat
- `gh formatting help`
- `gh pr list --json author,state --jq 'map(select(.state == "OPEN" or .state == "DRAFT")) | .[].author.login' --limit 1000 | sort | uniq -c | sort -r`

# shortcuts
## Terminal/Iterm2/bash
- `mkdir [directoryname]`
- `rmdir -r [directoryname]`
- `touch [filename]`
- `mv [filename] [directory]` moves file to directory
- `mv index.html about.html` renames index.html to about.html
- `cp index.html about.html`
- `cat [filename]` prints content of file in console
- `nano [filename]`
- `code .` . open VScode at current directory
- `ls [directoryname]` foldername optional - for listing content of that folder
- `ll` ls with details
- `~/` shortcut for homedir
- `z [part of folder name]` goes to folder matching the naming
- `grep -rni "[term to search for]"` searches recursively for term in files within folder+subfolders
- `source venv/bin/activate` for starting a virtual environment
- `nano ~/.zshrc` for adding aliases, e.g. alias docs='dbt docs generate && dbt docs serve', to enable you to just write docs in the terminal rather than dbt docs generate && dbt docs serve
- Environment variables:
  - `export sample=true && export sample_from='2021-01-01' && export sample_to='2022-01-01'`
    - `export sample=true` for sampling dates when running dbt, the following for determining to- and from-dates
    - `export sample_from='2021-01-01'` and `export sample_to='2022-01-01'` to have next runs pull data between 1st of jan 2021 and 1st of jan 2022
    - `&&` runs all of the different commands in a single line 
- `printf "%s\n" "sample" "... activated: ${sample}" "... from: ${sample_from}" "... to: ${sample_to}"` to output the current values of these variables. 
  - env to see all currently set variables
- xargs is useful for stringing commands together, e.g. 
- `dbt ls -m models/core/activity_based_interest/events --output name | xargs -I{} echo -n ' "{}",'` outputs all the models within a folder, and formats them as follows: 
  - `"activity_based_interest_activated", "activity_based_interest_deactivated", "activity_based_interest_updated", "downgrade_interest_level_for_user", "set_inactive_interest_rate_after_july_1st_in_bec_for_user", "set_inactive_interest_rate_from_july_1st_in_bec_for_user", "set_interest_levels_from_june_1st_in_bec_for_user",%`
  - This can then be copy-pasted into a dbt run-operations generate_model_yaml command.
## Misc 
- `CTRL + R` Search bash history
- `CTRL + L` Clear the screen
- `CTRL + C` Kill process
- `⌘ + F` take a wild guess 🕵️‍♀️
## vim
- `i` Enter insert mode
- `esc` Enter command mode
- `:w` save (write)
- `:q` quit, `:wq` to save, then quit
## `Git`...
- `pull`
- `clone [git-repo-URL]`
- `branch [branchname]` creates branch 
- `checkout -b [branchname]` creates branch and switches to it
- `branch -D [branchname]` deletes branch
- `checkout [branchname]` switches to branch
- `stash` stashes changes, stash show shows the stash, - `stash pop` restores stashed changes
- `status` shows all files having to be staged
- `add .` stages all files - replace . with specific files or patterns
- `commit -m` 'insert commit message here'
If you change your mind, git reset --soft HEAD~1 will undo the last commit, move the mistakenly committed files back to the staging area.
- `push origin [branchname]` (creates PR)
## dbt
- `dbt deps` pulls the most recent version of the dependencies listed in your packages.yml from git
dbt compile generates executable SQL from source model, test, and analysis files. You can find these compiled SQL files in the target/ directory of your dbt project. Useful for validating complex jinja logic or macro usage, or debugging purposes through manually running compiled SQL.
- `dbt compile -s [model]` limits compiling to [model]
- `dbt build --select [model]` build and test all selected resources (models, seeds, snapshots, tests). [model] could e.g. be +f_transaction for f_transaction and all its upstream dependencies
- `dbt run -m [model]` for executing the sql to create the model + run transformations to populate it 
Supply the -x flag to dbt run to make dbt exit immediately if a single resource fails to build.
- `dbt docs generate` is responsible for generating your project's documentation website.
- `dbt docs serve` lets you view the documentation in browser
- `dbt ls --select [pattern]` for listing models matching a given pattern 
Can search for tags, output in JSON, and other stuff:  
- `dbt run --select result:error+ result:skipped+ --defer --state ./target --full-refresh` runs what failed in the previous run. 
- `dbt test -m core.aml.* --target edb` - run tests on core layer or aml in a local db
- `sample=true dbt run -m +model_name --full-refresh -- target dev`
## VS Code
- `⌥+z` for word wrap for current window
- `⌥ + SHIFT + F` for making single-line JSON multiline 
- `⌥+click` or ⌥+SHIFT+click for adding multiple cursors to write on multiple places in the same doc at once

## Datagrip
- `SHIFT + F6` lets you refactor, e.g. change all occurrences (smart enough to only replace table name and not column names that are the same)
- `⌥ + ⌘ + L` lets you instantly reformat the entire code you’re working on, as specified in Preferences | Editor | Code Style | SQL | General (Click Set from… and select Joe Celko which looks most like the style we use)
