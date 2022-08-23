package com.kh.spring.menu.model.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.kh.spring.menu.model.dto.Menu;
import com.kh.spring.menu.model.dto.Taste;
import com.kh.spring.menu.model.dto.Type;

@Mapper
public interface MenuDao {
	
	@Select("select * from menu order by id")
	List<Menu> selectAllMenu();

	@Select("select * from menu where type = #{type}")
	List<Menu> findByType(Type type);

	@Select("select * from menu where type = #{type} and taste = #{taste}")
	List<Menu> findByTypeAndTaste(Menu menu);

	@Select("select * from menu where id = #{id}")
	Menu findById(int id);

}
