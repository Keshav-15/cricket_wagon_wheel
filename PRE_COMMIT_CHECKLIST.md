# Pre-Commit Checklist for Beta 2 Release

## ✅ Files to EXCLUDE from commit:

1. **`example/pubspec.lock`** - Already in .gitignore, should NOT be committed
   ```bash
   git reset HEAD example/pubspec.lock
   ```

2. **`CODEBASE_CHECKPOINT.md`** - Development documentation, optional to commit
   - If you want to keep it for reference: commit it
   - If you want to keep it private: add to .gitignore or don't commit

3. **Build artifacts** (already in .gitignore):
   - `example/build/` - Should NOT be committed
   - `build/` - Should NOT be committed
   - `.dart_tool/` - Should NOT be committed

## ✅ Files that MUST be updated/committed:

1. **`CHANGELOG.md`** ✅ - Already updated with beta.2 changes
2. **`pubspec.yaml`** ✅ - Version is already 1.0.0-beta.2
3. **`README.md`** ✅ - Already updated with new features
4. **All source code files** ✅ - Ready to commit

## 📝 Optional files (your choice):

- `.fvmrc` - FVM version file (if team uses FVM, commit it)
- `.vscode/settings.json` - VS Code settings (if team uses, commit it)
- `CODEBASE_CHECKPOINT.md` - Development docs (optional)

## 🚀 Recommended commit command:

```bash
# Unstage files that shouldn't be committed
git reset HEAD example/pubspec.lock

# Review what will be committed
git status

# Commit all changes
git add .
git commit -m "chore: Release 1.0.0-beta.2

- Add bottom sheet for shot selection with animated shimmer borders
- Add WagonWheelShotOptionsProvider with pre-built shot options
- Replace List<String> labels with WagonWheelSectorLabel class
- Enhance onMarkerPositionChanged callback to include sector label
- Improve code documentation and extract magic numbers to constants
- Zero lint errors and improved code quality"
```

## ⚠️ Before pushing, verify:

- [ ] `example/pubspec.lock` is NOT staged
- [ ] `CHANGELOG.md` is updated
- [ ] `pubspec.yaml` version is 1.0.0-beta.2
- [ ] All tests pass (if any)
- [ ] `flutter analyze` shows no errors
- [ ] `flutter pub publish --dry-run` passes (if publishing)

