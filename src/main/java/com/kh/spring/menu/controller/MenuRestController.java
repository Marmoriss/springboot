package com.kh.spring.menu.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.kh.spring.menu.model.dto.Menu;
import com.kh.spring.menu.model.dto.Taste;
import com.kh.spring.menu.model.dto.Type;
import com.kh.spring.menu.model.service.MenuService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/menu")
public class MenuRestController {

	@Autowired
	MenuService menuService;

	@GetMapping
	public ResponseEntity<?> menu() {

		return ResponseEntity.ok(menuService.selectAllMenu());
	}

	@GetMapping("/type/{type}")
	public ResponseEntity<?> findByType(@PathVariable Type type) {
		// 아무 것도 없으면 404
		List<Menu> list = menuService.findByType(type);

		if (list.isEmpty()) 
			return ResponseEntity.notFound().build(); //404

		return ResponseEntity.ok(list);
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
	
	
	
	

}
