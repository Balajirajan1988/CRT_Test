#
# Test asset originally created using Copado QEditor.
#

*** Settings ***
Documentation          Example resource file with custom keywords. NOTE: Some keywords below may need
...                    minor changes to work in different instances.
Library                QWeb
Library                QForce
Library                QVision
Library                String 
Suite Setup            Open Browser    about:blank    chrome
Suite Teardown         CloseAllBrowsers
Test Teardown          CloseAllBrowsers
Resource               ../resources/common.robot
Library                RetryFailed     global_retries=1  keep_retried_tests=False   log_level=None

*** Keywords ***
Setup Browser
    # Setting search order is not really needed here, but given as an example 
    # if you need to use multiple libraries containing keywords with duplicate names
    Set Library Search Order                          QForce    QWeb
    Open Browser          about:blank                 ${BROWSER}
    SetConfig             LineBreak                   ${EMPTY}               #\ue000
    Evaluate              random.seed()               random                 # initialize random generator
    SetConfig             DefaultTimeout              45s                    #sometimes salesforce is slow
    # adds a delay of 0.3 between keywords. This is helpful in cloud with limited resources.
    SetConfig             Delay                       0.3
End suite
    Close All Browsers
Login
    [Documentation]       Login to Salesforce instance
    GoTo                  ${login_url}
    TypeText              Username                    ${username}             delay=1
    TypeText              Password                    ${password}
    ClickText             Log In
    # We'll check if variable ${secret} is given. If yes, fill the MFA dialog.
    # If not, MFA is not expected.
    # ${secret} is ${None} unless specifically given.
    ${MFA_needed}=       Run Keyword And Return Status          Should Not Be Equal    ${None}       ${secret}
    Run Keyword If       ${MFA_needed}               Fill MFA
Fill MFA
    ${mfa_code}=         GetOTP    ${username}   ${secret}   ${login_url}    
    TypeSecret           Verification Code       ${mfa_code}      
    ClickText            Verify 
Home
    [Documentation]       Navigate to homepage, login if needed
    GoTo                  ${home_url}
    ${login_status} =     IsText                      To access this page, you have to log in to Salesforce.    2
    Run Keyword If        ${login_status}             Login
    ClickText             Home
    VerifyTitle           Home | Salesforce
# Example of custom keyword with robot fw syntax
VerifyStage
    [Documentation]       Verifies that stage given in ${text} is at ${selected} state; either selected (true) or not selected (false)
    [Arguments]           ${text}                     ${selected}=true
    VerifyElement        //a[@title\="${text}" and (@aria-checked\="${selected}" or @aria-selected\="${selected}")]
NoData
    VerifyNoText          ${data}                     timeout=3                        delay=2
DeleteAccounts
    [Documentation]       RunBlock to remove all data until it doesn't exist anymore
    ClickText             ${data}
    ClickText             Delete
    VerifyText            Are you sure you want to delete this account?
    ClickText             Delete                      2
    VerifyText            Undo
    VerifyNoText          Undo
    ClickText             Accounts                    partial_match=False
DeleteLeads
    [Documentation]       RunBlock to remove all data until it doesn't exist anymore
    ClickText             ${data}
    ClickText             Delete
    VerifyText            Are you sure you want to delete this lead?
    ClickText             Delete                      2
    VerifyText            Undo
    VerifyNoText          Undo
    ClickText             Leads                    partial_match=False
ACC_Login
    [Documentation]    Block created using the QEditor
    GoTo              ${Goto}
    TypeText          Username          ${UserName}
    TypeSecret        Password          ${Password}
    ClickText         Log In to Sandbox
    Sleep             5
    SwitchWindow      1
    ClickText         App Launcher
    LaunchApp         Customer Central 
    ClickText         Show Navigation Menu    delay=5
    ClickText         Home
ACC_CSR_Login
    [Documentation]    Block created using the QEditor
    GoTo              ${Goto}
    TypeText          Username          ${UserName}
    TypeSecret        Password          ${Password}
    ClickText         Log In to Sandbox
    Sleep             5
    SwitchWindow      1
ACC_Case_Login
    [Documentation]    Block created using the QEditor
    GoTo              ${Goto}
    TypeText          Username          ${Case_Login}
    TypeSecret        Password          ${Case_pwd}
    ClickText         Log In to Sandbox
    Sleep             5
    SwitchWindow      1
ACC_AIA_Login
    [Documentation]    Block created using the QEditor
    GoTo              ${Goto}
    TypeText          Username          ${AIA_Login}
    TypeSecret        Password          ${AIA_pwd}
    ClickText         Log In to Sandbox
    Sleep             5
    SwitchWindow      1
ACC_BB_Login
    [Documentation]    Block created using the QEditor
    GoTo              ${Goto}
    TypeText          Username          ${BB_Fibre_Login}
    TypeSecret        Password          ${BB_Fibre_pwd}
    ClickText         Log In to Sandbox
    Sleep             5
    SwitchWindow      1
ACC_BBTechAgent_Login
    [Documentation]    Block created using the QEditor
    GoTo              ${Goto}
    TypeText          Username          ${BBTechAgent_Login}
    TypeSecret        Password          ${BBTechAgent_pwd}
    ClickText         Log In to Sandbox
    Sleep             5
    SwitchWindow      1
ACC_KMAuthor_Login
    [Documentation]    Block created using the QEditor
    GoTo              ${Goto}
    TypeText          Username          ${KM_username}
    TypeSecret        Password          ${KM_pwd}
    ClickText         Log In to Sandbox
    Sleep             5
    SwitchWindow      1
Search_Customer_Offline
    [Documentation]    Block created using the QEditor
    PickList           *Interaction Type     Offline
    ClickText    Search Customer             timeout=100
    TypeText     7–15 digit numeric account number    553439864106    delay=15
    ClickText    Search    anchor=Account Type    timeout=100
    ClickText    Bypass    Delay=10
Search_Customer_Outbound
    [Documentation]    Block created using the QEditor
    PickList           *Interaction Type     Outbound
    ClickText    Search Customer             timeout=100
    TypeText     7–15 digit numeric account number   337084444368    delay=15
    ClickText    Search    anchor=Account Type    timeout=100
    ClickText    Bypass    Delay=10
Handle_Component_Error
    [Documentation]    Block created using the QEditor
    UseModal      On
    ${componenterror}=      IsText               A Component Error has occurred!       delay=5
    IF                       ${componenterror} == True  
    ClickText    Close this window    anchor=A Component Error has occurred!
    ClickText    Close this window    anchor=A Component Error has occurred!
    END
    UseModal     Off
New_Lead_UI
    [Documentation]    Block created using the QEditor
    UseModal     On
    VerifyText    Customer Consent
    VerifyText    English
    TypeText     First Name       Chris
    TypeText     Last Name        Evans
    TypeText     Mobile Phone     (456)-789-1112
    ClickText    Accept           anchor=Cancel
    UseModal     Off

    #TypeText     Email    sg5443@att.com
    #VerifyText    Language Preference
    
    VerifyText    Reason to Follow Up
    VerifyText    Sales Opportunity
    VerifyText    Service Follow-Up
    ClickText     Sales Opportunity
    VerifyText    Account
    VerifyText    Consult Someone Else
    VerifyText    Product (Out of Stock)
    VerifyText    Price
    VerifyText    Time
    ClickText     Service Follow-Up
    VerifyText    Service Follow-Up    anchor=2
    VerifyText    Post-Sale Check-In
    VerifyText    Technical Support
    VerifyText    Time
    ClickText     Technical Support
    VerifyText    Customer Type
    VerifyText    New Customer
    VerifyText    Existing Customer
    ClickText     New Customer
    VerifyText    Follow Up Opportunity
    VerifyText    Wireless
    VerifyText    Internet
    VerifyText    Video
    ClickText     Wireless
    VerifyText    Wireless Follow-Up Opportunity
    VerifyText    Prepaid
    VerifyText    Postpaid
    VerifyText    FirstNet
    ClickText     Wireless
    ClickText     Video
    VerifyText    Video Follow-Up Opportunity
    VerifyText    DTV via Sat
    VerifyText    DTV via Internet
    ClickText     Video
    ClickText     Internet
    VerifyText    Internet Follow-Up Opportunity
    VerifyText    AT&T Broadband
    VerifyText    AT&T Fiber
    VerifyText    AT&T Internet Air
    ClickText     AT&T Fiber
    VerifyText    Preferred Method of Contact
    VerifyText    Call
    VerifyText    SMS
    VerifyText    Email
    VerifyText    In Person
    ClickText     SMS
    ClickText     In Person
    VerifyText    Contact By
    ClickText    Contact By    anchor=2
    UseTable    Sun
    # ClickText    Next Month
    ClickCell    r5c3
    ClickText    Save                  anchor=Cancel
Old_Lead_UI
    ClickText    New Customer    anchor=Search Customer    timeout=20
    VerifyText    Customer Type
    VerifyText    Consumer
    ClickText    Continue
    TypeText     First Name       Dorothy
    TypeText     Last Name        Murphy
    TypeText     Mobile Phone     (456)-789-1115
    TypeText     Email Address    sg5443@att.com
    VerifyText    Language Preference
    VerifyText    English
    VerifyText    Customer Consent:
    ClickText    Accept and Continue
    VerifyText    Reasons for Visit
    ClickText     Service Support
    VerifyText    Due Date
    ClickText    Contact By    anchor=Approved
    UseTable    Sun
    # ClickText    Next Month
    ClickCell    r6c1
    ClickText    Call          anchor=2
    ClickText    Email         anchor=SMS
    ClickText    Submit                  anchor=2
    Handle_Page doesnt exist_Error
    #VerifyText                        Your lead has been successfully created.    timeout=15
    ClickText                        Close this window
    ClickText                        Show Navigation Menu                        anchor=Leads    timeout=40
    ClickText                        Leads                        timeout=30
    #ClickText    Select a List View: Leads
    ClickText    Recently Viewed                        timeout=20
    ClickText    Refresh
    UseTable                        Item Number
    ClickCell    r?Dorothy Murphy/c3Name                       index=3
    ClickCell     r?Dorothy Murphy/c3Name                       tag=a
    ClickText    Captured    anchor=LeadSonam Marketing Lead 2
Handle_Page doesnt exist_Error
    [Documentation]    Block created using the QEditor
    UseModal      On
    ${componenterror}=      IsText               Page doesn't exist       delay=5
    IF                       ${componenterror} == True  
    ClickText    Close this window    anchor=A Component Error has occurred!
    ClickText    Close this window    anchor=A Component Error has occurred!
    END
    UseModal     Off
Retry_Search
    [Documentation]    Block created using the QEditor
    ${search_error}=   IsText               An unexpected error occurred. Try your search again.    partial_match=True    timeout=20
    IF                 ${search_error} == True
    ClickText          Search    partial_match=False    timeout=30
    END

*** Test Cases ***
# TC_01 Sales - Buy flow - AIA with extender
#     [Documentation]    Test Case created using the QEditor
#     [Tags]             Buyflow
#     OpenBrowser        about:blank    chrome
#     DeleteAllCookies
#     ACC_CSR_Login
#     Handle_Component_Error
#     LaunchApp          Customer Central
#     ClickText          Show Navigation Menu
#     ClickText          Home
#     PickList           *Interaction Type    Offline    timeout=60  
#     ClickText          Search Customer         timeout=40 
#     ${othertabs}=      IsText                  Show more actions    anchor=Device Issues    timeout=60
#     IF                 ${othertabs} == True
#     ClickText          Show more actions       delay=25
#     ClickText          New Customer                        timeout=120  
#     ELSE
#     ClickText          New Customer                        delay=25
#     END                     
#     TypeText           Enter address                       2537 W OAKRIDGE DR ALBANY, GA, 31721    timeout=120
#     #ClickText    2537 W OAKRIDGE DR, ALBANY, GA, 31721    partial_match=True    timeout=25                    
#     ClickText          Continue                        delay=20
#     ${Product_Msg} =   QWeb.IsText            I want to continue to shop for new service    anchor=New Service    delay=25
#     IF                 ${Product_Msg} == True
#      ClickText      Select    anchor=I want to continue to shop for new service             delay=10
#      ClickText      Continue          anchor=Cancel                        timeout=120
#      ClickText      Select    anchor=${Product_Air}                        timeout=120
#      ClickText      Continue                        timeout=80
#     ELSE
#      ClickText      Select    anchor=${Product_Air}                        timeout=120
#      ClickText      Continue                        timeout=120
#     END 
#     ClickText          Select    anchor=${Product_Air}                        timeout=80
#     ClickText          Continue                        timeout=80
#     ClickText          increment
#     ClickText          Continue                        anchor=Back            delay=5
#     VerifyText         Checkout                        anchor=Back            timeout=120 
#     ClickText          Checkout                        anchor=Back            timeout=120
#     ${Checkoutbuttonpresent}              IsText                        Checkout                        anchor=Back    delay=5
#     IF                 ${Checkoutbuttonpresent} == True
#      ClickText          Checkout          anchor=Back            delay=5
#     END                                                            
#     TypeText           Enter customer's first name   ${FirstName}     delay=5
#     TypeText           Enter customer's last name    ${LastName}
#     TypeText           Email Address                 rj147y@att.com 
#     ${rand_phone}=     Generate Random String      length=4    chars=[NUMBERS]
#     ${phone}=          SetVariable                 214205${rand_phone}
#     TypeText           Enter customer's mobile number    ${phone}          
#     #TypeText          Mobile Number                 9724154130  
#     ClickText          Continue          parent=LIGHTNING-BUTTON
#     ${Emailaddressenabled}              GetAttribute                        xpath\=//*[@title\="Email address"]    disabled
#     IF                 ${Emailaddressenabled} == False 
#      ClickText          xpath\=//*[@title\="Email address"] 
#      ClickText          Verify PIN        delay=10
#      VerifyText         Verified
#      ClickText          Continue          timeout=120
#      ClickCheckbox      OnOff    on
#      ClickText          Continue          anchor=Back              timeout=120
#     ELSE
#      #ClickText         Continue
#      ClickText          Continue          anchor=Back              timeout=180
#     END
#     TypeText           MM/DD/YYYY        01-01-1990               timeout=100
#     TypeText           Enter full SSN                 666885845                 
#     TypeText           Confirm Social Security Number                 666885845
#     ClickText          Check Credit                        delay=40                     
#     #ClickText         Continue                        delay=15
#     #ClickText         Continue                        anchor=Back              delay=10
#     #ClickText         Continue                        anchor=Edit Billing Address                  delay=10    
#     #ScrollTo          Do you understand and agree to the terms as I have explained them?        delay=15
#     #ClickCheckbox     Do you understand and agree to the terms as I have explained them?    on     delay=10
#     ScrollTo           Check here to acknowledge that the above has been read to the customer & the customer agrees.    delay=45
#     ClickCheckbox      Check here to acknowledge that the above has been read to the customer & the customer agrees.    on    anchor=Read to the Customer:
#     ClickText          Check Credit                        timeout=60                        
#     ClickText          Continue                        timeout=120
#     ClickText          Continue                        anchor=Back              delay=10
#     ClickText          Continue                        anchor=Edit Billing Address                  delay=10 
#     ClickText          Edit Billing Address   timeout=30
#     TypeText           123 Main St, Winter Park, FL, 90123    29 ARAPAHO VILLAGE CTR, RICHARDSON, TX, 75080
#     #ClickText         29 ARAPAHO VILLAGE CTR, RICHARDSON, TX, 75080
#     #ClickText         Continue                        timeout=120
#     ScrollTo           Do you understand and agree to the terms as I have explained them?        delay=15
#     ClickCheckbox      Do you understand and agree to the terms as I have explained them?    on    delay=10
#     ClickText          Continue                        delay=15
#     ClickText          Debit/Credit Card                        timeout=20
#     ClickText          Add New Debit/Credit Card                        timeout=20
#     TypeSecret         Card Number    5555555555554444   timeout=20 sec
#     TypeText           MM/YY    02/26                    timeout=20 sec
#     TypeSecret         3 or 4 digits    837               timeout=20 sec
#     TypeText           Cardholder Name    TestCreditc                        timeout=20
#     TypeText           Billing Zip Code    53151                        timeout=20                        
#     ClickText          Continue                        delay=30
#     ScrollTo           Do you understand and agree to the terms as I have explained them?        delay=15
#     ClickText          Do you understand and agree to the terms as I have explained them?    on    delay=10
#     ClickText          Continue                        delay=20
#     #ClickCheckbox    Check here to acknowledge that the above has been read to the customer & the customer agrees.    on
#     #ClickText         Continue                        delay=20
#     #ClickText         Send                        anchor=Continue                        timeout=60
#     #ClickText         Refresh                     delay=30                        
#     #ClickText         Continue                        anchor=Back              delay=10
#     #ClickText        Submit Order                    timeout=20
#     CloseAllBrowsers
# TC_02 Sales - Buy flow - Broadband Fiber - Autopay Enrolled Paperless Enrolled
#     [Documentation]    This test case is to verify Buy flow for Broadband Fiber with Auto pay enrolled and Paperless Enrolled
#     [Tags]             Buyflow    Broadband    Fiber
#     OpenBrowser    about:blank    chrome
#     DeleteAllCookies
#     ACC_CSR_Login
#     Handle_Component_Error
#     LaunchApp      Customer Central
#     ClickText      Show Navigation Menu
#     ClickText      Home
#     PickList           *Interaction Type     Offline
#     ClickText         Search Customer
#     ClickText         New Customer
#     #TypeText          Enter address     ${CustAddress_Fiber}
#     TypeText          Enter address          12611 HALLUM ST    timeout=120
#     #ClickText         ${CustAddress_Fiber}    ${CustAddress_Fiber}    Partial_match=True    timeout=15
#     ClickText         12611 HALLUM ST    partial_match=True    timeout=100
#     ClickText         Continue          delay=5
   
#     #------------ Below IF condition added to handle if modal popup asking to continue for new service message is displayed------
#     UseModal    On
#     ${Product_Msg} =    IsText            I want to continue to shop for new service     timeout=150
#     IF                    "${Product_Msg}" == "True"
#     ClickText    Select    anchor=I want to continue to shop for new service             delay=5
#     ClickText    Continue  anchor=Cancel                        delay=3
#     END
#     UseModal    Off
#     #----------------------------------------------------------------------------------------------------------------------------

#     ClickText         Select           anchor=Installation fee waived                        timeout=50
#     ClickText         Continue
    
#     #------------ Below IF condition added to handle if Information modal popup is displayed and No button to be clicked --------
#     UseModal          On
#     ${nobutton}=      IsText         Do any of the following apply to the customer?                        anchor=Information                        timeout=30
#     IF                "${nobutton}" == "True"
#     ClickText         No               anchor=Information
#     END
#     UseModal          Off
#     #----------------------------------------------------------------------------------------------------------------------------
    
#     ClickText         Continue          timeout=50

#     #----- Below IF condition added to handle if Continue button is still displayed and needs to be clicked ------
#     ${Continuepresent}                  IsText                        Continue                        timeout=50
#     IF                        ${Continuepresent}== True
#     ClickText                 Continue
#     END
#     #------------------------------------------------------------------------------------------------------------- 

#     #----- Below IF condition added to handle delay in displaying Cart Review details----------
#     ${Due1stBill}              IsText                    Due on 1st Bill                        anchor= Cart Review                        timeout=100
#     IF                       ${Due1stBill}==False
#     ClickText         Checkout
#     END
#     #------------------------------------------------------------------------------------------
    
#     ClickText         Checkout          anchor=Back                        delay=5
#     TypeText          Enter customer's first name   Test                        timeout=20
#     ${random_lname}=  Generate Random String        5  [LOWER]
#     TypeText          Enter customer's last name    BB${random_lname}
#     TypeText          Email Address                 bn7539@att.com
#     TypeText          Mobile Number                 4243767094  
#     ClickText         Continue          parent=LIGHTNING-BUTTON
#     ClickText         Email address     anchor=2       timeout=30
#     VerifyText        Verify PIN        timeout=20

#     TypeText          Enter email verification PIN     943539                   timeout=20
#     VerifyText        Verified                        partial_match=True        timeout=20
#     ClickText         Verify PIN        timeout=20
    
#     ClickText    Continue    anchor=2                        timeout=20
#     TypeText     MM/DD/YYYY                     12/20/1990                timeout=100
#     TypeText     Enter full SSN                 345678901                 
#     TypeText     Confirm Social Security Number                 345678901
#     ClickText     Check Credit                        timeout=20
#     ClickText    Continue                        timeout=30
#     VerifyText   Choose a Date and Time Window for the Technician Install                timeout=100                        
#     ScrollTo   Click here to acknowledge the above has been read to the customer.
#     ClickCheckbox    Click here to acknowledge the above has been read to the customer.    On     timeout=100
#     ClickCheckbox    Click here to acknowledge the above has been read to the customer.    Off
#     ClickCheckbox    Click here to acknowledge the above has been read to the customer.    On     delay=5
#     ClickText    Continue                        timeout=30
#     ClickText    Continue
#     ClickText    Continue
#     ClickText    Continue    anchor=Edit Billing Address                        timeout=100
#     VerifyText               The billing address was successfully validated and saved      timeout=100

#     #---- Auto Pay Enrollment verification ----
#     VerifyText               Enroll in AutoPay                        anchor=Payment Terms        timeout=50
#     VerifyCheckboxValue      Enroll in AutoPay                        On
#     ScrollTo     Do you understand and agree to the terms as I have explained them?
#     ClickCheckbox            Do you understand and agree to the terms as I have explained them?        On                    delay=5
#     ClickText    Continue                        delay=5
#     #------------------

#     ClickText    Debit/Credit Card                        timeout=20
    
#     #------------ Below IF condition added to handle difference in UAT -----------------------
#     ${AddDebitCreditCard}=      IsText                        Add New Debit/Credit Card       delay=5
#     IF                       "${AddDebitCreditCard}" == "True"   
#     ClickText    Add New Debit/Credit Card
#     END
#     #------------------------------------------------------------------------------------------
     
#     TypeText    Cardholder Name    TestCredit                        timeout=20
#     TypeText    Billing Zip Code    53151                        timeout=20                        
#     TypeSecret    Card Number    4111111111111111   timeout=20 sec
#     TypeText    MM/YY    12/25                    timeout=20 sec
#     TypeSecret    3 or 4 digits    123                timeout=20 sec
#     ClickText    Continue                        delay=5
#     VerifyText                        AutoPayment Details        partial_match=False          timeout=50

#     #------ Paperless Billing Enrollment verification ----------
#     VerifyText                        Enroll in Paperless Billing                        anchor=Paperless Billing                        timeout=50
#     VerifyCheckboxValue               Enroll in Paperless Billing                        On
#     ScrollTo     Do you understand and agree to the terms as I have explained them?
#     ClickCheckbox    Do you understand and agree to the terms as I have explained them?    on    delay=5
#     ClickText    Continue                        delay=5
#     #-----------------------------------                        

#     TypeText    Enter 4 digit number    1234                        timeout=50
#     TypeText    Re Enter 4 digit number    1234
#     ClickText    Select Question    anchor=*Security Question
#     ClickText    Who is your favorite actor?    anchor=*Security Passcode
#     TypeText    Enter answer    Rajnikant
#     ClickText    Continue    Index=1
#     ClickText    Log out
#     CloseAllBrowsers
TC_03 Customer Search_Verify the user Can search with customer with Valid Account number, Phone Number, Order ID, AT&T login ID, Email address
    [Documentation]    This test case is to verify Account search using BAN, Order Number, Email ID, ATTUID and Phone Number
    [Tags]             Services                           Account Search
    OpenBrowser        about:blank                        chrome
    DeleteAllCookies
    ACC_CSR_Login
    LaunchApp          Customer Central
    ClickText          Show Navigation Menu
    ClickText          Home
    PickList           *Interaction Type                  Offline

    #----- Account Search using BAN
    ClickText          Search Customer
    ClickText          Advanced Search
    TypeText           7–15 digit numeric account number  177032669487                        timeout=30
    ClickText          Search                             partial_match=False                 timeout=30
    Retry_Search
    ClickText          Bypass                             timeout=30
    VerifyText         Accounts & Services                timeout=50

    #----- Complete Interaction
    ClickText          Complete Interaction               timeout=20
    UseModal           On
    TypeText           Notes                              Test                                timeout=50
    ClickText          Submit
    UseModal           Off

    #----- Account Search using Order ID
    VerifyText         Search Customer                    timeout=50
    PickList           *Interaction Type                  Offline
    ClickText          Search Customer                    timeout=100
    ClickText          Advanced Search
    TypeText           Order ID                           71-000008387055394
    ClickText          Search                             partial_match=False                 timeout=20
    ClickText          Bypass                             timeout=100
    VerifyText         Accounts & Services                timeout=50
    
    #----- Complete Interaction
    ClickText          Complete Interaction               timeout=20
    UseModal           On
    TypeText           Notes                              Test                                timeout=50
    ClickText          Submit
    UseModal           Off

    #----- Account Search using Email ID
    VerifyText         Search Customer                    timeout=50
    PickList           *Interaction Type                  Offline   
    ClickText          Search Customer                    timeout=100
    ClickText          Advanced Search
    TypeText           mail@domain.com                    rc7302@att.com
    ClickText          Search                             partial_match=False                 timeout=20
    VerifyText         Customers                          timeout=50
    ClickText          Expand All
    
    #----- Complete Interaction
    ClickText          Complete Interaction               timeout=20
    UseModal           On
    TypeText           Notes                              Test                                timeout=50
    ClickText          Submit
    UseModal           Off

    #----- Account Search using ATT UID
    VerifyText         Search Customer                    timeout=50 
    PickList           *Interaction Type                  Offline   
    ClickText          Search Customer                    timeout=100
    ClickText          Advanced Search
    TypeText           AT&T Login ID                      rc7302
    ClickText          Search                             partial_match=False                 timeout=50
    VerifyText         Customers                          timeout=50
    ClickText          Expand All
    
    #----- Complete Interaction
    ClickText          Complete Interaction               timeout=20
    UseModal           On
    TypeText           Notes                              Test                                timeout=50
    ClickText          Submit
    UseModal           Off

    #----- Account Search using Phone Number   
    VerifyText         Search Customer                    timeout=50 
    PickList           *Interaction Type                  Offline   
    ClickText          Search Customer                    timeout=100
    ClickText          Advanced Search
    #TypeText           Phone Number                       9876543211
    TypeText           Phone Number                       2145555555
    ClickText          Search                             partial_match=False                 timeout=50
    VerifyText         Customers                          timeout=50
    ClickText          Expand All
    
    #----- Complete Interaction
    ClickText          Complete Interaction               timeout=20
    UseModal           On
    TypeText           Notes                              Test                                timeout=50
    ClickText          Submit
    UseModal           Off

    ClickText          Log out
    CloseAllBrowsers
TC_04 Service - Verify the Service Interaction Sections and fields are displaying in Accounts & Services page - Uverse
    [Documentation]    This test case is to verify fields and sections displayed in Service Interaction page of a Wireless BAN
    [Tags]             Services       Uverse
    OpenBrowser        about:blank    chrome
    DeleteAllCookies
    ACC_CSR_Login
    LaunchApp          Customer Central
    ClickText          Show Navigation Menu
    ClickText          Home    
    PickList           *Interaction Type                  Offline
    
    #----- Account Search
    ClickText          Search Customer

    #----- Added condition to handle if Quick Search screen is displayed
    ${quick_search_present}=                               IsText                               Quick Search                    partial_match=False                    timeout=20
    IF                 ${quick_search_present} == True
     ClickText         Advanced Search
    END

    #TypeText           7–15 digit numeric account number  144761012                           timeout=30
    TypeText           7–15 digit numeric account number  322592904                           timeout=30
    ClickText          Search                             partial_match=False                  timeout=30
    ClickText          Bypass                             timeout=30 

    #----- Check Interaction page Highlight section fields
    VerifyText         Primary Contact Number   timeout=50
    VerifyText         Primary Contact Email
    VerifyText         Employee
    VerifyText         CPNI Consent

    #----- Check tabs displayed in Interaction page
    VerifyText         Accounts & Services
    VerifyText         Billing & Payments
    VerifyText         Contacts & Activities
    VerifyText         Support                            anchor=Contacts & Activities
    VerifyText         Notes History
    VerifyText         Profile

    #----- Check Accounts & Services - Sections displayed
    VerifyText         Plan                               anchor=2                            timeout=200
    VerifyText         Service Alerts
    VerifyText         Knowledge                          anchor=1
    VerifyText         Service Availability               anchor=1                            timeout=100
    VerifyText         Service & Offers                   timeout=150
    
    #----- Check Plan fields displayed
    VerifyText         Account                            anchor=2                            timeout=150
    VerifyText         Product
    VerifyText         Plan Name
    VerifyText         Start Date
    VerifyText         Plan Status
    VerifyText         Monthly Cost
    VerifyText         Phone
    VerifyText         Receivers/DVRs
    VerifyText         Protection Plan
    
    #----- Check Service Alerts related tabs
    VerifyText         Critical                           timeout=150
    VerifyText         Notices                            timeout=20
    VerifyText         Cases                              timeout=20
   
    #----- Check Knowledge section related tabs
    VerifyText         AT&T Assistant
    VerifyText         Search Knowledge

    #----- Check Service Availability section
    ScrollTo           Service Availability               anchor=2
    VerifyText         Expand All
    ClickText          Expand All
    VerifyText         Collapse All
    ClickText          Collapse All

    ClickText          Log out
    CloseAllBrowsers
TC_05 Service - Verify fields and sections displayed in Service Interaction page_Wireless BAN
    [Documentation]    This test case is to verify fields and sections displayed in Service Interaction page of a Wireless BAN
    [Tags]             Services       Wireless
    OpenBrowser        about:blank    chrome
    DeleteAllCookies
    ACC_CSR_Login
    LaunchApp          Customer Central
    ClickText          Show Navigation Menu
    ClickText          Home    
    PickList           *Interaction Type                  Offline
    
    #----- Account Search
    ClickText          Search Customer

    #----- Added condition to handle if Quick Search screen is displayed
    ${quick_search_present}=                               IsText                               Quick Search                    partial_match=False                    timeout=20
    IF                 ${quick_search_present} == True
     ClickText         Advanced Search
    END

    TypeText           7–15 digit numeric account number  177067413211                        timeout=30
    ClickText          Search                             partial_match=False                 timeout=30
    ClickText          Bypass                             timeout=30

    #----- Check Interaction page Highlight section fields
    VerifyText         Primary Contact Number   timeout=50
    VerifyText         Primary Contact Email
    VerifyText         Employee
    VerifyText         CPNI Consent

    #----- Check tabs displayed in Interaction page
    VerifyText         Accounts & Services
    VerifyText         Billing & Payments
    VerifyText         Contacts & Activities
    VerifyText         Support                            anchor=Contacts & Activities
    VerifyText         Notes History
    VerifyText         Profile

    #----- Check Accounts & Services - Sections displayed
    VerifyText         Plan                               anchor=2                            timeout=200
    VerifyText         Lines                              anchor=3
    VerifyText         Service Alerts
    VerifyText         Knowledge                          anchor=1
    VerifyText         Service Availability               anchor=1                            timeout=100
    VerifyText         Service & Offers                   timeout=150
    
    #----- Check Plan fields displayed
    VerifyText         Account                            anchor=2
    VerifyText         Plan Name
    VerifyText         Start Date
    VerifyText         Monthly Cost
    VerifyText         Lines                              anchor=1

    #----- Check Lines fields displayed
    VerifyText         Phone Number 
    VerifyText         Subscriber Plan Name
    VerifyText         User 
    VerifyText         Device Type
    VerifyText         Make and Model 
    VerifyText         Status
    VerifyText         Installment 
    VerifyText         Installment Amount
    VerifyText         Warranty Ends
    VerifyText         Device Protection 
    VerifyText         Upgrade
    
    #----- Check Service Alerts related tabs
    VerifyText         Critical                           timeout=150
    VerifyText         Notices                            timeout=20
    VerifyText         Cases                              timeout=20
   
    #----- Check Knowledge section related tabs
    VerifyText         AT&T Assistant
    VerifyText         Search Knowledge

    #----- Check Service Availability section
    ScrollTo           Service Availability               anchor=2
    VerifyText         Expand All
    ClickText          Expand All
    VerifyText         Collapse All
    ClickText          Collapse All

    ClickText          Log out
    CloseAllBrowsers
TC_06 Service - Verify View Bill Escalate Case creation_Wireless BAN
    [Documentation]    This test case is to verify Billing | Inquiry Case creation from View Bill Page by clicking Escalate button
    [Tags]             Services    Case Creation    Wireless
    OpenBrowser        about:blank    chrome
    DeleteAllCookies
    ACC_CSR_Login
    LaunchApp          Customer Central
    ClickText          Show Navigation Menu
    ClickText          Home    
    PickList           *Interaction Type                  Offline
    
    #----- Account Search
    ClickText          Search Customer

    #----- Added condition to handle if Quick Search screen is displayed
    ${quick_search_present}=                               IsText                               Quick Search                    partial_match=False                    timeout=20
    IF                 ${quick_search_present} == True
     ClickText         Advanced Search
    END

    TypeText           7–15 digit numeric account number  177067413211                        timeout=30
    ClickText          Search                             partial_match=False                 timeout=30
    ClickText          Bypass                             timeout=30
    
    #---------------- Verify Escalate Case Creation from View Bill Page  ------------------------------------------------------------
    ClickText          Billing & Payments                 timeout=50
    ClickText          View Bill                          timeout=150
    ClickText          Escalate                           timeout=100

    #----- Check Case creation screen, fields, options displayed and select values
    VerifyText         Case Information                    timeout=50
    PickList           *Type                               Billing | Inquiry                  anchor=Product Category
    PickList           *Case Action                        Bill Image - Delayed Bill
    PickList           *Priority                           Medium
    PickList           *Response                           Not Required
    PickList           *Preferred Language                 English
    PickList           *Bill Type                          E Bill
    ClickText          *Bill / Invoice Date
    UseModal           On
    UseTable           Sun
    ClickText          Previous Month
    ClickCell          r4c3
    UseModal           Off
    ClickText          *Date Bill Expected
    UseModal           On
    UseTable           Sun
    ClickText          Previous Month
    ClickCell          r4c3
    UseModal           Off
    ClickText          *Date Bill Received
    UseModal           On
    UseTable           Sun
    ClickText          Previous Month
    ClickCell          r4c5
    UseModal           Off
    TypeText           *Description                        Test Escalate Case Creation from View Bill page
    ${Sub_options} =   GetPicklist                         *Subscriber/CTN
    PickList           *Subscriber/CTN                     ${Sub_options}[0]
    ClickText          Continue

    #----- Submit Billing | Inquiry Case creation
    VerifyText         Review & Submit                     timeout=20
    ClickElement       xpath\=//button[text()\='Submit']   timeout=20

    #----- Get Case Number once Case is created
    ${CaseId}          GetFieldValue                       Case Number                         timeout=50
    VerifyText         Target Close Date
    
    #----- Close Case details and other tabs
    ClickText          Actions                             anchor=Close 500                    timeout=10
    ClickText          Close Tab                           timeout=10
    ClickText          Close Bill: Account 177067413211    timeout=30  

    #----- Verify newly created Case details displayed in Case related list in Contacts & Activities tab                    
    ClickText          Contacts & Activities               timeout=30
    ClickText          Cases
    UseTable           Case Number
    ClickText          ${CaseId}
    VerifyText         Case Information                    timeout=30
    VerifyField        Case Number                         ${CaseId}
    #-------------------------------------------------------------------------------------------------------------------------------
    
    ClickText          Log out
    CloseAllBrowsers
TC_07 Services - OTP Validation via Inbound for AIA BAN
    [Documentation]   This test case is to verify Change Order details for AIA BAN logged in as BB Tech Agent user
    [Tags]            Services    Order Details            AIA
    OpenBrowser       about:blank                          chrome
    DeleteAllCookies
    ACC_BBTechAgent_Login
    LaunchApp         Customer Central
    ClickText         Show Navigation Menu
    ClickText         Home
    PickList          *Interaction Type                    Inbound
    
    #----- Account Search
    ClickText         Search Customer

    #----- Added condition to handle if Quick Search screen is displayed
    ${quick_search_present}=                               IsText                               Quick Search                    partial_match=False                    timeout=20
    IF                ${quick_search_present} == True
     ClickText        Advanced Search
    END

    TypeText          7–15 digit numeric account number    553355800033                         timeout=30
    ClickText         Search                               partial_match=False                  timeout=30
    
    #----- Select OTP Authentication Type
    PickList          Authentication Type                  One-Time PIN (OTP)                   timeout=80
    ClickText         Select an option                     anchor=Contact Method                timeout=20
    ClickText         (***) **                             partial_match=True                   anchor=Authentication Type      timeout=80
    QForce.ClickText  Authenticate the Customer

    #----- Open Console logs and get the OTP generated
    HotKey            ctrl  shift  J
    HotKey            ctrl  l                              delay=5                    
    QForce.ClickText  Send OTP                             timeout=100
    ${securitycode}=  QVision.GetText                      locator="securityCode"                                   
    HotKey            ctrl  shift  J    
    ${code}=          Get Substring                        ${securitycode}                      -8                        -2

    #----- Enter the OTP from Console logs and check OTP Authentication
    QWeb.TypeText     OTP                                  ${code}                              timeout=10
    QForce.ClickText  Continue                             timeout=10
    
    #----- Check Account Interaction Page displayed
    QForce.VerifyText  Accounts & Services                 timeout=50
    QForce.VerifyText  553355800033                        timeout=50

    ClickText         Log out
    CloseAllBrowsers
TC_08 KM - Verify Article creation and functionality for Compliance article
    [Documentation]    This test case is to verify KM Compliance Article creation
    [Tags]             KM
    OpenBrowser        about:blank    chrome
    DeleteAllCookies
    ACC_KMAuthor_Login
    ClickText          Show Navigation Menu
    ClickText          Knowledge Management

    #----- Create New Compliance Article
    ClickText          New                                 timeout=60
    ClickText          Compliance                          partial_match=True                   timeout=60
    ClickText          Next                                timeout=60
    VerifyText         New Knowledge Management: Compliance                                     anchor=3                        timeout=50
    ${random_title}=   Generate Random String              6  [LOWER]
    TypeText           *Title                              ${random_title}
    TypeText           *Content Sponsor                    qa2022
    ${random_url}=     Generate Random String              10
    ScrollTo           URL Name
    TypeText           *URL Name                           URL_${random_url}
    ClickText          Save                                partial_match=False
    VerifyText         was created.                        partial_match=True                   timeout=20

    #----- Check newly created Compliance Article details
    VerifyField        Publication Status                  Draft                                timeout=30
    VerifyField        Article Status                      Draft
    VerifyField        Article Record Type                 Compliance
    VerifyField        Title                               ${random_title}
    
    #----- Update Compliance Article Categories
    ClickElement       xpath\=//a[@class\="slds-button slds-button--icon-border slds-button--icon slds-button--icon-border-filled slds-grid slds-grid_align-center slds-grid_vertical-align-center"]                       timeout=10
    ClickElement       xpath\=//a[@title\="Edit"]          timeout=20
    ClickElement       xpath\=(//span[@class\="slds-checkbox_faux"])[7]                         timeout=20
    ClickElement       xpath\=(//span[@class\="slds-checkbox_faux"])[8]                         timeout=20
    ClickElement       xpath\=(//span[@class\="slds-checkbox_faux"])[9]                         timeout=20
    ClickElement       xpath\=(//span[@class\="slds-checkbox_faux"])[10]                        timeout=20
    ClickText          Save                                anchor=Cancel                        timeout=20
    
    #----- Publish Article
    ClickText          Publish                             anchor=Follow                        timeout=20
    VerifyText         Success!                            partial_match=True                   timeout=20
    
    #----- Check Article Status after Publishing
    ClickText          Action                              anchor=Knowledge Management          timeout=20
    ClickText          Refresh Tab                         timeout=10
    VerifyField        Article Status                      Ready for Publication                timeout=20
    
    ClickText          Log out
    CloseAllBrowsers