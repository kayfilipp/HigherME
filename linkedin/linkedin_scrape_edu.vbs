'''
''' REMARKS 
''' Data capture is focused on getting the following
''' Education -  We use a separate URL for edu for edge cases were the profile page doesn't capture all cards.
'''

''' profile url / details / field --> we can simply replace the {} with the full profile URL.
const LINKEDIN_EDUCATION_URL  = "{}/details/education/"
const SEP = "@"

Sub logIntoLinkedIn(driver, username, password)
    
    'navigate to linkedIn
    driver.Get "https://www.linkedin.com/login"
    
    'enter our credentials into the session key and the session password
    driver.FindElementByName("session_key").SEndKeys username
    driver.FindElementByName("session_password").SEndKeys password
    
    'Submit
    call driver.FindElementByName("session_password").Submit

End Sub

'a special built function that keeps:
' alphanumeric chars
' !, <, > , ", and ' characters 
' whitespace, =, ;,:
function regexify(text)
    regexify = objRegEx.Replace(text,"")
end function 

'returns a string representation of the HTML containing a user's educational activity

function getEduHTML(driver,url)
    driver.get(url)
    set pvsList = driver.FindElementByClass("pvs-list")
    
    'remove line breaks 
    content = cstr(pvsList.attribute("innerHTML"))
    content = Replace(content, vbCr, "")
    content = Replace(content, vbLf, "")
    getEduHTML = content 
end function 

'extract username from linkedin profile url 
function getUserName(profileUrl)
    getUserName = replace(profileUrl,"https://www.linkedin.com/in/","")
end function 

'declare a regex obj to format HTML data 
Set objRegEx = CreateObject("VBScript.RegExp")
objRegEx.Global = True   
objRegEx.Pattern = "[^A-Za-z0-9\s\<\>\-\"+chr(34)+"\!\=\:\_\$\#\;\"+chr(39)+"\/\\]"


'get directory by taking the name of our script out of the full script path.
this_dir = replace(WScript.ScriptFullName,WScript.ScriptName,vbNullString)
urls = this_dir + "linkedin_urls_clean.txt"

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
call logIntoLinkedIn(driver,username,password)

'iterate over each URL in our textfile 
set fso = CreateObject("Scripting.FileSystemObject")
set profileURLs = fso.OpenTextFile(urls,1)

'note - we have to separate by an esoteric character combination since separating by 
'commas produces edge cases where we get more than 2 columns.
prev_html = "-1"

do until profileURLs.atEndOfStream
    on error resume next 
    
    'get the URL itself, get the username, specify the text file we want to park this in.
    this_row = split(profileURLs.ReadLine,",")
    this_profile_url = this_row(0)
    this_url = replace(LINKEDIN_EDUCATION_URL,"{}",this_profile_url)
    this_user= getUserName(this_profile_url)
    this_user_dir = this_dir+"edu_data/"+this_user+".txt"

    'check if we have a text file for this user. if we do not , let's get scraping!
    if fso.fileExists(this_user_dir) = true then 
        wscript.echo "data exists for " + this_url + ". skipping."
    else
        wscript.echo "fetching data for " + this_url 

        'get HTML 
        this_html = getEduHTML(driver,this_url)

        'make sure we didn't get stopped along the way - otherwise, alert the user
        if this_html = prev_html then 
            ' Set sapi=CreateObject("sapi.spvoice")
            ' sapi.Speak "Warning - HTML across concurrent linked matches. Investigate further and press ok to continue."
            ' msgbox "Press OK to Continue."
            ' Set sapi = Nothing 
        end if 

        set this_doc = fso.OpenTextFile(this_user_dir,2,true)
        this_doc.writeLine this_profle_url + SEP + this_html 

        if Err.Number <> 0 then 
            wscript.echo "failing to write html ... attempting to standardize through regex."
            this_doc.WriteLine this_url + SEP + regexify(this_html)
            Err.Clear 
            wscript.echo "success!"
        end if 
        
        prev_html = this_html 

        this_doc.close 

        'wait 
        rndWaitTime = 3000 + cInt(Rnd()*7000)
        wscript.echo "Waiting for ms: " + cStr(rndWaitTime)
        wscript.sleep(rndWaitTime)

        'maybe even wait longer 
        Randomize()
        if (Rnd() >= 0.9) then 
            wscript.echo "snoozing a little longer :3 "
            wscript.sleep(5000)
        end if 

    end if 
loop

profileURLs.close 