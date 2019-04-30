In Folder 'M4PL_Windows_Service' we have 2 solutions,

1) Console Application 'TestM4PLApplication', In this we are performing opening the notepad, which is opening perfectly.
2) Solution 'M4PL_Executor', In this we have one windows Service and one Installer for that. 
	-> If you'll install this service using installer service will get install and start automatically.
	-> In this Service right now have written code to open notepad.
	-> But it is not getting open in GUI. it is opening as background process.

-> To make this Windows Service and Installer did below things,
	-> Read articals/YouTube video that how to create installer for windows services.(Url:https://www.google.co.in/search?q=create+setup+for+windows+service+in+visual+studio+2015&sa=X&ved=0ahUKEwjX59Xvi93cAhULuI8KHQzMBU4Q1QII5AEoAg&biw=1920&bih=974#kpvalbx=1)
	-> Followed the same and for visual studio installer I had to install separate extension.
	-> Read the articles for Communication between WebApplication and Windows Service,
		-> https://docs.microsoft.com/en-us/dotnet/framework/windows-services/introduction-to-windows-service-applications
		-> https://docs.microsoft.com/en-us/dotnet/api/system.serviceprocess.servicecontroller?view=netframework-4.7.2
		-> https://www.c-sharpcorner.com/uploadfile/Yousafi/allow-windows-service-to-interact-with-desktop/
		-> https://stackoverflow.com/questions/4237225/allow-service-to-interact-with-desktop-in-windows
		-> https://social.msdn.microsoft.com/Forums/vstudio/en-US/6b337fbf-ec97-4493-bed7-414acaaed429/allow-service-to-interact-with-desktop-in-c?forum=csharpgeneral
	-> Created Console Appliaction to open notepad from there for checking that able to open notepad or not.
	-> After some changes and googling got the solution that how can i make 'Allow Service to interact with desktop' checkbox check.
	-> Now notepad is getting open from service but in background only not as GUI.

(On -> 17/08/2018)
-> Added one more Project 'M4PL_Executor_Setup'
	-> In this added one more overriden method called 'CustomCommand'. This we can call from our WebApplication and do desired functionality. 
	   The Limitation of this method is that we can pass only one parameter(Int32) that too should be between 126 to 258.
	-> One alternate way to send extra parameter is, If service is running then stop and pass all the parameters in Start method and do desired functionality.
	-> This project supports removal of older version. If we want to update the service in client's machine then we fhave to just update the Installer version and Windows project's Assembly version and file version.
	   It will ask to remove the older service to user if user clicks Continue then it will remove older version and install newer version.
	   After successfull installation it will show message to restart the system.
	-> Have updated the project. Now I am able to open GUI exe's(notepad/calc) from this windows service as well.
	   