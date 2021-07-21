/// Testing API Telegram
Class appmsw.telestat.API.util [ Abstract ]
{

Parameter TELESERVER = "api.telegram.org";

/// write ##class(appmsw.telestat.API.util).Init()
/// set b("admin")=$lb("admin","123"),b("informer")=$lb("informer","321") write ##class(appmsw.telestat.API.util).Init(.b)
ClassMethod Init(ByRef bots) As %String
{
 if '$D(bots) {
 	if '($p="00" || ($p["/nul")) { // current device is not terminal
	 	read !,"Shall we enter names and tokens ? [y,n] <y> ",*R:5
	 	if R="-1"||("13,121,89"'[R) write !,..WriteMessInit(1) quit $$$OK
 	}
 }
 if '$D(bots) quit $$$ERROR($$$GeneralError,"Bots information is empty")
 do ..InitBots(.bots)
 #dim p As Ens.Config.Production
 Set p = ##class(Ens.Config.Production).%OpenId("appmsw.telestat.Production")
 quit:p="" $$$ERROR($$$GeneralError,"Production not found")
 #dim item As Ens.Config.Item
 #dim sett As Ens.Config.Setting
 for i=1:1:p.Items.Count() {
	 s item=p.Items.GetAt(i)
	 ;w !,item.Name
	 if item.Name="appmsw.telestat.TelegramService"
	 	||(item.Name="appmsw.telestat.TelegramOperation")
	 	||(item.Name="appmsw.telestat.TelegramServiceAlert")
	 	{
	 	for s=1:1:item.Settings.Count() {
	 		set sett=item.Settings.GetAt(s)
	 		;w !,sett.Name
	 		if sett.Name="TelegramName" set sett.Value=$lg(bots("informer"),1)
	 		if sett.Name="TelegramToken" set sett.Value=$lg(bots("informer"),2)
	 	}
	 }
	 if item.Name="appmsw.telestat.TelegramServiceAdmin"
	 	||(item.Name="appmsw.telestat.TelegramOperationAdmin")
	 	{
	 	for s=1:1:item.Settings.Count() {
	 		set sett=item.Settings.GetAt(s)
	 		;w !,sett.Name
	 		if sett.Name="TelegramName" set sett.Value=$lg(bots("admin"),1)
	 		if sett.Name="TelegramToken" set sett.Value=$lg(bots("admin"),2)
	 	}
	 }
	 
 }
 Set sc = p.%Save()
 if sc write !,"Product items changed successfully"
 If $$$ISERR(sc) { write !,$System.Status.GetErrorText(sc)	} 
 quit sc
}

/// write ##class(appmsw.telestat.API.util).InitBots()
ClassMethod InitBots(ByRef bots) As %String
{
	if '$DATA(bots) {
		for bot="admin","informer" {
Again1		write !,"Enter the username of the "_bot_" bot "
			read username 
			if username="" write !," You entered an empty value" goto Again1
			write " ["_username_"]"
Again2		write !,"Enter the token to access of the "_bot_" bot "
			read token
			if token="" write !," You entered an empty value" goto Again2
			write " ["_token_"]"
			set number=""
			if bot="admin" {
Again3			write !,"Enter the number phone of the "_bot_" bot "
				read number
				if number="" write !," You entered an empty value" goto Again3
				write " ["_number_"]"
			}
			
			set bots(bot)=$lb(username,token,number)
		}
	}
	for bot="admin","informer" {
		#dim obj AS appmsw.telestat.Bots
		set obj=##class(appmsw.telestat.Bots).GetObjByRoles(bot)
		if obj="" set obj=##class(appmsw.telestat.Bots).%New() 
		set obj.Roles=bot
		set obj.TelegramName = $lg(bots(bot),1)
		set obj.TelegramToken = $lg(bots(bot),2)
		set obj.Number = $lg(bots(bot),3)
		set st=obj.%Save()
		if 'st write $$$GETERRORMESSAGE(st) quit
	}
	write !,..WriteMessInit(0)
  QUIT $$$OK
}

ClassMethod WriteMessInit(fail) As %String
{
	if fail {set text="fail, or"}
	else {set text="make a mistake, or"}
	quit "If you "_text_" BotFather changed the token, you can always retry later by performing a utility ##class(appmsw.telestat.API.util).Init()"
}

/// The method checks for the existence of the configured SSL configuration
/// and creates an empty configuration with that name if this yet
/// to connect to a https server, that's enough
/// write ##class(appmsw.telestat.API.util).CheckSSLCertificate("telestat")
ClassMethod CheckSSLCertificate(name) As %String
{
  NEW $NAMESPACE
  SET $NAMESPACE = "%SYS"
  
  IF '##class(Security.SSLConfigs).Exists(name) {
    DO ##class(Security.SSLConfigs).Create(name)
  }
  QUIT name
}

/// zwrite ##class(appmsw.telestat.API.util).TelegramSendMessage("Token","ChatId","sendMessage","Hi "_$wc($zhex("1F609")))
ClassMethod TelegramSendMessage(botId, chatId, method, text, replyMarkup As %DynamicObject = 0) As %DynamicObject
{
	#dim request as %Net.HttpRequest
	set request = ##class(%Net.HttpRequest).%New()
	set request.Server = ..#TELESERVER
	set request.SSLConfiguration = ##class(appmsw.telestat.API.util).CheckSSLCertificate("telestat")
	set request.Https = 1 

	do request.InsertFormData("chat_id",chatId)
	do request.InsertFormData("text",text)
	if (replyMarkup'=0) {
		do request.InsertFormData("reply_markup",replyMarkup.%ToJSON())
	}
	set st = request.Post("bot"_botId_"/"_method)
	if '(st) {
		throw ##class(%Exception.StatusException).CreateFromStatus(st)
	}
	return ##class(%Library.DynamicObject).%FromJSON(request.HttpResponse.Data)
}

ClassMethod GetButtons(textbuttons)
{
	;set button = {}
	;if (getPhone=1) { //phone or geolocation request
	;	do button.%Set("request_contact",1,"boolean") 
	;	;do button.%Set("request_location",1,"boolean") 
	;} 
	;set button.text = buttonText
	
	set buttons = []

	for i=1:1:$l(textbuttons,",") {
		set text=$P(textbuttons,",",i)
		continue:text=""
		set button = {}
		set button.text = text
		do buttons.%Push(button)
	}

	set obj = {"one_time_keyboard":true,"resize_keyboard":true}
	set obj.keyboard = []
	do obj.keyboard.%Push(buttons)
	quit obj
}

/// Sending a message to the administration bot 
/// zwrite ##class(appmsw.telestat.API.util).ToAdmin("Contest")
/// zwrite ##class(appmsw.telestat.API.util).ToAdmin("Contest2","Yes,No")
ClassMethod ToAdmin(msg, buttonstext = "") As %Status
{
	if buttonstext'="" set buttons=..GetButtons(buttonstext)
	else  set buttons=0
	set emo=$wc($zhex("1F6A9"))
	#dim obj As appmsw.telestat.Bots
	set obj=##class(appmsw.telestat.Bots).GetObjByRoles("admin")
	if $isobject(obj) {
		set ChatId=obj.ChatId
		set token=obj.TelegramToken
		;w !,"ChatId= ",ChatId," Token= ",token
		set js=##class(appmsw.telestat.API.util).TelegramSendMessage(token,ChatId,"sendMessage",emo_msg,buttons)
		quit js
	} else {
		q 0
	}
}

/// Sending a message to the informer bot 
/// zwrite ##class(appmsw.telestat.API.util).ToInformer("323232323",,,"Test message")
ClassMethod ToInformer(Phone = "", ChatId = "", Token = "", msg, buttonstext = "") As %Status
{
	if buttonstext'="" set buttons=..GetButtons(buttonstext)
	else  set buttons=0
	set emo=$wc($zhex("1F6A9"))
	if Phone'="" {
		#dim obj As appmsw.telestat.Bots
		set obj=##class(appmsw.telestat.Bots).GetObjByNumber(Phone)
		if $isobject(obj) {
			set ChatId=obj.ChatId
			set Token=obj.TelegramToken
		}
	}
	set js=##class(appmsw.telestat.API.util).TelegramSendMessage(Token,ChatId,"sendMessage",emo_msg,buttons)
	quit js
}

}

