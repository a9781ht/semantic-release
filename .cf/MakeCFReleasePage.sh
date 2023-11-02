# Title
echo "<!-- Title: ${CI_PROJECT_TITLE} - ${CI_COMMIT_TAG} -->" >> CFReleasePage.md

# Download file section
echo >> CFReleasePage.md
echo "## Download file: " >> CFReleasePage.md
echo "* [release_test.zip](${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/my_package/${CI_COMMIT_TAG}/test.zip)" >> CFReleasePage.md

# Release notes section
echo "" >> CFReleasePage.md
echo "## Release Notes: " >> CFReleasePage.md
echo "<!-- Include: template/jira_ticket_macro.md -->" >> CFReleasePage.md
# Feature ticket table
echo "" >> CFReleasePage.md
echo "### Features: " >> CFReleasePage.md
echo "<!-- Include: featureTicketTable.md -->" >> CFReleasePage.md
# Bug ticket table
echo "" >> CFReleasePage.md
echo "### Bugs: " >> CFReleasePage.md
echo "<!-- Include: bugTicketTable.md -->" >> CFReleasePage.md

# disclaimer section
echo "" >> CFReleasePage.md
echo "**NOTE**: this document is generated automatically." >> CFReleasePage.md