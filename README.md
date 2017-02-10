L
=
即时通信 —— 实现中英同步聊天翻译
##服务器
* 使用 C++ 开发
* 调用 Linux 系统 API 实现网络功能
* 选用 select 系统调用实现用户并发（单个进程 1024 用户量）
* 使用 MySql 数据库存储用户信息
* 没有使用第三方服务推送 SDK， 由应用服务器缓存离线消息并完成消息推送
* 使用腾讯云服务器运行服务端程序

##客户端
* 使用 Qt 框架开发
* 用 qml 写界面，用 JavaScript 和 C++ 完成业务逻辑

##通信方式
* 建立并维护 tcp 长连接，并以此连接进行消息传送；使用心跳包保持连接的有效性

##第三方
* 调用有道翻译 API 接口实现中英互译
