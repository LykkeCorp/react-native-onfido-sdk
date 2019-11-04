//
//  RCTConvert+FlowConfiguration.m
//  RNOnfidoSdk
//
//  Created by Mihai Chifor on 13/12/2018.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "ONFlowConfigBuilder+FlowConfiguration.h"

@implementation ONFlowConfigBuilder (FlowConfiguration)

+ (NSError *)validateParams:(id)params {
    NSDictionary *dictionary = [RCTConvert NSDictionary:params];
    NSString *token = dictionary[@"token"];
    NSString *applicantId = dictionary[@"applicantId"];
    id documentTypes = dictionary[@"documentTypes"];
    
    NSString *message;
    if (!token) {
        message = @"No token specified";
    }
    
    if (!applicantId) {
        message = @"No applicantId specified";
    }
    
    if (documentTypes && ![documentTypes isKindOfClass:[NSArray class]]) {
        message = @"invalid documentTypes type";
    }
    
    if (message) {
        return [NSError errorWithDomain:@"invalid_params"
                                   code:100
                               userInfo:@{
                                          NSLocalizedDescriptionKey: message
                                          }];
    }
    
    return nil;
}
    
// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:1]; // bypass '#' character
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (void)create:(id)json successCallback:(successCallback)successCallback errorCallback: (errorCallback)errorCallback {
    NSError *paramsError = [self validateParams:json];
    if (paramsError) {
        return errorCallback(paramsError);
    }
    
    NSDictionary *dictionary = [RCTConvert NSDictionary:json];
    NSString *token = dictionary[@"token"];
    NSString *applicantId = dictionary[@"applicantId"];
    NSArray *documentTypes =dictionary[@"documentTypes"];
    NSString *primaryColor = dictionary[@"primaryColor"];
    NSString *locale = dictionary[@"locale"];

    ONFlowConfigBuilder *configBuilder = [ONFlowConfig builder];
    [configBuilder withToken:token];
    [configBuilder withApplicantId:applicantId];
    if (documentTypes && documentTypes.count && [documentTypes[0] integerValue] != 4) {
        [configBuilder withDocumentStepOfType:[documentTypes[0] integerValue] andCountryCode:@""];
    } else {
        [configBuilder withDocumentStep];
    }

    NSError * error;
    Builder * variantBuilder = [ONFaceStepVariantConfig builder];
    [variantBuilder withVideoCaptureWithConfig:
    [[VideoStepConfiguration alloc] initWithShowIntroVideo: YES]];
    [configBuilder withFaceStepOfVariant: [variantBuilder buildAndReturnError: &error]];
  
    if ([locale isEqualToString:@"de"]) {
      [configBuilder withCustomLocalizationWithTableName:@"onfido-de"];
    }

    if ([locale isEqualToString:@"fr"]) {
      [configBuilder withCustomLocalizationWithTableName:@"onfido-fr"];
    }

    if ([locale isEqualToString:@"it"]) {
      [configBuilder withCustomLocalizationWithTableName:@"onfido-it"];
    }
  
   if ([primaryColor length] > 0) {
     ONAppearance *appearance = [[ONAppearance alloc]
                                 initWithPrimaryColor: [self colorFromHexString: primaryColor] // background color of document type icon and capture confirmation buttons and back navigation button
                                 primaryTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] //  text color of labels included in views such as capture confirmation buttons.
                                 primaryBackgroundPressedColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] //capture confirmation buttons when pressed
                                 secondaryBackgroundPressedColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] //capture cancel buttons when pressed
                                 //fontRegular: @"PlayfairDisplay-Black"
                                 //fontBold: @"PlayfairDisplay-Black" //(NSString * _Nullable)fontBold
                                 supportDarkMode:false
                                 ];
     [configBuilder withAppearance:appearance];
   }
      
    NSError *configError = NULL;
    ONFlowConfig *config = [configBuilder buildAndReturnError:&configError];
    
    if (configError == NULL) {
        successCallback(config);
    } else {
        errorCallback(configError);
    }
}

@end
