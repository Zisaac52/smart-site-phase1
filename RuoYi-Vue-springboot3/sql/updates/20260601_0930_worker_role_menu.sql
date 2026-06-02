-- =============================================================
-- 变更说明：「人员管理」目录下新增「角色规则」菜单（tb_worker_role 的 CRUD）
-- 依据    ：doc/First_stage_v2.md（角色规则表 + 多对多关联设计）
-- 作者    ：Zisaac52
-- 日期    ：2026-06-01
-- 执行    ：mysql -u <本地账号> -p ry-vue < sql/updates/20260601_0930_worker_role_menu.sql
-- 说明    ：tb_worker_role 表已在 20260601_worker_module.sql 建好，本文件只加菜单。
--           父目录用 SELECT 查「人员管理」menu_id，不硬编码，跨库可重放。
-- =============================================================
USE `ry-vue`;

SET @worker_dir_id := (SELECT menu_id FROM sys_menu WHERE menu_name='人员管理' AND parent_id=0 LIMIT 1);

-- C 菜单：角色规则（对应 tb_worker_role 的 CRUD 页面 worker/role/index）
INSERT INTO `sys_menu`
  (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES
  ('角色规则', @worker_dir_id, 2, 'role', 'worker/role/index', '', '', 1, 0, 'C', '0', '0', 'worker:role:list', 'role', 'admin', NOW(), '人员角色与考勤/资质规则');
SET @role_menu_id := LAST_INSERT_ID();

-- 角色规则 5 个按钮权限
INSERT INTO `sys_menu`
  (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`)
VALUES
  ('角色规则查询', @role_menu_id, 1, '#', '', 1, 0, 'F', '0', '0', 'worker:role:query',  '#', 'admin', NOW()),
  ('角色规则新增', @role_menu_id, 2, '#', '', 1, 0, 'F', '0', '0', 'worker:role:add',    '#', 'admin', NOW()),
  ('角色规则修改', @role_menu_id, 3, '#', '', 1, 0, 'F', '0', '0', 'worker:role:edit',   '#', 'admin', NOW()),
  ('角色规则删除', @role_menu_id, 4, '#', '', 1, 0, 'F', '0', '0', 'worker:role:remove', '#', 'admin', NOW()),
  ('角色规则导出', @role_menu_id, 5, '#', '', 1, 0, 'F', '0', '0', 'worker:role:export', '#', 'admin', NOW());
