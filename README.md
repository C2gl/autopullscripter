
[![GitHub release](https://img.shields.io/github/release/c2gl/autopullscripter.svg)](https://github.com/c2gl/autopullscripter/releases)
[![GitHub issues](https://img.shields.io/github/issues/c2gl/autopullscripter.svg)](https://github.com/c2gl/autopullscripter/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/c2gl/autopullscripter.svg)](https://github.com/c2gl/autopullscripter/pulls)

A simple .bat script to automatically pull all actively folowed git repos.

# How to use?
To use this script you can just simply download the [release](https://github.com/C2gl/autopullscripter/releases) script from github. 
You place said script exe in a folder. And **in that same folder** you are to manually add a .txt file called repos.txt.
On the first run, the script will check for the existance of repos.txt. 
if it does not find anny, it will propose to create it for you for you to eddit afterwards. 
you can also then add it manually and restart the program

In that 'repos.txt' file you can add the paths to the repositories you wish to track, 

these should be added as plain text, and each on a different line, no added text. 
You can check the [example file](https://github.com/C2gl/autopullscripter/blob/main/example-repos.txt) in the github repository.

## configurations
### default configuration
at first run, the script will prompt you to know if you want it to run by default, these are the following default configurations:
- waitime between pulls: 3 sec
- go through entire repos.txt file
- just pull the working branch of the repo

### custom configurations
if at the first run, you tell it you do not wish to run the default script, it will walk you though some questions. 
these questions are self explainatory and clear, but if needed, the different configurations will be explained here.

| Configuration                        | Description                                                                                  | Example                  |
|---------------------------------------|----------------------------------------------------------------------------------------------|--------------------------|
| Wait time between pulls               | Set the number of seconds to wait between pulls                                              | `3`                      |
| Fetch changes before pulling          | Whether to fetch changes before pulling (`y`/`n`)                                            | `y`                      |
| Custom command before every pull      | Run a custom command before each pull (e.g., switch branch)                                  | `git checkout main`      |
# future features 
In the (far) future, quite a few features are planned, not to be a usefull repository, but as a fun project to get my hands on some basic coding.

- [X] the ability to pull new repos
- [X] automatically populate the repos.txt
- [ ] an automated fetcher to see release changes when you didn't keep yourself up to date with the repo for a while
- [ ] sort repositories by category and choose what category to pull
- [ ] the ability to have a cron job

# report issues 
if you see issues, or want to help developing this, feel free to.
i would be asking to explain why and how since this is mostly a learning project. so i am not looking for stuff to be done in place of me 

# important! 
this repo is both on github and gitlab, 
whilst bug reports on gitlab will be looked at, the main used place will be github. and thus that one will be more actively used, especially for code and pull requests

**github: https://github.com/C2gl/autopullscripter**
**gitlab: https://gitlab.com/C2gl/autopullscripter**


# dependancies 
- [Bat-to-Exe-Converter](https://github.com/l-urk/Bat-To-Exe-Converter-64-Bit/releases) - used to make releases