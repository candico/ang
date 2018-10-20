
function setStaffGrid(el) {
	$(el).kendoGrid({		
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
}

var staffDataSource = new kendo.data.DataSource({
	transport: {					
		read: {
			url: "index.cfm?action=staff.getlocalStaff",
			dataType: "json",
			type: "POST"
		}	
	}
});
	
var onDataBound = function(el, e) {	
	//set a function to react to the click event on a grid row
    $(el).find("tr").click(clickRowFun);
};

var clickRowFun = function (el, e) {
	//function to open the staff member detail view
    var dataItem = $(el).data("kendoGrid").dataItem(this);	
    if(e.ctrlKey)
       console.log('Ctrl + click on ' + dataItem.staff_member_id);
};