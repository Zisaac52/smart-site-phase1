package com.ruoyi.web.controller.app;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.worker.domain.TbWorker;
import com.ruoyi.worker.mapper.TbWorkerMapper;
import com.ruoyi.worker.mapper.TbWorkerRoleRelMapper;

/**
 * 手机端认证（第一版：手机号+身份证后6位，不接微信OAuth）
 */
@RestController
@RequestMapping("/app/auth")
public class AppAuthController
{
    @Autowired private TbWorkerMapper tbWorkerMapper;
    @Autowired private TbWorkerRoleRelMapper tbWorkerRoleRelMapper;

    /** 手机号+身份证后6位登录 */
    @PostMapping("/login")
    public AjaxResult login(@RequestBody Map<String, String> body) {
        String phone = body.get("phone");
        String idCardLast6 = body.get("idCardLast6");
        if (phone == null || idCardLast6 == null) return AjaxResult.error("手机号和身份证后6位不能为空");
        TbWorker q = new TbWorker(); q.setPhone(phone);
        List<TbWorker> list = tbWorkerMapper.selectTbWorkerList(q);
        TbWorker w = list.stream()
            .filter(t -> t.getIdCard() != null && t.getIdCard().endsWith(idCardLast6) && "0".equals(t.getDelFlag()))
            .findFirst().orElse(null);
        if (w == null) return AjaxResult.error("手机号或身份证后6位不正确");
        Map<String, Object> data = new HashMap<>();
        data.put("workerId", w.getId());
        data.put("workerName", w.getWorkerName());
        data.put("auditStatus", w.getAuditStatus());
        data.put("faceStatus", w.getFaceStatus());
        data.put("status", w.getStatus());
        return AjaxResult.success(data);
    }

    /** 获取当前人员信息 */
    @GetMapping("/me")
    public AjaxResult me(@RequestParam Long workerId) {
        TbWorker w = tbWorkerMapper.selectTbWorkerById(workerId);
        if (w == null || !"0".equals(w.getDelFlag())) return AjaxResult.error("人员不存在或已归档");
        Map<String, Object> data = new HashMap<>();
        data.put("workerId", w.getId());
        data.put("workerName", w.getWorkerName());
        data.put("phone", w.getPhone());
        data.put("idCard", w.getIdCard());
        data.put("gender", w.getGender());
        data.put("unitType", w.getUnitType());
        data.put("auditStatus", w.getAuditStatus());
        data.put("faceStatus", w.getFaceStatus());
        data.put("status", w.getStatus());
        data.put("roleIds", tbWorkerRoleRelMapper.selectRoleIdsByWorkerId(workerId));
        return AjaxResult.success(data);
    }
}
