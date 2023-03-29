# VoltMoney iOS SDK - Example App.

This repo contains a sample iOS app, which consumes the Volt Money iOS SDK (published over .framework file). This code can be used as a reference code to integrate Volt Money SDK in your iOS Native app.

## Contents
* [Set up an environment](#set-up-an-environment)
* [Create an instance of VoltSDK](#create-voltsdk-instance)
* [Pre-create customer application](#precreate-application)
* [Init Volt Money Journey](#init-volt-money-journey)

## 1. Set up an environment 

* Download Latest Xcode and open this cloned repo as a new project.
* This sdk is published via CocoaPods file, follow below steps to get it in your project: 

Step 1. : Create pod init
          Open pod file

Step 2. Add the dependency for VOLT SDK. 
 Add pod 'VoltFramework', '1.0.3'
	  
```  
  target 'VoltDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for VoltDemo
  pod 'VoltFramework'

  target 'VoltDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'VoltDemoUITests' do
    # Pods for testing
  end

end
```

## 2. Create an instance of VoltSDK

The first and mandatory step to integrate volt sdk is to create an instance of VoltSDKContainer class. The constructor to the class takes in configuration parameters which would be used while rendering content, these are: 

1. **voltEnv (optional)**: Application's provide the facility of providing environment either Staging or Production. Default is Staging. 
2. **app_key (mandatory)**: Application's private key provided by the Volt Money team. If you don't have the key please contact the team at integration-support@voltmoney.in. 
3. **app_secret (mandatory)**: Application's private hash key provided by the Volt Money team. If you don't have the key please contact the team at integration-support@voltmoney.in. 
4. **partner_platform (mandatory)**: partner_platform, partner platform is the name/id provided to you by the Volt Money team to identify the SDK user. This is a mandatory field and will be passed as header in all API calls. If you don't have this 'id' please reach out to volt team @ integration-support@voltmoney.in.
5. **primary_color(optional)** : Primary color, hex code of the color to be used as primary color for Volt Money sdk. The UI will get automatically customized to use this color as primary color (ex. all CTA, Icons etc.) 
6. **secondary_color(optional)** : Secondary color, hex code of the color to be used as secondary color for Volt Money sdk. The UI will get automatically customized to use this color. ex. all svgs, progress bar etc.)
7. **ref (optional)**: Ref, is short for referral code, referral code can be specific to partner/platform based on the use-case. If provided the user signing up would be associated with the partner/platform. 

VoltSDKContainer instance can be created as follows: 

Environment: Two types of environment

public enum VOLTENV {
    case STAGING
    case PRODUCTION
}

  ```
  var voltSDKInstance: VoltSDKContainer?
  let voltInstance = VoltInstance(voltEnv: .STAGING,
  				app_key: appKey,
  				app_secret: appSecret,
				partner_platform: partnerPlatform,
				primary_color: primaryColor,
				secondary_color: secondaryColor,
				ref: ref)
  voltSDKInstance = Volt(voltInstance: voltInstance)
  
  ```
 
## 3. Pre-create customer application (Optional) 

Most of the applications which are consuming Volt Money SDK would already have customer details like mobile, phone, email and date of birth, which form the first 3 steps of the loan application process. We provide a way to simplify the user experience by pre-creating the application, this will skip the first 3 steps and will take the customers directly to the portfolio fetch steps. This is based on the  APIs provided by  Volt Money  to partners (documented here: https://volt-docs.readme.io/reference/createcreditapplicationusingpost). Hence the VOLTSDKContainer, provides a simple function which takes care of calling the API. 

***Please note:*** you only need to call this API once for a customer, in case of duplicate API call it will throw an exception saying application is already created.

The api takes in the 4 customer details : 

1. **PAN** : Customer's PAN number 
2. **Mobile Number** : Customer's mobile number. 
3. **email**: Customer's email address. 
4. **dob**: Customer's date of birth. 


```
// API to pre-create the application. 
VoltSDKContainer.preCreateApplication(dob: dob, email: email, panNumber: panNumber, mobileNumber: Int(mobileNumber)) { [weak self] response in
            if response?.customerAccountId != nil {
                self?.showAlert(message: "Application Created.")
            } else {
                self?.showAlert(message: response?.message ?? "")
            }
        }
	
``` 
customerAccountId: Indicate for success response
response.message:  Provide specific message for issues


## 4. Init Volt Money Journey. 

Initialize/Resume customer journey by calling this API. The same API will be called every time customer want to open up the volt journey/dashboard, which step or state customer will be shown will be decided by Volt Money backend services, which manage the customer state hence the client app would not have to do it. You can simply call this API everytime the customer visit's VOLT SDK entry point, this API will open up VOLT Money's customized UI based on the parameters passed during the setup of sdk instance.

The API takes one optional parameter as input : 

1. **Mobile Number** : Customer's mobile number. If passed it would autofill the mobile number in the mobile number text box on the login screen. 

## 5. Integrate Framework class in Navigation stack --
Navigation Header View will come only in Navigation stack in Push View Controller and it doesn't work in Present View Controller.

hideNavigationBar: It contains bool value for show/hide navigation bar.
```
let controller = VoltHomeViewController(mobileNumber: "", hideNavigationBar: false)
self.navigationController?.pushViewController(controller, animated: false)
 
```
 

