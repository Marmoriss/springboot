﻿<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8" />
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param name="title" value="메뉴 RESTAPI" />
</jsp:include>
<style>
div.menu-test {
	width: 50%;
	margin: 0 auto;
	text-align: center;
}

div.result {
	width: 70%;
	margin: 0 auto;
}
</style>

<!-- 
	GET /menu
	
	GET /menu/type/kr
	GET /menu/type/ch
	GET /menu/type/jp
	
	GET /menu/taste/mild
	GET /menu/taste/hot

	GET /menu/type/kr/taste/mild

	GET /menu/10
	
	POST /menu
	
	PUT /menu
	PATCH /menu
	
	DELETE /menu/10
 -->

<div id="menu-container" class="text-center">
	<!-- 1.GET /menus-->
	<div class="menu-test">
		<h4>전체메뉴조회(GET)</h4>
		<input type="button"
			class="btn btn-block btn-outline-success btn-send" id="btn-menus"
			value="전송" />
	</div>
	<div class="result" id="menus-result"></div>
	<script>
	document.querySelector("#btn-menus").addEventListener('click', (e) => {
		$.ajax({
			url : "${pageContext.request.contextPath}/menu",
			method : "GET",
			success(response){
				console.log(response);
				renderTable(response, "#menus-result");
			},
			error : console.log
		});
	});
	
	const renderTable = (response, id) => {
		const container = document.querySelector(id);
		let html = `
		<table class='table'>
			<thead>
				<tr>
					<th>번호</th>
					<th>음식점</th>
					<th>메뉴명</th>
					<th>가격</th>
					<th>타입</th>
					<th>맛</th>
				</tr>
			</thead>
			<tbody>
		`;
		if(response.length){
			response.forEach((menu) => {
				const {id, restaurant, name, price, type, taste} = menu;
				html += `
					<tr>
						<td>\${id}</td>
						<td>\${restaurant}</td>
						<td>\${name}</td>
						<td>￦\${price.toLocaleString()}</td>
						<td>
							<span class="badge badge-pill badge-\${type === 'kr' ? 'primary' : (type === 'jp' ? 'secondary' : 'warning')}">\${type}</span>
						</td>
						<td>
							<span class="badge badge-pill badge-\${taste === 'mild' ? 'info' : 'danger'}">\${taste}</span>
						</td>
					</tr>
				`;
			});
		} 
		else {
			html += `
				<tr>
					<td class='text-center' colspan="6">검색된 결과가 없습니다.</td>
				</tr>
			`;
		}
		html += `
			</tbody>
		</table>
		`;
		
		container.innerHTML = html;
	};
	</script>

	<div class="menu-test">
		<h4>메뉴 타입별 조회(GET)</h4>
		<select class="form-control" id="typeSelector">
			<option value="" disabled selected>음식타입선택</option>
			<option value="kr">한식</option>
			<option value="ch">중식</option>
			<option value="jp">일식</option>
		</select>
	</div>
	<div class="result" id="menuType-result"></div>
	<script>
	document.querySelector("#typeSelector").addEventListener('change', (e) => {
		const type = e.target.value;
		console.log(type);
		$.ajax({
			url : `${pageContext.request.contextPath}/menu/type/\${type}`,
			method : "GET",
			success(response){
				console.log(response);
				renderTable(response, "#menuType-result");
			},
			error(xhr, statusText, err){
				if(xhr.status === 400){
					alert("해당 음식 타입은 존재하지 않습니다.");
				}
				else {
					console.log(xhr, statusText, err);
				}
			}
		});
	});
	
	</script>
	<div class="menu-test">
		<h4>메뉴 타입/맛별 조회(GET)</h4>
		<form name="menuTypeTasteFrm">
			<div class="form-check form-check-inline">
				<input type="radio" class="form-check-input" name="type" id="get-kr"
					value="kr"> <label for="get-kr" class="form-check-label">한식</label>&nbsp;
				<input type="radio" class="form-check-input" name="type" id="get-ch"
					value="ch"> <label for="get-ch" class="form-check-label">중식</label>&nbsp;
				<input type="radio" class="form-check-input" name="type" id="get-jp"
					value="jp"> <label for="get-jp" class="form-check-label">일식</label>&nbsp;
			</div>
			<br />
			<div class="form-check form-check-inline">
				<input type="radio" class="form-check-input" name="taste"
					id="get-hot" value="hot"> <label for="get-hot"
					class="form-check-label">매운맛</label>&nbsp; <input type="radio"
					class="form-check-input" name="taste" id="get-mild" value="mild">
				<label for="get-mild" class="form-check-label">순한맛</label>
			</div>
			<br /> <input type="submit"
				class="btn btn-block btn-outline-success btn-send" value="전송">
		</form>
	</div>
	<div class="result" id="menuTypeTaste-result"></div>

	<script>
	document.menuTypeTasteFrm.addEventListener('submit', (e) => {
		e.preventDefault();
		
		const type = e.target.type.value;
		const taste = e.target.taste.value;
		if(!type || !taste) return;
		
		$.ajax({
			url : `${pageContext.request.contextPath}/menu/type/\${type}/taste/\${taste}`,
			success(response){
				console.log(response);
				renderTable(response, "#menuTypeTaste-result");
			},
			error(xhr, statusText, err){
				if(xhr.status === 404){
					alert("해당 타입/맛별 음식은 존재하지 않습니다.");
				}
				else {
					console.log(xhr, statusText, err);
				}
			}
			
		});
	});
	</script>
	<div class="menu-test">
		<h4>메뉴 등록하기(POST)</h4>
		<form name="menuEnrollFrm">
			<input type="text" name="restaurant" placeholder="음식점" class="form-control" required />
			<br />
			<input type="text" name="name" placeholder="메뉴" class="form-control" required />
			<br />
			<input type="number" name="price" placeholder="가격" class="form-control" required />
			<br />
			<div class="form-check form-check-inline">
				<input type="radio" class="form-check-input" name="type" id="post-kr" value="kr" checked>
				<label for="post-kr" class="form-check-label">한식</label>&nbsp; 
				<input type="radio" class="form-check-input" name="type" id="post-ch" value="ch">
				<label for="post-ch" class="form-check-label">중식</label>&nbsp; 
				<input type="radio" class="form-check-input" name="type" id="post-jp" value="jp"> 
				<label for="post-jp" class="form-check-label">일식</label>&nbsp;
			</div>
			<br />
			<div class="form-check form-check-inline">
				<input type="radio" class="form-check-input" name="taste" id="post-hot" value="hot" checked>
				<label for="post-hot" class="form-check-label">매운맛</label>&nbsp;
				<input type="radio" class="form-check-input" name="taste" id="post-mild" value="mild">
				<label for="post-mild" class="form-check-label">순한맛</label>
			</div>
			<br /> 
			<input type="submit" class="btn btn-block btn-outline-success btn-send" value="등록">
		</form>
	</div>
	<script>
	document.menuEnrollFrm.addEventListener('submit', (e) => {
		e.preventDefault(); // 제출 방지
		
		const frm = e.target;
		const restaurant = frm.restaurant.value;
		const name = frm.name.value;
		const price = frm.price.value;
		const type = frm.type.value;
		const taste = frm.taste.value;
		const menu = {
				restaurant, name, price, type, taste
			};
		console.log(menu);
		console.log(JSON.stringify(menu));
		
		$.ajax({
			url : "${pageContext.request.contextPath}/menu",
			method : "POST",
			data : JSON.stringify(menu),
			contentType : 'application/json; charset=utf-8',
			success(response, textStatus, jqxhr){
				console.log(response, textStatus, jqxhr);
				// 응답헤데어 Location 확인
				const location = jqxhr.getResponseHeader('Location');
				console.log(location);
			},
			error : console.log
		});
	});
	</script>
	
	<div class="menu-test">
		<h4>메뉴 수정하기(PUT)</h4>
		<p>메뉴번호를 사용해 해당메뉴정보를 수정함.</p>
		<form id="menuSearchFrm" name="menuSearchFrm">
			<input type="text" name="id" placeholder="메뉴번호" class="form-control" /><br />
			<input type="submit" class="btn btn-block btn-outline-primary btn-send" value="검색" >
		</form>
	
		<hr />
		<form id="menuUpdateFrm" name="menuUpdateFrm">
			<!-- where조건절에 사용할 id를 담아둠 -->
			<input type="hidden" name="id" />
			
			<input type="text" name="restaurant" placeholder="음식점" class="form-control" />
			<br />
			<input type="text" name="name" placeholder="메뉴" class="form-control" />
			<br />
			<input type="number" name="price" placeholder="가격" step="1000" class="form-control" />
			<br />
			<div class="form-check form-check-inline">
				<input type="radio" class="form-check-input" name="type" id="put-kr" value="kr" checked>
				<label for="put-kr" class="form-check-label">한식</label>&nbsp;
				<input type="radio" class="form-check-input" name="type" id="put-ch" value="ch">
				<label for="put-ch" class="form-check-label">중식</label>&nbsp;
				<input type="radio" class="form-check-input" name="type" id="put-jp" value="jp">
				<label for="put-jp" class="form-check-label">일식</label>&nbsp;
			</div>
			<br />
			<div class="form-check form-check-inline">
				<input type="radio" class="form-check-input" name="taste" id="put-hot" value="hot" checked>
				<label for="put-hot" class="form-check-label">매운맛</label>&nbsp;
				<input type="radio" class="form-check-input" name="taste" id="put-mild" value="mild">
				<label for="put-mild" class="form-check-label">순한맛</label>
			</div>
			<br />
			<input type="submit" class="btn btn-block btn-outline-success btn-send" value="수정" >
		</form>
	</div>
	<script>
	document.menuUpdateFrm.addEventListener('submit', (e) => {
		e.preventDefault();
		const frm = e.target;
		const menu = {};
		menu.id = frm.id.value;
		menu.restaurant = frm.restaurant.value;
		menu.name = frm.name.value;
		menu.price = frm.price.value;
		menu.type = frm.type.value;
		menu.taste = frm.taste.value;
		console.log(menu);
		console.log(JSON.stringify(menu));
		
		$.ajax({
			url : '${pageContext.request.contextPath}/menu',
			method : "PUT",
			data : JSON.stringify(menu),
			contentType : "application/json; charset=utf-8",
			success(response){
				console.log(response);
				alert(response.resultMessage);
				e.target.reset();
			},
			error : console.log
		});
		
	});
	
	document.menuSearchFrm.addEventListener('submit', (e) => {
		e.preventDefault();
		
		const frm = e.target;
		const id = frm.id.value;
		console.log(id);
		if(!id) return;
		
		$.ajax({
			url : `${pageContext.request.contextPath}/menu/\${id}`,
			method : "GET",
			success(response){
				console.log(response);
				
				const {id, restaurant, name, price, type, taste} = response;
				console.log(id, restaurant, name, price, type, taste);
				
				const menuUpdateFrm = document.menuUpdateFrm;
				menuUpdateFrm.id.value = id;
				menuUpdateFrm.restaurant.value = restaurant;
				menuUpdateFrm.name.value = name;
				menuUpdateFrm.price.value = price;
				menuUpdateFrm.type.value = type;
				menuUpdateFrm.taste.value = taste;
			},
			error(jqxhr, statusText, err){
				jqxhr.status === 404 && alert("해당 id는 존재하지 않습니다.");
				console.log(jqxhr, statusText, err);
			}
		});
	});
	
	</script>
	<div class="menu-test">
        <h4>메뉴 삭제하기(DELETE)</h4>
        <p>메뉴번호를 사용해 해당메뉴정보를 삭제함.</p>
        <form id="menuDeleteFrm" name="menuDeleteFrm">
            <input type="text" name="id" placeholder="메뉴번호" class="form-control" /><br />
            <input type="submit" class="btn btn-block btn-outline-danger btn-send" value="삭제" >
        </form>
    </div>
    <script>
    document.menuDeleteFrm.addEventListener('submit', (e) => {
    	e.preventDefault();
    	const id = e.target.id.value;
    	console.log(id);
    	if(!id) return;
    	
    	$.ajax({
    		url : `${pageContext.request.contextPath}/menu/\${id}`,
    		method : "DELETE",
    		success(response){
    			console.log(response);
    			alert(response.resultMessage);
    			e.target.reset();
    		},
    		error : console.log
    	});
    });
    </script>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>









