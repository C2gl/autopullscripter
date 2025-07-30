# Enhanced Category System for AutoPullScripter

## Overview

The AutoPullScripter now supports an enhanced category system that allows you to:

- **Organize repositories by categories** (e.g., Jellyfin, Home Assistant, Development Tools)
- **Select specific categories to pull** during script execution
- **View progress and summaries per category** during the pull process
- **Maintain backward compatibility** with the existing repos.txt format

## New Features

### 1. Category-Based Repository Organization

Instead of a simple list, you can now organize repositories into logical categories:

```ini
[JELLYFIN_ECOSYSTEM]
C:\Path\To\jellyfin
C:\Path\To\jellyfin-web
C:\Path\To\jellyseerr

[HOME_ASSISTANT_CORE]
C:\Path\To\home-assistant\core
C:\Path\To\home-assistant\frontend

[DEVELOPMENT_TOOLS]
C:\Path\To\vscode
C:\Path\To\flutter
```

### 2. Category Selection at Runtime

When you run the enhanced script, you can choose:
- **All categories** - Process everything (default behavior)
- **Specific categories** - Only pull selected categories
- **Skip category mode** - Use the traditional repos.txt file

### 3. Enhanced Display During Pull

The script now shows:
- Current category being processed
- Progress within each category
- Category-specific summaries
- Color-coded status messages

## Files

### Core Files

- **`simple_git_pull_enhanced.bat`** - The enhanced script with category support
- **`repos_with_categories.txt`** - Your categorized repository list
- **`migrate_to_categories.bat`** - Migration tool to convert from old format

### Example Category File Structure

```ini
# Repository Categories Configuration
# Format: [CATEGORY_NAME] followed by repository paths
# Empty lines and lines starting with # are ignored

[PERSONAL_PROJECTS]
C:\Users\lieve\Documents\Github\personal_repos\autopullscripter
C:\Users\lieve\Documents\Github\personal_repos\tududi_HACS

[JELLYFIN_ECOSYSTEM]
C:\Users\lieve\Documents\GitHub\JELLY\jellyfin
C:\Users\lieve\Documents\GitHub\JELLY\jellyfin-web
C:\Users\lieve\Documents\GitHub\JELLY\streamyfin

[HOME_ASSISTANT_CORE]
C:\Users\lieve\Documents\Github\HOME_ASSISTANT\core
C:\Users\lieve\Documents\Github\HOME_ASSISTANT\frontend
```

## Usage Guide

### Getting Started

1. **Use the migration tool** (recommended):
   ```batch
   cd scripts
   migrate_to_categories.bat
   ```
   This will analyze your existing `repos.txt` and create a categorized version.

2. **Or manually create** `repos_with_categories.txt` in the root directory.

3. **Run the enhanced script**:
   ```batch
   cd scripts
   simple_git_pull_enhanced.bat
   ```

### Category Selection Options

When running the enhanced script, you'll see:

```
Enhanced category mode available!
Do you want to use category-based selection? (y/n, default is n): y

Available Categories:
==================================
- PERSONAL_PROJECTS
- JELLYFIN_ECOSYSTEM
- HOME_ASSISTANT_CORE
- ARR_STACK
- FINANCIAL_TOOLS
==================================

Category Selection Options:
1. Process ALL categories
2. Select specific categories
3. Skip category selection (use all repos)

Choose option (1-3, default is 1): 2

Enter category names separated by spaces.
Example: JELLYFIN_ECOSYSTEM HOME_ASSISTANT_CORE
Available categories:
  PERSONAL_PROJECTS
  JELLYFIN_ECOSYSTEM
  HOME_ASSISTANT_CORE
  ARR_STACK
  FINANCIAL_TOOLS

Enter categories: JELLYFIN_ECOSYSTEM HOME_ASSISTANT_CORE
```

### Sample Output

```
==== CATEGORY: JELLYFIN_ECOSYSTEM ====
[1/5] jellyfin
Progress: [####----------------] 20% complete
OK - ALREADY UP TO DATE

[2/5] jellyfin-web
Progress: [########------------] 40% complete
OK - PULLED NEW CHANGES

--- Category "JELLYFIN_ECOSYSTEM" Complete ---
Processed: 5 repositories
Successful: 5
Errors: 0
--------------------------------

==== CATEGORY: HOME_ASSISTANT_CORE ====
[6/8] core
Progress: [###############-----] 75% complete
OK - ALREADY UP TO DATE
```

## Migration from Old Format

### Automatic Migration

Use the included migration tool:

```batch
cd scripts
migrate_to_categories.bat
```

This tool will:
- Analyze your existing `repos.txt`
- Detect categories based on folder patterns
- Generate `repos_categorized_auto.txt`
- Suggest appropriate category names

### Manual Migration

1. Create `repos_with_categories.txt`
2. Add category headers in brackets: `[CATEGORY_NAME]`
3. List repository paths under each category
4. Use comments with `#` for documentation

## Category Naming Suggestions

Choose meaningful category names that reflect your workflow:

- **By Project/Service**: `JELLYFIN_ECOSYSTEM`, `HOME_ASSISTANT`, `ARR_STACK`
- **By Function**: `MEDIA_TOOLS`, `DEVELOPMENT_TOOLS`, `MONITORING`
- **By Priority**: `CRITICAL_SERVICES`, `DEVELOPMENT`, `EXPERIMENTAL`
- **By Update Frequency**: `DAILY_UPDATES`, `WEEKLY_UPDATES`, `MANUAL_ONLY`

## Benefits

### Workflow Efficiency
- Pull only the repositories you're currently working on
- Skip categories that don't need frequent updates
- Organize by project priorities

### Better Visibility
- See progress per category
- Identify which categories have the most issues
- Track updates by logical groupings

### Maintenance
- Easier to manage large repository lists
- Clear organization for team environments
- Better logging and troubleshooting

## Backward Compatibility

The enhanced script maintains full backward compatibility:

- If `repos_with_categories.txt` doesn't exist, it uses `repos.txt`
- You can choose to skip category mode and use the traditional format
- All existing command-line parameters still work
- Log format remains consistent

## Best Practices

1. **Start with migration tool** - Let it suggest initial categories
2. **Review and customize** - Adjust category names to match your workflow
3. **Keep categories focused** - Don't make them too broad or too narrow
4. **Use meaningful names** - Choose names that make sense to your team
5. **Document your categories** - Add comments explaining the purpose
6. **Regular maintenance** - Review and update categories as projects evolve

## Troubleshooting

### Common Issues

**Q: Category mode isn't available**
A: Ensure `repos_with_categories.txt` exists in the root directory (not in scripts folder)

**Q: No repositories found in selected categories**
A: Check category names for typos. Category matching is case-insensitive but must be exact.

**Q: Migration tool doesn't detect categories correctly**
A: Review and manually edit the generated file. The tool provides a starting point, not a perfect solution.

**Q: Want to go back to simple mode**
A: Choose option 3 during category selection, or delete/rename `repos_with_categories.txt`

### Log Files

Category information is logged in the same format as before, with additional category context:

```
2025-07-30 15:30:25 - Custom settings: Category mode: y
2025-07-30 15:30:26 - Processing repository: C:\Path\To\jellyfin
2025-07-30 15:30:27 - OK - ALREADY UP TO DATE | No changes for C:\Path\To\jellyfin
```

## Future Enhancements

Potential future improvements:
- Category-specific settings (different wait times, fetch options)
- Parallel processing within categories
- Category-based filtering in logs
- Integration with task scheduling
- Web-based category management interface
