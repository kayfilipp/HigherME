'''
''' REMARKS 
''' Data capture is focused on getting the following
''' Education -  We use a separate URL for edu for edge cases were the profile page doesn't capture all cards.
'''

''' profile url / details / field --> we can simply replace the {} with the full profile URL.
const LINKEDIN_EDUCATION_URL  = "{}/details/education/"

Sub logIntoLinkedIn(driver, username, password)
    
    'navigate to linkedIn
    driver.Get "https://www.linkedin.com/login"
    
    'enter our credentials into the session key and the session password
    driver.FindElementByName("session_key").SEndKeys username
    driver.FindElementByName("session_password").SEndKeys password
    
    'Submit
    call driver.FindElementByName("session_password").Submit

End Sub


'get directory by taking the name of our script out of the full script path.
this_dir = replace(WScript.ScriptFullName,WScript.ScriptName,vbNullString)
urls = this_dir + "linkedin_urls_clean.txt"

'declare a dir to write information to 
write_dir = this_dir + "linkedin_urls_edu.txt"

'declare selenium obj and point it , turn off head
set driver = CreateObject("Selenium.ChromeDriver")
driver.SetBinary ("C:\Program Files\Google\Chrome\Application\chrome.exe")
driver.AddArgument "--headless"

'get user auth 
WScript.StdOut.Write "Enter linkedin username: "
username = WScript.StdIn.ReadLine
Wscript.StdOut.Write "Enter linkedin password: "
password = Wscript.StdIn.ReadLine 

'login 
'call logIntoLinkedIn(driver,username,password)

'iterate over each URL in our textfile 
set fso = CreateObject("Scripting.FileSystemObject")
set profileURLs = fso.OpenTextFile(urls,1)
set profileEDUs = fso.OpenTextFile(write_dir,2,true)

do until profileURLs.atEndOfStream
    this_row = split(profileURLs.ReadLine,",")
    this_url = replace(LINKEDIN_EDUCATION_URL,"{}",this_row(0))
    

loop
