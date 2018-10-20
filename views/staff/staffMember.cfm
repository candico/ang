
<div style="padding-top: 10px">
	<div id="staffMemberTabStrip">   
        <ul>
            <li class="k-state-active">
                General Data
            </li>
            <li>
                Family Data
            </li>
            <li>
                Professional Experience
            </li>           
        </ul> 
        <div></div>
        <div></div>
        <div></div>
        <div></div>
        <div></div>  
	</div>
</div>    


<script>

	$(document).ready(function() {
		
		var ts = $("#staffMemberTabStrip").kendoTabStrip({
            animation: { open: { effects: "fadeIn"} },
            contentUrls: [
				'index.cfm?action=staff.editStaffMemberBasics',
				'index.cfm?action=staff.editStaffMemberBasics',
				'index.cfm?action=staff.editStaffMemberBasics',
			]			
        }).data('kendoTabStrip');
		
	});
	
</script>



