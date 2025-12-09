# Beta Testing Guide

## Publishing a Beta Version

You've published version `1.0.0-beta.1` which is a **pre-release** version. This allows you to:
- Test the package as an end user
- Get feedback before the official release
- Make fixes if needed before 1.0.0

## How Pre-Release Versions Work

### Version Format
- `1.0.0-beta.1` - Beta version (pre-release)
- `1.0.0-rc.1` - Release candidate (pre-release)
- `1.0.0-dev.1` - Development version (pre-release)
- `1.0.0` - Stable release (users get this by default)

### Important Notes
1. **Pre-release versions are NOT selected by default** - Users must explicitly request them
2. **Users won't automatically get beta versions** - They need to specify the version
3. **You can publish multiple beta versions** - e.g., `1.0.0-beta.1`, `1.0.0-beta.2`, etc.

## Testing Your Beta Version

### Step 1: Publish the Beta Version
```bash
flutter pub publish
```

### Step 2: Test as an End User

Create a test project and add your beta version:

```yaml
# In a test project's pubspec.yaml
dependencies:
  cricket_wagon_wheel: 1.0.0-beta.1  # Explicitly specify beta version
```

Then run:
```bash
flutter pub get
```

### Step 3: Test Everything
- ✅ Install the package
- ✅ Import and use the widgets
- ✅ Test all features
- ✅ Check documentation
- ✅ Verify assets load correctly
- ✅ Test on different platforms if possible

## Publishing the Official Release

Once you're satisfied with the beta:

### Step 1: Update Version
Change `pubspec.yaml`:
```yaml
version: 1.0.0  # Remove -beta.1 suffix
```

### Step 2: Update CHANGELOG.md
Add the official release entry:
```markdown
## 1.0.0

- Official stable release
- All features tested and verified
```

### Step 3: Publish
```bash
flutter pub publish
```

Now users can use:
```yaml
dependencies:
  cricket_wagon_wheel: ^1.0.0  # Gets the stable version automatically
```

## Version Progression Example

1. **First Beta**: `1.0.0-beta.1` → Test and fix issues
2. **Second Beta** (if needed): `1.0.0-beta.2` → Test fixes
3. **Release Candidate** (optional): `1.0.0-rc.1` → Final testing
4. **Official Release**: `1.0.0` → Stable version

## Benefits of Beta Testing

✅ Catch issues before official release  
✅ Test installation and usage as a real user  
✅ Verify documentation is clear  
✅ Ensure everything works across platforms  
✅ Build confidence before 1.0.0  

## After Publishing Beta

1. Wait a few minutes for pub.dev to process
2. Visit: `https://pub.dev/packages/cricket_wagon_wheel`
3. You'll see the beta version listed
4. Test it in a separate project
5. Make any necessary fixes
6. Publish the official 1.0.0 when ready

