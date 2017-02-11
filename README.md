L
=
即时通信 —— 实现中英同步聊天翻译
-----------------------------

##服务器
* 使用 C++ 开发
* 调用 Linux 系统 API 实现网络功能
* 选用 select 系统调用实现用户并发（单个进程 1024 用户量）
* 使用 MySql 数据库存储用户和好友信息
* 没有使用第三方服务推送 SDK， 由应用服务器缓存离线消息并完成消息推送
* 使用腾讯云服务器运行服务端程序

##客户端
* 使用 Qt 框架开发
* 用 qml 写界面，用 JavaScript 和 C++ 完成业务逻辑

##通信方式
* 使用 C/S 架构模式，用户之间通信所有数据由服务器中转
* 建立并维护 tcp 长连接，并以此连接进行消息传送；使用心跳包保持连接的有效性
* 使用 json 作为数据传输格式

##第三方
* 调用有道翻译 API 接口实现中英互译

##应用说明
* 功能
 * 支持私聊
 * 支持发送文本消息
 * 支持消息缓存
 * 支持消息提醒
 * 支持离线消息推送
 * 支持断线后自动重连
 * 支持中英互译
* 注意
 * 当且仅当双方语言不同才进行翻译，长按消息可获取原文，再次长按消息或长按原文则隐藏原文；翻译需要联网
 * 若译文跟原文相同，则表示翻译失败
 * 消息发送与接收接口，消息推送，以及其他一些细节尚未完善，可能会出现程序运行异常
 * 退出应用后聊天记录会清除
 
##功能演示
* 登录、注册、添加好友<br>![image](https://github.com/QYPan/L/blob/master/example_pictures/register_login_add.gif)
* 聊天<br>![image](https://github.com/QYPan/L/blob/master/example_pictures/talk.gif)
* 模拟网络断开<br>![image](https://github.com/QYPan/L/blob/master/example_pictures/bad_network.gif)
* 删除好友<br>![image](https://github.com/QYPan/L/blob/master/example_pictures/remove_linkman.gif)

##后期计划
* 添加语音聊天功能，并尝试语音翻译
* 使用 libevent 网络库重新编写服务器，使用 redis 数据库作为离线消息缓存数据库
* 完善消息推送功能，尽可能做到消息的可靠传输，必达性，实时性，不重复
