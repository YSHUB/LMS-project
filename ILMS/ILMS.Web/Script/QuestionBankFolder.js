
/*현재 파일 경로*/
var this_js_script = $('script[src*=QuestionBankFolder]'); 

var _pageType = this_js_script.attr('_pageType');
if (typeof _pageType === "undefined") {
    var _pageType = "_pageType is not found, input '_pageType' in script tag referencing this page. \r\n ex) <script src='QuestionBankFolder' _pageType='Index'/>";
}

/*전역변수*/
var selectNodeNo = 0;
var ajaxHelper = new AjaxHelper();

QuestionBankType = $("#hdnQuestionBankType").val();

function fnCategoryClick(e) {
    gubunNo = e.target.id.split('_')[1];

    if (typeof QuestionBankType == 'undefined') {
        QuestionBankType = "MJTP001";
    }

    if (_pageType == "Index") {
        window.location = "/QuestionBank/Index/" + QuestionBankType + "/" + gubunNo;

    } else if (_pageType == "Write" || _pageType == "Update") {

        $("#spanSubtitle").text(e.target.value);
        $("#hdnGubunNo").val(gubunNo);
    }
    else if (_pageType == "List") {
        window.location = "/QuestionBank/List/" + QuestionBankType + "/" + gubunNo;

    }
    else {
        var errorMessage = "_pageType is not found, input '_pageType' in script tag referencing this page. \r\n ex) <script src='QuestionBankFolder' _pageType='Index'/>";
        bootAlert(errorMessage);
    };

}

$(document).ready(function () {

    //카테고리 클릭  
    $("input[name='GubunNos']").on("click", function (e) {
        fnCategoryClick(e);
    });

    //문제폴더 추가 클릭
    $("#btnAddRoot").click(function () {
    selectNodeNo = 0;
        var template = $("#divTemplateSave", "#template").html();
        $("#divCategoryLayer").append($.stringFormat("<div class='categoryRow deleterow list-item bg-light'><div class='tempparent row'>{0}</div></div>", template));
        setTimeout(function () { $("#divCategoryLayer").find("input[type=text].divTemplateEditText").last().focus(); }, 10);
    });

    //저장
    $(".btn_icon_save").on("click", function () {
        
        var categoryName = $(this).parent().parent().find("input[name='categoryName']").val();
        ajaxHelper.CallAjaxPost("/QuestionBank/CategoryCreate", { paramQuestionBankType: QuestionBankType, paramCategoryName: categoryName, paramGubunNo: selectNodeNo }, "fnCompleteCategoryCreate");
    });

    //수정 후 저장 클릭
    $(".btn_icon_update").on("click", function () {
        editMode = false;
        var category = $(this).parent().parent().find("input[name='GubunNos']");
        var categoryName = $(category).val();
        selectNodeNo = $(category).attr("id").split("_")[1];

        ajaxHelper.CallAjaxPost("/QuestionBank/CategoryUpdate", { paramQuestionBankType: QuestionBankType, paramCategoryName: categoryName, paramGubunNo: selectNodeNo }, "fnCompleteCategoryUpdate");

    });
});

function fnSave() {
    myeditor.outputBodyHTML();
    try {
        var _content = $("#editorContentValue").val();
        $("#hdnQuestion").val(encodeURI(_content));

    } catch (e) {

    }

    var _correctAnswer = $("input[name='CorrectAnswerYesNo']:checked");
    var _examples = $("#pnlQuestionExampleArea textarea[name='ExampleContents']");
    var isValid = true;
    if ($("#hdnGubunNo").val() == "0") {
        bootAlert("폴더를 선택하세요.");
        return false;
    }

    if ($("#ddlDifficulty").val() == "" && $("#h_QuestionBankType").val() == "MJTP001") {
        bootAlert("출제주차를 선택하세요.");
        return false;
    }

    if (_examples.length > 0) {
        for (var i = 0; i < _examples.length; i++) {
            if ($(_examples[i]).val() == "") {
                bootAlert("보기를 입력하세요");
                isValid = false;
                break;
            }
        }
    }

    if (!isValid) return false;
    if ($("#ddlQuestionType").val() == "MJQT001") {
        //시험문항 : MJTP001
        if ($("#h_QuestionBankType").val() == "MJTP001") {
            if (_correctAnswer.length == 0) {
                bootAlert("정답을 선택하세요.");
                return false;
            }
        }
    }
    document.forms[0].submit();
}

/* AJAX 관련 함수 */
function fnCompleteCategoryCreate(gbn) {
    gbn = gbn || "C" // C일 경우 신규 U일 경우 수정

    var result = ajaxHelper.CallAjaxResult();

    if (result == -1) {
        bootAlert("이미 사용중 입니다.", 1);
    } else if (result == 0) {
        bootAlert("업데이트시 오류가 발생 되었습니다.");
    } else {
        if (result != null && result.length > 0 && gbn == "C") {
            bootAlert('저장되었습니다.', function () {
                window.location.reload(true);
            });
        } else if (result != null && result > 0 && gbn == "U") {
            bootAlert('수정되었습니다.', function () {
                window.location.reload(true);
            });
		}
    }
    $("#GB_" + $("#hdnGubunNo").val()).click();
    
}

function fnCompleteCategoryUpdate() {
    fnCompleteCategoryCreate('U');
}

function fnCompleteCategoryDelete() {

    var result = ajaxHelper.CallAjaxResult();

    if (result > 0) {
        bootAlert("해당 폴더가 삭제되었습니다.", function () {
            selectNodeNo = 0;
            location.reload();
        })
    } else if (result == -1) {
        bootAlert("해당 폴더에 문제가 등록되어 있는 경우 삭제가 불가능합니다.");
        return false;
    } else {
        bootAlert("오류가 발생하였습니다.");
        return false;
	}

}

//폴더 모달
function fnModal(catNo, catNm, obj, action) {

    $("#txtCatName").val("");
    $("#hdnCatCode").val(catNo);

    if (action == "new") {
        $("#divModalParentFolder").hide();
        $("#ModalTitle").text("폴더 추가");
        $("#btnUpdate").hide();
        $("#btnDel").hide();


    } else if (action == "add") {
        $("#btnUpdate").hide();
        $("#btnSave").show();
        $("#divModalParentFolder").show();
        $("#ModalTitle").text("하위폴더 추가");
        $("#txtParentName").val(catNm);


    } else if (action = "modify") {
        $("#btnUpdate").show();
        $("#btnSave").hide();
        $("#divModalParentFolder").hide();
        $("#ModalTitle").text("폴더 수정");
        $("#txtCatName").val(catNm);
    }
    $("#txtCatName").focus();
    fnPrevent();

}

function fnDeleteFolder(GubunCode, GubunName, obj) {
    bootConfirm(GubunName + "을(를) 정말 삭제 하시겠습니까?", function () {
        ajaxHelper.CallAjaxPost("/QuestionBank/CategoryDelete", { paramGubunNo: GubunCode }, "fnCompleteCategoryDelete");
    });

    //if (!confirm("정말 폴더를 삭제하시겠습니까?")) return;
    //if (confirm(GubunName + "을(를) 정말 삭제 하시겠습니까?")) {
        
    //}
}

function fnSaveCategory() {

    let catVal = $("#txtCatName").val();

    if (fnGetBytes(catVal) < 1) {
        bootAlert("폴더명을 입력하세요.");
    }

    var cnt = 0
    Array.from($("input[type=text][id*=GB_]")).forEach(item => {
        if (item.value == catVal) {
            cnt++;
        }
    });
    
    if (cnt >= 1) {
        bootAlert('해당 폴더명과 같은 폴더명이 존재합니다. 다른 폴더명을 입력하세요.');

    } else {

        $("#CatCode").val($("#hdnCatCode").val());
        $("#CatName").val(catVal);
        
        let gbn = $("#CatCode").val();
        ajaxHelper.CallAjaxPost("/QuestionBank/CategoryCreate", { paramQuestionBankType: QuestionBankType, paramCategoryName: catVal, paramGubunNo: $("#hdnCatCode").val()}, "fnCompleteCategoryCreate");
    }
}

function fnUpdateCategory() {

    let catVal = $("#txtCatName").val();

    if (fnGetBytes(catVal) < 1) {
        bootAlert("폴더명을 입력하세요.");
    }

    var cnt = 0
    Array.from($("input[type=text][id*=GB_]")).forEach(item => {
        if (item.value == catVal) {
            cnt++;
        }
    });

    if (cnt >= 1) {
        bootAlert('해당 폴더명과 같은 폴더명이 존재합니다. 다른 폴더명을 입력하세요.');

    } else {

        var category = $(this).parent().parent().find("input[name='GubunNos']");
        var categoryName = $(category).val();

        ajaxHelper.CallAjaxPost("/QuestionBank/CategoryUpdate", { paramQuestionBankType: QuestionBankType, paramCategoryName: catVal, paramGubunNo: $("#hdnCatCode").val() }, "fnCompleteCategoryUpdate");
    }
}

//하위 디렉토리 추가
function fnAdd(target) {
    var _id = $(target).parent().parent().find("input[name='GubunNos']").attr("id");

    if (_id != "") {
        var _idArray = _id.split("_");
        selectNodeNo = _idArray[1];
        var template = $("#divTemplateSave", "#template").html();
        $(target).parent().parent().parent().append("<div class='categoryRow deleterow list-item bg-light'><div class='tempparent row'><div class='categoryRow col-7'><input type='text' name='categoryName' class='divTemplateEditText form-control' onblur='javascript:outtemp(this);' style='margin-left: undefinedpx;'></div><div class='col-5 text-right'><button class='btn btn-sm btn-dark btn_icon_save' title='저장'><i class='bi bi-save'></i></button></div></div></div>");
        setTimeout(function () { $("#divCategoryLayer").find("input[type=text].divTemplateEditText").last().focus(); }, 10);
    }

    fnPrevent();
}
