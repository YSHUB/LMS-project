<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Popup.Master" Inherits="System.Web.Mvc.ViewPage<ILMS.Design.ViewModels.OcwViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" runat="server">콘텐츠<%:Model.Ocw.OcwNo > 0 ? " 수정" : " 등록"%></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentBlock" runat="server">

    <form action="/Ocw/OcwReg" id="mainForm" method="post" enctype="multipart/form-data">
        <input type="hidden" name="Ocw.OcwNo" id="hdnOcwNo" value="<%:Model.Ocw.OcwNo > 0 ? Model.Ocw.OcwNo : 0 %>" />
        <input type="hidden" name="Ocw.OcwFileGroupNo" id="hdnOcwFileGroupNo" value="<%:Model.Ocw.OcwFileGroupNo > 0 ? Model.Ocw.OcwFileGroupNo : 0 %>" />
        <input type="hidden" name="Ocw.ThumFileGroupNo" id="hdnThumFileGroupNo" value="<%:Model.Ocw.ThumFileGroupNo > 0 ? Model.Ocw.ThumFileGroupNo : 0 %>" />

        <div class="tab-content mt-3" id="myTabContent" role="tablist">

            <!-- 탭리스트 -->
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <a class="nav-link active show" id="tab1" href="#" data-toggle="tab" role="tab" aria-controls="tab1" aria-selected="false">기본 정보</a>
                </li>
                <%
                    if (Model.Ocw.OcwNo > 0)
                    {
                %>
                <li class="nav-item" role="presentation">
                    <a class="nav-link" id="tab2" href="#" data-toggle="tab" role="tab" aria-controls="tab2" aria-selected="false"
                        onclick="javascript:location.href='/Ocw/OcwCourse/<%:Model.Ocw.OcwNo%>'">강의연계</a>
                </li>
                <%                    
                    }
                %>
            </ul>
        </div>

        <!-- 기본 정보 -->
        <div class="tab-pane fade show p-4" id="contInfo" role="tabpanel" aria-labelledby="contInfo-tab">
            <h4 class="title04">콘텐츠 <%:Model.Ocw.OcwNo > 0 ? "수정" : "등록" %></h4>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-12">
                            <div class="form-row">
                                <div class="form-group col-12">
                                    <label for="txtContNm" class="form-label">콘텐츠명 <strong class="text-danger">*</strong></label>
                                    <input type="text" id="txtContNm" name="Ocw.OcwName" class="form-control" value="<%:Model.Ocw.OcwName %>" />
                                </div>
                                <div class="form-group col-6 col-md-3">
                                    <label for="OcwType" class="form-label">콘텐츠 종류 <strong class="text-danger">*</strong></label>
                                    <select id="OcwType" name="Ocw.OcwType" onchange="fnGetOcwSourceType();" class="form-control">
                                        <option value="block">선택</option>
                                        <% 
                                            foreach (var baseCode in Model.BaseCode.Where(w => w.ClassCode.ToString() == "CTKD"))
                                            {
                                        %>
                                        <option id="<%: baseCode.CodeValue %>"
                                            value="<%: baseCode.Remark %>" <%:Model.Ocw.OcwNo > 0 &&( Model.Ocw.OcwType  == Convert.ToInt32(baseCode.Remark)) ? "selected" : "" %>>
                                            <%: baseCode.CodeName%></option>
                                        <%                                                    
                                            }
                                        %>
                                    </select>

                                </div>
                                <div class="form-group col-6 col-md-3">
                                    <label for="ocwSourceType" class="form-label">콘텐츠 등록방식 <strong class="text-danger">*</strong></label>
                                    <select id="ocwSourceType" name="Ocw.OcwSourceType" onchange="fnSetVisible();" class="form-control">
                                        <option value="block">선택</option>
                                    </select>
                                </div>

                                <div id="contSel" class="form-group col-12 col-md-6 d-none">
                                    <label for="txtOcwData" class="form-label">콘텐츠 선택 <strong class="text-danger">*</strong></label>
                                    <input id="txtOcwData" name="Ocw.OcwData" type="text" class="form-control" value="<%:Model.Ocw.OcwData %>" />
                                </div>

                                <div id="firstPage" class="form-group col-12 col-md-6 d-none">
                                    <label for="txtXIDstart" class="form-label">시작 페이지 <strong class="text-danger">*</strong></label>
                                    <input id="txtXIDstart" type="text" name="XIDstart" class="form-control mb-1" placeholder="시작페이지" value="<%:Model.XIDstart %>"" />
                                </div>

                                <div class="col-12">
                                    <div id="ocwSrcType01" class="alert alert-light border-light d-none">
                                        <p class="font-size-14 text-primary mb-0">
                                            <i class="bi bi-info-circle-fill"></i> 외부 홈페이지에서 운영되고 있는 콘텐츠/웹페이지들을 연결할 경우 선택하며, <br /> 해당 콘텐츠의 URL 주소만 입력하면 됩니다.
										<br />
                                            ex1) https://news.v.daum.net/v/20181109115456255<br />
                                            ex2) https://youtu.be/8kajveDuUR4
                                        <br />
                                        </p>
                                    </div>
                                    <div id="ocwSrcType02" class="alert alert-light border-light d-none">
                                        <p class="font-size-14 text-primary mb-0">
                                            <i class="bi bi-info-circle-fill"></i> 유투브, TED 등 각종 동영상 사이트들에서 재생되는 동영상 콘텐츠만을 가져다가 사용하고 싶을 경우 선택하며, 해당 사이트에서 제공하는 소스코드(or iframe)을 복사해서 입력하면 됩니다. 대개 &lt;iframe&gt;
										으로 시작됩니다.<br />
                                            ex) &lt;iframe width="560" height="315" src="https://www.youtube.com/embed/8kajveDuUR4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen&gt;&lt;/iframe&gt;
                                            <br /><br />
                                            <i class="bi bi-info-circle-fill"></i>  유튜브 링크에 www가 붙어 있지 않은 경우 출석체크가 정상적으로 되지 않을 수 있습니다
                                        <br />
                                            ex1) https://www.youtube.com/영상아이디~ : 정상작동 <br />
                                            ex2) https://youtube.com/영상아이디~ : 출석체크 누락 가능성 있음
                                        </p>
                                    </div>
                                    <div id="ocwSrcType03" class="alert alert-light border-light d-none">
                                        <p class="font-size-14 text-primary mb-0">
                                            <i class="bi bi-info-circle-fill"></i> 확장자가 mp4로 되어있는 동영상을 직접 업로드하고 싶을 경우 선택합니다.
										다른 동영상 확장자(avi,mpeg,ogg,wmv)들은 등록이 불가능하며 mp4확장자로 변환을 해야 합니다.
                                        </p>
                                    </div>
                                    <div id="ocwSrcType04" class="alert alert-light border-light d-none">
                                        <p class="font-size-14 text-primary mb-0">
                                            <i class="bi bi-info-circle-fill"></i> 외부 콘텐츠 제작업체에서 제작된 HTML 형식의 콘텐츠를 직접 업로드할 경우 선택합니다.
										보통 여러 개의 파일로 구성되어있기 때문에 반드시 zip파일로 압축을 진행하신뒤 업로드하셔야 합니다.
                                        </p>
                                    </div>
                                    <div id="ocwSrcType05" class="alert alert-light border-light d-none">
                                        <p class="font-size-14 text-primary mb-0">
                                            <i class="bi bi-info-circle-fill"></i> 임의의 파일을 업로드하고 싶을 경우 선택합니다.
                                        </p>
                                    </div>
                                </div>

                                <div id="MP4Upload" class="form-group col-12 d-none">
                                    <div class="input-group">

                                        <% Html.RenderPartial("./Common/File"
                                                     , Model.MP4FileList
                                                     , new ViewDataDictionary { {"id", "MP4FileUpload"}
                                                       , { "name", "MP4FileGroupNo" }
                                                       , { "fname", "MP4File" }
                                                       , { "value", Model.MP4FileGroupNo }
                                                       , { "fileDirType", "OCW"}
                                                       , { "filecount", 1 }
                                                       , { "width", "100" }
                                                       , { "isimage", 0 }
                                                       , { "FileCustomizeYN", "Y"}
                                                       , { "FileCustomizeTag", "<i class=\"bi bi-upload\"></i> MP4 업로드" }
                                                       , { "reloadYN", "Y"}
                                                     }); %>

                                        <%--<button class="btn btn-primary" title="업로드"><i class="bi bi-upload"></i> 업로드</button>--%>
                                    </div>
                                </div>


                                <div id="HTMLUpload" class="form-group col-12 d-none">

                                    <% Html.RenderPartial("./Common/File"
                                                 , Model.HTMLFileList
                                                 , new ViewDataDictionary { {"id", "HTMLFileUpload"}
                                                   , { "name", "HTMLFileGroupNo" }
                                                   , { "fname", "HTMLFile" }
                                                   , { "value", Model.HTMLFileGroupNo }
                                                   , { "fileDirType", "OCW"}
                                                   , { "filecount", 1 }
                                                   , { "width", "100" }
                                                   , { "isimage", 0 }
                                                   , { "FileCustomizeYN", "Y"}
                                                   , { "FileCustomizeTag", "<i class=\"bi bi-upload\"></i> HTML(ZIP) 업로드" }
                                                   , { "reloadYN", "Y"}
                                                 }); %>

                                    <%--<button class="btn btn-primary" title="업로드"><i class="bi bi-upload"></i> 업로드</button>--%>
                                </div>


                                <div id="FileUpload" class="form-group col-12 d-none">
                                    <div class="input-group">

                                        <% Html.RenderPartial("./Common/File"
                                                     , Model.BasicFileList
                                                     , new ViewDataDictionary { {"id", "BasicFileUpload"}
                                                       , { "name", "BasicFileGroupNo" }
                                                       , { "fname", "BasicFile" }
                                                       , { "value", Model.BasicFileList }
                                                       , { "fileDirType", "OCW"}
                                                       , { "filecount", 1 }
                                                       , { "width", "100" }
                                                       , { "isimage", 0 }
                                                       , { "FileCustomizeYN", "Y"}
                                                       , { "FileCustomizeTag", "<i class=\"bi bi-upload\"></i> 파일 업로드" }
                                                       , { "reloadYN", "Y"}
                                                     }); %>

                                        <%--<button class="btn btn-primary" title="업로드"><i class="bi bi-upload"></i> 업로드</button>--%>
                                    </div>
                                </div>

                                <div id="contSize" class="form-group col-12 col-md-6 d-none">
                                    <label for="txtWidth" class="form-label">콘텐츠 사이즈 <strong class="text-danger">*</strong></label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">너비</span>
                                        </div>
                                        <input type="text" id="txtWidth" name="Ocw.OcwWidth" class="form-control text-right"
                                            oninput="fnOnlyNumber(this);" placeholder="" value="<%: Model.Ocw.OcwWidth  %>" />
                                        <div class="input-group-append input-group-prepend">
                                            <span class="input-group-text">pixel</span>
                                        </div>
                                        <div class="input-group-append input-group-prepend">
                                            <span class="input-group-text">높이</span>
                                        </div>
                                        <input type="text" id="txtHeight" name="Ocw.OcwHeight" class="form-control text-right"
                                            oninput="fnOnlyNumber(this);" placeholder="" value="<%:Model.Ocw.OcwHeight %>" />
                                        <div class="input-group-append input-group-prepend">
                                            <span class="input-group-text">pixel</span>
                                        </div>
                                    </div>
                                </div>

                                <%
									if (ConfigurationManager.AppSettings["UnivYN"].ToString().Equals("Y"))
									{
                                %>
                                        <div class="form-group col-12 col-md-6">
                                            <label for="AssignNo" class="form-label">관련학과 <strong class="text-danger">*</strong></label>
                                            <select id="AssignNo" name="Ocw.AssignNo" class="form-control">
                                                <option value="block">선택</option>

                                                <%
                                                    foreach (var assign in Model.AssignList.Where(w => w.HierarchyLevel >= 2))
                                                    {
                                                %>
                                                <option value="<%: assign.AssignNo %>" <%: Model.Ocw.AssignNo == assign.AssignNo ? "selected" : "" %>><%: assign.AssignName%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>
                                <%
									} 
                                %>                                

                                <div class="form-group col-12">
                                    <label for="ocwTheme" class="form-label">테마분류 <strong class="text-danger">*</strong></label>
                                    <input type="hidden" id="ocwThemeNos" name="Ocw.ThemeNos" value="<%:Model.Ocw.ThemeNos %>" />

                                    <%
                                        foreach (var ocwTheme in Model.OcwThemeList)
                                        {
                                    %>

                                    <div class="form-check form-check-inline">
                                        <label class="form-check-label">
                                            <input id="OcwTheme_<%:ocwTheme.ThemeNo %>" type="checkbox" class="form-check-input" name="ThemeNo" value="<%:ocwTheme.ThemeNo %>"
                                                <%:Model.Ocw.OcwNo > 0 && Model.Ocw.ThemeNos.Contains(ocwTheme.ThemeNo.ToString()) ? "checked" : "" %> />
                                            <%: ocwTheme.ThemeName %>
                                        </label>
                                    </div>

                                    <% 
                                        }
                                    %>
                                </div>

                                <div class="form-group col-6">
                                    <label for="UserCat" class="form-label">폴더선택 <strong class="text-danger">*</strong></label>
                                    <select id="UserCat" name="Ocw.CatCode" class="form-control">

                                        <%
                                            foreach (var ocwUserCat in Model.OcwUserCatList)
                                            {
                                        %>
                                        <option value="<%:ocwUserCat.CatCode %>" <%:Model.Ocw.OcwNo > 0 && Model.Ocw.CatCode == ocwUserCat.CatCode ? "selected" : "" %>>
                                            <%:ocwUserCat.CatName %></option>

                                        <% 
                                            }
                                        %>
                                    </select>
                                </div>

                                <div class="form-group col-6">
                                    <label for="IsOpen" class="form-label">공개설정 <strong class="text-danger">*</strong></label>
                                    <select id="IsOpen" name="Ocw.IsOpen" class="form-control">
                                        <option value="block" selected="selected">선택</option>
                                        <%
                                            foreach (var OpenGb in Model.BaseCode.Where(w => w.ClassCode.ToString() == "OPGB"))
                                            {
                                        %>
                                        <option id="<%: OpenGb.CodeValue %>" value="<%: OpenGb.Remark %>"
                                            <%:Model.Ocw.OcwNo > 0 && Model.Ocw.IsOpen == Convert.ToInt32(OpenGb.Remark) ? "selected" : "" %>><%: OpenGb.CodeName%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </div>
                            </div>


                            <div class="form-row">
                                <div class="form-group col-12">
                                    <label for="txtDescText" class="form-label">콘텐츠 설명 <strong class="text-danger">*</strong></label>
                                    <textarea class="form-control" id="txtDescText" name="Ocw.DescText" rows="5"><%: Html.Raw((Model.Ocw.DescText ?? "")) %></textarea>

                                </div>
                            </div>
                            <div class="alert alert-light border-light">
                                <p class="font-size-14 text-primary mb-0">
                                    <i class="bi bi-info-circle-fill"></i> 콘텐츠의 저작권에 유의하시기 바랍니다. 본인 저작물이 아닌 경우 본 사이트에 업로드하는 것은 불법이며, 웹페이지 또는 소스코드로만 등록 가능합니다.
                                </p>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-12">
                                    <label for="txtKword" class="form-label">검색 키워드 </label>
                                    <input type="text" id="txtKword" name="Ocw.KWord" class="form-control" value="<%: Model.Ocw.KWord %>" />
                                </div>
                            </div>
                            <div class="alert alert-light border-light">
                                <p class="font-size-14 text-primary mb-0">
                                    <i class="bi bi-info-circle-fill"></i> Ex) 로봇산업진흥원, 로봇, 데이터, IT
                                </p>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-12">
                                    <label for="btnUpload" class="form-label">썸네일 등록 </label>
                                    <p class="font-size-14 text-danger font-weight-bold mb-0">
                                        <i class="bi bi-info-circle-fill"></i> 썸네일의 가로 세로 비율은 420px by 300px을 권장합니다.</p>
                                    <div>

                                    <!-- image type -->
                                    <div id="divOcwThumbImg" class="col-md-4 col-lg-3 mt-2 mb-2 
                                        <%:Model.Ocw.OcwNo > 0 && !(string.IsNullOrEmpty(Model.Ocw.ThumFileName)) ? "" : "d-none" %>">
                                        <div class="thumb-wrap">
                                            <div class="thumb">
                                                <img id="ocwThumbnailImg" src=" <%:!(string.IsNullOrEmpty(Model.Ocw.ThumFileName)) ? Model.Ocw.FileExtension : "" %>">
                                            </div>
                                        </div>
                                    </div>
                                        
                                        <% Html.RenderPartial("./Common/File"
                                                      , Model.ThumFileList
                                                      , new ViewDataDictionary { {"id", "ThumbnailFileUpload"}
                                                      , { "name", "ThumFileGroupNo" }
                                                      , { "fname", "ThumbnailFile" }
                                                      , { "value", Model.ThumFileGroupNo }
                                                      , { "fileDirType", "OCW"}
                                                      , { "filecount", 1 }
                                                      , { "imageid", "ocwThumbnailImg"}
                                                      , { "width", "100" }
                                                      , { "isimage", 1 }
                                                      , { "FileCustomizeYN", "Y"}
                                                      , { "FileCustomizeTag", "<i class=\"bi bi-upload\"></i> 썸네일 업로드" }
                                                      , { "reloadYN", "Y"}
                                                   }); %>


                                        <%--<button class="btn btn-primary" title="업로드" id="btnUpload" value=""><i class="bi bi-upload"></i> 썸네일 업로드</button>--%>
                                    </div>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-12">
                                    <label for="LinkOcw" class="form-label">연계 콘텐츠 추가</label>
                                    <div id="divLinkOcw">
                                        <button id="btnAddLinkOcw" class="btn btn-primary" type="button" onclick="fnChkNo();" title="추가"
                                            data-toggle="modal" data-target="#divLinkCont" role="button">
                                            <i class="bi bi-plus"></i>
                                        </button>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-12 text-right">
                    <input type="button" onclick="fnSaveOcwReg();" class="btn btn-primary" value="저장" />
                    <input type="button" onclick="fnDelConfirm();" class="btn btn-danger <%:(Model.Ocw.OcwNo > 0 && Model.Ocw.OcwDeletePossibleYN == "Y") ? "" : "d-none"%>" value="삭제" />
                    <input type="button" onclick="window.close();" class="btn btn-secondary" value="닫기" />
                </div>
            </div>

            <input type="hidden" id="hdnLinkOcwNo" name="hdnLinkOcwNo" value="<%:Model.Ocw.OcwNo > 0 ? string.Join(",", Model.LinkOcwList.Select(s=>s.LinkOcwNo)) : ""%>" />

        </div>



        <!-- 연계 콘텐츠 모달 -->
        <div class="modal fade show " id="divLinkCont" tabindex="-1" aria-labelledby="linkCont" aria-modal="true" role="dialog">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title h4" id="linkCont">연계 콘텐츠 추가</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="card">
                            <div class="card-body pb-1">
                                <div class="form-row ">
                                    <div class="form-group col-4">
                                        <label for="UserCatModal" class="sr-only"></label>
                                        <select id="UserCatModal" name="UserCatModal" class="form-control">
                                            <option value="-1">전체(<%: Model.OcwUserCatList.Sum(s => s.OcwCount).ToString("#,0") %>)</option>
                                            <%
                                                foreach (var ocwUserCat in Model.OcwUserCatList)
                                                {
                                            %>
                                            <option value="<%: ocwUserCat.CatCode %>"><%: ocwUserCat.CatName%>(<%: ocwUserCat.OcwCount.ToString("#,0") %>)</option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>

                                    <div class="form-group col-5 ">
                                        <label for="" class="sr-only">검색어</label>
                                        <input id="SearchText" name="SearchText" type="text" class="form-control" placeholder="콘텐츠명 검색" value="<%:Model.SearchText %>">
                                    </div>

                                    <div class="form-group col-sm-auto text-right">
                                        <button type="button" id="btnSearch" class="btn btn-secondary" onclick="fnSearch();">
                                            <span class="icon search">검색</span>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-body py-0">
                                <div class="overflow-auto overflow-xs overflow-sm overflow-md overflow-xl">
                                    <div class="table-responsive">
                                        <table id="OcwList" class="table table-hover " cellspacing="0" summary="">
                                            <thead>
                                                <tr>
                                                    <th scope="col">제목</th>
                                                    <th scope="col">등록일</th>
                                                    <th scope="col">관리</th>
                                                </tr>
                                            </thead>
                                            <tbody>

                                                <%
                                                    foreach (var myOcw in Model.OcwList)
                                                    {
                                                %>
                                                <tr>
                                                    <td class="text-left">
                                                        <%: myOcw.OcwName %>
                                                    </td>
                                                    <td class="text-center text-nowrap "><%: myOcw.CreateDateTime %></td>
                                                    <td>
                                                        <input name="LinkOcwNo" id="chkId_<%:Model.OcwList.IndexOf(myOcw) %>" value="<%:myOcw.OcwNo %>" type="checkbox"
                                                            class="checkbox enableAllCheck" />
                                                    </td>
                                                </tr>
                                                <%
                                                    }
                                                %>
                                                <tr>
                                                    <td colspan="3" class="text-center <%: Model.OcwList.Count() > 0 ? "d-none" : "" %>">등록된 나의 OCW가 없습니다.</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer">
                                <div class="row">
                                    <div class="col-12 text-right">
                                        <button type="button" id="btnLinkOcw" class="btn btn-primary" onclick="fnAddLinkOcw();">추가</button>
                                        <button type="button" id="btnCancel" class="btn btn-secondary" data-dismiss="modal" title="닫기">닫기</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </form>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
        var check = false;

        // ajax 객체 생성
        var ajaxHelper = new AjaxHelper();

        $(document).ready(function () {
            var tapIdx = "<%:Request.QueryString["tapIdx"]%>";
            if (tapIdx != "") {
                $("#" + tapIdx + "-tab").addClass("active");
                $("#" + tapIdx).addClass("show active");
            } else {
                $("#contInfo-tab").addClass("active");
                $("#contInfo").addClass("show active");
            }

            check = true;

            let arrNo, arrName = "";
            arrNo = $("#hdnLinkOcwNo").val();
            arrName = '<%:Model.Ocw.OcwNo > 0 ? string.Join(",", Model.LinkOcwList.Select(s=>s.LinkOcwName)) : ""%>';

            fnGetOcwSourceType();
            fnSetVisible();
            fnSetLinkOcw(arrNo, arrName)
        });

        $("body").on("change", "input[type=file]", function (e) {
            $(this).parent().find("input.file_input_textbox").val($(this).val());
            var fbox = $(this).closest("div.fgbox");

            if ($(this).val() != "") {
                _filecontrol = $(this);
                var fname = $(this).val().toUpperCase();
                var fext = fname.split('.')[fname.split('.').length - 1].toUpperCase();

                if (this.id == "ThumbnailFileUpload") {
                    if (fbox.attr("data-isimage") == "1" && fext != "JPG" && fext != "JPEG" && fext != "GIF" && fext != "PNG") {
                        $(this).val("");
                        $("#div_ThumbnailFileUpload").empty();
                        bootAlert("이미지만 첨부해주세요.");
                        $("#ocwThumbnailImg").attr("src", "");
                        $("#divOcwThumbImg").addClass("d-none");
                    } else {
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
                        $("#divOcwThumbImg").removeClass("d-none");
                        $("#" + $(this).closest(".fgbox").attr("data-imageid")).show();
                    }
                }

                if (this.id == "MP4FileUpload") {
                    if (fext != "MP4") {
                        $(this).val("");
                        $("#div_MP4FileUpload").empty();
                        bootAlert("MP4 형식의 파일만 첨부해주세요.");
                    }
                }
            }
        });

        //해당 페이지 새로고침
        function fnRefresh(tapIdx) {
            tapIdx = tapIdx || "";
            location.href = "/Ocw/OcwReg/<%:Model.Ocw.OcwNo %>?tapIdx=" + tapIdx;
        }

        //초기화 관련
        function fnSetVisible() {
            fnSetFileEmpty();
            fnResetControl();

            var ocwSourceTypeId = $("#ocwSourceType option:selected").attr("id");

            if (ocwSourceTypeId == 'CTRB001') {
                $("#ocwSrcType01").removeClass("d-none");
                $("#ocwSrcType02").addClass("d-none");
                $("#ocwSrcType03").addClass("d-none");
                $("#ocwSrcType04").addClass("d-none");
                $("#ocwSrcType05").addClass("d-none");

                $("#contSel").removeClass("d-none");
                $("#MP4Upload").addClass("d-none");
                $("#HTMLUpload").addClass("d-none");
                $("#FileUpload").addClass("d-none");
                $("#contSize").addClass("d-none");
                $("#firstPage").addClass("d-none");
            }
            else if (ocwSourceTypeId == 'CTRB002') {
                $("#ocwSrcType01").addClass("d-none");
                $("#ocwSrcType02").removeClass("d-none");
                $("#ocwSrcType03").addClass("d-none");
                $("#ocwSrcType04").addClass("d-none");
                $("#ocwSrcType05").addClass("d-none");

                $("#contSel").removeClass("d-none");
                $("#MP4Upload").addClass("d-none");
                $("#HTMLUpload").addClass("d-none");
                $("#FileUpload").addClass("d-none");
                $("#contSize").removeClass("d-none");
                $("#firstPage").addClass("d-none");
            }
            else if (ocwSourceTypeId == 'CTRB003') {
                $("#ocwSrcType01").addClass("d-none");
                $("#ocwSrcType02").addClass("d-none");
                $("#ocwSrcType03").removeClass("d-none");
                $("#ocwSrcType04").addClass("d-none");
                $("#ocwSrcType05").addClass("d-none");

                $("#contSel").addClass("d-none");
                $("#MP4Upload").removeClass("d-none");
                $("#HTMLUpload").addClass("d-none");
                $("#FileUpload").addClass("d-none");
                $("#contSize").removeClass("d-none");
                $("#firstPage").addClass("d-none");

            }
            else if (ocwSourceTypeId == 'CTRB004') {
                $("#ocwSrcType01").addClass("d-none");
                $("#ocwSrcType02").addClass("d-none");
                $("#ocwSrcType03").addClass("d-none");
                $("#ocwSrcType04").removeClass("d-none");
                $("#ocwSrcType05").addClass("d-none");

                $("#contSel").addClass("d-none");
                $("#MP4Upload").addClass("d-none");
                $("#HTMLUpload").removeClass("d-none");
                $("#FileUpload").addClass("d-none");
                $("#contSize").removeClass("d-none");

                $("#firstPage").removeClass("d-none");
            }
            else if (ocwSourceTypeId == 'CTRB005') {
                $("#ocwSrcType01").addClass("d-none");
                $("#ocwSrcType02").addClass("d-none");
                $("#ocwSrcType03").addClass("d-none");
                $("#ocwSrcType04").addClass("d-none");
                $("#ocwSrcType05").removeClass("d-none");

                $("#contSel").addClass("d-none");
                $("#MP4Upload").addClass("d-none");
                $("#HTMLUpload").addClass("d-none");
                $("#FileUpload").removeClass("d-none");
                $("#contSize").addClass("d-none");
                $("#firstPage").addClass("d-none");
            }
            else {
                //fnResetControl();
            }

            check = false;

        }

        function fnResetControl() {
            $("#ocwSrcType01").addClass("d-none");
            $("#ocwSrcType02").addClass("d-none");
            $("#ocwSrcType03").addClass("d-none");
            $("#ocwSrcType04").addClass("d-none");
            $("#ocwSrcType05").addClass("d-none");

            $("#contSel").addClass("d-none");
            $("#MP4Upload").addClass("d-none");
            $("#HTMLUpload").addClass("d-none");
            $("#FileUpload").addClass("d-none");
            $("#contSize").addClass("d-none");
            $("#firstPage").addClass("d-none");

            if (!check) {
                $("#txtOcwData").val('');
                $("#txtXIDstart").val('');
                $("#txtWidth").val('');
                $("#txtHeight").val('');
            }
        }

        function fnSetFileEmpty() {
            $("#MP4FileUpload").val("");
            $("#div_MP4FileUpload").empty();

            $("#HTMLFileUpload").val("");
            $("#div_HTMLFileUpload").empty();

            $("#BasicFileUpload").val("");
            $("#div_BasicFileUpload").empty();
        }


        //Modal 연계콘텐츠 검색
        function fnSearch() {
            var userCat = $("#UserCatModal").val();
            var searchText = $("#SearchText").val();

            ajaxHelper.CallAjaxPost("/Ocw/GetMyOcwList", { userCat: userCat, searchText: searchText }, "fnCbGetMyOcwList");

        }

        //Modal 연계콘텐츠 OCW리스트 조회
        function fnCbGetMyOcwList() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            $("#OcwList > tbody").empty();

            var html = '';
            if (ajaxResult.length > 0) {
                for (var i = 0; i < ajaxResult.length; i++) {
                    html += "<tr>";
                    html += "<td class=\"text-left\">" + ajaxResult[i].OcwName + "</td>";
                    html += "<td class=\"text-center text-nowrap\">" + ajaxResult[i].CreateDateTime + "</td>";
                    html += "<td>";
                    html += "<input name=\"LinkOcwNo\" id=\"chkId_" + i + "\" class=\"checkbox enableAllCheck\" value=" + ajaxResult[i].OcwNo + " type=\"checkbox\"/>";
                    html += "</td>";
                    html += "</tr>";
                }

            } else {
                html += "<tr>";
                html += "<td colspan=\"3\" class=\"text-center\">조회된 콘텐츠가 없습니다.";
                html += "</td>";
                html += "</tr>";
            }

            $("#OcwList > tbody").append(html);

        }

        function fnChkNo() {
            var hdnLinkOcwNo = $("#hdnLinkOcwNo").val();

            $('input:checkbox[name=LinkOcwNo]').each(function () {
                if (hdnLinkOcwNo.indexOf(this.value) > -1) {
                    $(this).attr("disabled", true);
                    $(this).prop("checked", true);

                } else if ($("#hdnOcwNo").val().indexOf(this.value) > -1) {
                    $(this).attr("disabled", true);

                } else {
                    $(this).attr("disabled", false);
                    $(this).prop("checked", false);
                }
            });
        }

        //Modal 연계콘텐츠 추가
        function fnAddLinkOcw() {
            $("#hdnLinkOcwNo").val('');

            if ($('input:checkbox[name=LinkOcwNo]:checked').length == 0) {
                bootAlert("선택된 항목이 없습니다.");
                return false;
            }

            var LinkOcwNoList = "";
            var LinkOcwNameList = "";

            $('input:checkbox[name=LinkOcwNo]:checked').each(function () {

                if (LinkOcwNoList == "") {
                    LinkOcwNoList += this.value;
                    LinkOcwNameList += $.trim($(this).parent().parent().children().eq(0).text());
                }
                else {
                    LinkOcwNoList += "," + this.value;
                    LinkOcwNameList += "," + $.trim($(this).parent().parent().children().eq(0).text());

                }
            });

            $("#hdnLinkOcwNo").val(LinkOcwNoList);
            fnSetLinkOcw(LinkOcwNoList, LinkOcwNameList);

            $("#btnCancel").click();

        }

        function fnSetLinkOcw(arrNo, arrName) {
            $("div").remove('[name="divLinkOcwNo"]');

            if (arrNo.length > 0) {
                var LinkOcwNoArr = arrNo.split(",");
                var LinkOcwNameList = arrName.split(",");

                var html = '';
                for (var i = 0; i < LinkOcwNoArr.length; i++) {
                    html += "<div id=div" + LinkOcwNoArr[i] + " class=\"ml-3 mt-1\" name=divLinkOcwNo>";
                    html += "<button class=\"btn-sm btn-sm btn-danger mr-1\" type=\"button\" title=\"삭제\" onclick=fnDelLinkOcw(this); value=" + LinkOcwNoArr[i] + ">";
                    html += "<i class=\"bi bi-x\"></i>";
                    html += "</button>" + LinkOcwNameList[i];
                    html += "</div>";
                }

                $("#divLinkOcw").append(html);
            }
        }

        //연계 콘텐츠 삭제
        function fnDelLinkOcw(obj) {
            var linkOcwNo = $(obj).val();

            var hdnLinkOcw = $("#hdnLinkOcwNo").val().split(",");

            var newHdnLinkOcw = '';
            for (var i = 0; i < hdnLinkOcw.length; i++) {
                if (hdnLinkOcw[i] != linkOcwNo) {
                    if (newHdnLinkOcw == '') {
                        newHdnLinkOcw += hdnLinkOcw[i];
                    } else {
                        newHdnLinkOcw += ',' + hdnLinkOcw[i];
                    }
                }
            }

            $("#hdnLinkOcwNo").val(newHdnLinkOcw);
            $("#div" + linkOcwNo).empty();
        }

        //콘텐츠 등록방식 바인딩
        function fnGetOcwSourceType() {

            fnSetFileEmpty();
            fnResetControl();

            let gbn = "'" + $("#OcwType option:selected").attr("id") + "'";

            if ($("#OcwType").val() == "block") {

                fnResetControl();

                var innnerocwSourceType = "<option value=''>선택</option>";

                $("#ocwSourceType").html();
                $("#ocwSourceType").html(innnerocwSourceType);
            }
            else {
                ajaxHelper.CallAjaxPost("/Ocw/GetOcwSourceType", {}, "fnCbGetOcwSourceType", gbn);

            }
        }

        function fnCbGetOcwSourceType(gbn) {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            fnSetFileEmpty();
            fnResetControl();

            var innnerocwSourceType = "<option value=block>선택</option>";


            for (var i = 0; i < ajaxResult.length; i++) {
                var selected = (<%:Model.Ocw.OcwNo%> > 0 && <%:Model.Ocw.OcwSourceType %> == ajaxResult[i].Remark && check) ? "selected" : "";
                innnerocwSourceType += "<option id='" + ajaxResult[i].CodeValue + "' value='" + ajaxResult[i].Remark + "' " + selected + ">" + ajaxResult[i].CodeName + "";
            }

            $("#ocwSourceType").html(innnerocwSourceType);

            if (gbn == "CTKD001") {
                $("select option[id='CTRB005']").prop("hidden", true);
            }
            else if (gbn == 'CTKD002') {
                $("select option[id='CTRB002']").prop("hidden", true);
                $("select option[id='CTRB003']").prop("hidden", true);
                $("select option[id='CTRB004']").prop("hidden", true);
            }

            //check = false;
        }

        //콘텐츠 저장
        function fnSaveOcwReg() {
            var ocwSourceType = $("#ocwSourceType option:selected").attr("id");

            if ($("#txtContNm").length < 1 || $.trim($("#txtContNm").val()) == "") {
                bootAlert("콘텐츠명을 입력하세요.", function () {
                    $("#txtContNm").focus();
                });

                fnPrevent();
            }
            else if ($("#OcwType").val() == "block") {
                bootAlert("콘텐츠종류를 선택하세요.", function () {
                    $("#OcwType").focus();
                });

                fnPrevent();
            }
            else if ($("#ocwSourceType").val() == "block") {
                bootAlert("콘텐츠 등록방식을 선택하세요.", function () {
                    $("#ocwSourceType").focus();
                });

                fnPrevent();
            }
            else if ((ocwSourceType == "CTRB001" || ocwSourceType == "CTRB002") && ($("#txtOcwData").length < 1 || $.trim($("#txtOcwData").val()) == "")) {
                bootAlert("콘텐츠를 등록하세요.", function () {
                    $("#txtOcwData").focus();
                });

                fnPrevent();
            }
            else if (ocwSourceType == "CTRB003" && $("#MP4FileUpload").val() == "") {
                bootAlert("콘텐츠를 등록하세요.", function () {
                    $("#MP4Upload").attr("tabindex", -2).focus();

                });

                fnPrevent();
            }
            else if (ocwSourceType == "CTRB004" && $("#HTMLFileUpload").val() == "") {
                bootAlert("콘텐츠를 등록하세요.", function () {
                    $("#HTMLUpload").attr("tabindex", -2).focus();

                });

                fnPrevent();
            }
            else if (ocwSourceType == "CTRB005" && $("#BasicFileUpload").val() == "") {
                bootAlert("콘텐츠를 등록하세요.", function () {
                    $("#FileUpload").attr("tabindex", -2).focus();

                });

                fnPrevent();
            }
            else if (ocwSourceType == "CTRB004" && $("#txtXIDstart").val() == "") {
                bootAlert("시작페이지를 입력하세요.", function () {
                    $("#txtXIDstart").focus();

                });

                fnPrevent();
            }
            else if ((ocwSourceType == "CTRB002" || ocwSourceType == "CTRB003" || ocwSourceType == "CTRB004") && ($("#txtWidth").val() == "" || $("#txtHeight").val() == "")) {
                bootAlert("콘텐츠 사이즈 너비 및 높이를 입력하세요.", function () {
                    $("#txtWidth").focus();

                });

                fnPrevent();
            }

            else if ($("#AssignNo").val() == "block") {
                bootAlert("관련학과를 선택하세요.", function () {
                    $("#AssignNo").focus();
                });

                fnPrevent();
            }

            else if ($("input[name='ThemeNo']:checked").length < 1) {
                bootAlert("테마분류를 선택하세요.", function () {
                    $("input[name^='ThemeNo']")[0].focus();

                });

                fnPrevent();
            }
            else if ($("#IsOpen").val() == "block") {
                bootAlert("공개설정을 선택하세요", function () {
                    $("#IsOpen").focus();
                });

                fnPrevent();
            }
            else if ($("#txtDescText").length < 1 || $.trim($("#txtDescText").val()) == "") {
                bootAlert("콘텐츠 설명을 입력하세요", function () {
                    $("#txtDescText").focus();
                });

                fnPrevent();
            }
            else {

                let openFlag = false;

				if ($("#IsOpen option:selected").attr("id") == "OPGB001") {
					openFlag = true;
                }

                if (openFlag) {

                    bootConfirm("현재 공개여부가 '전체공개' 상태입니다. 이대로 저장하시겠습니까? \n 등록 시 시간이 소요될 수 있습니다.", function () {

                        fnSave();
                    });
                }
                else if (!openFlag)
                {

					bootConfirm("저장하시겠습니까? \n 등록 시 시간이 소요될 수 있습니다.", function () {

						fnSave();
					});
				}                			
			}
        }

        function fnSave() {

			$("#ocwThemeNos").val("," + fnLinkChkValue("OcwTheme", ",") + ",");

			if (ocwSourceType == "CTRB004") {
				$("#txtOcwData").val($("#txtXIDstart").val());
			}
			$("#txtOcwData").val(encodeURIComponent($("#txtOcwData").val()));
			$("#txtDescText").val($("#txtDescText").val());

			var formData = new FormData($("#mainForm")[0]);

			ajaxHelper.CallAjaxPostFile("/Ocw/SaveOcwReg", formData, "fnCbSaveOcwReg");
		}

        function fnCbSaveOcwReg() {
            var ajaxResult = ajaxHelper.CallAjaxResult();
            if (ajaxResult > 0) {
                bootAlert("저장되었습니다.", function () {
                    opener.parent.location.reload();
                    window.close();
                })
            } else {
                bootAlert("오류가 발생하였습니다.");
			}
        }


        function fnDelConfirm() {
            var ocwNo = $("#hdnOcwNo").val();

            bootConfirm('삭제하시겠습니까?', fnDeleteOcwReg, ocwNo);

            //if (confirm("삭제하시겠습니까?")) {
            //    ajaxHelper.CallAjaxPostFile("/Ocw/DeleteOcwReg", { OcwNo: ocwNo }, "fnCbDeleteOcwReg");

            //}

        }

        function fnDeleteOcwReg(ocwNo) {
            ajaxHelper.CallAjaxPost("/Ocw/DeleteOcwReg", { OcwNo: ocwNo }, "fnCbDeleteOcwReg");
        }

        function fnCbDeleteOcwReg() {
            var ajaxResult = ajaxHelper.CallAjaxResult();
            if (ajaxResult > 0) {
                bootAlert("삭제되었습니다.", function () {
                    opener.parent.location.reload();
                    window.close();
                })
            }
        }

        /* 강의 연계 script START*/

        function fnHrefTab() {
            if ('<%: Model.Ocw.IsAuth %>' === '2') {
                $("#courseInfo-tab").prop("href", "#courseInfo");

            } else {
                bootAlert("관리자 승인 후 강의연계 요청하실 수 있습니다.");
            }

        }

        //교과목 바인딩
        function fnGetCourse() {
            var termNo = $("#term").val();
            if (termNo != "termBlock") {
                ajaxHelper.CallAjaxPost("/Ocw/GetCourse", { TermNo: termNo }, "fnCbCourse");
            }
            else {
                $("#course").html();
                $("#week").html();

                var innerCourseBlock = "";
                var innerWeekBlock = "";

                innerCourseBlock = "<option value=courseBlock><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>을 선택하세요</option>";
                innerWeekBlock = "<option value=weekBlock>주차를 선택하세요</option>";

                $("#course").html(innerCourseBlock);
                $("#week").html(innerWeekBlock);

            }
        }

        function fnCbCourse() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            var innerCourseHtml = "";
            innerCourseHtml = "<option value=courseBlock><%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>을 선택하세요</option>";

            $("#week").html();
            var innerWeekHtml = "";
            innerWeekHtml = "<option value=courseBlock>주차를 선택하세요</option>";

            for (var i = 0; i < ajaxResult.length; i++) {
                innerCourseHtml += "<option value='" + ajaxResult[i].CourseNo + "'>" + ajaxResult[i].SubjectName + "";
            }

            $("#course").html(innerCourseHtml);
            $("#week").html(innerWeekHtml);

        }

        //주차 바인딩
        function fnGetWeek() {
            var courseNo = $("#course").val();
            if (courseNo != "courseBlock") {
                ajaxHelper.CallAjaxPost("/Ocw/GetWeek", { CourseNo: courseNo }, "fnCbWeek");
            }
            else {
                $("#week").html();

                var innerWeekBlock = "";
                innerWeekBlock = "<option value=weekBlock>주차를 선택하세요</option>"
                $("#week").html(innerWeekBlock);
            }
        }

        function fnCbWeek() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            var innerHtml = "";
            innerHtml = "<option value=weekBlock>주차를 선택하세요</option>";

            for (var i = 0; i < ajaxResult.length; i++) {
                innerHtml += "<option value='" + ajaxResult[i].Week + "'>" + ajaxResult[i].Week + "";
            }

            $("#week").html(innerHtml);
        }

        //강좌 적용하기
        function fnAddCourse() {
            if ($("#term").val() == "termBlock") {
                bootAlert("<%:ConfigurationManager.AppSettings["TermText"].ToString() %>를 선택하세요.");
            }
            else if ($("#course").val() == "courseBlock") {
                bootAlert("<%:ConfigurationManager.AppSettings["SubjectText"].ToString() %>/분반을 선택하세요.");
            }
            else if ($("#week").val() == "weekBlock") {
                bootAlert("주차를 선택하세요.");
            }
            else {
                var objParam = {
                    CourseNo: parseInt($("#course").val()),
                    OcwNo: <%:Model.Ocw.OcwNo%>,
                    Impt: $("#impt").val() == "IMPT001" ? 1 : 0,
                    WeeK: parseInt($("#week").val())
                };

                ajaxHelper.CallAjaxPost("/Ocw/AddCourse", objParam, "fnCbAddCourse");
            }

        }

        function fnCbAddCourse() {
            var ajaxResult = ajaxHelper.CallAjaxResult();
            if (ajaxResult > 0) {
                bootAlert("추가되었습니다.", function () {
                    fnRefresh("courseInfo");
                });
            }
            else {
                bootAlert("이미 등록된 콘텐츠이거나 미승인된 콘텐츠입니다.");
            }
        }

        //강의 연계 현황 조회
        function fnGetCourseLink() {
            var termNo = $("#termSub").val();
            var ocwNo = $("#hdnOcwNo").val();

            ajaxHelper.CallAjaxPost("/Ocw/GetCourseLink", { OcwNo: ocwNo, TermNo: termNo }, "fnSetCourseLink");
        }

        function fnSetCourseLink() {
            var ajaxResult = ajaxHelper.CallAjaxResult();

            $("#CourseLinkList > tbody").empty();

            var html = '';
            if (ajaxResult.length > 0) {
                for (var i = 0; i < ajaxResult.length; i++) {
                    let impt = ajaxResult[i].IsImportant == '0' ? '보조' : '필수';

                    html += "<tr>";
                    html += "<td class=\"text-center\">" + ajaxResult[i].IsCourseOcwName + "</td>";
                    html += "<td class=\"text-center text-nowrap\">" + ajaxResult[i].TermYear + "/" + ajaxResult[i].TermQuarterName + "</td>";
                    html += "<td class=\"text-center text-nowrap\">" + ajaxResult[i].SubjectName + "</td>";
                    html += "<td class=\"text-center text-nowrap\">" + ajaxResult[i].Week + "</td>";
                    html += "<td class=\"text-center text-nowrap\">" + ajaxResult[i].SeqNo + "</td>";
                    html += "<td class=\"text-center text-nowrap\">" + impt + "</td>";
                    html += "</tr>";
                }

            } else {
                html += "<tr>";
                html += "<td colspan=\"6\" class=\"text-center\">조회된 자료가 없습니다.";
                html += "</td>";
                html += "</tr>";
            }

            $("#CourseLinkList > tbody").append(html);
        }

        /* 강의 연계 script END*/
	</script>

</asp:Content>
