package com.kh.spring.menu.model.service;

import java.util.List;

import com.kh.spring.menu.model.dto.Menu;
import com.kh.spring.menu.model.dto.Taste;
import com.kh.spring.menu.model.dto.Type;

public interface MenuService {

	List<Menu> selectAllMenu();

	List<Menu> findByType(Type type);

	List<Menu> findByTypeAndTaste(Menu menu);

	Menu findById(int id);

	int insertMenu(Menu menu);

	int updateMenu(Menu menu);

	int deleteMenu(int id);

	
	
}
