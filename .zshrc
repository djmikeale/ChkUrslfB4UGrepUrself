alias docs='dbt docs generate && dbt docs serve'
alias sample_status='printf "%s\n" "sample" "... activated: ${sample}" "... from: ${sample_from}" "... to: ${sample_to}"'
alias git_sync_master='git checkout master && git pull && git checkout - && git rebase origin/master && git push -f'
ddocs() {
    git ls-tree -r --name-only master | grep -E '^models.*sql$' | \
    sed -E 's|(.*)/([^/]*)\.sql|\2 \1|' | column -t | fzf | \
    awk '{print $1}' | \
    xargs -I{} \
      echo 'http://lunarway-prod-data-dbt-documentation.s3-website-eu-west-1.amazonaws.com/#!/model/model.lw_go_events.{}'
}

# Find and return docs block in '{{ doc("docs_block_name") }}' format
doc() {
# get all docs blocks and clean up
awk '/{% docs/,/{% enddocs %}/ {if (NF && !/% enddocs %/) printf "%s ", $0; else if (NF) print ""}' ./**/*.md | \
# clean up some more
sed -E 's/ +/ /g' | \
# structure: name of doc \t doc description
sed -E 's/ *{% docs ([^ ]*) %} (.*)/\1\t\2/' | \
# only get first 300 chars of each line, search gets messy otherwise
cut -c -300 | \
# add ansi colours to name of doc
awk -F'\t' '{printf "\033[1;32m%s\033[0m\t%s\n", $1, $2}' | \
sort | \
# fuzzyfind the docs block you're looking for
fzf --ansi -e --header="Press enter to copy docs block to clipboard" --height=10 --scheme=path | \
# format it in the right way
awk '{printf "'\''{{ doc(\"%s\") }}'\''", $1}' | \
# add to clipboard
pbcopy
}

# release command simplification
prep() {
    # Prompt for release type
    clear
    echo "Constructing release command: \033[1;32mhubble release prepare master\033[0m"
    echo "1) unstable"
    echo "2) stable"
    echo -n "Enter your choice (1 or 2): "
    read -sk release_type_choice

    case $release_type_choice in
        1)
            release_type="unstable"
            ;;
        2)
            release_type="stable"
            ;;
        *)
            echo "Invalid choice. Exiting."
            return 1
            ;;
    esac

    # Prompt for refresh type
    clear
    echo -e "Constructing release command: \033[1;32mhubble release prepare master ${release_type}\033[0m"
    echo "1) default"
    echo "2) selected"
    echo "3) none"
    echo -n "Enter your choice (1, 2, or 3): "
    read -sk refresh_choice

    case $refresh_choice in
        1)
            refresh=""
            ;;
        2)
            refresh="--refresh SELECTED"
            ;;
        3)
            refresh="--refresh NONE"
            ;;
        *)
            echo "Invalid choice. Exiting."
            return 1
            ;;
    esac

    # Prompt for models if SELECTED was chosen
    if [ "$refresh_choice" -eq 2 ]; then
        clear
        echo "Constructing release command: \033[1;32mhubble release prepare master ${release_type} ${refresh}\033[0m"
        echo -n "Enter comma-separated list of models (and graph operators), e.g. account,f_account,+s_user: "
        read models
        changes="--model-selection-operator SELECTED --changes ${models}"
    else
        changes=""
    fi

    # Construct the final command
    final_command="hubble release prepare master ${release_type} ${refresh} ${changes}"

    # Execute, edit before execution, or print the command and exit
    clear
    echo "Constructed command: \033[1;32m$final_command \033[0m"
    echo "1) Execute the command"
    echo "2) Edit the command before execution"
    echo "3) Print the command and exit"
    echo -n "Enter your choice (1, 2, or 3): "
    read -sk action_choice
    clear

    case $action_choice in
        1)
            # Execute the final command
            echo "Running command: \033[1;32m$final_command \033[0m"
            eval $final_command
            ;;
        2)
            # Write the command to a temporary file for editing
            tmpfile=$(mktemp /tmp/release_command.XXXXXX)
            echo "$final_command" > $tmpfile

            # Open the temporary file in the default editor
            ${EDITOR:-nano} $tmpfile

            # Read the edited command back from the file
            final_command=$(cat $tmpfile)

            # Clean up the temporary file
            rm $tmpfile

            # Execute the edited command
            echo "Running edited command: \033[1;32m$final_command \033[0m"
            eval $final_command
            ;;
        3)
            # Print the final command and exit
            echo "\033[1;32m$final_command \033[0m"
            ;;
        *)
            echo "Invalid choice. Exiting."
            return 1
            ;;
    esac
}

# usage: dbt run; notify --> sends popup on mac once first command is done running
function notify() {
  if [[ $? == 0 ]]; then
    osascript -e 'display dialog "Your command has finished successfully" with title "Command Notification"'
  else
    osascript -e 'display dialog "Your command has failed" with title "Command Notification"'
  fi
}

# fix these:
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
