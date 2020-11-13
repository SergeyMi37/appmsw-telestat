Class appmsw.telestat.API.commands Extends appmsw.telestat.API.service
{

/// Get commands
ClassMethod GetCommands(ByRef comm, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	// Header 
	set comm="Service for tracking the status of Ensemble and IRIS servers. Can receive commands: "_$$$NL
	
	//s comm("/CommandName")=$listbuild("class","method",arg."Description","routine")
	set comm("/ServersStatus")=$listbuild("appmsw.telestat.API.status","ServersStatus","","Get a list of monitored instances","")
	set comm("/GetLastAlerts")=$listbuild("appmsw.telestat.API.commands","GetAlerts","","Get last alerts. Server: '"_$Zu(110)_"'","")
	
	// commands for admin
	#dim obj As appmsw.telestat.Bots
	set obj=##class(appmsw.telestat.Bots).GetObjByRoles("admin")
	if $isobject(obj) {
		if ChatId=obj.ChatId, Token=obj.TelegramToken { //if currently user is admin
			set comm("/Userlist")=$listbuild(..%ClassName(1),"UserList","","Get a list of users associated with the bot informant","")
		}
	}
	
	Quit $$$OK
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
/// do ##class(appmsw.telestat.API.commands).GetAlerts(.str,.return)
ClassMethod GetAlerts(str, ByRef return, command, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
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
ClassMethod UserEdit(id, ByRef return, command, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	#dim obj As appmsw.telestat.Bots
	set obj=##class(appmsw.telestat.Bots).%OpenId(id)
	if $isobject(obj) {
		;set return="Change the access rights for the user "_obj.NameFirst_" "_obj.NameLast_$$$NL
		set username=obj.NameFirst_" "_obj.NameLast
		
		set @..#GNtmp@("Admin",id)=$lb($h,obj.TelegramToken,obj.ChatId,obj.Number,obj.NameFirst,obj.NameLast)
		
		set buttons="=Access:"_$Select(obj.Access="Yes":"No",1:"Yes")_":"_id
		set buttons=buttons_",=Notify:"_$Select(obj.Notify="Yes":"No",1:"Yes")_":"_id
		
		do ##class(appmsw.telestat.API.util).ToAdmin("Change the access rights for "_username,buttons)
	}
	else {
		set return="...empty"_$$$NL
	}
	quit $$$OK
}

/// do ##class(appmsw.telestat.API.commands).UserList()
ClassMethod UserList(arg, ByRef return, command, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	set return="List of active users:"_$$$NL
	set icon = $wc($zhex("1F610")) ;neutral
	set iconrage = $wc($zhex("1F621")) ;rage
	set result=##CLASS(%ResultSet).%New("%DynamicQuery:SQL")
	set tSC=result.Prepare("select ID,NameFirst,NameLast,Number,Access,Notify,ChatId,Resource,TimeStamp,Groups,IsAdmin,Allow FROM appmsw_telestat.Bots where Roles ='informer' and ChatId  is not null order by NumCommSent desc")
	set:tSC tSC=result.Execute()
	if '$$$ISOK(tSC) {
		QUIT tSC
	}
	else {
		while result.Next() {
			set ico=icon
			set Acc=result.Data("Access")
			set id=result.Data("ID")			
			if $E(Acc,1)'="Y" set ico=iconrage
			set command="/UserEdit"_id
			set @..#GNtmp@("Command",ChatId,command)=$listbuild(..%ClassName(1),"UserEdit",id,"Get last alerts. Server: '"_$Zu(110)_"'")
			set return= return_ico_" "_command_" "_result.Data("Number")_ ", "_result.Data("NameFirst")_" "_result.Data("NameLast")_", Access:"_Acc_", Notify:"_result.Data("Notify")_$$$NL
		}
	}
	set:return="" return="...empty"_$$$NL
	quit $$$OK
}

}

