-- =============================================================
-- 变更说明：新增「人员信息与资质管理」模块（1.1）—— 7 张 tb_worker* 业务表 + 顶级菜单「人员管理」+ 相关数据字典
-- 依据    ：doc/First_stage_v2.md（角色采用「规则表 + 多对多关联」设计）
-- 作者    ：Zisaac52
-- 日期    ：2026-06-01
-- 执行    ：mysql -u <本地账号> -p ry-vue < sql/updates/20260601_0900_worker_module.sql
-- 说明    ：本文件只建「表/字典/顶级目录」；各表的增删改查菜单由若依代码生成器生成时挂到「人员管理」目录下。
-- =============================================================
USE `ry-vue`;

-- -------------------------------------------------------------
-- 1) tb_worker —— 人员基础档案（核心）
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `tb_worker`;
CREATE TABLE `tb_worker` (
  `id`           bigint       NOT NULL AUTO_INCREMENT COMMENT '人员ID',
  `worker_name`  varchar(50)  NOT NULL                COMMENT '姓名',
  `phone`        varchar(20)  DEFAULT ''              COMMENT '手机号',
  `id_card`      varchar(20)  DEFAULT ''              COMMENT '身份证号',
  `gender`       char(1)      DEFAULT '0'             COMMENT '性别（字典 sys_user_sex：0男 1女 2未知）',
  `dept_id`      bigint       DEFAULT NULL            COMMENT '所属单位（关联 sys_dept.dept_id）',
  `status`       char(1)      DEFAULT '0'             COMMENT '人员状态（字典 worker_status：0在场 1离场 2禁用）',
  `face_status`  char(1)      DEFAULT '0'             COMMENT '人脸录入状态（字典 worker_face_status：0未录入 1已录入）',
  `audit_status` char(1)      DEFAULT '0'             COMMENT '审核状态（字典 worker_audit_status：0待审核 1已通过 2已驳回 3已过期）',
  `del_flag`     char(1)      DEFAULT '0'             COMMENT '删除标志（0存在 2删除）',
  `create_by`    varchar(64)  DEFAULT ''              COMMENT '创建者',
  `create_time`  datetime     DEFAULT NULL            COMMENT '创建时间',
  `update_by`    varchar(64)  DEFAULT ''              COMMENT '更新者',
  `update_time`  datetime     DEFAULT NULL            COMMENT '更新时间',
  `remark`       varchar(500) DEFAULT NULL            COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `idx_id_card` (`id_card`),
  KEY `idx_dept` (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='人员基础档案';

-- -------------------------------------------------------------
-- 2) tb_worker_role —— 人员角色规则（打卡/点到/资质规则的载体）
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `tb_worker_role`;
CREATE TABLE `tb_worker_role` (
  `id`                bigint       NOT NULL AUTO_INCREMENT COMMENT '角色规则ID',
  `role_code`         varchar(50)  NOT NULL                COMMENT '角色编码',
  `role_name`         varchar(50)  NOT NULL                COMMENT '角色名称',
  `unit_type`         char(1)      DEFAULT ''              COMMENT '单位类型（字典 worker_unit_type：1管网 2第三方 3施工方）',
  `fixed_site_flag`   char(1)      DEFAULT '0'             COMMENT '是否固定工点（0否 1是）',
  `need_sign_in`      char(1)      DEFAULT '0'             COMMENT '是否需要签到（0否 1是）',
  `need_sign_out`     char(1)      DEFAULT '0'             COMMENT '是否需要签退（0否 1是）',
  `need_hourly_check` char(1)      DEFAULT '0'             COMMENT '是否需要点到（0否 1是）',
  `hourly_interval`   int          DEFAULT NULL            COMMENT '点到间隔（分钟）',
  `need_cert`         char(1)      DEFAULT '0'             COMMENT '是否需要资质（0否 1是）',
  `cert_type`         varchar(50)  DEFAULT ''              COMMENT '所需资质类型（字典 worker_cert_type）',
  `status`            char(1)      DEFAULT '0'             COMMENT '状态（0正常 1停用）',
  `create_by`         varchar(64)  DEFAULT ''              COMMENT '创建者',
  `create_time`       datetime     DEFAULT NULL            COMMENT '创建时间',
  `update_by`         varchar(64)  DEFAULT ''              COMMENT '更新者',
  `update_time`       datetime     DEFAULT NULL            COMMENT '更新时间',
  `remark`            varchar(500) DEFAULT NULL            COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_code` (`role_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='人员角色规则';

-- -------------------------------------------------------------
-- 3) tb_worker_role_rel —— 人员与角色 多对多关联
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `tb_worker_role_rel`;
CREATE TABLE `tb_worker_role_rel` (
  `id`        bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `worker_id` bigint NOT NULL                COMMENT '人员ID（tb_worker.id）',
  `role_id`   bigint NOT NULL                COMMENT '角色规则ID（tb_worker_role.id）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_worker_role` (`worker_id`, `role_id`),
  KEY `idx_role` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='人员角色关联';

-- -------------------------------------------------------------
-- 4) tb_worker_face —— 人脸信息
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `tb_worker_face`;
CREATE TABLE `tb_worker_face` (
  `id`           bigint       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `worker_id`    bigint       NOT NULL                COMMENT '人员ID',
  `face_img_url` varchar(500) DEFAULT ''              COMMENT '人脸照片URL',
  `face_feature` text                                 COMMENT '人脸特征值（当前阶段可空，后续 AI 生成）',
  `collect_time` datetime     DEFAULT NULL            COMMENT '采集时间',
  `create_by`    varchar(64)  DEFAULT ''              COMMENT '创建者',
  `create_time`  datetime     DEFAULT NULL            COMMENT '创建时间',
  `update_by`    varchar(64)  DEFAULT ''              COMMENT '更新者',
  `update_time`  datetime     DEFAULT NULL            COMMENT '更新时间',
  `remark`       varchar(500) DEFAULT NULL            COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `idx_worker` (`worker_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='人脸信息';

-- -------------------------------------------------------------
-- 5) tb_worker_cert —— 资质证件
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `tb_worker_cert`;
CREATE TABLE `tb_worker_cert` (
  `id`           bigint       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `worker_id`    bigint       NOT NULL                COMMENT '人员ID',
  `cert_type`    varchar(50)  DEFAULT ''              COMMENT '证件类型（字典 worker_cert_type）',
  `cert_no`      varchar(100) DEFAULT ''              COMMENT '证件编号',
  `issue_date`   date         DEFAULT NULL            COMMENT '发证日期',
  `expire_date`  date         DEFAULT NULL            COMMENT '过期日期',
  `cert_img`     varchar(500) DEFAULT ''              COMMENT '证件图片URL',
  `audit_status` char(1)      DEFAULT '0'             COMMENT '审核状态（字典 worker_audit_status：0待审核 1已通过 2已驳回 3已过期）',
  `create_by`    varchar(64)  DEFAULT ''              COMMENT '创建者',
  `create_time`  datetime     DEFAULT NULL            COMMENT '创建时间',
  `update_by`    varchar(64)  DEFAULT ''              COMMENT '更新者',
  `update_time`  datetime     DEFAULT NULL            COMMENT '更新时间',
  `remark`       varchar(500) DEFAULT NULL            COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `idx_worker` (`worker_id`),
  KEY `idx_expire` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资质证件';

-- -------------------------------------------------------------
-- 6) tb_worker_audit —— 资料审核记录
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `tb_worker_audit`;
CREATE TABLE `tb_worker_audit` (
  `id`            bigint       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `biz_type`      varchar(30)  DEFAULT ''              COMMENT '审核业务类型（worker人员 / cert资质）',
  `biz_id`        bigint       DEFAULT NULL            COMMENT '业务数据ID（人员ID 或 证件ID）',
  `worker_id`     bigint       DEFAULT NULL            COMMENT '关联人员ID',
  `audit_status`  char(1)      DEFAULT '0'             COMMENT '审核结果（字典 worker_audit_status：0待审核 1已通过 2已驳回 3已过期）',
  `audit_opinion` varchar(500) DEFAULT ''              COMMENT '审核意见 / 驳回原因',
  `auditor`       varchar(64)  DEFAULT ''              COMMENT '审核人',
  `audit_time`    datetime     DEFAULT NULL            COMMENT '审核时间',
  `create_by`     varchar(64)  DEFAULT ''              COMMENT '创建者',
  `create_time`   datetime     DEFAULT NULL            COMMENT '创建时间',
  `update_by`     varchar(64)  DEFAULT ''              COMMENT '更新者',
  `update_time`   datetime     DEFAULT NULL            COMMENT '更新时间',
  `remark`        varchar(500) DEFAULT NULL            COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `idx_worker` (`worker_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资料审核记录';

-- -------------------------------------------------------------
-- 7) tb_worker_checkin —— 打卡记录（签到/签退/点到，AI 字段预留）
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `tb_worker_checkin`;
CREATE TABLE `tb_worker_checkin` (
  `id`           bigint       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `worker_id`    bigint       NOT NULL                COMMENT '人员ID',
  `role_id`      bigint       DEFAULT NULL            COMMENT '打卡时角色ID',
  `check_type`   char(1)      DEFAULT ''              COMMENT '打卡类型（字典 worker_check_type：1签到 2签退 3点到）',
  `check_time`   datetime     DEFAULT NULL            COMMENT '打卡时间',
  `check_method` varchar(20)  DEFAULT ''              COMMENT '打卡方式（AI / 公众号 / 手动）',
  `site_id`      bigint       DEFAULT NULL            COMMENT '工点ID（后续阶段）',
  `photo_url`    varchar(500) DEFAULT ''              COMMENT '现场照片URL',
  `ai_result`    varchar(500) DEFAULT ''              COMMENT 'AI识别结果（JSON，后续阶段）',
  `helmet_flag`  char(1)      DEFAULT NULL            COMMENT '安全帽（0未戴 1已戴）',
  `vest_flag`    char(1)      DEFAULT NULL            COMMENT '反光衣（0未穿 1已穿）',
  `create_by`    varchar(64)  DEFAULT ''              COMMENT '创建者',
  `create_time`  datetime     DEFAULT NULL            COMMENT '创建时间',
  `update_by`    varchar(64)  DEFAULT ''              COMMENT '更新者',
  `update_time`  datetime     DEFAULT NULL            COMMENT '更新时间',
  `remark`       varchar(500) DEFAULT NULL            COMMENT '备注',
  PRIMARY KEY (`id`),
  KEY `idx_worker` (`worker_id`),
  KEY `idx_check_time` (`check_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='打卡记录';

-- =============================================================
-- 顶级菜单：人员管理（M 目录，和「系统管理」平级）
-- 用 LAST_INSERT_ID() 捕获自增 menu_id，子菜单据此挂载，避免硬编码 ID（跨库可重放）。
-- order_num=0 让它排在侧边栏最上方（业务优先），可在「菜单管理」里调整。
-- =============================================================
INSERT INTO `sys_menu`
  (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES
  ('人员管理', 0, 0, 'worker', NULL, '', '', 1, 0, 'M', '0', '0', '', 'peoples', 'admin', NOW(), '人员信息与资质管理（实名制底座）');
SET @worker_dir_id := LAST_INSERT_ID();

-- 子菜单：人员档案（C 菜单，对应 tb_worker 的 CRUD 页面 worker/worker/index）
INSERT INTO `sys_menu`
  (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `remark`)
VALUES
  ('人员档案', @worker_dir_id, 1, 'worker', 'worker/worker/index', '', '', 1, 0, 'C', '0', '0', 'worker:worker:list', 'user', 'admin', NOW(), '人员基础档案管理');
SET @worker_menu_id := LAST_INSERT_ID();

-- 人员档案 6 个按钮权限
INSERT INTO `sys_menu`
  (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`)
VALUES
  ('人员档案查询', @worker_menu_id, 1, '#', '', 1, 0, 'F', '0', '0', 'worker:worker:query',  '#', 'admin', NOW()),
  ('人员档案新增', @worker_menu_id, 2, '#', '', 1, 0, 'F', '0', '0', 'worker:worker:add',    '#', 'admin', NOW()),
  ('人员档案修改', @worker_menu_id, 3, '#', '', 1, 0, 'F', '0', '0', 'worker:worker:edit',   '#', 'admin', NOW()),
  ('人员档案删除', @worker_menu_id, 4, '#', '', 1, 0, 'F', '0', '0', 'worker:worker:remove', '#', 'admin', NOW()),
  ('人员档案导出', @worker_menu_id, 5, '#', '', 1, 0, 'F', '0', '0', 'worker:worker:export', '#', 'admin', NOW());

-- =============================================================
-- 数据字典：类型
-- =============================================================
INSERT INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `remark`) VALUES
  ('人员状态',     'worker_status',       '0', 'admin', NOW(), '施工人员在场/离场/禁用'),
  ('人员审核状态', 'worker_audit_status', '0', 'admin', NOW(), '人员/资质 审核状态'),
  ('人脸录入状态', 'worker_face_status',  '0', 'admin', NOW(), '是否已录入人脸'),
  ('证件类型',     'worker_cert_type',    '0', 'admin', NOW(), '资质证件类型'),
  ('单位类型',     'worker_unit_type',    '0', 'admin', NOW(), '管网/第三方/施工方'),
  ('打卡类型',     'worker_check_type',   '0', 'admin', NOW(), '签到/签退/点到');

-- =============================================================
-- 数据字典：明细
-- =============================================================
INSERT INTO `sys_dict_data` (`dict_sort`, `dict_label`, `dict_value`, `dict_type`, `list_class`, `is_default`, `status`, `create_by`, `create_time`) VALUES
  -- 人员状态
  (1, '在场', '0', 'worker_status', 'success', 'Y', '0', 'admin', NOW()),
  (2, '离场', '1', 'worker_status', 'info',    'N', '0', 'admin', NOW()),
  (3, '禁用', '2', 'worker_status', 'danger',  'N', '0', 'admin', NOW()),
  -- 审核状态
  (1, '待审核', '0', 'worker_audit_status', 'warning', 'Y', '0', 'admin', NOW()),
  (2, '已通过', '1', 'worker_audit_status', 'success', 'N', '0', 'admin', NOW()),
  (3, '已驳回', '2', 'worker_audit_status', 'danger',  'N', '0', 'admin', NOW()),
  (4, '已过期', '3', 'worker_audit_status', 'info',    'N', '0', 'admin', NOW()),
  -- 人脸录入状态
  (1, '未录入', '0', 'worker_face_status', 'info',    'Y', '0', 'admin', NOW()),
  (2, '已录入', '1', 'worker_face_status', 'success', 'N', '0', 'admin', NOW()),
  -- 证件类型
  (1, '身份证',     'id_card',        'worker_cert_type', 'default', 'N', '0', 'admin', NOW()),
  (2, '安全员证',   'safe_cert',      'worker_cert_type', 'default', 'N', '0', 'admin', NOW()),
  (3, '电工证',     'electric_cert',  'worker_cert_type', 'default', 'N', '0', 'admin', NOW()),
  (4, '监理证',     'supervisor_cert','worker_cert_type', 'default', 'N', '0', 'admin', NOW()),
  (5, '作业监护证', 'guardian_cert',  'worker_cert_type', 'default', 'N', '0', 'admin', NOW()),
  (6, '保险',       'insurance',      'worker_cert_type', 'default', 'N', '0', 'admin', NOW()),
  -- 单位类型
  (1, '管网',   '1', 'worker_unit_type', 'default', 'N', '0', 'admin', NOW()),
  (2, '第三方', '2', 'worker_unit_type', 'default', 'N', '0', 'admin', NOW()),
  (3, '施工方', '3', 'worker_unit_type', 'default', 'N', '0', 'admin', NOW()),
  -- 打卡类型
  (1, '签到', '1', 'worker_check_type', 'success', 'N', '0', 'admin', NOW()),
  (2, '签退', '2', 'worker_check_type', 'info',    'N', '0', 'admin', NOW()),
  (3, '点到', '3', 'worker_check_type', 'warning', 'N', '0', 'admin', NOW());
