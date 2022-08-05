var ajaxHelper = new AjaxHelper();

//첨부파일 삭제
function fnFileDeleteNew(id, a, param) {
	let strParam = "'" + param + "'";
	_deletea = a;

	bootConfirm('삭제하시겠습니까?', function () {
		_fbox = $(a).closest("div.fgbox");
		ajaxHelper.CallAjaxPost("/Common/FileDelete", { param1: id }, "fnCallbackDelFile", strParam);
	})

	//if (confirm('삭제 하시겠습니까?')) {
	//	_fbox = $(a).closest("div.fgbox");
	//	ajaxHelper.CallAjaxPost("/Common/FileDelete", { param1: id }, "fnCallbackDelFile", strParam);
	//}
}

//첨부파일 삭제 콜백
function fnCallbackDelFile(strParam) {
	
	var result = ajaxHelper.CallAjaxResult();
	if (result == 1) {
		if (($(_deletea).closest(".fgbox").attr("data-imageid") || "") != "") {
			$("#" + $(_deletea).closest(".fgbox").attr("data-imageid")).attr("src", "/content/images/common/arrow_white.png");
		}
		if (_fbox.attr("data-hidemode") == "1") {
			_fbox.find(".input-group").show();
		}
		$(_deletea).closest(".fileitembox").remove();
		fnResetFile(strParam);

		bootAlert('삭제되었습니다');
		//alert("삭제되었습니다.", 1);
		
	}
	else {
		bootAlert("삭제할 권한이 없습니다.");
		//alert("삭제할 권한이 없습니다.", 1);
	}
}

var _fbox;
function fnResetFile(strParam) {
	if (strParam == "Y") {
		location.reload();
	} else {
		if (fnGetInt(_fbox.attr("data-filecount")) > _fbox.find("input[type=file]").length + $(_fbox).find("a.btn_txt").length && _fbox.find("input[data-empty='1']").length < 1) {
			_fbox.append("<div class=\"input-group mt-1\"><input title=\"첨부파일\" id=\"files\" type=\"file\" name=\"" + _fbox.attr("data-fname") + "\" data-empty=\"1\"></div>");
		}
		else if (_fbox.find("input[type=file][data-empty='1']").length > 1) {
			$.each(_fbox.find("input[type=file][data-empty='1']"), function (i, e) {
				$(this).closest("div.input-group").remove();
			});
			_fbox.append("<div class=\"input-group mt-1\"><input title=\"첨부파일\" id=\"files\" type=\"file\" name=\"" + _fbox.attr("data-fname") + "\" data-empty=\"1\"></div>");
		}
    }
}

function fnGetInt(v) {
	v = v == null || v == "" ? 0 : v;
	v = v.toString();
	v = v.replace(/,/gi, '');
	if (isNaN(parseInt(v, 10)))
		return 0;
	return parseInt(v, 10);
}

var _filecontrol;
var _filesize = 838860800;
var _filemax = "800 Mega ";
$(document).ready(function () {
	$("body").first().append("<form id=\"frmFile\" method=\"POST\"></form>");
	$("body").on("change", "input#files", function (e) {
		$(this).parent().find("input.file_input_textbox").val($(this).val());
		var fbox = $(this).closest("div.fgbox");
		if ($(this).val() != "") {
			//$(this).parent().find("input.file_input_textbox").val($(this).val());
			_filecontrol = $(this);
			var fname = $(this).val().toUpperCase();
			var fext = fname.split('.')[fname.split('.').length - 1];
			var bytes = $(this)[0].files.length > 0 ? $(this)[0].files[0].size : 0;
			if (fbox.attr("data-isimage") == "1" && fext != "JPG" && fext != "GIF" && fext != "PNG") {
				$(this).val("");
				bootAlert("이미지만 첨부해주세요.", 1);
			}
			else if (",XLSX,XLS,HWP,PDF,ZIP,JPG,GIF,PNG,TXT,PPTX,PPT,DOC,DOCX,PSD,MP4,MP3,WAV,WMV,SHOW,ODP,DWG,JPEG,V,M4A,MOV,CUIX,PPS,M4A,".indexOf("," + fext + ",") < 0) {
				$(this).val("");
				bootAlert("허용된 파일유형이 아닙니다.", 1);
			}
			else if (bytes > (_filesize || 838860800)) {
				bootAlert('파일제한 크기는 ' + (_filemax || "800 Mega ") + "입니다.", 1);
				$(this).val("");
			}
		}
		if ($(this).closest(".fgbox").attr("data-imageid") != "") {
			if ($(this).val() == "") {
				var dimg = ($(this).closest(".fgbox").attr("data-dftsrc") || "") == "" ? "/Content/images/common/thum_noimage.gif" : $(this).closest(".fgbox").attr("data-dftsrc");
				$("#" + $(this).closest(".fgbox").attr("data-imageid")).attr("src", dimg);
			}
			else {
				var files = e.target.files;
				var filesArr = Array.prototype.slice.call(files);
				var fitem = $(this);
				filesArr.forEach(function (f) {
					if (!f.type.match("image.*")) {
						//alert("Not Image File.");
						return;
					}
					sel_file = f;
					var reader = new FileReader();
					reader.onload = function (e) {
						$("#" + $(fitem).closest(".fgbox").attr("data-imageid")).attr("src", e.target.result);
					}
					reader.readAsDataURL(f);
				});
				$("#" + $(this).closest(".fgbox").attr("data-imageid")).show();
			}
		}
		$(this).attr("data-empty", 1);
		if ($(this).val() != "") {
			$(this).attr("data-empty", 0);
		}
		_fbox = fbox;
		fnResetFile();
	});
});