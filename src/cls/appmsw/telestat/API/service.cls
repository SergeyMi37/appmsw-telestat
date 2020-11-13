Class appmsw.telestat.API.service Extends Ens.BusinessService
{

/// We use the global node to save and transfer private information between information exchange sessions
Parameter GNtmp = "^appmsw.telestat.tmp";

/// Check for permission to send info
ClassMethod IsPermiss(token, ChatId, phone = "0") As %Status
{
	#dim obj As appmsw.telestat.Bots
	if phone {
		set obj=##class(appmsw.telestat.Bots).GetObjByNumber(phone)
		if $isobject(obj) {
			if obj.ChatId=ChatId,obj.TelegramToken=token Quit $E(obj.Access,1)="Y"
			else  Quit 0
		} else {
			Quit "0"			
		}
	} else {
		set obj=##class(appmsw.telestat.Bots).GetObjByChatId(ChatId,token)
		if $isobject(obj) {
			Quit $E(obj.Access,1)="Y"
		} else {
			Quit "0"			
		}

	}
}

ClassMethod InitMessage(pInput As %RegisteredObject, Token, Output msg, ChatId, NameFirst, NameLast, IsAdmin = "") As %Status
{
    set msg = ##class(appmsw.telestat.Msg.TextRequest).%New()
    set ChatId = pInput.message.chat.id ;user chat id
	;set $$$AppL("TLG",ChatId_"-input")=$$$AppObJs(pInput)

    set NameFirst=pInput.message.from."first_name"
    set NameLast=pInput.message.from."last_name"
	if '$D(@..#GNtmp@("Users"_IsAdmin,ChatId)) set @..#GNtmp@("Users",ChatId)=$LB(NameFirst,NameLast)
	if $I(@..#GNtmp@("Users"_IsAdmin,ChatId,"count")) //for statistic
	set st=##class(appmsw.telestat.Bots).IncNumCommSent(Token,ChatId)
	Quit $$$OK
}

ClassMethod GetMessage(token, pInput As %RegisteredObject, Output msg) As %Status
{
	d ..InitMessage(pInput,token,.msg, .ChatId,.NameFirst,.NameLast)	
	
	Try {
		do ##class(appmsw.telestat.API.commands).GetCommands(.cmd,ChatId,token,NameFirst,NameLast)
		
		set Text = ""
		if pInput.message.text="/start" {
			set Text = $GET(cmd)_$$$NL
			if ChatId>0,'..IsPermiss(token,ChatId) { //not allowed yet
				set msg = ##class(appmsw.telestat.Msg.ButtonRequest).%New()
				set msg.Text = Text_"For information, you need to provide a phone number"
				set msg.Button = "Provide phone number"			
			} 
			elseif ..IsPermiss(token,ChatId) {
				/// Put List commands for currently user
				set co=""
				for { set co=$Order(cmd(co)) quit:co=""
					set Text = Text_co_" - "_$LG(cmd(co),4)_$$$NL
				}
				set msg.Text=Text
			}
		}
		elseif($e(pInput.message.text,1)="/") { //any command
			set comm=pInput.message.text
			if '..IsPermiss(token,ChatId) { //not allowed yet
				set msg.Text="The admin has not confirmed your right to receive information"_$$$NL
				do ##class(appmsw.telestat.API.util).ToAdmin("New request for information from "_NameFirst_" "_NameLast_"("_ChatId_")")
			} else {
				//response to command for currently user
				set msg.Text=Text_"Response to command:"
				
				;m ^tmp($i(^tmp),"Merge2")=cmd
				;m ^tmp($i(^tmp),"Merge3")=@..#GNtmp@("Command",ChatId)
				
				if $GET(cmd(comm))'="" set command=$GET(cmd(comm))
				else  set command=$GET(@..#GNtmp@("Command",ChatId,comm))
				if command="" set msg.Text="Error node command" quit
				
				;s ^tmp($i(^tmp),"set")=$lg(command,3)
				
				Try {
	  			  if $lg(command,5)'="" xecute "do "_$lg(command,5) //routine TODO
	  			  else  do $classmethod($lg(command,1),$lg(command,2),$lg(command,3),.return,command,ChatId,token,NameFirst,NameLast)
	  			  set msg.Text=Text_$GET(return)_$$$NL
				} Catch ex {
				   ;Set sc = $g(%objlasterror, $$$OK)
				   ;Set sc = $$$ADDSC(sc, ex.AsStatus())
				   set msg.Text=Text_"Error code "_$ZE_$$$NL
				 }
			}
		}
		elseif (pInput.message.contact."phone_number" '= "") {
			// update with phonenumber - someone clicked the button. Update Lookup table
			set phone = pInput.message.contact."phone_number"
			set phone = $tr(phone,"+ -()")
			// Place the number in the database and tell the admin that they are asking for permission
			if '..IsPermiss(token,ChatId,phone) { //not allowed yet - permission denied
				set msg.Text = "Your number has been accepted. A confirmation from the administrator about permission to receive information on servers is awaiting"
				
				set from=NameFirst_" "_NameLast_" +"_phone
				//We use the global node to save and transfer private information between information exchange sessions
				set GNtmp=..#GNtmp
				set gnId=$i(@..#GNtmp@("Admin"))
				set @..#GNtmp@("Admin",gnId)=$lb($h,token,ChatId,phone,NameFirst,NameLast)
				set butt="=Access:Yes("_gnId_"),=Access:Deny("_gnId_")"
				do ##class(appmsw.telestat.API.util).ToAdmin(" Request for access to information from "_from,butt)
			} else {		
				//if you have permission
				set msg.Text = "Confirmation received from the administrator about permission to receive information on servers"
			}
		} else  {
			s emo=$wc($zhex("1F6AB")) ;
			set msg.Text =emo_$$$FormatText("Command (%1) is not supported",pInput.message.text)
		}
	}
	Catch ex {
	   set msg.Text=msg.Text_$g(Text)_"Error "_$ZE_$$$NL
	}

	set msg.ChatId = pInput.message.chat.id	
	;set $$$AppL("TLG",ChatId_"-Output")=$$$AppObJs(msg)
	return $$$OK
}

}

