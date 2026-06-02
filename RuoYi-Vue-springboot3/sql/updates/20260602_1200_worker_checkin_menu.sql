-- 打卡记录菜单（tb_worker_checkin CRUD）
USE `ry-vue`;

SET @dir := (SELECT menu_id FROM sys_menu WHERE menu_name='人员管理' AND parent_id=0 LIMIT 1);

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
VALUES ('打卡记录', @dir, 6, 'checkin', 'worker/checkin/index', '', '', 1, 0, 'C', '0', '0', 'worker:checkin:list', 'time', 'admin', NOW(), '签到/签退/点到 打卡记录');
SET @mid := LAST_INSERT_ID();

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
VALUES
('打卡记录查询', @mid, 1, '#', '', 1, 0, 'F', '0', '0', 'worker:checkin:query',  '#', 'admin', NOW()),
('打卡记录新增', @mid, 2, '#', '', 1, 0, 'F', '0', '0', 'worker:checkin:add',    '#', 'admin', NOW()),
('打卡记录修改', @mid, 3, '#', '', 1, 0, 'F', '0', '0', 'worker:checkin:edit',   '#', 'admin', NOW()),
('打卡记录删除', @mid, 4, '#', '', 1, 0, 'F', '0', '0', 'worker:checkin:remove', '#', 'admin', NOW()),
('打卡记录导出', @mid, 5, '#', '', 1, 0, 'F', '0', '0', 'worker:checkin:export', '#', 'admin', NOW());
