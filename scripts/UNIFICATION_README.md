# Git Pull Scripts Simplification

## Overview
The `auto_git_pull.bat` and `configurable_git_pull.bat` scripts have been simplified into a single `simple_git_pull.bat` script that asks one simple question at the start: whether to use default settings or configure custom options.

## New Simplified Script: `simple_git_pull.bat`

### How It Works
1. **Single Question**: "Use default settings? (y/n)"
2. **If Yes**: Runs automatically with defaults (3 seconds wait, no fetch, no custom command)
3. **If No**: Prompts for custom configuration options

### Default Settings
- Wait time: 3 seconds between pulls
- Fetch before pull: No
- Custom command: No

### Usage
```batch
simple_git_pull.bat
```

Then choose:
- **y** (or just press Enter) → Quick automatic execution with defaults
- **n** → Configure custom settings interactively

## Benefits of Simplification

1. **Reduced Complexity**: Single script, single question to start
2. **User-Friendly**: Clear default options displayed upfront
3. **Fast for Power Users**: Just press Enter to use defaults
4. **Flexible for Custom Needs**: Easy to configure when needed
5. **No Command-Line Parameters**: No need to remember syntax
6. **Consistent Behavior**: Same script for all use cases

## Migration from Old Scripts

### From `auto_git_pull.bat`
- Users can now just run `simple_git_pull.bat` and press Enter (or type 'y')
- Same 3-second default timing and no-fetch behavior

### From `configurable_git_pull.bat` 
- Users can run `simple_git_pull.bat` and type 'n' to get the full configuration options
- Same customization capabilities available

## Usage Examples

### Quick Run (Default Settings)
```
> simple_git_pull.bat
Use default settings? (y/n, default is y): [Enter]
Starting git pull process with settings:
- Wait time: 3 seconds
- Fetch before pull: n
- Custom command: n
```

### Custom Configuration
```
> simple_git_pull.bat
Use default settings? (y/n, default is y): n
Enter wait time between pulls (default is 3 seconds): 5
Do you want to fetch latest changes before pulling? (y/n): y
Do you want to run a custom command after pulling? (y/n): n
```

## Migration Path

### Simple Replacement
1. Replace calls to `auto_git_pull.bat` with `simple_git_pull.bat` (users just press Enter)
2. Replace calls to `configurable_git_pull.bat` with `simple_git_pull.bat` (users type 'n' for custom config)
3. Update `run.bat` to call the new simplified script
4. Remove the old separate scripts after testing

### Update run.bat
Instead of choosing between two different scripts, `run.bat` can simply call:
```batch
call scripts\simple_git_pull.bat
```

## Features Preserved
- All logging functionality
- Error detection and reporting
- Path validation
- Success/failure counting
- Fetch capability
- Custom command execution
- Timeout between operations
