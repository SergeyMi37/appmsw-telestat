Class appmsw.telestat.API.status Extends appmsw.telestat.API.service
{

/// do ##class(appmsw.telestat.API.status).ServersStatus()
ClassMethod ServersStatus(arg, ByRef return, command, ChatId = "", Token = "", NameFirst = "", NameLast = "") As %Status
{
	set return="List of active servers:"_$$$NL
	;set icon = $wc($zhex("1F610")) ;neutral
	;TODO
	set:$GET(ret)="" return="...empty"_$$$NL
	quit $$$OK
}

}

