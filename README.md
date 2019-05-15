# react-native-onfido-sdk

iOS and Android wrapper for [onfido-ios-sdk](https://github.com/onfido/onfido-ios-sdk) and [onfido-android-sdk](https://github.com/onfido/onfido-android-sdk).

## Installation

Install the npm package

```bash
  npm install react-native-onfido-sdk
```

or

```bash
  yarn add react-native-onfido-sdk
```

### iOS Setup

If you're already using Cocoapods, add the following to your Podfile

```
pod 'react-native-onfido-sdk', path: '../node_modules/react-native-onfido-sdk'
```

Otherwise, setup Podfile according to [react native documentation](https://facebook.github.io/react-native/docs/integration-with-existing-apps), so the Podfile will look like this:

```
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'

target 'YourTargetName' do
    pod 'React', :path => '../node_modules/react-native', :subspecs => [
        'Core',
        'CxxBridge', # Include this for RN >= 0.47
        'DevSupport', # Include this to enable In-App Devmenu if RN >= 0.43
        'RCTText',
        'RCTNetwork',
        'RCTWebSocket', # Needed for debugging
        'RCTAnimation', # Needed for FlatList and animations running on native UI thread
        ]
    # Explicitly include Yoga if you are using RN >= 0.42.0
    pod 'yoga', :path => '../node_modules/react-native/ReactCommon/yoga'
    pod 'DoubleConversion', :podspec => '../node_modules/react-native/third-party-podspecs/DoubleConversion.podspec'
    pod 'glog', :podspec => '../node_modules/react-native/third-party-podspecs/glog.podspec'
    pod 'Folly', :podspec => '../node_modules/react-native/third-party-podspecs/Folly.podspec'

    pod 'react-native-onfido-sdk', path: '../node_modules/react-native-onfido-sdk'

end
```

Remember to replace _YourTargetName_ with your actual target name.

Next, run `pod install`.

Because Onfido sdk is written in Swift, we also need to go to _YourTargetName -> Build Settings_ and search for **Always Embed Swift Standard Libraries** and set it to **YES**.

### Android Setup

1. Link the library by running

```bash
react-native link
```

2. Add

```
maven {
        url  "https://dl.bintray.com/onfido/maven"
}
```

into

```
allprojects {
    repositories {
        ...
        maven {
                url  "https://dl.bintray.com/onfido/maven"
        }
    }
}
```

in _android/build.gradle_

3. Enable multidex by adding `multiDexEnabled true` in _app/build.gradle_:

```
android {
    ...
    defaultConfig {
        ...
        multiDexEnabled true
    }
}
```

## Usage

First, import the module:

```javascript
import RNOnfidoSdk from "react-native-onfido-sdk"
```

Then, launch the sdk by using the following method:

`RNOnfidoSdk.startSDK(params, successCallback, errorCallback);`, where:

**params**

- token (string, onfido mobile sdk token) **required**
- applicantId (string, applicant id that needs to come from your backend implementation after an applicant has been created) **required**
- documentTypes (array)

By default, `onfido-ios-sdk` and `onfido-android-sdk` can only be used either with all document types, or with a single document type.
We've added the possibility to specify exactly which document type checks your app might use.
If _documentTypes_ is `undefined`, the sdk will launch with default document types (Passport, Driver's licence, National Id, Residence permit).
The following document types are defined to be used:

- RNOnfidoSdk.DocumentTypePassport
- RNOnfidoSdk.DocumentTypeDrivingLicence
- RNOnfidoSdk.DocumentTypeNationalIdentityCard
- RNOnfidoSdk.DocumentTypeResidencePermit

Example:

```js
const params = {
  token: "test...",
  applicantId: "test",
  documentTypes: [
    RNOnfidoSdk.DocumentTypePassport,
    RNOnfidoSdk.DocumentTypeNationalIdentityCard
  ]
}
```

In this example we opt in only for passport and national id card checks.

**successCallback**

Example:

```js
const successCallback = () => {
  ...
}
```

**errorCallback**

Example:

```js
const errorCallback = (error) => {
  ...
}
```

## Example

To see more of `react-native-onfido-sdk` in action you can check out the source in the `example` folder.

```bash
cd example
npm install
```

### iOS

```bash
cd ios
pod install
cd ..
react-native run-ios
```

### Android

```bash
react-native run-android
```

##PUBLISH on feedz

Before uploading, searching or installing packages on each machine, you will need to authenticate using a personal access token, as explained thoroughly in this [guide](https://feedz.io/docs/package-types/npm)

To publish a new package:

updade package version in package.json

create the package with npm pack --> react-native-onfido-sdk-0.0.x.tgz

publish the package on Lykke private register npm publish react-native-onfido-sdk-0.0.x.tgz --scope lykkecorp

In alternative to steps 2 & 3 just run sh buildPackage.sh from terminal

## License

`react-native-onfido-sdk` is available under the MIT license. See the LICENCE file for more info.
