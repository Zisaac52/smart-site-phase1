<template>
  <view class="container">
    <view class="user-bar">
      <text class="name">{{ workerInfo.workerName || '未登录' }}</text>
      <text class="status">{{ auditLabel }}</text>
    </view>

    <view class="clock">{{ now }}</view>
    <view class="date">{{ today }}</view>

    <view class="today-status">
      <text>今日签到：{{ hasSignIn ? signInTime : '未签到' }}</text>
      <text>今日签退：{{ hasSignOut ? signOutTime : '未签退' }}</text>
    </view>

    <view class="photo-area" @click="takePhoto">
      <image v-if="photoUrl" :src="photoUrl" class="photo" mode="aspectFill" />
      <text v-else class="photo-placeholder">点击拍照</text>
    </view>

    <view class="btn-group">
      <button class="btn signin" @click="doSignIn" :disabled="hasSignIn || loading">{{ loading ? '提交中...' : '签 到' }}</button>
      <button class="btn signout" @click="doSignOut" :disabled="hasSignOut || loading">{{ loading ? '提交中...' : '签 退' }}</button>
    </view>

    <view class="records-link" @click="goRecords">查看打卡记录 →</view>
  </view>
</template>

<script>
import config from '@/config.js'

function pad(n) { return n < 10 ? '0' + n : '' + n }

export default {
  data() {
    return {
      workerInfo: {}, now: '', today: '', hasSignIn: false, hasSignOut: false,
      signInTime: '', signOutTime: '', photoUrl: '', loading: false
    }
  },
  computed: {
    auditLabel() {
      const s = this.workerInfo.auditStatus
      if (s === '0') return '待审核'
      if (s === '1') return '已通过'
      if (s === '2') return '已驳回'
      return ''
    }
  },
  onShow() { this.refresh() },
  mounted() { setInterval(() => { this.updateTime() }, 1000) },
  methods: {
    updateTime() {
      const d = new Date()
      this.now = pad(d.getHours()) + ':' + pad(d.getMinutes()) + ':' + pad(d.getSeconds())
      this.today = d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate())
    },
    async refresh() {
      this.updateTime()
      const id = uni.getStorageSync('workerId')
      if (!id) { uni.reLaunch({ url: '/pages/worker/login' }); return }
      // 个人信息
      const [e1, r1] = await uni.request({ url: config.baseUrl + '/app/auth/me?workerId=' + id })
      if (r1 && r1.data.code === 200) this.workerInfo = r1.data.data
      // 今日打卡
      const [e2, r2] = await uni.request({ url: config.baseUrl + '/app/checkin/today?workerId=' + id })
      if (r2 && r2.data.code === 200) {
        const d = r2.data.data
        this.hasSignIn = d.hasSignIn; this.signInTime = d.signInTime || ''
        this.hasSignOut = d.hasSignOut; this.signOutTime = d.signOutTime || ''
      }
    },
    takePhoto() {
      uni.chooseImage({ count: 1, success: (res) => { this.photoUrl = res.tempFilePaths[0] } })
    },
    async doSignIn() {
      await this.doCheck('signIn')
    },
    async doSignOut() {
      await this.doCheck('signOut')
    },
    async doCheck(action) {
      this.loading = true
      const id = uni.getStorageSync('workerId')
      try {
        const [err, res] = await uni.request({
          url: config.baseUrl + '/app/checkin/' + action,
          method: 'POST',
          data: { workerId: id, photoUrl: this.photoUrl, checkMethod: 'H5' }
        })
        this.loading = false
        if (res.data.code === 200) {
          uni.showToast({ title: action === 'signIn' ? '签到成功' : '签退成功' })
          this.refresh()
        } else {
          uni.showToast({ title: res.data.msg || '失败', icon: 'none' })
        }
      } catch (e) {
        this.loading = false
        uni.showToast({ title: '网络错误', icon: 'none' })
      }
    },
    goRecords() { uni.navigateTo({ url: '/pages/worker/records' }) }
  }
}
</script>

<style scoped>
.container { padding: 30rpx; min-height: 100vh; background: #f5f5f5; }
.user-bar { display: flex; justify-content: space-between; align-items: center; padding: 20rpx; background: #fff; border-radius: 12rpx; margin-bottom: 30rpx; }
.name { font-size: 36rpx; font-weight: bold; }
.status { font-size: 24rpx; color: #007aff; padding: 6rpx 16rpx; background: #e8f4ff; border-radius: 6rpx; }
.clock { font-size: 80rpx; text-align: center; font-weight: bold; color: #333; margin-top: 40rpx; }
.date { text-align: center; color: #999; font-size: 28rpx; margin-bottom: 30rpx; }
.today-status { background: #fff; border-radius: 12rpx; padding: 20rpx; margin-bottom: 20rpx; display: flex; justify-content: space-around; font-size: 26rpx; color: #666; }
.photo-area { width: 200rpx; height: 200rpx; background: #e5e5e5; border-radius: 12rpx; margin: 20rpx auto; display: flex; align-items: center; justify-content: center; overflow: hidden; }
.photo { width: 100%; height: 100%; }
.photo-placeholder { color: #999; font-size: 28rpx; }
.btn-group { display: flex; gap: 20rpx; margin-top: 40rpx; }
.btn { flex: 1; font-size: 32rpx; border-radius: 12rpx; color: #fff; padding: 24rpx; }
.signin { background: #007aff; }
.signout { background: #ff3b30; }
.records-link { text-align: center; margin-top: 50rpx; color: #007aff; font-size: 28rpx; }
</style>
