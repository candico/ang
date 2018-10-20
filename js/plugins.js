
//From https://www.sitepoint.com/url-parameters-jquery/
$.urlParam = function(name){
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results == null){
       return $.sesUrlParam(name);
    }
    else{
       return results[1] || 0;
    }
}

$.sesUrlParam = function(name){
    var results = new RegExp('/' + name + '/([^/#]*)').exec(window.location.href);
    if (results == null)
       return null;    
    else
       return results[1] || 0;    
}// JavaScript Document

Date.prototype.getAge = function (date) {
    if (!date) date = new Date();
    var feb = (date.getMonth() == 1 || this.getMonth() == 1);
    return ~~((date.getFullYear() + date.getMonth() / 100 + 
        (feb && date.getDate() == 29 ? 28 : date.getDate())
        / 10000) - (this.getFullYear() + this.getMonth() / 100 + 
        (feb && this.getDate() == 29 ? 28 : this.getDate()) 
        / 10000));
}