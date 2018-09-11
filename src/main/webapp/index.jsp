<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>testing</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style type="text/css">
#filecontents {
	border: single;
	overflow-y: scroll;
	overflow-x: scroll;
	height: 400px;
}
</style>
<style type="text/css">
#submit {
	text-align: center;
  	margin:0 auto;
}


.row{
 display: inline-block;
 text-align: center;
 float: left;
 width: 50%;
}

</style>
<body>
	<form method="post">
		<label for="file"> <span>Source/Target</span> <input
			type="text" />
		</label> 
		<label>
		<span>FileImport:</span> <input type="file" id="txtfiletoread" /> 
		</label>
		<label>
		<button type='button' class="btn" id='submit2'
			name='submit2' onClick="download('test.py')">Export</button>
		</label>
		<br />
		<br />
		
		<div style="text-align: center;">
		<button  type='button' id='printbtn' value="print">print</button>
		<button  type='button' id='maxbtn' value="max" onClick="printVal(this.id)">max</button>
		<button  type='button' id='minbtn' value="min" onClick="printVal(this.id)">min</button>
		</div>

		<br />
		<br />
		

		<div class="row">
			<p>Code:</p>
			<textarea style="width: 70%" id="filecontents" name="filecontents"></textarea>
		</div>
	
		<div class="row">
			<p>Output:</p>
			<textarea readonly style="width: 30%" id='outputArea' rows="26" cols="5"
				style="float: right" ></textarea>
		</div> 
		<br/> <br/>
		<br/> <br/>
		<div style="text-align: left;">
		<button type='button' class="btn" id='submit'
			name='submit'>Execute</button>
		</div>  
	</form>

</body>
<script type="text/javascript">
window.onload = function() {
    //Check the support for the File API support
    if (window.File && window.FileReader && window.FileList && window.Blob) {
        var fileSelected = document.getElementById('txtfiletoread');
        fileSelected.addEventListener('change', function(e) {
            //Set the extension for the file
            var fileExtension = /text.*/;
            //Get the file object
            var fileTobeRead = fileSelected.files[0];
            //Check of the extension match
            if (fileTobeRead.type.match(fileExtension)) {
                //Initialize the FileReader object to read the 2file
                var fileReader = new FileReader();
                fileReader.onload = function(e) {
                    var fileContents = document.getElementById('filecontents');
                    fileContents.innerText = fileReader.result;
                }
                fileReader.readAsText(fileTobeRead);
            } else {
                alert("Please select text file");
            }

        }, false);
    } else {
        alert("Files are not supported");
    }
}

	function download(fileName) {
	  	var fileContent = document.getElementById("filecontents").value;
	  	fileContent = fileContent.replace(/<br>/g, '\n');
	  
	  	document.getElementById("outputArea").value = fileContent;
	  	var element = document.createElement('a');
	  	element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(fileContent));
	  	element.setAttribute('download', fileName);
	  
	  	element.style.display = 'none';
	  	document.body.appendChild(element);
	  
	  	element.click();
	  
	  	document.body.removeChild(element);
	  }
	
	$(document).on("click", "#submit", function() {
		console.log("test");
		var val = encodeURIComponent($('#filecontents').val());
		console.log(val);
		$.post("./Testing", {
			"name" : val
		}, function(responseText) {
			$("#outputArea").val(responseText);
		});
	});
	
	
	$(document).delegate('#filecontents', 'keydown', function(e) {
 	   var keyCode = e.keyCode || e.which;

 	   if (keyCode == 9) {
 	     e.preventDefault();
 	     var start = this.selectionStart;
 	     var end = this.selectionEnd;

 	     // set textarea value to: text before caret + tab + text after caret
 	     $(this).val($(this).val().substring(0, start)
 	                 + "\t"
 	                 + $(this).val().substring(start));

 	     // put caret at right position again
 	     this.selectionStart =
 	     this.selectionEnd = start + 1;
 	   }
 	 });
	

	$(document).on('click', '#printbtn', () => {
		   var start = $('#filecontents')[0].selectionStart;
	       var end = $('#filecontents')[0].selectionEnd;
	       var val = 'print ("")';
	 	   $('#filecontents').val($('#filecontents').val().substring(0, start)
	                 + val
	                 + $('#filecontents').val().substring(start));
	 	   $('#filecontents').focus();
	 	   $('#filecontents')[0].selectionStart =
	 		  $('#filecontents')[0].selectionEnd = start + val.length -2;
	 	   }
	 );
	
	function printVal(id){
	   var start = $('#filecontents')[0].selectionStart;
	   var end = $('#filecontents')[0].selectionEnd;
	   var val = (id == 'maxbtn') ? "max ()" : "min ()";
	  $('#filecontents').val($('#filecontents').val().substring(0, start)
              + val
              + $('#filecontents').val().substring(start));
	   $('#filecontents').focus();
	   $('#filecontents')[0].selectionStart = $('#filecontents')[0].selectionEnd = start + val.length -1;
	}
</script>
</html>