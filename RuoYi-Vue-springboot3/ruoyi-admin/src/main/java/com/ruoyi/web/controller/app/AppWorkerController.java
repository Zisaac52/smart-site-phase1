package com.ruoyi.web.controller.app;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.worker.domain.TbWorker;
import com.ruoyi.worker.domain.TbWorkerCert;
import com.ruoyi.worker.mapper.TbWorkerCertMapper;
import com.ruoyi.worker.mapper.TbWorkerMapper;
import com.ruoyi.worker.mapper.TbWorkerRoleRelMapper;

/**
 * 手机端 人员资料/资质
 */
@RestController
@RequestMapping("/app/worker")
public class AppWorkerController
{
    @Autowired private TbWorkerMapper workerMapper;
    @Autowired private TbWorkerCertMapper certMapper;
    @Autowired private TbWorkerRoleRelMapper roleRelMapper;

    /** 我的资料 */
    @GetMapping("/profile")
    public AjaxResult profile(@RequestParam Long workerId) {
        TbWorker w = workerMapper.selectTbWorkerById(workerId);
        if (w == null) return AjaxResult.error("人员不存在");
        Map<String, Object> d = new HashMap<>();
        d.put("workerId", w.getId());
        d.put("workerName", w.getWorkerName());
        d.put("phone", w.getPhone());
        d.put("idCard", w.getIdCard());
        d.put("gender", w.getGender());
        d.put("unitType", w.getUnitType());
        d.put("auditStatus", w.getAuditStatus());
        d.put("faceStatus", w.getFaceStatus());
        d.put("status", w.getStatus());
        d.put("roleIds", roleRelMapper.selectRoleIdsByWorkerId(workerId));
        return AjaxResult.success(d);
    }

    /** 我的资质列表 */
    @GetMapping("/certs")
    public AjaxResult certs(@RequestParam Long workerId) {
        TbWorkerCert q = new TbWorkerCert(); q.setWorkerId(workerId);
        return AjaxResult.success(certMapper.selectTbWorkerCertList(q));
    }

    /** 上传证件 */
    @PostMapping("/certs")
    public AjaxResult addCert(@RequestBody TbWorkerCert cert) {
        cert.setAuditStatus("0"); // 待审核
        certMapper.insertTbWorkerCert(cert);
        return AjaxResult.success(Collections.singletonMap("id", cert.getId()));
    }
}
