function readText(filePath) {
    var reader = new FileReader();
    var output = ""; //placeholder for text output
    if (filePath.files && filePath.files[0]) {
        reader.onload = function (e) {
            output = e.target.result;
            displayContents(output);
        };//end onload()
        reader.readAsText(filePath.files[0]);
    }//end if html5 filelist support
    else if (ActiveXObject && filePath) { //fallback to IE 6-8 support via ActiveX
        reader = new ActiveXObject("Scripting.FileSystemObject");
        var file = reader.OpenTextFile(filePath, 1); //ActiveX File Object
        output = file.ReadAll(); //text contents of file
        file.Close(); //close file "input stream"
        displayContents(output);
    }
}
function isJson(json) {
    try {
        JSON.parse(json);
        return true;
    }
    catch (e) { return false; }
}

function isXML(xml) {
    try {
        $.parseXML(xml); //is valid XML
        return true;
    }
    catch (err) {
        // was not XML
        return false;
    }
}

function displayContents(txt) {
    if (isJson(txt)) {
        var jsonPretty = JSON.stringify(JSON.parse(txt), null, 4);
        $('#ViewText').text(jsonPretty);
        document.getElementById('<%=ImportFileText.ClientID %>').value = txt;
    }
    else if (isXML(txt)) {
        $('#ViewText').text(txt);
        document.getElementById('<%=ImportFileText.ClientID %>').value = txt;
    }
    else {
        $('#ViewText').text(jsonPretty);
        document.getElementById('<%=ImportFileText.ClientID %>').value = "NOT JSON NOT XML";
    }
}