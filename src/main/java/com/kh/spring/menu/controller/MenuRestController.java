package com.kh.spring.menu.controller;

import java.net.URI;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.graphql.GraphQlProperties.Rsocket;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kh.spring.menu.model.dto.Menu;
import com.kh.spring.menu.model.dto.Taste;
import com.kh.spring.menu.model.dto.Type;
import com.kh.spring.menu.model.service.MenuService;

import lombok.extern.slf4j.Slf4j;

//@CrossOrigin
@RestController
@Slf4j
@RequestMapping("/menu")
public class MenuRestController {

	@Autowired
	MenuService menuService;

	@GetMapping
	public ResponseEntity<?> menu(HttpServletResponse response) {
//		response.addHeader("Access-Control-Allow-Origin", "http://localhost:9090");
//		response.addHeader("Access-Control-Allow-Origin", "*");
		return ResponseEntity.ok(menuService.selectAllMenu());
	}

	@GetMapping("/type/{type}")
	public ResponseEntity<?> findByType(@PathVariable Type type) {
		// 아무 것도 없으면 404
		List<Menu> list = menuService.findByType(type);

		if (list.isEmpty()) 
			return ResponseEntity.notFound().build(); //404

		return ResponseEntity.ok()
//				.header(HttpHeaders.ACCESS_CONTROL_ALLOW_ORIGIN, "*")
				.body(list);
	}
	
	
	@GetMapping("/type/{type}/taste/{taste}")
	public ResponseEntity<?> findByTypeAndTaste(@PathVariable Type type, @PathVariable Taste taste){
		Menu menu = Menu.builder()
						.type(type)
						.taste(taste)
						.build();
				
		List<Menu> list = menuService.findByTypeAndTaste(menu);
		
		if(list.isEmpty())
				return ResponseEntity.notFound().build();
		
		return ResponseEntity.ok(list);
	}
	
	@GetMapping("/{id}")
	public ResponseEntity<?> findById(@PathVariable int id){
		Menu menu = menuService.findById(id);
		if(menu == null)
			return ResponseEntity.notFound().build();
		
		return ResponseEntity.ok(menu);
	}
	
	@PostMapping
	public ResponseEntity<?> insertMenu(@RequestBody Menu menu, HttpServletRequest request){
		log.debug("menu = {}", menu);
		int result = menuService.insertMenu(menu);
		
		return ResponseEntity
				.created(URI.create(request.getContextPath() + "/menu/" + menu.getId()))
				.build(); // /springboot/menu/id
	}
	
	@PutMapping
	public ResponseEntity<?> updateMenu(@RequestBody Menu menu){
		log.debug("menu = {}", menu);
		int result = menuService.updateMenu(menu);
		Map<String, Object> map = new HashMap<>();
		map.put("result", "success");
		map.put("resultMessage", "성공적으로 수정했습니다.");
		
		return ResponseEntity.ok(map);
	}
	
	@DeleteMapping("/{id}")
	public ResponseEntity<?> deleteMenu(@PathVariable int id){
		int result = menuService.deleteMenu(id);
		Map<String, Object> map = new HashMap<>();
		map.put("result", "success");
		map.put("resultMessage", "성공적으로 삭제했습니다.");
		
		return ResponseEntity.ok().body(map); // 204
//		return ResponseEntity.noContent().build(); // 전달할 map 등이 없을 때 사용
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

}
