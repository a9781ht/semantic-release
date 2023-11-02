# variables
MERGE_COMMIT_PREFIX="^(feat|fix): merge(\(.*\))?\s"
FEATURE_BRANCH_PREFIX="_f_"
BUG_BRANCH_PREFIX="_b_"
TABLE_HEADER="|  |Issue|\n|:---:|----|"

# arrays
featureBranches=()
bugBranches=()

# Get latest git tag
latestgitTag=$(git describe --tags --abbrev=0)
previousgitTag=$(git describe --tags --abbrev=0 $latestgitTag^)

# Get specific commit message prefix from the previous to the latest tag
commitList=$(git log $previousgitTag..$latestgitTag --pretty=format:"%s" | grep -P "$MERGE_COMMIT_PREFIX")

IFS=$'\n'
for line in $commitList; do
  # Get feature branch
  if [[ $line == *"$FEATURE_BRANCH_PREFIX"* ]]; then
    featureBranches+=($(echo $line | sed -r -e "s/$MERGE_COMMIT_PREFIX//g" -e "s/$FEATURE_BRANCH_PREFIX.*//g"))
  # Get bug branch
  elif [[ $line == *"$BUG_BRANCH_PREFIX"* ]]; then
    bugBranches+=($(echo $line | sed -r -e "s/$MERGE_COMMIT_PREFIX//g" -e "s/$BUG_BRANCH_PREFIX.*//g"))
  fi
done

# Remove duplicate branches ( means 2nd merge, 3rd merge, etc. ) and sort them
IFS=" " read -r -a featureBranches <<< "$(echo "${featureBranches[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')"
IFS=" " read -r -a bugBranches <<< "$(echo "${bugBranches[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')"

# change _ to - in branch name
for i in "${!featureBranches[@]}"; do
  featureBranches[$i]=$(echo "${featureBranches[$i]}" | sed -r "s/_/-/g")
done
for i in "${!bugBranches[@]}"; do
  bugBranches[$i]=$(echo "${bugBranches[$i]}" | sed -r "s/_/-/g")
done

# create Feature and Bug ticket table
echo -e $TABLE_HEADER > featureTicketTable.md
echo -e $TABLE_HEADER > bugTicketTable.md
for i in "${!featureBranches[@]}"; do
  echo "|$(expr $i + 1)|"${featureBranches[$i]}"|" >> featureTicketTable.md
done
for i in "${!bugBranches[@]}"; do
  echo "|$(expr $i + 1)|"${bugBranches[$i]}"|" >> bugTicketTable.md
done
