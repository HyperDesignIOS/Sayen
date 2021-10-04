//
//  Messages.swift
//  classes
//
//  Created by Smaat2 on 7/5/18.
//  Copyright © 2018 Smaat2. All rights reserved.
//

import Foundation
import UIKit

typealias L0S  = GetAlertsLocalize
enum GetAlertsLocalize : String {
    case invalidNationalId
    case new
    case newArrival
    case bestSeller
    case all
    case state
    case applyPromoCode
    case userName
    case piece
    case pleaseSelectShippingAddress
    case user_Name
    case password
    case directionNotAva
    case sorry
    case  thisProductDoesntHaveUnits
    case addToWishList
    case removeFromWishList
    case nationalType
    case borderLineNumber
    case passportNumber
    case fullName
    case serviceDesc
    case oldPassword
    case confirmPassword
    case newPassword
    case errorMsgOldPassword
    case oldMessageNotTrue
    case pleaseEnterNewPassword
    case newMsgNotTrue
    case pleaseEnterConfirm
    case confirmPasswordNotTrue
    case EditProfile
    case editAddress
    case addAddress
    case Edit
    case passwordNotMatch
    case changePasswordSuccess
    case changePasswordNotSuccess
    case SAR
    case Sale
    case youDidnotAddAddress
    case pleaseAddAnotherShippingAddress
    case successLogin
    case enterValidData
    case networkRes
    case Categories
    case resetSuccess
    case reOrderedSuccess
    case changeLang
    case enterEmail
    case enterValidEmail
    case enterPhone
    case EnterPhone
    case phone
    case privacyPolicy
    case ourBranches
    case changeLang_
    case left_in_stock
    case errorUpdateProfile
    case successUpdatePhoto
    case errorCode
    case Profile
    case AddressDescription
    case street
     case ZipCode
    case ContactUs
    case terms
    case addedToYourWishList
    case removedFromYourWishList
case notes
    case WishList
    case logout_
    case aboutUs
    case successUpdateProfile
    case codeSendToPhone
    case fieldSendCodeToPhone
    case chooseTypeOfIdentity
    case pleaseChooseIdentityNumber
    case sendCodeOnPhone
    case invalidIdinty
    case couldnotValidIdentity
    case enterValidIdentity
    case enterValue
    case enterYourPhone
    case phoneVlaid
    case sendCodeOnEmail
    case email_empty
    case email_invalid
    case pw_empty
    case pw_invalid
    case emptyPhoneNum
    case invalidPhone
    case requiredPassword
    case success
    case activeAccount 
    case activeAccountMessage
    case emailSent
    case emailSentMessage
    case ok
    case failed
    case cancel
    case agree
    case logout
    case signout
    case you_canot_add_more_than
    case hotels
    case your_address
    case you_have_to_select_time_range
    case you_have_to_select_IndividualsCount
    case ok_
    case pleaseCheckYourEMail
    case closetToHarm
    case awayFromHarm
    case lessRating
    case offersFirst
    case favFirst
    case lessPriceFirst
    case recentAdded
    case noData
    case selection
    case howWasYourStay_
    case postive_required
    case negativeTxtF_required
    case postive_requiredMore15
    case negativeTxtF_requiredMore15
    case only_1_roomAva
    
    case one_am
    case two_am
    case three_am
    case four_am
    case five_am
    case six_am
    case seven_am
    
    case one_pm
    case two_pm
    case three_pm
    case four_pm
    case five_pm
    case six_pm
    case seven_pm
    case days
    case day
    case most_popular_hotels_first
    
    case _1_star
    case _2_star
    case _3_star
    case _4_star
    case _5_star
    
    case national_id
    case national_placed
    case national_pas
    case national_sar
    case numberOfLines
    case n
    case nn
    case myNumbers
    case offers
    case complaints
    case mkyas
    case searchProcess
    case otherServices
    case fllowUpVisitorAlert
    
    case reportsVisitorAlert
    case code_pin_empty
    case complaintMissingFIleDesc
    case at_date
    case at_hour
    case myNumbersDesc
    case offersDesc
    case mkyasDesc
    case searchService
    case otherService
    case phoneNum
    case phoneNumber
    case nationalityID
    case select_your_image_from_
    case photoGallery
    case camera
    case this_app_isnot_authorized_to_use_Camera
    case settings
    case no_Camera
    case files
    case file_msg_error
    case attachType_isRequired
    case hasOrganization
    case yes
    case no
    case organizationNum
    case complaintNumUnder
    case complaintEscalation
    case complaintBody
    case followComplaint
    case payment_main
    //Main Problems
    case lowServiceQuality_main
    case registerServiceNum_main
    case changeOrNotNum_main
    case cancelNum_main
    case notActiveServ_main
    case annoying_main
    case humanHarmingWaves_main
    case notSecretive_main
    //Sub Problems
    case missCalc_sub
    case notPaying_sub
    case notReturn_sub
    case dualPayment_sub
    case creaditAddingProb_sub
    case receiptProb_sub
    //
    case lowServ_sub
    case disconnection_sub
    case establishment_sub
    case addServWithoutOrd_sub
    case transferWithout_sub
    case disableTransfer_sub
    case smsProblems_sub
    case onHoldServNum_sub
    case notFunctionOnHoldServ_sub
    case servNotAction_sub
    case benefits_notAction_sub
    case servNotReceived_sub
    case annoying_sub
    case spam_sub
    case secretiveLess_sub
    case serNum
    case subCompType
    case servType
    case subscriptionType
    case or
    
    case ComplainerType
    case crNumber
    case crValidateDate
    case address
    case companyName
    case complainerStateType
    case complainer
    case mandateNum
    case mandateDate
    case agencyNum
    case agencyDate
    case agencyOrigin
    case under_mandate
    case under_agency
    case complaintNum
    case serviceProvider
    case pickFromPhoneNumList
    case nationalityType
    case receiptable
    case prePaid
    case landLine
    case mobile
    case InternetLandLine
    case InternetMobile
    case mainCompTypeRequired
    case serviceProviderIsRequired
    case error
    case isRequired
    case canotBeLessTHan
    case Words
    case word
    case field
    case from
    case to
    case exceptDay
    case invalidEmail
    case file
    case photos
    case pickFileType
    case idCheck
    case invalidId
    case enterId
    case enterValidId
    case enterExpDate
    case pickNationality
    case enterName
    case nameLessThan3Chr
    case addProfileImg
    case idChecked
    case invalidIdDetails
    case enterPassPortNum
    case enterValidPasspNum
    case addPhoto
    case idMore7Num
    case enterBirthDate
    case birthDate
    case expirDate
    case nationality
    case enterValidPhone
    case notverified
    case codeSentagain
    case emilIsEmpty
    case passNotValid
    case newPassNotValid
    case loginSuccess
    case notCompletData
    case enterRequiredData
    case email
    case email_
    case consPass
    case industName
    case modelName
    case manuf
    case invalidCode_askFornewPassCode
    case national1
    case national2

    case home
    case descAbout
    case indv
    case comp
    case Saudi
    case Egyption
    case Kwity
    case address_
    case addressTitle
    case billingTitle
    case setting_faceID
    case faceId_unauth
    case newOffer
    case newwwOffer
    case newUser
    case userNamee
    case login
    case loginRequired
    case loginWithFace
    case loginWithFaceDesc
    case loginwithFinger
    case loginWithFingerDesc
    case region
    case country
    case city
    case town
    case Search
    case locality
    case enterNumber
    case PersonComplainerInfo
    case Nationality
    case IDType
    case IDNumber
    case FirstName
    case SecondName
    case ThirdName
    case FourthName
    case IDExpiryDate
    case Birthdate
    case Address
    case EMail
    case Mobile
    case City
    case IsHaveProcuration
    case stockOutOFStock
    case addedItemToCart
    case Gender
    case Cart
    case removedItemFromCart
    case no3gServ
    case no4gServ
    case noInteriorsAreCovered
    case notActivatChip
    case lowInternetSpeed
    case serviceNotActive
    case DSLNotAvailable
    case noFiberServiceAvailable
    case definingProblem
    case youhaveToPickLocation
    case attachmentsType
    case pickFile
    case packagePeriod
    case approveForSaveFile
    case cartHasBeenUpdated
    case successSaveFile
    case xmlFormatError
    case cartIsEmpty
    case actionFileTypeHeading
    case actionFileTypeDescription
    case phoneLibrary
    case video
    case voice
    case stockNotAva
    case activeFingerd
    case activeNotNeedFingerd
    case fingerdNotActive
    case activeNotFingerd
    case notActiveNotFingerd
    
    case activeFingerdDesc
    case activeNotNeedFingerdDesc
    case fingerdNotActiveDesc
    case activeNotFingerdDesc
    case notActiveNotFingerdDesc

  
    case errorEscaleComplaint
    case successEscaleComplaint
    case commCom
    case successRate
    case rateService
    case needData
    case chooseDate
    case enter_compl_num
    case enter_serv_num
    case select_serv_provider
    case month
    case saveFingerSuccess
    case Unavailable
    case BusinessRegistrationSoon_
    case SkipRegistration
    case confirmEmail
    case confirmEmailRequired
    case emailNotMatched
    case error_finger_setting
    
    case notification_size
    case user_hint_limited
    case user_hint_visitor
    case alert
    case notFound
    case notFoundDevices
    case attachments_isRequired
    case phoneNotConnectedToNationalID
    case please_enterFullData
    case loading_thatMightTakeTime
    case loading_thatMightTakeTimeReg
    case cantAddComment
    case comment
    case commentRequired
    case saveComp
    case saveComp_
    case doneSaveComp
    case number
    case IdentityUnderVerification
    case yourLocation
    case visitorWantAddComp
    case error500 
    case InvoicesAndFinancial
    case UserRequest
    func message() -> String {
        return self.rawValue.localized
    }
}



extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
}