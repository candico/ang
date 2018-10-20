<!---<cfoutput>

<script>

var localStaffMemberURL = "#buildURL('staff.localStaffMember')#";

</script>

</cfoutput>--->

<div id="staffGridContainer" style="padding-top: 10px">
<div id="staffGrid" style="padding-top: 10px"></div>
</div>

<div id="staffMemberContainer" >
<div id="staffMember"></div>
</div>

<script>

$(document).ready(function() {

	$("#staffGrid").kendoGrid({		
		dataSource: staffDataSource,
		sortable: true,
		columns: [
			{ field: "staff_member_id", title: "Staff ID" },
			{ field: "last_name", title: "Last Name" },
			{ field: "first_name", title: "First Name" },
			{ field: "job", title: "Job" },			
		],
		dataBound: onDataBound		
	});	
	
	$("#staffGridContainer").toggle(true);
});	

var staffDataSource = new kendo.data.DataSource({
	transport: {					
		read: {
			url: "index.cfm?action=staff.getLocalStaff",
			dataType: "json",
			type: "POST"
		}	
	}
});

var onDataBound = function(e) {	
	//set a function to react to the click event on a grid row
    $("#staffGrid").find("tr").click(clickRowFun);
};

var clickRowFun = function (e) {
	//function to open the staff member detail view
    var dataItem = $("#staffGrid").data("kendoGrid").dataItem(this);	
    if(e.ctrlKey)
       console.log('Ctrl + click on ' + dataItem.staff_member_id);
	   
	var localStaffMemberURL	=  "/FSM/index.cfm?action=staff.staffMember" + "&staff_member_id=" + dataItem.staff_member_id;	   
	$("#staffMember").load(localStaffMemberURL);
	$("#staffGridContainer").toggle(false);
	$("#staffMemberContainer").toggle(true);
	 
	//location.href="/FSM/index.cfm?action=staff.localStaffMember" + "&staff_member_id=" + dataItem.staff_member_id;
	   
};

</script>

