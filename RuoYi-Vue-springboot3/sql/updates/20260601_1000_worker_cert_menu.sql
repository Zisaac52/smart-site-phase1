-- =============================================================
-- 变更说明：「人员管理」目录下新增「资质证件」菜单（tb_worker_cert 的 CRUD）
-- 依据    ：doc/First_stage_v2.md（资质证件上传 + 审核）
-- 作者    ：Zisaac52
-- 日期    ：2026-06-01
-- 执行    ：mysql -u <本地账号> -p ry-vue < sql/updates/20260601_1000_worker_cert_menu.sql
-- 说明    ：tb_worker_cert 表已在 worker_module 里建好，本文件只加菜单。
--           父目录用 SELECT 查「人员管理」menu_id，不硬编码，跨库可重放。
-- =============================================================
USE `ry-vue`;

SET @worker_dir_id := (SELECT menu_id FROM sys_menu WHERE menu_name='人员管理' AND parent_id=0 LIMIT 1);

-- C 菜单：资质证件（对应 tb_worker_cert 的 CRUD 页面 worker/cert/index）
INSERT INTO `sys_menu`
  (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES
  ('资质证件', @worker_dir_id, 3, 'cert', 'worker/cert/index', '', '', 1, 0, 'C', '0', '0', 'worker:cert:list', 'documentation', 'admin', NOW(), '人员资质证件上传与审核');
SET @cert_menu_id := LAST_INSERT_ID();

-- 资质证件 5 个按钮权限
INSERT INTO `sys_menu`
  (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`)
VALUES
  ('资质证件查询', @cert_menu_id, 1, '#', '', 1, 0, 'F', '0', '0', 'worker:cert:query',  '#', 'admin', NOW()),
  ('资质证件新增', @cert_menu_id, 2, '#', '', 1, 0, 'F', '0', '0', 'worker:cert:add',    '#', 'admin', NOW()),
  ('资质证件修改', @cert_menu_id, 3, '#', '', 1, 0, 'F', '0', '0', 'worker:cert:edit',   '#', 'admin', NOW()),
  ('资质证件删除', @cert_menu_id, 4, '#', '', 1, 0, 'F', '0', '0', 'worker:cert:remove', '#', 'admin', NOW()),
  ('资质证件导出', @cert_menu_id, 5, '#', '', 1, 0, 'F', '0', '0', 'worker:cert:export', '#', 'admin', NOW());
