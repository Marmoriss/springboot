package com.kh.spring.menu.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.spring.menu.model.dao.MenuDao;
import com.kh.spring.menu.model.dto.Menu;
import com.kh.spring.menu.model.dto.Taste;
import com.kh.spring.menu.model.dto.Type;

@Service
public class MenuServiceImpl implements MenuService {

	@Autowired
	MenuDao menuDao;
	
	@Override
	public List<Menu> selectAllMenu() {
		return menuDao.selectAllMenu();
	}
	
	@Override
	public List<Menu> findByType(Type type) {
		return menuDao.findByType(type);
	}
	
	@Override
	public List<Menu> findByTypeAndTaste(Menu menu) {
		return menuDao.findByTypeAndTaste(menu);
	}
	
	@Override
	public Menu findById(int id) {
		return menuDao.findById(id);
	}
	
	@Override
	public int insertMenu(Menu menu) {
		return menuDao.insertMenu(menu);
	}
	
	@Override
	public int updateMenu(Menu menu) {
		return menuDao.updateMenu(menu);
	}
	
	@Override
	public int deleteMenu(int id) {
		return menuDao.deleteMenu(id);
	}
	
	
}
