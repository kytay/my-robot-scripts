*** Settings ***
Documentation   Using SeleniumLibrary to parse and export Grab E-Receipt from gmail inbox
Library         SeleniumLibrary
Library         OperatingSystem
Library         DateTime
Test Setup      Run firefox and gecko in marionette
Test Teardown   Kill existing firefox and gecko

*** Variables ***
${IMAGE_DIR}                    ${CURDIR}/assets

${GMAIL_URL}                    https://mail.google.com/mail/u/0/#inbox
${GMAIL_FILTER_FROMDATE}        2021/05/01
${GMAIL_FILTER_TODATE}          2021/06/01
${GMAIL_SEARCH_CONDITIONS}      "subject: "your grab e-receipt" after: ${GMAIL_FILTER_FROMDATE} before: ${GMAIL_FILTER_TODATE} "Hope you enjoyed your ride!""
${GMAIL_BTN_BACK}               xpath:/html/body/div[7]/div[3]/div/div[2]/div[1]/div[2]/div/div/div/div/div[1]/div[3]/div[1]/div/div[1]/div/div

${SEARCH_TEXT_XPATH}            xpath:/html/body/div[7]/div[3]/div/div[1]/div[3]/header/div[2]/div[2]/div[2]/form/div/table/tbody/tr/td/table/tbody/tr/td/div/input[1]
${TOTAL_EMAIL_COUNT_XPATH}      xpath:/html/body/div[7]/div[3]/div/div[2]/div[1]/div[2]/div/div/div/div/div[1]/div[2]/div[2]/div[2]/div/span/div[1]/span/span[2]

${RECEIPT_CONTENT_LOADED_XPATH}       xpath:/html/body/div[7]/div[3]/div/div[2]/div[1]/div[2]/div/div/div/div/div[2]/div/div[1]/div/div[3]/div/table/tr/td[1]/div[2]/div[2]/div/div[3]/div/div/div/div/div/div[1]/div[2]/div[3]/div[3]/div/div[1]/table/tbody/tr/td/div/table
${RECEIPT_TOTAL_PAID_XPATH}           xpath:/html/body/div[7]/div[3]/div/div[2]/div[1]/div[2]/div/div/div/div/div[2]/div/div[1]/div/div[3]/div/table/tr/td[1]/div[2]/div[2]/div/div[3]/div/div/div/div/div/div[1]/div[2]/div[3]/div[3]/div/div[1]/table/tbody/tr/td/div/table/tbody/tr[3]/td/div[1]/table/tbody/tr/td[2]/div
${RECEIPT_PICKED_UP_DATE_XPATH}       xpath:/html/body/div[7]/div[3]/div/div[2]/div[1]/div[2]/div/div/div/div/div[2]/div/div[1]/div/div[3]/div/table/tr/td[1]/div[2]/div[2]/div/div[3]/div/div/div/div/div/div[1]/div[2]/div[3]/div[3]/div/div[1]/table/tbody/tr/td/div/table/tbody/tr[1]/td/table[2]/tbody/tr[2]/td[1]/div/div[2]/div[1]
${RECEIPT_PICKED_UP_LOCATION_XPATH}   xpath:/html/body/div[7]/div[3]/div/div[2]/div[1]/div[2]/div/div/div/div/div[2]/div/div[1]/div/div[3]/div/table/tr/td[1]/div[2]/div[2]/div/div[3]/div/div/div/div/div/div[1]/div[2]/div[3]/div[3]/div/div[1]/table/tbody/tr/td/div/table/tbody/tr[5]/td/table/tbody/tr/td/table/tbody/tr[1]/td[2]/div[1]
${RECEIPT_PICKED_UP_TIME_XPATH}       xpath:/html/body/div[7]/div[3]/div/div[2]/div[1]/div[2]/div/div/div/div/div[2]/div/div[1]/div/div[3]/div/table/tr/td[1]/div[2]/div[2]/div/div[3]/div/div/div/div/div/div[1]/div[2]/div[3]/div[3]/div/div[1]/table/tbody/tr/td/div/table/tbody/tr[5]/td/table/tbody/tr/td/table/tbody/tr[1]/td[2]/div[2]
${RECEIPT_DROPPED_OFF_LOCATION_XPATH}  xpath:/html/body/div[7]/div[3]/div/div[2]/div[1]/div[2]/div/div/div/div/div[2]/div/div[1]/div/div[3]/div/table/tr/td[1]/div[2]/div[2]/div/div[3]/div/div/div/div/div/div[1]/div[2]/div[3]/div[3]/div/div[1]/table/tbody/tr/td/div/table/tbody/tr[5]/td/table/tbody/tr/td/table/tbody/tr[2]/td[2]/div[1]
${RECEIPT_DROPPED_OFF_TIME_XPATH}     xpath:/html/body/div[7]/div[3]/div/div[2]/div[1]/div[2]/div/div/div/div/div[2]/div/div[1]/div/div[3]/div/table/tr/td[1]/div[2]/div[2]/div/div[3]/div/div/div/div/div/div[1]/div[2]/div[3]/div[3]/div/div[1]/table/tbody/tr/td/div/table/tbody/tr[5]/td/table/tbody/tr/td/table/tbody/tr[2]/td[2]/div[2]


*** Test Cases ***
Exporting Grab E-Receipt from inbox
    Open Browser        ${GMAIL_URL}  firefox  gmail  http://127.0.0.1:4444
    Maximize Browser Window
    Wait Until Page Contains Element    ${SEARCH_TEXT_XPATH}  timeout=30s
    Input Text          ${SEARCH_TEXT_XPATH}  ${GMAIL_SEARCH_CONDITIONS}  clear=true
    Press Keys          none  RETURN
    Sleep               3s

    ${TOTALCOUNT} =     Get Text    ${TOTAL_EMAIL_COUNT_XPATH}
    ${TOTALCOUNT_INT} =     Convert To Integer  ${TOTALCOUNT}
    Log To Console  Total filtered emails: ${TOTALCOUNT_INT}
    ${EXPORT_FILENAME} =   Run Keyword If  ${TOTALCOUNT_INT} > 0   Create new CSV file


    FOR     ${i}   IN RANGE     9999
        Exit For Loop If    ${i + 1} > ${TOTALCOUNT_INT}
        Log To Console  Processing email no. ${i + 1}
        ${EMAIL_INDEX} =  Evaluate    ${TOTALCOUNT_INT} - ${i}
        ${EMAIL_ROW} =  Set Variable    xpath:/html/body/div[7]/div[3]/div/div[2]/div[1]/div[2]/div/div/div/div/div[2]/div/div[1]/div/div[2]/div[5]/div[2]/div/table/tbody/tr[${i + 1}]/td[6]/div/div/span
        Wait Until Element Is Visible   ${EMAIL_ROW}    timeout=3s
        # comment
        Log To Console  Scrolling to element specified
        Scroll To Element    ${EMAIL_ROW}
        # comment
        Log To Console  Clicking element specified
        Click Element   ${EMAIL_ROW}
        # comment
        Log To Console  Appending CSV file...
        Wait Until Element Is Visible   ${RECEIPT_TOTAL_PAID_XPATH}     timeout=3s
        ${RECEIPT_TOTAL_PAID} =     Get Text    ${RECEIPT_TOTAL_PAID_XPATH}
        ${RECEIPT_PICKED_UP_DATE} =     Get Text    ${RECEIPT_PICKED_UP_DATE_XPATH}
        ${RECEIPT_PICKED_UP_LOCATION} =     Get Text    ${RECEIPT_PICKED_UP_LOCATION_XPATH}
        ${RECEIPT_PICKED_UP_TIME} =     Get Text    ${RECEIPT_PICKED_UP_TIME_XPATH}
        ${RECEIPT_DROPPED_OFF_LOCATION} =     Get Text    ${RECEIPT_DROPPED_OFF_LOCATION_XPATH}
        ${RECEIPT_DROPPED_OFF_TIME} =     Get Text    ${RECEIPT_DROPPED_OFF_TIME_XPATH}
        
        Append To File  ${EXPORT_FILENAME}  content="${RECEIPT_PICKED_UP_DATE}",
        Append To File  ${EXPORT_FILENAME}  content="${RECEIPT_TOTAL_PAID}",
        Append To File  ${EXPORT_FILENAME}  content="${RECEIPT_PICKED_UP_TIME}",
        Append To File  ${EXPORT_FILENAME}  content="${RECEIPT_PICKED_UP_LOCATION}",
        Append To File  ${EXPORT_FILENAME}  content="${RECEIPT_DROPPED_OFF_TIME}",
        Append To File  ${EXPORT_FILENAME}  content="${RECEIPT_DROPPED_OFF_LOCATION}"\n

        Capture Element Screenshot  ${RECEIPT_CONTENT_LOADED_XPATH}     receipt_${i + 1}.png
        
        Click Element   ${GMAIL_BTN_BACK}
    END

*** Keywords ***
Create new CSV file
    ${date} =   Get Current Date    result_format=%Y%m%d.csv
    ${filename} =   Set Variable   ./${date}
    Create File     ${filename}  
    Log To Console  Created file. ${filename}
    Return From Keyword     ${filename}

Convert to CSV Friendly Date
    [Arguments]     ${inputDate}
    ${date} =   Convert Date  

Scroll To Element
    [Arguments]  ${locator}
    ${x}=        Get Horizontal Position  ${locator}
    ${y}=        Get Vertical Position    ${locator}
    Execute Javascript  window.scrollTo(${x}, ${y})

*** Keywords ***
Run firefox and gecko in marionette
    Run     firefox -marionette >/dev/null 2>&1 &
    Run     geckodriver --connect-existing --marionette-port 2828 >/dev/null 2>&1 &
    Sleep   3s

Kill existing firefox and gecko
    Run     kill -9 $(ps -ef | grep firefox | awk '{print $2" "}' | tr -d '\n')
    Run     kill -9 $(ps -ef | grep geckodriver | awk '{print $2" "}' | tr -d '\n')