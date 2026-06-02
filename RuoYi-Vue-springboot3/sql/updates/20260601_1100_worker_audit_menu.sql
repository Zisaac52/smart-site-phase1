-- =============================================================
-- 变更说明：「人员管理」目录下新增「审核记录」菜单（tb_worker_audit 的 CRUD）
-- 依据    ：doc/First_stage_v2.md（资料审核及状态维护）
-- 作者    ：Zisaac52
-- 日期    ：2026-06-01
-- 执行    ：mysql -u <本地账号> -p ry-vue < sql/updates/20260601_1100_worker_audit_menu.sql
-- 说明    ：tb_worker_audit 表已在 worker_module 里建好，本文件只加菜单。
--           父目录用 SELECT 查「人员管理」menu_id，不硬编码，跨库可重放。
-- =============================================================
USE `ry-vue`;

SET @worker_dir_id := (SELECT menu_id FROM sys_menu WHERE menu_name='人员管理' AND parent_id=0 LIMIT 1);

-- C 菜单：审核记录（对应 tb_worker_audit 的 CRUD 页面 worker/audit/index）
INSERT INTO `sys_menu`
  (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES
  ('审核记录', @worker_dir_id, 5, 'audit', 'worker/audit/index', '', '', 1, 0, 'C', '0', '0', 'worker:audit:list', 'list', 'admin', NOW(), '人员/资质 资料审核流水');
SET @audit_menu_id := LAST_INSERT_ID();

-- 审核记录 5 个按钮权限
INSERT INTO `sys_menu`
  (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`)
VALUES
  ('审核记录查询', @audit_menu_id, 1, '#', '', 1, 0, 'F', '0', '0', 'worker:audit:query',  '#', 'admin', NOW()),
  ('审核记录新增', @audit_menu_id, 2, '#', '', 1, 0, 'F', '0', '0', 'worker:audit:add',    '#', 'admin', NOW()),
  ('审核记录修改', @audit_menu_id, 3, '#', '', 1, 0, 'F', '0', '0', 'worker:audit:edit',   '#', 'admin', NOW()),
  ('审核记录删除', @audit_menu_id, 4, '#', '', 1, 0, 'F', '0', '0', 'worker:audit:remove', '#', 'admin', NOW()),
  ('审核记录导出', @audit_menu_id, 5, '#', '', 1, 0, 'F', '0', '0', 'worker:audit:export', '#', 'admin', NOW());
