Class appmsw.telestat.API.commands [ Abstract ]
{

/// Get commands
ClassMethod GetCommands(ByRef comm, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	// Header 
	set comm="Service for tracking the status of Ensemble and IRIS servers. Can receive commands: "_$$$NL
	
	//s comm("/CommandName")=$listbuild("class","method","routine")
	//set comm("/ServersStatus")=$listbuild("appmsw.telestat.API.commands","ServersStatus","","Servers Status")
	set comm("/GetLastAlerts")=$listbuild("appmsw.telestat.API.commands","GetAlerts","","Get last alerts. Server: '"_$Zu(110)_"'")
	
	// commands for admin
	#dim obj As appmsw.telestat.Bots
	set obj=##class(appmsw.telestat.Bots).GetObjByRoles("admin")
	if $isobject(obj) {
		if ChatId=obj.ChatId, Token=obj.TelegramToken { //if currently user is admin
			set comm("/Userlist")=$listbuild("appmsw.telestat.API.commands","UserList","","Get a list of users receiving information about servers and their status")
		}
	}
	
	Q $$$OK
}

/// Get commands for Admin
ClassMethod GetCommandsAdmin(ByRef comm, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	do ..GetCommands(.comm,ChatId,Token,NameFirst,NameLast)
	// Header replace
	set comm= "Bot administration service for tracking Ensemble and IRIS servers. Can take commands: "_$$$NL
	Quit $$$OK
}

/// do ##class(%SYS.System).WriteToConsoleLog("InterSystems Interoperability Contest",,3)
/// do ##class(appmsw.telestat.API.commands).GetAlerts()
ClassMethod GetAlerts(ByRef return, command, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	do ##class(%SYSTEM.Monitor).GetAlerts(,.str,.last)
	set i="",return=""
	for ii=1:1 { set i=$Order(str(i),-1,val) quit:i=""
		if ii>10 quit
				
		set icon=$wc($zhex("1F610")) ;neutral
		if $P(val," ",3)>2 set icon=$wc($zhex("1F621")) ;rage
		
		set return=icon_$GET(val)_$$$NL_return
	}
	if return="" set return="...empty"_$$$NL
}

/// do ##class(appmsw.telestat.API.commands).UserList()
ClassMethod UserList(ByRef return, command, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	
	set return="..."_$$$NL
}

}

