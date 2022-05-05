/obj/machinery/computer3/atmos_alert
	default_prog = /datum/file/program/atmos_alert
	spawn_parts = list(/obj/item/part/computer/storage/hdd,/obj/item/part/computer/networking/radio)
	icon_state = "frame-eng"

/datum/file/program/atmos_alert
	name = "atmospheric alert monitor"
	desc = "Recieves alerts over the radio."
	active_state = "alert:2"
	refresh = 1


	var/list/priority_alarms = list()
	var/list/minor_alarms = list()
	var/receive_frequency = 1437
	var/datum/radio_frequency/radio_connection

	execute(var/datum/file/program/source)
		..(source)

		if(!computer.radio)
			computer.Crash(MISSING_PERIPHERAL)

		computer.radio.set_frequency(1437,RADIO_ATMOSIA)

	// This will be called as long as the program is running on the parent computer
	// and the computer has the radio peripheral
	receive_signal(datum/signal/signal)
		if(!signal || signal.encryption) return

		var/zone = signal.data["zone"]
		var/severity = signal.data["alert"]

		if(!zone || !severity) return

		minor_alarms -= zone
		priority_alarms -= zone
		if(severity=="severe")
			priority_alarms += zone
		else if (severity=="minor")
			minor_alarms += zone
		update_icon()
		return


	interact()
		var/datum/browser/popup = new(usr, "computer", name)
		popup.set_content(return_text())
		popup.set_title_image(usr.browse_rsc_icon(computer.icon, computer.icon_state))
		popup.open()


	update_icon()
		..()
		if(priority_alarms.len > 0)
			overlay.icon_state = "alert:2"
		else if(minor_alarms.len > 0)
			overlay.icon_state = "alert:1"
		else
			overlay.icon_state = "alert:0"

		if(computer)
			computer.update_icon()


	proc/return_text()
		var/priority_text
		var/minor_text

		if(priority_alarms.len)
			for(var/zone in priority_alarms)
				priority_text += "<FONT color='red'><B>[format_text(zone)]</B></FONT>  <A href='?src=\ref[src];priority_clear=[ckey(zone)]'>X</A><BR>"
		else
			priority_text = "No priority alerts detected.<BR>"

		if(minor_alarms.len)
			for(var/zone in minor_alarms)
				minor_text += "<B>[format_text(zone)]</B>  <A href='?src=\ref[src];minor_clear=[ckey(zone)]'>X</A><BR>"
		else
			minor_text = "No minor alerts detected.<BR>"

		var/output = {"<h2>Priority Alerts:</h2>
	[priority_text]
	<BR>
	<HR>
	<h2>Minor Alerts:</h2>
	[minor_text]
	<BR>"}

		return output



	Topic(var/href, var/list/href_list)
		if(..())
			return

		if(href_list["priority_clear"])
			var/removing_zone = href_list["priority_clear"]
			for(var/zone in priority_alarms)
				if(ckey(zone) == removing_zone)
					usr << "\green Priority Alert for [format_text(zone)] cleared."
					priority_alarms -= zone

		if(href_list["minor_clear"])
			var/removing_zone = href_list["minor_clear"]
			for(var/zone in minor_alarms)
				if(ckey(zone) == removing_zone)
					usr << "\green Minor Alert for [format_text(zone)] cleared."
					minor_alarms -= zone
		update_icon()
		return
