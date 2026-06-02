package com.ruoyi.web.controller.app;

import java.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.worker.domain.TbWorkerCheckin;
import com.ruoyi.worker.mapper.TbWorkerCheckinMapper;
import com.ruoyi.worker.mapper.TbWorkerMapper;

/**
 * 手机端打卡
 */
@RestController
@RequestMapping("/app/checkin")
public class AppCheckinController
{
    @Autowired private TbWorkerCheckinMapper checkinMapper;
    @Autowired private TbWorkerMapper workerMapper;

    /** 今日是否已签到/签退 */
    @GetMapping("/today")
    public AjaxResult today(@RequestParam Long workerId) {
        TbWorkerCheckin q = new TbWorkerCheckin(); q.setWorkerId(workerId);
        List<TbWorkerCheckin> list = checkinMapper.selectTbWorkerCheckinList(q);
        String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
        TbWorkerCheckin signIn = null, signOut = null;
        for (TbWorkerCheckin c : list) {
            String d = new java.text.SimpleDateFormat("yyyy-MM-dd").format(c.getCheckTime());
            if (!today.equals(d)) continue;
            if ("1".equals(c.getCheckType())) signIn = c;
            if ("2".equals(c.getCheckType())) signOut = c;
        }
        Map<String, Object> data = new HashMap<>();
        data.put("hasSignIn", signIn != null);
        data.put("hasSignOut", signOut != null);
        data.put("signInTime", signIn != null ? signIn.getCheckTime() : null);
        data.put("signOutTime", signOut != null ? signOut.getCheckTime() : null);
        return AjaxResult.success(data);
    }

    /** 签到 */
    @PostMapping("/signIn")
    public AjaxResult signIn(@RequestBody Map<String, Object> body) {
        return doCheck(body, "1");
    }

    /** 签退 */
    @PostMapping("/signOut")
    public AjaxResult signOut(@RequestBody Map<String, Object> body) {
        return doCheck(body, "2");
    }

    private AjaxResult doCheck(Map<String, Object> body, String checkType) {
        Long workerId = body.get("workerId") != null ? Long.valueOf(body.get("workerId").toString()) : null;
        if (workerId == null) return AjaxResult.error("workerId 不能为空");
        if (workerMapper.selectTbWorkerById(workerId) == null) return AjaxResult.error("人员不存在");
        TbWorkerCheckin c = new TbWorkerCheckin();
        c.setWorkerId(workerId);
        c.setCheckType(checkType);
        c.setCheckTime(new Date());
        c.setCheckMethod(body.get("checkMethod") != null ? body.get("checkMethod").toString() : "H5");
        if (body.get("photoUrl") != null) c.setPhotoUrl(body.get("photoUrl").toString());
        if (body.get("latitude") != null) {
            c.setLatitude(new java.math.BigDecimal(body.get("latitude").toString()));
        }
        if (body.get("longitude") != null) {
            c.setLongitude(new java.math.BigDecimal(body.get("longitude").toString()));
        }
        c.setCreateBy("worker:" + workerId);
        checkinMapper.insertTbWorkerCheckin(c);
        return AjaxResult.success(Collections.singletonMap("id", c.getId()));
    }

    /** 我的打卡记录 */
    @GetMapping("/list")
    public AjaxResult list(@RequestParam Long workerId) {
        TbWorkerCheckin q = new TbWorkerCheckin(); q.setWorkerId(workerId);
        List<TbWorkerCheckin> list = checkinMapper.selectTbWorkerCheckinList(q);
        list.sort((a, b) -> b.getCheckTime().compareTo(a.getCheckTime()));
        return AjaxResult.success(list);
    }
}
