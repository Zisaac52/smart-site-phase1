-- =============================================================
-- 变更说明：<一句话描述这次改了什么，例如：新增「作业单」模块>
-- 作者    ：<你的名字>
-- 日期    ：<YYYY-MM-DD>
-- 关联     ：<可选：分支名 / PR 链接 / 任务号>
-- 执行     ：mysql -u <你的本地账号> -p ry-vue < 本文件
-- =============================================================
USE `ry-vue`;

-- -------------------------------------------------------------
-- 1) 建表 DDL（把代码生成器或手写的 CREATE TABLE 贴到这里）
-- -------------------------------------------------------------
-- DROP TABLE IF EXISTS `biz_worksheet`;
-- CREATE TABLE `biz_worksheet` (
--   `id`          bigint        NOT NULL AUTO_INCREMENT COMMENT '主键',
--   `worksheet_no` varchar(64)  NOT NULL                COMMENT '作业单编号',
--   `create_by`   varchar(64)   DEFAULT ''              COMMENT '创建者',
--   `create_time` datetime      DEFAULT NULL            COMMENT '创建时间',
--   PRIMARY KEY (`id`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作业单';

-- -------------------------------------------------------------
-- 2) 菜单 SQL（把若依「代码生成 → 生成菜单」给出的 sys_menu INSERT 贴到这里）
--    提示：若用了固定的 menu_id，要确保不和现有菜单 / 同伴的冲突；
--          拿不准就让 menu_id 自增（INSERT 时不写 menu_id 列）。
-- -------------------------------------------------------------
-- insert into sys_menu
--   (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time)
-- values
--   ('作业单', 0, 5, 'worksheet', 'biz/worksheet/index', 1, 0, 'C', '0', '0', 'biz:worksheet:list', 'form', 'admin', sysdate());

-- -------------------------------------------------------------
-- 3) 字典（按需：sys_dict_type / sys_dict_data）
-- -------------------------------------------------------------

-- -------------------------------------------------------------
-- 4) 其它初始化数据（按需）
-- -------------------------------------------------------------
