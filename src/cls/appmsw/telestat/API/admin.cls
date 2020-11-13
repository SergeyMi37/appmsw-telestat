/// Include apptools.core
/// Admin bot
Class appmsw.telestat.API.admin Extends appmsw.telestat.API.service
{

ClassMethod GetMessage(token, pInput As %RegisteredObject, Output msg) As %Status
{
	d ..InitMessage(pInput,token,.msg, .ChatId,.NameFirst,.NameLast,"Admin")	
		
	set Text = ""
	Try {
		do ##class(appmsw.telestat.API.commands).GetCommandsAdmin(.cmd,ChatId,token,NameFirst,NameLast)
		
		if pInput.message.text="/start" {
			set Text = $GET(cmd)_$$$NL
			if ChatId>0,'..IsPermiss(token,ChatId) { //not allowed yet
				set msg = ##class(appmsw.telestat.Msg.ButtonRequest).%New()
				set msg.Text = Text_"To confirm the right to be an administrator, you need to provide a phone number"
				set msg.Button = "Provide admin phone number"	
			} 
			elseif ..IsPermiss(token,ChatId) {
				/// Put List commands for currently admin
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
				set msg.Text="You have not verified admin rights"_$$$NL
			} else {
				//response to command for currently user
				set msg.Text=Text_"Response to command:"

				if $GET(cmd(comm))'="" set command=$GET(cmd(comm))
				else  set command=$GET(@..#GNtmp@("Command",ChatId,comm)) 
				if command="" set msg.Text="Error node command" quit

				Try {
	  			  if $lg(command,5)'="" xecute "do "_$lg(command,5) //routine TODO
	  			  else  do $classmethod($lg(command,1),$lg(command,2),$lg(command,3),.return,command,ChatId,token,NameFirst,NameLast)
	  			  set msg.Text=Text_$GET(return)_$$$NL
				} 
				Catch ex {
				   ;Set sc = $g(%objlasterror, $$$OK)
				   ;Set sc = $$$ADDSC(sc, ex.AsStatus())
				   set msg.Text=Text_"Error "_$ZE_$$$NL
				 }
			}
		}
		elseif($e(pInput.message.text,1)="=") {  //=Allow or =Deny or =Notify or =Do not notify
			if '..IsPermiss(token,ChatId) {
				set msg.Text="You have not verified admin rights"_$$$NL
			} else {
				set buttontext=$e(pInput.message.text,2,*)
				
				// We use the global node to save and transfer private information between information exchange sessions
				set id=$p(buttontext,":",3) 
				set $lb(gh,gtoken,gChatId,gphone,gNameFirst,gNameLast)=$G(@..#GNtmp@("Admin",id))
				
				if '$d(gChatId) set msg.Text="Error node " quit
				
				#dim ob As appmsw.telestat.Bots
				set ob=##class(appmsw.telestat.Bots).GetObjByNumber(gphone)
				if '$isobject(ob)  set ob=##class(appmsw.telestat.Bots).%New()
				set ob.ChatId=gChatId
				set:gNameFirst'="" ob.NameFirst=gNameFirst
				set:gNameLast'="" ob.NameLast=gNameLast
				set:gtoken'="" ob.TelegramToken=gtoken
				set ob.Roles="informer"
				set:gphone'="" ob.Number=gphone
				set Property=$P(buttontext,":")
				set Value=$P(buttontext,":",2)
				set $Property(ob,Property)=Value
				set st=ob.%Save()
				if st {
					set Mess=" Admin response: "_$p(buttontext,":",1,2)
					do ##class(appmsw.telestat.API.util).ToInformer(,gChatId,gtoken,Mess)
				}
				else { 
					set Mess=" Error "_$System.Status.GetErrorText(st)_" "_buttontext
				}
				set msg.Text = msg.Text _ Mess
			}
		}
		elseif (pInput.message.contact."phone_number" '= "") {
			set phone = pInput.message.contact."phone_number"
			set phone = $tr(phone,"+ -")
			;Compare number	
			#dim obj As appmsw.telestat.Bots
			set obj=##class(appmsw.telestat.Bots).GetObjByNumber(phone,1)
			if $isobject(obj) {
				set msg.Text = "Your number has been successfully accepted"
				set obj.ChatId=ChatId
				set obj.NameFirst=NameFirst
				set obj.NameLast=NameLast
				set obj.Allow=1
				set obj.Access="Yes"
				set obj.Notify="Yes"
				set st=obj.%Save()
				if st set Mess=" ОК"
				else  set Mess=" Error "_$System.Status.GetErrorText(st)
				set msg.Text = msg.Text _ Mess
			} else {		
				set msg.Text = "Your number is not included in the allowed table. Check the correctness of the initial data"
			}
		}
		else {
			s emo=$wc($zhex("1F6AB")) ;
			set msg.Text =emo_$$$FormatText("Command (%1) is not supported",pInput.message.text)
		}
	}
	Catch ex {
	   set msg.Text=msg.Text_$g(Text)_"Error "_$ZE_$$$NL
	}
	set msg.ChatId = pInput.message.chat.id	
	;set $$$AppL("ADM",ChatId_"-Output")=$$$AppObJs(msg)
	return $$$OK
}

/// Get a brief status of users
/// d ##class(appmsw.telestat.API.admin).GetUsers()
ClassMethod GetUsers(err) As %Status
{
	s ret="Status users:"_$$$NL
	quit ret
}

}

