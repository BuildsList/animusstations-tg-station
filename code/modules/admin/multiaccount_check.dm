/client/proc/checkAccount()  // Украли с грина для вайта
	set name = "Check multiaccounts"
	set category = "Admin"
	var/target = input(usr, "Напечатайте ckey, который нужно проверить.", "Ckey") as text|null
	if(!target) //Cancel теперь работает
		return
	showAccounts(src, target)



/proc/showAccounts(var/mob/user, var/targetkey)

	var/output = "<center><table border='1'> <caption>Совпадение по computerID</caption><tr> <th width='100px' >ckey</th><th width='100px'>firstseen</th><th width='100px'>lastseen</th><th width='100px'>ip</th><th width='100px'>computerid </th></tr>"

	var/DBQuery/query = dbcon.NewQuery("SELECT ckey,firstseen,lastseen,ip,computerid FROM erro_player WHERE computerid IN (SELECT DISTINCT computerid FROM erro_player WHERE ckey LIKE '[targetkey]')")
	query.Execute()
	while(query.NextRow())
		output+="<tr><td>[query.item[1]]</td>"
		output+="<td>[query.item[2]]</td>"
		output+="<td>[query.item[3]]</td>"
		output+="<td>[query.item[4]]</td>"
		output+="<td>[query.item[5]]</td></tr>"

	output+="</table>"

	output += "<center><table border='1'> <caption>Совпадение по IP</caption><tr> <th width='100px' >ckey</th><th width='100px'>firstseen</th><th width='100px'>lastseen</th><th width='100px'>ip</th><th width='100px'>computerid </th></tr>"

	query = dbcon.NewQuery("SELECT ckey,firstseen,lastseen,ip,computerid FROM erro_player WHERE ip IN (SELECT DISTINCT ip FROM erro_player WHERE computerid IN (SELECT DISTINCT computerid FROM erro_player WHERE ckey LIKE '[targetkey]'))")
	query.Execute()
	while(query.NextRow())
		output+="<tr><td>[query.item[1]]</td>"
		output+="<td>[query.item[2]]</td>"
		output+="<td>[query.item[3]]</td>"
		output+="<td>[query.item[4]]</td>"
		output+="<td>[query.item[5]]</td></tr>"

	output+="</table></center>"

	user << browse(output, "window=accaunts;size=600x400")


//fix it
/datum/admins/proc/checkAllAccounts()
	set name = "Check multiaccounts(All)"
	set category = "Admin"

	var/DBQuery/query
	var/t1 = ""
	var/output = "Это может пока плохо работать (сломать всё к чёрту), но падеюсь, всё хорошо :^)<br><B>Совпадение по IP</B><BR><BR>"


	try

		for (var/client/C in clients)
			t1 =""
			query = dbcon.NewQuery("SELECT ckey,lastseen,computerid FROM erro_player WHERE ip IN (SELECT DISTINCT ip FROM erro_player WHERE computerid IN (SELECT DISTINCT computerid FROM erro_player WHERE ckey LIKE '[C.ckey]'))")
			query.Execute()
			var/c = 0
	
			while(query.NextRow())
				c++
				var/CkeyItem = query.item[1]
				var/LasLogin = query.item[2]
				var/ComputerId = query.item[3]
				t1 +="[c]: - [CkeyItem] Последний вход: [LasLogin] с компуктера: [ComputerId]  <A href='?_src_=holder;newban=\ref[CkeyItem]'>(Ban)</A><BR>"
	
			if (c > 1)
				try
					output+= "Ckey: <a href='?_src_=holder;adminplayeropts=\ref[C.ckey]>[C.ckey]</a>  <A href='?_src_=holder;showmultiacc=\ref[C.ckey]'>(Show)</A><BR>"	 + t1
				catch(var/exception/e)
					output+= "Ckey: [C.ckey] <A href='?_src_=holder;showmultiacc=\ref[C.ckey]'>(Show)</A><BR>" + t1
					if(check_rights(R_DEBUG))
						usr << "[e] on [e.file]:[e.line]"
					
					
		output+="</table>"
		output+= "<BR><BR><B>Совпадение по computerID</B><BR><BR>"
	
		for (var/client/C in clients)
			t1 =""
			query = dbcon.NewQuery("SELECT ckey,lastseen,computerid FROM erro_player WHERE computerid IN (SELECT DISTINCT computerid FROM erro_player WHERE ckey LIKE '[C.ckey]')")
			query.Execute()
			var/c = 0
			while(query.NextRow())
				c++
				var/CkeyItem = query.item[1]
				var/LasLogin = query.item[2]
				var/ComputerId = query.item[3]
				t1 +="[c]: [CkeyItem] Последний вход: [LasLogin] с компьютера: [ComputerId]<BR>"
			if (c > 1)
				output+= "Ckey: [C.ckey] <A href='?_src_=holder;showmultiacc=\ref[C.ckey]'>Show</A><BR>" + t1
	
		usr << browse(output, "window=accauntsall;size=500x500")
		
	catch(var/exception/e)
		if(check_rights(R_DEBUG))
			usr << "[e] on [e.file]:[e.line]"
			
		for (var/client/C in clients)
			t1 =""
			query = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE ip IN (SELECT DISTINCT ip FROM erro_player WHERE computerid IN (SELECT DISTINCT computerid FROM erro_player WHERE ckey LIKE '[C.ckey]'))")
			query.Execute()
			var/c = 0
	
			while(query.NextRow())
				c++
				var/CkeyItem = query.item[1]
				t1 +="[c]: - [query.item[1]]  <A href='?_src_=holder;newban=CkeyItem'>(Ban)</A><BR>"
			if (c > 1)
				output+= "Ckey: [C.ckey] <A href='?_src_=holder;showmultiacc=[C.ckey]'>Show</A><BR>" + t1
		output+="</table>"
		output+= "<BR><BR><B>?????????? ?? computerID</B><BR><BR>"
	
		for (var/client/C in clients)
			t1 =""
			query = dbcon.NewQuery("SELECT ckey FROM erro_player WHERE computerid IN (SELECT DISTINCT computerid FROM erro_player WHERE ckey LIKE '[C.ckey]'))")
			query.Execute()
			var/c = 0
			while(query.NextRow())
				c++
				t1 +="[c]: [query.item[1]]<BR>"
			if (c > 1)
				output+= "Ckey: [C.ckey] <A href='?_src_=holder;showmultiacc=[C.ckey]'>Show</A><BR>" + t1
	
		usr << browse(output, "window=accauntsall;size=400x500")