
[![GitHub release](https://img.shields.io/github/release/c2gl/autopullscripter.svg)](https://github.com/c2gl/autopullscripter/releases)
[![GitHub downloads](https://img.shields.io/github/downloads/c2gl/autopullscripter/total.svg)](https://github.com/c2gl/autopullscripter/releases)
[![GitHub issues](https://img.shields.io/github/issues/c2gl/autopullscripter.svg)](https://github.com/c2gl/autopullscripter/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/c2gl/autopullscripter.svg)](https://github.com/c2gl/autopullscripter/pulls)

A simple .bat script to automatically pull all actively folowed git repos.

# How to use?

## Quick Start
1. Download the [latest release](https://github.com/C2gl/autopullscripter/releases) from GitHub
2. Place the executable in a folder where you want to run it
3. Run the script - it will guide you through the setup process

## First Run Setup
On the first run, the script will automatically detect if `repos_enhanced.txt` doesn't exist and offer you three options:

1. **Create empty repos_enhanced.txt** - Creates an empty categorized file for you to manually edit with repository paths organized by categories
2. **Scan a folder for Git repositories** - Automatically discovers existing Git repositories in a specified folder path (scans up to 2 levels deep) and organizes them in categories
3. **Exit without creating repos_enhanced.txt** - Exits the script (requires repos_enhanced.txt to function)

## Repository Management
The script uses a categorized repository structure in `repos_enhanced.txt` that allows you to organize your repositories by purpose, project type, or any other grouping that makes sense for your workflow.

### Manual Addition
Add repository paths to `repos_enhanced.txt` organized by categories. The format is:

```
# Repository Categories Configuration  
# Lines starting with # are comments and ignored
# Empty lines are also ignored

[CATEGORY_NAME]
C:\path\to\repository1
C:\path\to\repository2

[ANOTHER_CATEGORY]
C:\path\to\repository3
C:\path\to\repository4
```

**Examples of useful categories:**
- `[PERSONAL_PROJECTS]` - Your own coding projects
- `[WORK_PROJECTS]` - Professional/work repositories  
- `[OPEN_SOURCE]` - Contributions to open source projects
- `[LEARNING]` - Educational or tutorial repositories
- `[WEB_DEVELOPMENT]` - Frontend/backend web projects
- `[DATA_SCIENCE]` - Analytics, ML, or data projects

### Automatic Scanning
The script can scan any folder path and automatically detect Git repositories (looks for `.git` folders). It will:
- Scan the root directory and up to 2 levels of subdirectories
- Check if repositories are already in your `repos_enhanced.txt` to avoid duplicates
- Show you all found repositories before adding them
- Let you confirm which repositories to add
- Organize them into a timestamped category

### Clone New Repositories
The script can clone new repositories from remote URLs and automatically add them to your tracking list in the appropriate category.

### Category-Based Operations
You can choose to pull repositories from:
- **All categories** - Pull from every repository in your file
- **Specific categories** - Select only certain categories to update (e.g., only work projects, only personal projects)
- **Individual selection** - Choose exactly which repository groups to process

You can check the [example file](https://github.com/C2gl/autopullscripter/blob/main/example_repos_enhanced.txt) in the GitHub repository for reference.

## Configuration Options

### Default Settings
The script offers quick default settings for immediate use:
- **Wait time between pulls**: 1 second
- **Fetch before pull**: No
- **Custom command**: No  
- **Verbose mode**: No

### Custom Configuration
If you choose custom settings, you can configure:

| Configuration                        | Description                                                                                  | Example                  |
|---------------------------------------|----------------------------------------------------------------------------------------------|--------------------------|
| Wait time between pulls               | Set the number of seconds to wait between pulls                                              | `3`                      |
| Fetch changes before pulling          | Whether to fetch changes before pulling (`y`/`n`)                                            | `y`                      |
| Custom command after pulling          | Run a custom command after each pull operation                                               | `git checkout main`      |
| Verbose mode                          | Enable detailed output and progress information (`y`/`n`)                                    | `y`                      |

### Features
- **Category-Based Organization**: Organize repositories by project type, purpose, or any grouping that makes sense
- **Selective Processing**: Choose to pull from all categories or select specific ones
- **Smart Error Detection**: Detects authentication errors, network issues, and repository problems
- **Progress Tracking**: Visual progress bar showing completion status
- **Color-Coded Output**: Green for success, red for errors, yellow for up-to-date repositories
- **Comprehensive Logging**: All operations are logged with timestamps to `log/` folder
- **Repository Status**: Shows whether repositories were updated, already up-to-date, or had errors
- **Path Validation**: Checks if repository paths exist before attempting operations

## Script Output
The script provides clear, color-coded feedback for each repository:

- **🟢 OK - PULLED NEW CHANGES**: Repository was successfully updated with new changes
- **🟡 OK - ALREADY UP TO DATE**: Repository is current, no changes were pulled
- **🔴 ERROR**: There was an issue (path not found, authentication error, network problem, etc.)
- **🔴 PATH NOT FOUND**: The specified repository path doesn't exist

### Summary Report
After processing all repositories, you'll see a summary showing:
- Total repositories processed
- Successful operations
- Repositories that received updates
- Failed operations
# Future Features 
In the (far) future, quite a few features are planned. This is not meant to be a comprehensive tool, but rather a fun project to practice basic coding.

- [X] The ability to pull new repos
- [X] Automatically populate the repository list
- [X] Comprehensive logging system with timestamps
- [X] Progress tracking and visual feedback
- [X] Color-coded output for better readability
- [X] Repository scanning functionality
- [X] Smart error detection and handling
- [X] Verbose mode for detailed output
- [X] Automated checking for available updates
- [X] Sort repositories by category and choose what category to pull
- [ ] An automated fetcher to see release changes when you didn't keep yourself up to date with the repo for a while
- [ ] The ability to have a cron job
- [ ] Configuration file support for persistent settings

# Report Issues 
If you see issues, or want to help developing this, feel free to contribute!
I would be asking to explain why and how since this is mostly a learning project, so I am not looking for stuff to be done in place of me.

## Logging and Debugging
All script operations are automatically logged to the `log/` folder with timestamps. Each run creates a separate log file named with the date and time. These logs can be helpful when reporting issues. 

# Important! 
This repo is both on GitHub and GitLab. 
While bug reports on GitLab will be looked at, the main used place will be GitHub, and thus that one will be more actively used, especially for code and pull requests.

**GitHub: https://github.com/C2gl/autopullscripter**
**GitLab: https://gitlab.com/C2gl/autopullscripter**

# Dependencies 
- [Bat-to-Exe-Converter](https://github.com/l-urk/Bat-To-Exe-Converter-64-Bit/releases) - used to make releases