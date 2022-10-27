$(function() {
    $("#togBtn").on('change', function(e) {
        if (e.target.checked){
                chrome.storage.local.set({'sS': true}, function(){
                    chrome.browserAction.setIcon({path: "icon48.png"});
                    //alert('saved: True');
                });
        } else {
            chrome.storage.local.set({'sS': false}, function(){
                chrome.browserAction.setIcon({path: "iconGray.png"});
            //alert('saved: False');
            });
        }
});

    //kill switch for 7/1/21
    var Jul722 = 1656651600000;
    if(Date.now() > Jul722){
        chrome.storage.local.set({'sS': false}, function(){});
        chrome.b
        browserAction.setIcon({path: "iconGray.png"});
    }
    
    chrome.storage.local.get('sS', function(status){
        var switchStatus = status.sS;

        if(switchStatus) {
            $('#togBtn').prop('checked', true);
        } else {
            $('#togBtn').prop('checked', false);
        }
    });
});

