<cfoutput>

<form name="viewPreparationForm" id="viewPreparationForm" class="form-horizontal" novalidate>
<input type="hidden" name="evaluation_id" id="evalusation_id" value="" />

<div class="panel panel-default">
    
    <div class="row" style="padding:3px">
    
        <div class="col-sm-4 padding-right-3">
        
            <div class="well well-sm">
            
                <fieldset>
                
                    <legend class="scheduler-border">Participants</legend>
                
                    <div class="form-group">	            
                        <label for="evaluee" class="col-sm-3 control-label"><span class="label label-primary">Evaluee</span></label>  
                        <div class="col-sm-8 form-control-div">  
                            <p class="form-control-static">{{setPrepCtrl.evaluee.name}}</p>
                        </div>
                    </div>  
                    
                    <div class="form-group">	            
                        <label for="supervisor" class="col-sm-3 control-label"><span class="label label-primary">Supervisor</span></label>  
                        <div class="col-sm-8 form-control-div">                  
                            <p class="form-control-static">{{setPrepCtrl.supervisor.name}}</p>
                        </div>
                    </div>  
                    
                    <div class="form-group">	            
                        <label for="contributor_1" class="col-sm-3 control-label"><span class="label label-primary">Contributor 1</span></label>  
                        <div class="col-sm-8 form-control-div">                  
                            <p class="form-control-static">{{setPrepCtrl.contributor_1.name}}</p>
                        </div>
                    </div>        
                    
                	<div class="form-group">	            
                        <label for="contributor_2" class="col-sm-3 control-label"><span class="label label-primary">Contributor 2</span></label>  
                        <div class="col-sm-8 form-control-div">                  
                            <p class="form-control-static">{{setPrepCtrl.contributor_2.name}}</p>
                        </div>
                    </div>       
                    
                	<div class="form-group">	            
                        <label for="contributor_3" class="col-sm-3 control-label"><span class="label label-primary">Contributor 3</span></label>  
                        <div class="col-sm-8 form-control-div">                  
                            <p class="form-control-static">{{setPrepCtrl.contributor_3.name}}</p>
                        </div>
                    </div>      
                    
                	<div class="form-group">	            
                        <label for="hrfp" class="col-sm-3 control-label"><span class="label label-primary">HR FP / D4</span></label>  
                        <div class="col-sm-8 form-control-div">                  
                           <p class="form-control-static">{{setPrepCtrl.hrfp.name}}</p>
                        </div>
                    </div>     
                    
                	<div class="form-group">	            
                        <label for="hoo" class="col-sm-3 control-label"><span class="label label-primary">HoO / HoU</span></label>  
                        <div class="col-sm-8 form-control-div">                  
                            <p class="form-control-static">{{setPrepCtrl.hoo.name}}</p>
                        </div>
                    </div>                                                                      
                    
                </fieldset>
                
            </div> <!---end well--->  
        
        </div>  <!---end col 1--->    
        
        <div class="col-sm-4 padding-right-3">
        
            <div class="well well-sm">
            
                <fieldset>
                
                    <legend class="scheduler-border">Timetable</legend>
                    
                    <div class="form-group">	            
                        <label class="col-sm-3 control-label"><span class="label label-primary">Evaluation Period</span></label>                	
                        <div class="form-group col-sm-4">    	            
                            <label class="col-sm-4 control-label" style="font-weight:normal; font-style:italic">[From]</label> 
                            <div class="col-sm-8 form-control-div"> 
                                <input ng-model="setPrepCtrl.data.eval_period_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="eval_period_from" id="eval_period_from">                
                            </div>
                        </div>                
                         <div class="form-group col-sm-4">				
                            <label class="col-sm-4 control-label" style="font-weight:normal; font-style:italic">[Until]</label> 
                             <div class="col-sm-8 form-control-div"> 
                                <input ng-model="setPrepCtrl.data.eval_period_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="eval_period_until" id="eval_period_until">
                            </div>                        
                        </div>
                    </div>    
                    
                    <div class="form-group">	            
                        <label class="col-sm-3 control-label"><span class="label label-primary">Preparation</span></label>                	
                        <div class="form-group col-sm-4">    	            
                            <label class="col-sm-4 control-label" style="font-weight:normal; font-style:italic">[From]</label> 
                            <div class="col-sm-8 form-control-div"> 
                                <input ng-model="setPrepCtrl.data.prep_phase_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="prep_phase_from" id="prep_phase_from">                
                            </div>
                        </div>                
                         <div class="form-group col-sm-4">				
                            <label class="col-sm-4 control-label" style="font-weight:normal; font-style:italic">[Until]</label> 
                             <div class="col-sm-8 form-control-div"> 
                                <input ng-model="setPrepCtrl.data.prep_phase_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="prep_phase_until" id="prep_phase_until">
                            </div>                        
                        </div>
                    </div>       
                    
                    <div class="form-group">	            
                        <label class="col-sm-3 control-label"><span class="label label-primary">Self-Assessment</span></label>                	
                        <div class="form-group col-sm-4">    	            
                            <label class="col-sm-4 control-label" style="font-weight:normal; font-style:italic">[From]</label> 
                            <div class="col-sm-8 form-control-div"> 
                                <input ng-model="setPrepCtrl.data.assess_phase_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="assess_phase_from" id="assess_phase_from">                
                            </div>
                        </div>                
                         <div class="form-group col-sm-4">				
                            <label class="col-sm-4 control-label" style="font-weight:normal; font-style:italic">[Until]</label> 
                             <div class="col-sm-8 form-control-div"> 
                                <input ng-model="setPrepCtrl.data.assess_phase_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="assess_phase_until" id="assess_phase_until">
                            </div>                        
                        </div>
                    </div>    
                    
                    <div class="form-group">	            
                        <label class="col-sm-3 control-label"><span class="label label-primary">Evaluation</span></label>                	
                        <div class="form-group col-sm-4">    	            
                            <label class="col-sm-4 control-label" style="font-weight:normal; font-style:italic">[From]</label> 
                            <div class="col-sm-8 form-control-div"> 
                                <input ng-model="setPrepCtrl.data.eval_phase_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="eval_phase_from" id="eval_phase_from">                
                            </div>
                        </div>                
                         <div class="form-group col-sm-4">				
                            <label class="col-sm-4 control-label" style="font-weight:normal; font-style:italic">[Until]</label> 
                             <div class="col-sm-8 form-control-div"> 
                                <input ng-model="setPrepCtrl.data.eval_phase_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="eval_phase_until" id="eval_phase_until">
                            </div>                        
                        </div>
                    </div>    
                    
                    <div class="form-group">	            
                        <label class="col-sm-3 control-label"><span class="label label-primary">Closing &amp; Follow-up</span></label>                	
                        <div class="form-group col-sm-4">    	            
                            <label class="col-sm-4 control-label" style="font-weight:normal; font-style:italic">[From]</label> 
                            <div class="col-sm-8 form-control-div"> 
                                <input ng-model="setPrepCtrl.data.closing_phase_from" type="text" class="form-control" placeholder="dd/mm/yyyy" name="closing_phase_from" id="closing_phase_from">                
                            </div>
                        </div>                
                         <div class="form-group col-sm-4">				
                            <label class="col-sm-4 control-label" style="font-weight:normal; font-style:italic">[Until]</label> 
                             <div class="col-sm-8 form-control-div"> 
                                <input ng-model="setPrepCtrl.data.closing_phase_until" type="text" class="form-control" placeholder="dd/mm/yyyy" name="closing_phase_until" id="closing_phase_until">
                            </div>                        
                        </div>
                    </div>                                                                     
                    
                </fieldset>
                
            </div> <!---end well--->  
        
        </div>  <!---end col 2--->  
        
        <div class="col-sm-4 padding-right-3">
        
            <div class="well well-sm">
            
                <fieldset>
                
                    <legend class="scheduler-border">Documents Library</legend>                                                                   
                    
                </fieldset>
                
            </div> <!---end well--->  
        
        </div>  <!---end col 3--->               
        
            

    </div> <!---end row--->
    
    <nav class="navbar navbar-inverse navbar-fixed-bottom">
        <div class="container-fluid">
            <ul class="nav navbar-nav"> 
                <li><a ng-click="setPrepCtrl.backToGrid()" class="pointer-cursor">Back to Grid</a></li> 
                <li><a ng-click="setPrepCtrl.toggleViewEdit('edit')" class="pointer-cursor">Edit</a></li> 
                <li><a ng-click="setPrepCtrl.submitforAuth()" class="pointer-cursor">Submit for Authorization</a></li> 
            </ul>
            <ul class="nav navbar-nav navbar-right">                          
                <li><a ng-click="setPrepCtrl.changeLanguage()" class="pointer-cursor">Change Language</a></li>        	
            </ul>            
        </div>
    </nav>     

</div> <!---end editPrepCtrl--->

</form>

</cfoutput>