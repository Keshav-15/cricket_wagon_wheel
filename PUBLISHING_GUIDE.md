# Publishing to pub.dev - Step by Step Guide

## ✅ Pre-Publishing Checklist

### 1. Update Repository URLs
Before publishing, update the `homepage` and `repository` fields in `pubspec.yaml` with your actual GitHub repository URL:

```yaml
homepage: https://github.com/YOUR_USERNAME/cricket_wagon_wheel
repository: https://github.com/YOUR_USERNAME/cricket_wagon_wheel
```

Replace `YOUR_USERNAME` with your actual GitHub username.

### 2. Verify Package Name Availability
Check if the package name `cricket_wagon_wheel` is available on pub.dev:
- Visit: https://pub.dev/packages/cricket_wagon_wheel
- If it's taken, you'll need to rename your package in `pubspec.yaml`

### 3. Create a pub.dev Account
1. Go to https://pub.dev
2. Sign in with your Google account
3. Complete your profile

### 4. Verify Your Package
Run these commands to ensure everything is ready:

```bash
# Check for issues
flutter analyze

# Dry-run publish (already done - passed with 0 warnings!)
flutter pub publish --dry-run
```

## 📦 Publishing Steps

### Step 1: Prepare Your Repository
1. Push your code to GitHub (if not already done)
2. Ensure all files are committed
3. Make sure `.gitignore` excludes:
   - `pubspec.lock` (should be excluded for packages)
   - Build artifacts
   - IDE files

### Step 2: Final Verification
```bash
# Navigate to package root
cd /Users/keshavgupta/Documents/Practice/wagon_wheel

# Run dry-run one more time
flutter pub publish --dry-run
```

### Step 3: Publish to pub.dev
```bash
# This will prompt for your pub.dev credentials
flutter pub publish
```

You'll be asked to:
1. Sign in to pub.dev (if not already signed in)
2. Confirm the package details
3. Review the files being published

### Step 4: Post-Publishing
After successful publishing:
1. Your package will be available at: `https://pub.dev/packages/cricket_wagon_wheel`
2. It may take a few minutes to appear in search results
3. You can add screenshots, badges, and additional documentation on the pub.dev page

## 🔧 What Was Fixed

✅ **Fixed missing asset error**: Created `example/assets/icons/batsman.svg` and added it to `example/pubspec.yaml`
✅ **Added LICENSE file**: Created MIT License file (required for pub.dev)
✅ **Updated pubspec.yaml**: Added `repository` field (recommended for pub.dev)
✅ **Verified package**: Dry-run passed with 0 warnings

## 📝 Important Notes

1. **Version Numbers**: After publishing, you can't republish the same version. To update:
   - Increment version in `pubspec.yaml` (e.g., `1.0.0` → `1.0.1`)
   - Update `CHANGELOG.md` with changes
   - Run `flutter pub publish` again

2. **Package Name**: Once published, the package name is permanent and cannot be changed.

3. **Repository URL**: Make sure your GitHub repository is public (or the package won't be discoverable).

4. **Documentation**: Your README.md will be displayed on pub.dev, so make sure it's comprehensive.

## 🚀 Quick Publish Command

Once you've updated the repository URLs in `pubspec.yaml`:

```bash
cd /Users/keshavgupta/Documents/Practice/wagon_wheel
flutter pub publish
```

## 📚 Additional Resources

- [pub.dev Publishing Guide](https://dart.dev/tools/pub/publishing)
- [Package Layout Conventions](https://dart.dev/tools/pub/package-layout)
- [pub.dev Package Policy](https://pub.dev/policy)

