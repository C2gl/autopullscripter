
[![GitHub release](https://img.shields.io/github/release/c2gl/autopullscripter.svg)](https://github.com/c2gl/autopullscripter/releases)
[![GitHub issues](https://img.shields.io/github/issues/c2gl/autopullscripter.svg)](https://github.com/c2gl/autopullscripter/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/c2gl/autopullscripter.svg)](https://github.com/c2gl/autopullscripter/pulls)

A simple .bat script to automatically pull all actively folowed git repos.

# How to use?

## Quick Start
1. Download the [latest release](https://github.com/C2gl/autopullscripter/releases) from GitHub
2. Place the executable in a folder where you want to run it
3. Run the script - it will guide you through the setup process

## First Run Setup
On the first run, the script will automatically detect if `repos.txt` doesn't exist and offer you three options:

1. **Create empty repos.txt** - Creates an empty file for you to manually edit with repository paths
2. **Scan a folder for Git repositories** - Automatically discovers existing Git repositories in a specified folder path (scans up to 2 levels deep)
3. **Exit without creating repos.txt** - Exits the script (requires repos.txt to function)

## Repository Management
The script offers multiple ways to populate your repository list:

### Manual Addition
Add repository paths to `repos.txt`, one per line. Each line should contain the full path to a Git repository folder.

### Automatic Scanning
The script can scan any folder path and automatically detect Git repositories (looks for `.git` folders). It will:
- Scan the root directory and up to 2 levels of subdirectories
- Check if repositories are already in your `repos.txt` to avoid duplicates
- Show you all found repositories before adding them
- Let you confirm which repositories to add

### Clone New Repositories
The script can clone new repositories from remote URLs and automatically add them to your tracking list.

You can check the [example file](https://github.com/C2gl/autopullscripter/blob/main/example_repos.txt) in the GitHub repository for reference.

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
- [X] Automatically populate the repos.txt
- [X] Comprehensive logging system with timestamps
- [X] Progress tracking and visual feedback
- [X] Color-coded output for better readability
- [X] Repository scanning functionality
- [X] Smart error detection and handling
- [X] Verbose mode for detailed output
- [X] automated checking for available updates
- [ ] An automated fetcher to see release changes when you didn't keep yourself up to date with the repo for a while
- [ ] Sort repositories by category and choose what category to pull
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