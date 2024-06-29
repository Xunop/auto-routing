# Auto-routing

因为在使用 VPN 回公司内网的时候会默认将流量转到 VPN，在某些操作时不太方便，
所以写了一个脚本配置路由表只把需要内网访问的网站加入到白名单中。

使用的 [GlobalProtect-openconnect](https://github.com/yuezk/GlobalProtect-openconnect),
还是 Rust 写的，主要 UI 舒适，还有 CLI。

> PS: 用了几天才发现 GUI 是需要付费，看仓库 README 才发现这个项目不是完全开源。GUI 不用也不是不行，CLI 也很好！
> 写了一个 CLI 登录的脚本。（也不是不能用

GlobalProtect-openconnect 会建一个 tun0 的接口，并配置路由表，
可以通过 `ip a show` 查看一下 VPN 建立的接口。`ip route show dev tun0`
查看配置的路由，会发现将默认的流量转发到 tun0，所以只要稍稍删掉这个路由就好了。

所以这个脚本就是删掉一个路由然后加上我们需要的一些路由。

## Getting Start

```sh
# 创建 Hooks 脚本目录
sudo mkdir /etc/vpnc/post-connect.d
# 创一个软链接方便之后更新
cd $_ && ln -s /your/path/auto_routing.sh
```

这样每次启动 VPN 时都会自动运行这个脚本。

`ip route show dev tun0` 可以查看一下结果对不对。

## Auto connect VPN

替换一下脚本信息：

```bash
sed -i 's/your-username/username/' auto_vpn_example.sh
sed -i 's/your-password/password/' auto_vpn_example.sh
sed -i 's/vpn.example.com/vpn/' auto_vpn_example.sh
mv auto_vpn_example.sh auto_vpn.sh
chmod +x auto_vpn.sh
sudo ./auto_vpn.sh
```
