package com.kh.spring.menu.model.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

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

	@Insert("insert into menu values(seq_menu_id.nextval, #{restaurant}, #{name}, #{price}, #{type}, #{taste})")
	@SelectKey(before = false, statement = "select seq_menu_id.currval from dual", resultType = int.class, keyProperty = "id")
	int insertMenu(Menu menu);

	@Update("update menu set restaurant = #{restaurant}, name = #{name}, price = #{price}, type = #{type}, taste = #{taste} where id = #{id}")
	int updateMenu(Menu menu);

	@Delete("delete from menu where id = #{id}")
	int deleteMenu(int id);

}
