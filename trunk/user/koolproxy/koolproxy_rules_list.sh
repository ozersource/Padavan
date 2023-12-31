#规则控制功能为大家提供了经过koolproxy兼容认证的规则，其中包括：静态规则、每日规则、视频规则、自定规则，
#koolproxy用户可以根据自己的需求选取相应的规则。【规则在文字说明后面】

#koolproxy兼容认证规则介绍：
#1:静态规则（koolproxy.txt）：该规则包含了较多国内网站和部分知名国外网站的页面元素、js库等屏蔽规则，
#使用该规则可以屏蔽对应网站的一些推广内容

#2:每日规则（daily.txt）：每日规则不定时更新，是静态规则的补充，因为静态规则文件较大，
#因此更新较小的每日规则，以避免每次更新静态规则消耗过多服务器流量。

#3:视频规则（kp.dat）：
#视频规则为加密规则，多为过滤一些flash内嵌元素和一些不良网站，为避免不良网站被人获取，所以采取加密处理。

#4:自定规则（user.txt）：
#用户可以为网站编写自己的规则并用koolproxy引擎来进行过滤。

#5:第三方规则：
#你也能在此处添加第三方规则，不过第三方规则不能保证其和koolproxy的兼容性，有时候甚至会其它规则出现相互冲突。
#请确保第三方规则链接有对应的.md5链接，例如https://kprule.com/daily.txt，
#应该有对应的https://kprule.com/daily.txt.md5 链接，koolproxy才能正确下载规则。

#koolproxy的工作原理是基于规则来过滤页面元素，如果某些网站的一些元素无法屏蔽，
#可能是规则没有覆盖到这些网站，大家可以通过自己编写规则来实现屏蔽，或者反馈给规则维护人员，
#维护人员采纳后会通过规则推送，来实现这些网站元素的屏蔽。
#规则的更新由koolproxy主程序发起，用户只需要添加规则文件名，规则地址等信息即可获得相应规则。
#（可选项：前面添加#停用规则,删除前面的#可生效）
1|koolproxy.txt|https://cdn.jsdelivr.net/gh/kkddcclloo/pdn/koolproxy.txt|
1|daily.txt|https://cdn.jsdelivr.net/gh/kkddcclloo/pdn/daily.txt|
1|kp.dat|https://cdn.jsdelivr.net/gh/kkddcclloo/pdn/kp.dat|
1|user.txt|https://cdn.jsdelivr.net/gh/kkddcclloo/pdn/user.txt|
