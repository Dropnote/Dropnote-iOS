fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Runs all the tests
### ios beta
```
fastlane ios beta
```
Submit a new Beta Build to Apple TestFlight

- Ensure git clean status

- Increment build number

- Build

- Send to iTunesConnect skipping submission & skipping waiting for build to process

- Cleant build artifacts

- Commit version bump

- Add git tab b{build_number}

- Push to git remote
### ios commit_build_tag
```
fastlane ios commit_build_tag
```

### ios deploy
```
fastlane ios deploy
```
Deploy a new version to the App Store

- Ensure git clean status

- Match AppStore profile

- Build

- Send to iTunesConnect

- Clean build artifacts
### ios add_version_tag
```
fastlane ios add_version_tag
```
Adds git tag for current version
### ios screenshots
```
fastlane ios screenshots
```
Creates new screenshots
### ios screens
```
fastlane ios screens
```
Creates new screenshots and uploads them to iTunes Connect
### ios increment_version_patch
```
fastlane ios increment_version_patch
```
Increments patch
### ios increment_version_minor
```
fastlane ios increment_version_minor
```
Increments minor
### ios increment_version_major
```
fastlane ios increment_version_major
```
Increments major

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane/tree/master/fastlane).