<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%

    string pageType = "";
    if (HttpContext.Current.Request.Url.AbsolutePath.Split('/').Length > 2)
    {
        pageType = HttpContext.Current.Request.Url.AbsolutePath.Split('/')[2].ToString();
    }
    else
    {
        pageType = "Index";
    }

%>
<div class="row align-items-center my-2">
    <div class="col">
        <h2 class="title04">문제폴더</h2>
    </div>
    <div class="mr-xl-3">
        <%
            if (pageType != "List")
            {
        %>
        <button type="button" id="btnNew" class="btn btn-sm btn-primary" onclick="fnModal(-1, '', this,'new')" data-toggle="modal" data-target="#divModalCat">등록</button>

        <%
            }
        %>
    </div>
    <div class="col-auto text-right d-xl-none">
        <button class="btn btn-sm btn-light collapsed" type="button" data-toggle="collapse" data-target="#collapseExample1" aria-expanded="false" aria-controls="collapseExample1">
            <span class="sr-only">더 보기</span>
        </button>
    </div>
</div>
<div class="d-xl-block collapse" id="collapseExample1">
    <div id="divCategoryLayer" class="overflow-auto bg-white px-2 q-folder overflow-md overflow-xl">
        <% 
            foreach (var item in Model.CategoryList)
            { 
                if (item.Depth >= 1)
                {
        %>
        <div class="depth1-item has-child">
            <div style="margin-left: <%:(item.Depth*15) %>px;" class="row no-gutters align-items-center">
                <div class="col-auto w-2rem">
                    <i class="bi bi-arrow-return-right"></i>
                </div>
                <div class="col">
                    <label for="GB_<%:item.GubunNo %>" class="d-none">폴더선택</label>
                    <input type="text" value="<%:item.GubunCodeName %>" name="GubunNos" title="폴더선택" readonly="readonly" id="GB_<%:item.GubunNo %>" class="form-control bg-white border-0 btn text-left">
                </div>
                <%
                    if (pageType != "List")
                    {
                %>
                <div class="col text-right">
                    <button type="button" id="btnAdd" class="btn btn-sm btn-primary" onclick="fnModal(<%:item.GubunNo %>, '<%:item.GubunCodeName %>', this,'add')" data-toggle="modal" data-target="#divModalCat"><i class="bi bi-plus"></i></button>
                    <button type="button" id="btnModify" class="btn btn-sm btn-warning" onclick="fnModal(<%:item.GubunNo %>, '<%:item.GubunCodeName %>', this,'modify')" data-toggle="modal" data-target="#divModalCat"><i class="bi bi-pencil-square"></i></button>
                    <button type="button" id="btnDelete" class="btn btn-sm btn-danger" onclick="fnDeleteFolder(<%:item.GubunNo %>, '<%:item.GubunCodeName %>', this)"><i class="bi bi-trash"></i></button>
                </div>
                <%
                    }
                %>
            </div>
        </div>
        <%
            }
            else
            {
        %>
        <div class="depth1-item">
            <div class="row">
                <div class="col-7">
                    <label for="GB_<%:item.GubunNo %>" class="d-none">폴더선택</label>
                    <input type="text" value="<%:item.GubunCodeName %>" name="GubunNos" title="폴더선택" readonly="readonly" id="GB_<%:item.GubunNo%>" class="form-control bg-white border-0 btn text-left">
                </div>
                <%
                    if (pageType != "List")
                    {
                %>
                <div class="col-5 text-right pt-2">
                    <button type="button" id="btnAdd" class="btn btn-sm btn-primary" onclick="fnModal(<%:item.GubunNo %>, '<%:item.GubunCodeName %>', this,'add')" data-toggle="modal" data-target="#divModalCat"><i class="bi bi-plus"></i></button>
                    <button type="button" id="btnModify" class="btn btn-sm btn-warning" onclick="fnModal(<%:item.GubunNo %>, '<%:item.GubunCodeName %>', this,'modify')" data-toggle="modal" data-target="#divModalCat"><i class="bi bi-pencil-square"></i></button>
                    <button type="button" id="btnDelete" class="btn btn-sm btn-danger" onclick="fnDeleteFolder(<%:item.GubunNo %>, '<%:item.GubunCodeName %>', this)"><i class="bi bi-trash"></i></button>
                </div>
                <%
                    }
                %>
            </div>
        </div>
        <%
                }
            }
        %>
    </div>
</div>

<%--분류수정 / 등록 modal--%>
<div class="modal fade show" id="divModalCat" tabindex="-1" aria-labelledby="divCat" aria-modal="true" role="dialog">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title h4" id="divCat">폴더 변경</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="card">
                    <div class="card-body">
                        <div class="form-row">
                            <div id="divModalParentFolder" class="form-group col-md-12">
                                <label for="txtParentName" class="form-label">상위 폴더 </label>
                                <input type="text" id="txtParentName" class="form-control" disabled="disabled">
                                </div>
                            <div class="form-group col-md-12">
                                <label for="txtCatName" class="form-label">폴더명 <strong class="text-danger">*</strong></label>
                                <input type="text" id="txtCatName" name="CatName" class="form-control">
                                <input type="hidden" id="hdnCatCode" >
                                <input type="hidden" id="hdnCatCodeName">
                            </div>

                        </div>
                    </div>

                    <div class="card-footer">
                        <div class="row align-items-center">
                            <div class="col-6">
                                <p class="font-size-14 text-danger font-weight-bold mb-0"><i class="bi bi-info-circle-fill"></i>* 필수입력 항목</p>
                            </div>
                            <div class="col-6 text-right">
                                <button type="button" class="btn btn-primary" visible="false" id="btnSave" onclick="fnSaveCategory()">저장</button>
                                <button type="button" class="btn btn-warning" visible="false" id="btnUpdate" onclick="fnUpdateCategory()">수정</button>
                                <%--<button type="button" class="btn btn-danger" id="btnDel" onclick="fnDelCategory()">삭제</button>--%>
                                <button type="button" class="btn btn-outline-secondary" id="btnCancel" data-dismiss="modal" title="닫기" onclick="">닫기</button>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>