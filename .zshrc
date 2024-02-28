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

# fix these:
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
