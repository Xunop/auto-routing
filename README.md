# Auto-routing

因为在使用 VPN 的时候会默认将流量转到 VPN，在某些操作时很好用，
所以写了一个脚本配置路由表只把需要内网访问的网站加入到白名单中。

使用的 [GlobalProtect-openconnect](https://github.com/yuezk/GlobalProtect-openconnect),
还是 Rust 写的，感觉 UI 也舒适，还有 CLI。

GlobalProtect-openconnect 会建一个 tun0 的接口，并配置路由表，
可以通过 `ip a show` 查看一下 VPN 建立的接口。`ip route show dev tun0`
查看配置的路由，会发现将默认的流量转发到 tun0，所以只要稍稍删掉这个路由就好了。

所以这个脚本就是删掉一个路由然后加上我们需要的一些路由。
