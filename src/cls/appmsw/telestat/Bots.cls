/// Users table
Class appmsw.telestat.Bots Extends %Persistent
{

/// Telegram Name
Property TelegramName As %String;

/// Token telegram
Property TelegramToken As %String(MAXLEN = "");

/// Namber phone user
Property Number As %String;

/// ChatId user
Property ChatId As %String;

/// Name First 
Property NameFirst As %String;

/// Name Last
Property NameLast As %String;

/// Date and time last change
Property TimeStamp As %TimeStamp [ InitialExpression = {$zdt($h, 3, 1)} ];

/// Notify
Property Notify As %String;

/// Access :Allow or Deny
Property Access As %String;

/// Access :Allow or Deny
Property Allow As %String;

/// Is Admin
Property IsAdmin As %String;

/// Resource
Property Resource As %String(MAXLEN = "");

/// Groups
Property Groups As %String(MAXLEN = "");

/// Roles
Property Roles As %String(MAXLEN = "");

/// Number of commands sent
Property NumCommSent As %Integer;

Index idxNAccess On Access;

Index idxNumCommSent On NumCommSent;

Index idxResource On Resource;

Index idxGroups On Groups;

Index idxRoles On Roles;

Index idxAdmin On IsAdmin;

Index idxNameLast On NameLast;

Index idxNameFirst On NameFirst;

Index idxChatId On ChatId;

Index idxNumber On Number;

Index idxTelegramToken On TelegramToken;

Index idxTelegramName On TelegramName;

Index idxTimeStamp On TimeStamp [ Type = bitslice ];

/// Get object by ChatId
/// Example set obj=##class(appmsw.telestat.Bots).GetObjByChatId("123333333","sss")
ClassMethod GetObjByChatId(ChatId, token) As appmsw.telestat.Bots
{
	 set obj=""
	 set sql="Select ID FROM appmsw_telestat.Bots where TelegramToken=? and ChatId =?"
	 Set tStatement = ##class(%SQL.Statement).%New()
	 Set tSC = tStatement.%Prepare(sql)
	 If $$$ISERR(tSC) Quit ""
	 Set tRS = tStatement.%Execute(token,ChatId)
	 If tRS.%Next() {
		 if tRS.ID set obj=##class(appmsw.telestat.Bots).%OpenId(tRS.ID)
	 }
 	quit obj
}

/// Example set st=##class(appmsw.telestat.Bots).IncNumCommSent()
ClassMethod IncNumCommSent(Token As %String = "", ChatId As %String = "", ByRef Count) As appmsw.telestat.Bots
{
	set obj=##class(appmsw.telestat.Bots).GetObjByChatId(Token, ChatId)
	if $isobject(obj) {
		set Count=obj.NumCommSent
		set Count=Count+1
		set obj.NumCommSent=Count
		quit obj.%Save()
	}
	q $$$OK
}

/// Get object by Numer for Admin
/// Example set obj=##class(appmsw.telestat.Bots).GetObjByNumber("123333333")
ClassMethod GetObjByNumber(Number, IsAdmin = 0) As appmsw.telestat.Bots
{
	 set obj=""
	 if IsAdmin set role="Roles='admin' and "
	 else  set role="Roles='informer' and "
	 set sql="Select ID FROM appmsw_telestat.Bots where "_role_" Number =?"
	 Set tStatement = ##class(%SQL.Statement).%New()
	 Set tSC = tStatement.%Prepare(sql)
	 If $$$ISERR(tSC) Quit "" ;tSC
	 Set tRS = tStatement.%Execute(Number)
	 If tRS.%Next() {
		 if tRS.ID set obj=##class(appmsw.telestat.Bots).%OpenId(tRS.ID) ;w !,"=",tRS.ID
	 }
 	quit obj
}

/// Get object by roles
/// Example set obj=##class(appmsw.telestat.Bots).GetObjByRoles("admin")
ClassMethod GetObjByRoles(Roles) As appmsw.telestat.Bots
{
	 set obj=""
	 set sql="Select ID FROM appmsw_telestat.Bots where Roles=?"
	 Set tStatement = ##class(%SQL.Statement).%New()
	 Set tSC = tStatement.%Prepare(sql)
	 If $$$ISERR(tSC) Quit ""
	 Set tRS = tStatement.%Execute(Roles)
	 If tRS.%Next() {
		 if tRS.ID set obj=##class(appmsw.telestat.Bots).%OpenId(tRS.ID)
	 }
 	quit obj
}

/// s st=##class(appmsw.telestat.Bots).GetAllow(Token,phone,ChatId,.Allow)
ClassMethod GetAllow(Token As %String = "", Number As %String = "", ChatId As %String = "", ByRef Allow = 0)
{
	set sql="select * from appmsw_telestat.Users where Token=? and Number=? and ChatId=?"
	Set tSt = ##class(%SQL.Statement).%New()
	
	Set tStatus = tSt.%Prepare(sql)
	If $$$ISERR(tStatus) Quit tStatus
	Set tRS = tSt.%Execute(Token,Number,ChatId)
	While (tRS.Next()) {
		Set Allow = tRS.Data("Access")
	}
	Quit $$$OK
}

Storage Default
{
<Data name="BotsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TelegramName</Value>
</Value>
<Value name="3">
<Value>TelegramToken</Value>
</Value>
<Value name="4">
<Value>Number</Value>
</Value>
<Value name="5">
<Value>ChatId</Value>
</Value>
<Value name="6">
<Value>NameFirst</Value>
</Value>
<Value name="7">
<Value>NameLast</Value>
</Value>
<Value name="8">
<Value>TimeStamp</Value>
</Value>
<Value name="9">
<Value>Allow</Value>
</Value>
<Value name="10">
<Value>IsAdmin</Value>
</Value>
<Value name="11">
<Value>Resource</Value>
</Value>
<Value name="12">
<Value>Groups</Value>
</Value>
<Value name="13">
<Value>Roles</Value>
</Value>
<Value name="14">
<Value>NumCommSent</Value>
</Value>
<Value name="15">
<Value>Access</Value>
</Value>
<Value name="16">
<Value>Notify</Value>
</Value>
</Data>
<DataLocation>^appmsw.telestat.BotsD</DataLocation>
<DefaultData>BotsDefaultData</DefaultData>
<IdLocation>^appmsw.telestat.BotsD</IdLocation>
<IndexLocation>^appmsw.telestat.BotsI</IndexLocation>
<StreamLocation>^appmsw.telestat.BotsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

