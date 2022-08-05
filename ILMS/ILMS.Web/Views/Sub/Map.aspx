<%@ Page Language="C#" MasterPageFile="~/Views/Shared/sub.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

	<ul class="nav nav-tabs mt-4" id="myTab" role="tablist">
		<li class="nav-item" role="presentation">
			<a class="nav-link active show" id="tab1-tab" data-toggle="tab" href="#tab1" role="tab" aria-controls="tab1" aria-selected="true" onclick="tab1()">한국로봇산업진흥원 본원</a>
		</li>
		<li class="nav-item" role="presentation">
			<a class="nav-link" id="tab2-tab" data-toggle="tab" href="#tab2" role="tab" aria-controls="tab2" aria-selected="false" onclick="tab2()">마이스터 로봇화 교육센터</a>
		</li>
	</ul>
        
	<div class="tab-content" id="myTabContent">
		<div class="tab-pane fade active show" id="tab1" role="tabpanel" aria-labelledby="tab1-tab">
			<h3 class="title03 sr-only">한국로봇산업진흥원 본원</h3>

			<div class="mt-5">
				<div class="map-wrap">
					<!-- * 카카오맵 - 지도퍼가기 -->
					<!-- 1. 지도 노드 -->
					<div id="daumRoughmapContainer1649228340076" class="root_daum_roughmap root_daum_roughmap_landing"></div>

					<!--2. 설치 스크립트 	* 지도 퍼가기 서비스를 2개 이상 넣을 경우, 설치 스크립트는 하나만 삽입합니다.	-->
					<script charset="UTF-8" class="daum_roughmap_loader_script" src="https://ssl.daumcdn.net/dmaps/map_js_init/roughmapLoader.js"></script>
					<!-- 3. 실행 스크립트 -->
					<script charset="UTF-8">
						new daum.roughmap.Lander({
							"timestamp": "1649228340076",
							"key": "29quc",
							"mapWidth": "100%",
							"mapHeight": "480"
						}).render();
					</script>

					<div class="mapinfo" id="mapinfo">
						<dl class="map-info addr">
							<dt class="address">주소</dt>
							<dd>41496 대구광역시 북구 노원로 77(노원동 3가)</dd>
						</dl>
						<dl class="map-info tel">
							<dt class="address">전화</dt>
							<dd>053-210-9600</dd>
						</dl>
						<dl class="map-info tel">
							<dt class="address">팩스</dt>
							<dd>053-210-9529</dd>
						</dl>
						<a href="http://kko.to/Qq_b5MroY" class="map-btn" target="_blank" rel="noopener noreferrer"><span class="stit"></span></a>
					</div>
				</div>
			</div>

			<div class="traffic-wrap mt-5">
				<div class="in-sec">
					<div class="traffic-sec">
						<h4 class="highway">고속&amp;시외버스</h4>
					</div>
					<div class="course-wrap spc">
						<div class="course-line">
							<h5 class="direction">동대구 고속터미널</h5>
							<ol class="list-style02">
								<li>북구3(한국국토정보공사 앞)</li>
								<li><strong>한국로봇산업진흥원후문건너</strong> 하차</li>
								<li>대구은행 3공단 지점 방면 200m걷기 - 도보4분</li>
							</ol>
						</div>
						<div class="course-line">
							<h5 class="direction">동부정류장</h5>
							<ol class="list-style02">
								<li>순환2-1(동부정류장 건너)</li>
								<li>연암네거리1 정류장 하차</li>
								<li>북구1(연암네거리2 정류장)</li>
								<li><strong>한국로봇산업진흥원앞</strong> 하차</li>
								<li>만평역 방면 횡단보도 건넘 - 도보2분</li>
							</ol>
						</div>
						<div class="course-line">
							<h5 class="direction">서부정류장</h5>
							<ol class="list-style02">
								<li>급행6(서부정류장4)</li>
								<li>국민건강보험공단 앞 하차</li>
								<li>순환3(국민건강보험공단 앞)</li>
								<li><strong>한국로봇산업진흥원건너</strong> 하차</li>
								<li>노원네거리 방면 횡단보도 건넘 - 도보2분</li>
							</ol>
						</div>
						<div class="course-line">
							<h5 class="direction">북부정류장</h5>
							<ol class="list-style02">
								<li>서구1, 순환3(북부정류장건너)</li>
								<li><strong>한국로봇산업진흥원건너</strong> 하차</li>
								<li>노원네거리 방면 횡단보도 건넘 - 도보2분</li>
							</ol>
						</div>
					</div>
				</div>
				<div class="in-sec">
					<div class="traffic-sec">
						<h4 class="train">지하철</h4>
					</div>
					<div class="course-wrap spc">
						<div class="course-line">
							<h5 class="direction">3호선</h5>
							<ol class="list-style02">
								<li><strong>만평역</strong> 1번 출구 하차 후 노원네거리 방면 - 도보 15분</li>
							</ol>
						</div>
					</div>
				</div>
				<div class="in-sec">
					<div class="traffic-sec">
						<h4 class="plane">항공 &amp; 철도</h4>
					</div>
					<div class="course-wrap spc">
						<div class="course-line">
							<h5 class="direction">대구공항</h5>
							<ol class="list-style02">
								<li>동구2(대구국제공항 앞)</li>
								<li>명문세가APT앞 하차</li>
								<li>북구1(명문세가APT)</li>
								<li><strong>한국로봇산업진흥원앞</strong> 정류장 하차</li>
								<li>만평역 방면 횡단보도 건넘 - 도보 2분</li>
							</ol>
						</div>
						<div class="course-line">
							<h5 class="direction">동대구역</h5>
							<ol class="list-style02">
								<li>북구3(동대구역 건너)</li>
								<li><strong>한국로봇산업진흥원후문건너</strong> 하차</li>
								<li>대구은행 3공단지점 방면 200m걷기 - 도보4분</li>
							</ol>
						</div>
						<div class="course-line">
							<h5 class="direction">대구역</h5>
							<ol class="list-style02">
								<li>북구3(대구역 앞)</li>
								<li><strong>한국로봇산업진흥원후문건너</strong> 하차</li>
								<li>대구은행 3공단 지점 방면 200m걷기 - 도보4분</li>
							</ol>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- tab -->

		<!-- tab -->
	</div>
		<div class="tab-pane fade" id="tab2" role="tabpanel" aria-labelledby="tab2-tab">
			<h3 class="title03 sr-only">마이스터 로봇화 교육센터</h3>
			<div class="mt-5">
				<div class="map-wrap">
					<!-- 1. 지도 노드 -->
					<div id="daumRoughmapContainer1649232171579" class="root_daum_roughmap root_daum_roughmap_landing"></div>

					<!-- 2. 실행 스크립트 -->
					<script charset="UTF-8">
						new daum.roughmap.Lander({
							"timestamp": "1649232171579",
							"key": "29qw8",
							"mapWidth": "100%",
							"mapHeight": "480"
						}).render();
					</script>
					<div class="mapinfo" id="mapinfo2">
						<dl class="map-info addr">
							<dt class="address">주소</dt>
							<dd>06372 서울시 강남구 자곡로 7길 4, 아세아ICT센터 2층<br>
								(강남 ICT 로봇 리빙랩)</dd>
						</dl>
						<dl class="map-info tel">
							<dt class="address">전화</dt>
							<dd>02-568-9549</dd>
						</dl>
						<dl class="map-info tel">
							<dt class="address">팩스</dt>
							<dd>053-210-9529</dd>
						</dl>
						<a href="http://kko.to/VO4ZYxvPh" class="map-btn" target="_blank" rel="noopener noreferrer"><span class="stit"></span></a>
					</div>
				</div>
			</div>
			<div class="traffic-wrap mt-5">
				<div class="in-sec">
					<div class="traffic-sec">
						<h4 class="ktx">KTX</h4>
					</div>
					<div class="course-wrap spc">
						<div class="course-line">
							<h5 class="direction">서울KTX역 - URI-Lab서울</h5>
							<ol class="list-style02">
								<li>버스 이용 시, 1시간 20분 소요 택시 이용 시, 50분 소요</li>
							</ol>
						</div>
					</div>
				</div>
				<div class="in-sec">
					<div class="traffic-sec">
						<h4 class="car">자가용</h4>
					</div>
					<div class="course-wrap spc">
						<div class="course-line">
							<h5 class="direction">서울출발 (50분 소요)</h5>
							<ol class="list-style02">
								<li>삼일대로 - 올림픽대로 - 동부간선도로 - URI-Lab서울</li>
							</ol>
						</div>
						<div class="course-line">
							<h5 class="direction">부산출발 (4시간 30분 소요)</h5>
							<ol class="list-style02">
								<li>중앙고속도로(부산-대구) - 경부고속도로 - 중부내륙고속도로 - URI-Lab서울</li>
							</ol>
						</div>
					</div>
				</div>
			</div>
		</div>
</asp:Content>
<asp:Content ID="Script" ContentPlaceHolderID="ScriptBlock" runat="server">
    <script type="text/javascript">
		function tab1() {
			$("#tab2").addClass("d-none");
			$("#tab1").removeClass("d-none");
		}

		function tab2() {
			$("#tab1").addClass("d-none");
			$("#tab2").removeClass("d-none");
		}

	</script>
</asp:Content>


