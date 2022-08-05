<%@ Page Language="C#" MasterPageFile="~/Views/Shared/sub.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content" ContentPlaceHolderID="ContentBlock" runat="server">

	<ul class="nav nav-tabs mt-4" id="myTab" role="tablist">
		<li class="nav-item" role="presentation">
			<a class="nav-link active show" id="tab1-tab" data-toggle="tab" href="#tab1" role="tab" aria-controls="tab1" aria-selected="true">설립근거 및 목적</a>
		</li>
		<li class="nav-item" role="presentation">
			<a class="nav-link" id="tab2-tab" data-toggle="tab" href="#tab2" role="tab" aria-controls="tab2" aria-selected="false">연혁</a>
		</li>
	</ul>
        
	<div class="tab-content" id="myTabContent">
		<div class="tab-pane fade active show" id="tab1" role="tabpanel" aria-labelledby="tab1-tab">
			<h3 class="title03 sr-only">설립근거 및 목적</h3>
			<div class="establishment">
				<div class="row no-gutters">
					<div class="col-lg-6">
						<h4><img src="/site/resource/www/images/robot-icon01.svg" class="img-fluid" alt> 설립근거</h4>
						<div>지능형 로봇개발 및 보급 촉진법 제 41조<br>(한국로봇산업진흥원의 설립 등)</div>
					</div>
					<div class="col-lg-6">
						<h4><img src="/site/resource/www/images/robot-icon02.svg" class="img-fluid" alt> 설립목적</h4>
						<div>지능형 로봇산업 육성을 위한 다양한 사업을 효율적이고 체계적으로 추진하고 관련정책의 개발을 지원하는 기관으로서 한국 로봇산업진흥원 설립</div>
					</div>
				</div>

				<div>
					<ul>
						<li>01. 정책의 수립 및 개발</li>
						<li>02. 동향조사 및 출판 &middot; 전시 &middot; 홍보</li>
						<li>03. 통계작성 및 실태조사</li>
						<li>04. 로봇윤리헌장의 실행 &middot; 홍보</li>
						<li>05. 시범사업 및 보급 &middot; 확산</li>
						<li>06. 국제협력 및 해외 진출 지원</li>
						<li>07. 로봇제조에 대한 지원</li>
						<li>08. KS인증(로봇)사업</li>
						<li>09. 표준의 연구개발 &middot; 보급 및 국제표준화 활동</li>
						<li>10. 기반조성사업</li>
						<li>11. 창업 &middot; 성장 등의 지원</li>
						<li>12. 산업기술개발 사업</li>
						<li>13. 로봇 전문인력 양성 사업</li>
						<li>14. 기타 산업통상자원부장관이 인정하는 사업</li>
					</ul>
				</div>
			</div>
		</div>

		<div class="tab-pane fade" id="tab2" role="tabpanel" aria-labelledby="tab2-tab">
			<h3 class="title03 sr-only">연혁</h3>
			<div class="mt-5">
				<div class="row no-gutters history">
					<div class="col-md-3 col-lg-2">
						<h4>2021</h4>
					</div>
					<div class="col-md-9 col-lg-10">
						<dl>
							<dt>04</dt>
							<dd>제5대 손웅희 원장 취임</dd>
						</dl>
					</div>
				</div><!-- row -->

				<div class="row no-gutters history">
					<div class="col-md-3 col-lg-2">
						<h4>2020</h4>
					</div>
					<div class="col-md-9 col-lg-10">
						<dl>
							<dt>07</dt>
							<dd>한국로봇산업진흥원 10주년 기념식 및 백서 발간</dd>
							<dt>09</dt>
							<dd>공공부문 인적자원개발 우수기관 선정(3회 연속)<br>2019 경영실적평가 A(우수) 획득</dd>
						</dl>
					</div>
				</div><!-- row -->

				<div class="row no-gutters history">
					<div class="col-md-3 col-lg-2">
						<h4>2019</h4>
					</div>
					<div class="col-md-9 col-lg-10">
						<dl>
							<dt>03</dt>
							<dd>로봇산업 육성전략 발표</dd>
							<dt>05</dt>
							<dd>로봇규제혁신지원센터 개소</dd>
							<dt>08</dt>
							<dd>제3차 지능형 로봇 기본계획 공고</dd>
							<dt>09</dt>
							<dd>교육부 교육기부 우수기관 인증 획득</dd>
						</dl>
					</div>
				</div><!-- row -->

				<div class="row no-gutters history">
					<div class="col-md-3 col-lg-2">
						<h4>2018</h4>
					</div>
					<div class="col-md-9 col-lg-10">
						<dl>
							<dt>01</dt>
							<dd>제4대 문전일 원장 취임</dd>
							<dt>12</dt>
							<dd>교육부 교육기부 진로체험 인증기관 선정</dd>
						</dl>
					</div>
				</div><!-- row -->

				<div class="row no-gutters history">
					<div class="col-md-3 col-lg-2">
						<h4>2017</h4>
					</div>
					<div class="col-md-9 col-lg-10">
						<dl>
							<dt>09</dt>
							<dd>교육부 공공부문 인적자원개발 우수기관 인증 획득</dd>
							<dt>11</dt>
							<dd>여성가족부 가족친화 인증기관 선정</dd>
						</dl>
					</div>
				</div><!-- row -->

				<div class="row no-gutters history">
					<div class="col-md-3 col-lg-2">
						<h4>2016</h4>
					</div>
					<div class="col-md-9 col-lg-10">
						<dl>
							<dt>04</dt>
							<dd>로봇창업보육센터 지정 획득</dd>
							<dt>07</dt>
							<dd>KS인증기관 지정 획득</dd>
							<dt>12</dt>
							<dd>제3대 박기한 원장 취임</dd>
						</dl>
					</div>
				</div><!-- row -->

				<div class="row no-gutters history">
					<div class="col-md-3 col-lg-2">
						<h4>2015</h4>
					</div>
					<div class="col-md-9 col-lg-10">
						<dl>
							<dt>01</dt>
							<dd>진흥원 청사 입주 및 업무 개시</dd>
							<dt>05</dt>
							<dd>로봇산업클러스터 준공</dd>
							<dt>12</dt>
							<dd>로봇산업클러스터 출범식 개최</dd>
						</dl>
					</div>
				</div><!-- row -->

				<div class="row no-gutters history">
					<div class="col-md-3 col-lg-2">
						<h4>2014</h4>
					</div>
					<div class="col-md-9 col-lg-10">
						<dl>
							<dt>03</dt>
							<dd>2실2단(8팀, 1센터)으로 조직 개편</dd>
							<dt>06</dt>
							<dd>시장창출형 로봇보급사업 성과발표회 개최</dd>
							<dt>11</dt>
							<dd>진흥원 청사 완공</dd>
						</dl>
					</div>
				</div><!-- row -->

				<div class="row no-gutters history">
				<div class="col-md-3 col-lg-2">
				<h4>2013</h4>
				</div>
				<div class="col-md-9 col-lg-10">
				<dl>
				<dt>03</dt>
				<dd>한국로봇산업진흥원 비전 선포식 개최</dd>
				<dt>04</dt>
				<dd>한국로봇산업진흥원 청사기공식 개최</dd>
				<dt>09</dt>
				<dd>제2대 정경원 원장 취임</dd>
				</dl>
				</div>
				</div><!-- row -->

				<div class="row no-gutters history">
					<div class="col-md-3 col-lg-2">
						<h4>2012</h4>
					</div>
					<div class="col-md-9 col-lg-10">
						<dl>
							<dt>07</dt>
							<dd>로봇산업클러스터 조성사업 기반조성 부문 주관기관 선정</dd>
						</dl>
					</div>
				</div><!-- row -->

				<div class="row no-gutters history">
					<div class="col-md-3 col-lg-2">
						<h4>2011</h4>
					</div>
					<div class="col-md-9 col-lg-10">
						<dl>
							<dt>02</dt>
							<dd>기타 공공기관 지정(기획재정부)<br>범부처 로봇시범사업총괄추진단 발족</dd>
							<dt>07</dt>
							<dd>지능형로봇 개발 및 보급 촉진법 개정(로봇전문기업 지정제도 도입 등)</dd>
							<dt>08</dt>
							<dd>로봇산업클러스터조성사업 예비타당성 조사 통과(총사업비 2,328억원)</dd>
						</dl>
					</div>
				</div><!-- row -->

				<div class="row no-gutters history">
					<div class="col-md-3 col-lg-2">
						<h4>2010</h4>
					</div>
					<div class="col-md-9 col-lg-10">
						<dl>
							<dt>02</dt>
							<dd>진흥원 대구입지 확정</dd>
							<dt>03</dt>
							<dd>진흥원 설립에 따른 수도권 기업 지원방안 수립</dd>
							<dt>06</dt>
							<dd>진흥원 설립허가 &middot; 등기</dd>
							<dt>07</dt>
							<dd>진흥원 개원 및 창립이사회 개최</dd>
						</dl>
					</div>
				</div><!-- row -->

				<div class="row no-gutters history">
					<div class="col-md-3 col-lg-2">
						<h4>2009</h4>
					</div>
				<div class="col-md-9 col-lg-10">
						<dl>
							<dt>07</dt>
							<dd>	진흥원 설립 추진 기본계획 수립</dd>
						</dl>
					</div>
				</div><!-- row -->

				<div class="row no-gutters history">
					<div class="col-md-3 col-lg-2">
						<h4>2008</h4>
					</div>
					<div class="col-md-9 col-lg-10">
						<dl>
							<dt>03</dt>
							<dd>지능형로봇 개발 및 보급 촉진법 제정</dd>
						</dl>
					</div>
				</div><!-- row -->
			</div>
		</div>

	</div>
</asp:Content>
