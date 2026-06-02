-- =============================================================
-- 变更说明：「人员管理」目录下新增「人脸信息」菜单（tb_worker_face 的 CRUD）
-- 依据    ：doc/First_stage_v2.md（人脸信息采集）
-- 作者    ：Zisaac52
-- 日期    ：2026-06-01
-- 执行    ：mysql -u <本地账号> -p ry-vue < sql/updates/20260601_1030_worker_face_menu.sql
-- 说明    ：tb_worker_face 表已在 worker_module 里建好，本文件只加菜单。
--           父目录用 SELECT 查「人员管理」menu_id，不硬编码，跨库可重放。
-- =============================================================
USE `ry-vue`;

SET @worker_dir_id := (SELECT menu_id FROM sys_menu WHERE menu_name='人员管理' AND parent_id=0 LIMIT 1);

-- C 菜单：人脸信息（对应 tb_worker_face 的 CRUD 页面 worker/face/index）
INSERT INTO `sys_menu`
  (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES
  ('人脸信息', @worker_dir_id, 4, 'face', 'worker/face/index', '', '', 1, 0, 'C', '0', '0', 'worker:face:list', 'eye-open', 'admin', NOW(), '人员人脸采集（特征值后续 AI）');
SET @face_menu_id := LAST_INSERT_ID();

-- 人脸信息 5 个按钮权限
INSERT INTO `sys_menu`
  (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`)
VALUES
  ('人脸信息查询', @face_menu_id, 1, '#', '', 1, 0, 'F', '0', '0', 'worker:face:query',  '#', 'admin', NOW()),
  ('人脸信息新增', @face_menu_id, 2, '#', '', 1, 0, 'F', '0', '0', 'worker:face:add',    '#', 'admin', NOW()),
  ('人脸信息修改', @face_menu_id, 3, '#', '', 1, 0, 'F', '0', '0', 'worker:face:edit',   '#', 'admin', NOW()),
  ('人脸信息删除', @face_menu_id, 4, '#', '', 1, 0, 'F', '0', '0', 'worker:face:remove', '#', 'admin', NOW()),
  ('人脸信息导出', @face_menu_id, 5, '#', '', 1, 0, 'F', '0', '0', 'worker:face:export', '#', 'admin', NOW());
