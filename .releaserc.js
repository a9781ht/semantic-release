const { readFileSync } = require('fs');
const { join } = require('path');

var Handlebars = require('handlebars');
Handlebars.registerHelper('formatBodyOfCommitMessage', function(context) {
  if(context){
      var lines = context.split('\n').map(line => {
          // Escape special characters in Markdown
          line = line.replace(/([`*_{}[\]()#+-.!])/g, '\\$1');
          // Add tab at the beginning and two whitespace at the end
          return '\t' + line + '  ';
      });
      return new Handlebars.SafeString(lines.join('\n'));
  }
  return context;
});

module.exports =
{
  "branches": ["master"],
  "plugins": [
    "@semantic-release/commit-analyzer",
    [
      "@semantic-release/changelog",
      {
        "changelogFile": "ReleaseNote_.md"
      }
    ],
    [
      "@semantic-release/exec",
      {
         "prepareCmd": "cp ReleaseNote_.md ReleaseNote.md ; cat ReleaseNote_.md CHANGELOG.md > tmp.md ; mv -f tmp.md CHANGELOG.md"
      }
    ],
    [
      "@semantic-release/git",
      {
        "assets": ["CHANGELOG.md", "ReleaseNote.md"],
        "message": "chore(release): Push by semantic-release-bot in ${nextRelease.version}"
      }
    ],
    [
      "@semantic-release/gitlab",
      {
        "gitlabUrl": "https://gitlab.syntecclub.com",
        "assets": {
          "url": "${env.CI_API_V4_URL}/projects/${env.CI_PROJECT_ID}/packages/generic/my_package/${nextRelease.version}/test.zip",
          "label": "release_test.zip",
        }
      }
    ],
    [
      "@semantic-release/release-notes-generator",
      {
        "writerOpts": {
          commitPartial: readFileSync(join(__dirname, './commit.hbs'), 'utf-8')
        }
      }
    ]
  ]
}