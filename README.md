L
=
即时通信 —— 实现中英同步聊天翻译<br><br>
服务器<br>
* 使用 C++ 开发<br>
* 调用 Linux 系统 API 实现网络功能<br>
* 选用 select 系统调用实现用户并发（单个进程 1024 用户量）<br>
* 使用 MySql 存储用户信息<br>
* 没有使用第三方服务推送 SDK， 由服务器缓存离线消息<br><br>
客户端<br>
