/client/proc/web_parsing()
	set category = "Special Verbs"
	set name = "Parsing"
	if(!check_rights(0))	return

	var/URL = "http://www.byond.com/members/"
	var/playerCkey = null
	var/JoinDate = null
	var/ReturnValue = null

	var/PageCache = null

	playerCkey = input("Enter Ckey.","","")
	if(!playerCkey)	return usr << "Empty field."

	URL = URL + playerCkey

	PageCache = getFiles(URL)

	dat = [JoinDate] = document.getElementById("info_text").innerText;

	usr << dat
