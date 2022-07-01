'a subroutine that logs us into linkedin.
'if credentials are not supplied, an inputbox prompts us.

Sub logIntoLinkedIn(driver, username, password)
    'navigate to linkedIn
    driver.Get "https://www.linkedin.com/login"
    
    'enter our credentials into the session key and the session password
    driver.FindElementByName("session_key").SendKeys username
    driver.FindElementByName("session_password").SendKeys password
    
    'submit
    call driver.FindElementByName("session_password").Submit

End Sub

'a function that generates a searchable URL we can paginate based on a keyword.
'this function also accepts an optional page parameter.
Function createPeopleSearch(keyword, page)
    'create a search URL with two placeholders.
    Url = "https://www.linkedin.com/search/results/people/?keywords={1}&origin=SWITCH_SEARCH_VERTICAL&page={2}"
    'insert a keyword into our URL
    Url = Replace(Url, "{1}", Cstr(keyword),1,1,1)
    'insert the page we want to see
    Url = Replace(Url, "{2}", CStr(page),1,1,1)
    
    createPeopleSearch = Url
End Function

'given some keyword, iterate over people and return a collection of URLs
sub paginateSearchTerm(driver,fsoObj,keyword,sleeptime,startPage,endPage) 
    
    wscript.echo "now pulling results for keyword: "+keyword 

    For i = startPage To endPage
        'generate our URL
        searchTermUrl = createPeopleSearch(keyword, i)
        driver.Get (searchTermUrl)
    
        'sleep
        If sleeptime <> -1 Then driver.wait(sleeptime)

        'create a container for search results
        Set SearchObjs = driver.FindElementsByClass("entity-result__item")
        wscript.echo "page "+cstr(i)+" , number of results: "+cstr(SearchObjs.count)
        
        'iterate over each result and print their URL - Note: some URLs will not be printed as many individuals have chosen to stay private.
        For Each obj In SearchObjs
            objURL = obj.FindElementByClass("app-aware-link").attribute("href")
            fsoObj.WriteLine objURL + "," + keyword 
        Next
        
    Next

End sub

'driver is located in: C:\Users\{fkrasovsky}\AppData\Local\SeleniumBasic

Sub main()
    

    'provision a text file to write data into 
    dim fso
    dim oFile 

    set fso = CreateObject("Scripting.FileSystemObject")
    output_filename = "linkedin_urls.txt"
    scriptdir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
    full_out_path = scriptdir + "\" + output_filename 

    'if the file exists already, write to it instead of creating it 
    if fso.fileExists(full_out_path) then 
        wscript.echo "output file exists already..."
        wscript.echo "commencing writing operations through appending."
        set oFile = fso.OpenTextFile(full_out_path,8)
    else 
        wscript.echo "creating output file..."
        set oFile = fso.CreateTextFile(full_out_path)
    end if 
    
    set driver = CreateObject("Selenium.ChromeDriver")
    'point our selenium object at our chrome location and make the selenium obj invisible during runtime
    driver.SetBinary ("C:\Program Files\Google\Chrome\Application\chrome.exe")
    driver.AddArgument "--headless"

    'log into linkedin 
    driver.Start
    username = inputbox("please enter linkedin Username:")
    password = inputbox("please enter linkedin Password:")
    Call logIntoLinkedIn(driver, username, password)

    'start timing 
    Start = Now

    'let's collect some terms!
    ' call paginateSearchTerm(driver,oFile,"analyst",2000,1,100)
    ' call paginateSearchTerm(driver,oFile,"data scientist",2000,1,100)
    ' call paginateSearchTerm(driver,oFile,"technology",2000,1,100)
    ' call paginateSearchTerm(driver,oFile,"stem",2000,1,100)
    ' call paginateSearchTerm(driver,oFile,"codingdojo",2000,1,100)
    ' call paginateSearchTerm(driver,oFile,"engineer",2000,1,100)
    call paginateSearchTerm(driver,oFile,"business analyst",2000,1,100)

    'how long it took us to get all these
    wscript.echo "Total runtime (Seconds):"
    wscript.echo DateDiff("s", Start, Now)

    'shut down text file 
    oFile.Close 

    'shut down driver 
    driver.Quit
    
End Sub

call main()